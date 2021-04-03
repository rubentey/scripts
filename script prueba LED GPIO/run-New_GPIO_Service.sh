#!/bin/bash

a=echo

# Bienvenida
$a "*Ejecutar con sudo*"
$a
$a " --------------------------------------------------- "
$a "|  Bienvenid@ al asistente de RPi para .sh + .py,   |"
$a "|  .service y para LEDs indicando servicio activo!  |"
$a " --------------------------------------------------- "
sleep 0.4
$a
$a


# Introducir número de GPIO para el LED y escribir nombre servicio
$a "Actualmente se usan:"
ls -a ./GPIO_LED_SH_PY/ | grep LED- | grep .sh
$a
$a
$a "GPIOs que tienen LED, 17 en total:"
$a "╔═════════════════════════════════════════════════════════╗"
$a "║ 1 3 5 7  9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 ║"
$a "║ - - - █ -  █  █  █  -  -  -  -  -  -  █  █  █  █  █  -  ║"
$a "║ - - - - -  █  -  █  █  -  █  -  -  -  -  █  -  █  █  █  ║"
$a "║ 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 ║"
$a "╚═════════════════════════════════════════════════════════╝"
$a
$a "Crear uno nuevo:"
read -p "1/2 - Número de pin GPIO (el \"█\" de la tabla): " pin


#Número de pin GPIO
if [ $pin -ge 1 ] && [ $pin -le 40 ];
then
	if [ $pin == 7 ] || [ $pin == 11 ] || [ $pin == 12 ] || [ $pin == 13 ] || [ $pin == 15 ] || [ $pin == 16 ] || [ $pin == 18 ] || [ $pin == 22 ] || [ $pin == 29 ] || [ $pin == 31 ] || [ $pin == 32 ] || [ $pin == 33 ] || [ $pin == 35 ] || [ $pin == 36 ] || [ $pin == 37 ] || [ $pin == 38 ] || [ $pin == 40 ];
	then
		$a >> /dev/null
	else
		$a
		$a "¡El GPIO $pin no tiene LED, recomiendo elegir otro!"
		$a "      ¡Puede dar error si sigues adelante!"
		$a
	fi
else
	$a
	$a "Elige del 1 al 40!"
	sleep 1.5
	clear
	sh $0
fi

# Servicio a controlar
read -p "2/2 - Nombre de Servicio (p.e.: cups): " nomServ
$a

systemctl status $nomServ.service | head -3 | tail -1 | grep "(running)" > /dev/null

if [ $? = 0 ];
then
        $a "¡El servicio '$nomServ' está activo!"
else
        $a "¡El servicio '$nomServ', está parado o no funciona bien!"
	$a "Mira su estado actual: "
	$a
	systemctl status $nomServ.service | head -10 | grep "Active:" > /dev/tty
fi
$a



# Comprobar que los datos introducidos
$a "-----------------------------------------"
$a "Has elegido el Pin GPIO número: " $pin
$a "El servicio elegido es: " $nomServ
$a "-----------------------------------------"
$a



# Verificar que quiere seguir adelante
read -p "¿Quieres continuar? [s/n]: " continuar

if [ $continuar == 'S' ] || [ $continuar == 's' ];
then
$a
$a


#-----------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------
#rutaShPyLEDs=/etc/GPIO_LED_SH_PY/
rutaShPyLEDs=./GPIO_LED_SH_PY/


# Crear .sh led estado, .py led encendido, y .py led apagado
$a "Scripts estado, encendido, y apagado:"
	#Script bash comprueba si activo / apagado X servicio
main="LED-$pin-$nomServ"

$a "1/4 - Servicio, crear ruta carpeta, hecho."
if [ -d $rutaShPyLEDs ]
then
	$a "Ya existe la ruta."
else
	mkdir $rutaShPyLEDs
	chmod 777 $rutaShPyLEDs
fi

$a "2/4 - Script bash estado servicio, hecho."
	touch $rutaShPyLEDs$main.sh
	$a -e "#!/bin/bash \n# $main.sh \n \nwhile true; \ndo" > $rutaShPyLEDs$main.sh
	$a -e "systemctl status $nomServ.service | head -3 | tail -1 | grep \"(running)\" > /dev/null \n" >> $rutaShPyLEDs$main.sh
	$a '	if [ $? = 0 ];' >> $rutaShPyLEDs$main.sh
	$a -e "	then \n		python $main-on.txt > /dev/null \n		$a \"LED $nomServ on\" \n	else" >> $rutaShPyLEDs$main.sh
	$a -e "		python $main-on.txt > /dev/null \n		$a \"LED $nomServ off\" \n	fi \n \ndone" >> $rutaShPyLEDs$main.sh

	#chmod +x $rutaShPyLEDs$main.sh
	chmod 777 $rutaShPyLEDs$main.sh

servLED="LED-$pin-$nomServ"
	#Script python de encendido
$a "3/4 - Script python encendido, hecho."

	$a -e "#!/bin/python \n# $servLED-on.py \n \nimport RPi.GPIO as GPIO \nimport time \n" > $rutaShPyLEDs$servLED-on.py
	$a -e "GPIO.setmode(GPIO.BOARD) \nGPIO.setup($pin,GPIO.OUT) \n" >> $rutaShPyLEDs$servLED-on.py
	$a -e "GPIO.output($pin,1) \nprint (\"LED on\") \ntime.sleep(2) \n \nGPIO.cleanup()" >> $rutaShPyLEDs$servLED-on.py

	#Script python de apagado
$a "4/4 - Script python apagado, hecho."

	sed 's/(2,1)/(2,0)/g' $rutaShPyLEDs$servLED-on.py > $rutaShPyLEDs$servLED-temp.py
	sed 's/print ("LED on")/print ("LED off")/g' $rutaShPyLEDs$servLED-temp.py > $rutaShPyLEDs$servLED-off.py
	rm -r $rutaShPyLEDs$servLED-temp.py
$a


#-----------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------


$a
# Crear servicio systemd
$a "Servicios controlar script .sh anterior:"
	# Servicios systemd
servicio="LED-$pin-$nomServ-servicio.service"
#rutaSysd=/etc/systemd/system/LED-Servicios/
rutaSysd=./LED-Servicios/

$a "1/3 - Servicio, crear ruta carpeta, hecho."
if [ -d $rutaSysd ]
then
	$a "Ya existe la ruta."
else
	mkdir $rutaSysd
	chmod 777 $rutaSysd
fi

$a "2/3 - Servicio, crear archivo .service de $nomServ, hecho."
	$a -e "[Unit] \nDescription=Servicio de $nomServ, para LED en GPIO $pin. \n" > $rutaSysd$servicio
	$a -e "[Service] \nType=Simple \nExecStart=$rutaShPyLEDs$main.sh \nRestart=on-failure \n" >> $rutaSysd$servicio
	$a -e "[Install] \nWantedBy=multi-user.target \n" >> $rutaSysd$servicio

$a "3/3 - Servicio, haciendo stop y start, hecho."
	systemctl stop $servicio
	systemctl start $servicio


#-----------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------


$a
# Resumen de lo que se ha hecho

$a
$a " ----------- "
$a "| Servicio: |"
$a " ----------- "
$a
systemctl status $servicio | head -3 | tail -1 | grep "(running)" > /dev/null

if [ $? = 0 ];
then
        $a "¡El servicio '$servicio' está activo!"
else
        $a "¡El servicio '$servicio', está parado o no funciona bien!"
fi
$a
systemctl status $nomServ.service | head -10 | grep "Active:" > /dev/tty
$a

$a
$a " ---------------- "
$a "| Rutas creadas: |"
$a " ---------------- "
$a
$a "En /etc/GPIO_LED_SH_PY para guardar los scripts:"
#ls /etc/ | grep LED
ls ./GPIO_LED_SH_PY/ | grep LED
$a
$a "En /etc/systemd/system/LED-Servicios para guardar los servicios:"
#ls /etc/systemd/system/ | grep LED
#ls /etc/systemd/system/LED-Servicios
ls ./LED-Servicios/

$a
$a
$a " ----------------------------- "
$a "| Servicios asignados a LEDs: |"
$a " ----------------------------- "
$a
ls $rutaShPyLEDs | grep .sh

$a
$a
$a "Fin del programa."


else
	$a "Saliendo..."
	exit

fi


# Fin script
