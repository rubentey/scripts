#!/bin/bash

a=echo

# Bienvenida
$a
$a " --------------------------------------------------- "
$a "|  Bienvenid@ al asistente de RPi para .sh + .py,   |"
$a "|  .service y para LEDs indicando servicio activo!  |"
$a " --------------------------------------------------- "
sleep 0.4
$a



# Introducir número de GPIO para el LED y escribir nombre servicio
$a "GPIOs que tienen LED, 17 en total:"
$a "╔═════════════════════════════════════════════════════════╗"
$a "║ 1 3 5 7  9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 ║"
$a "║ - - - █ -  █  █  █  -  -  -  -  -  -  █  █  █  █  █  -  ║"
$a "║ - - - - -  █  -  █  █  -  █  -  -  -  -  █  -  █  █  █  ║"
$a "║ 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 ║"
$a "╚═════════════════════════════════════════════════════════╝"
$a
$a "Actualmente se usan:"
ls -a . | grep LED- | grep .sh
$a
read -p "1/2 - Número de pin GPIO (el \"█\" de la tabla): " pin


#Número de pin
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


#-----------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------


# Crear .sh led estado, .py led encendido, y .py led apagado
$a "Scripts estado, encendido, y apagado:"
	#Script bash comprueba si activo / apagado X servicio
main="LED-$pin-$nomServ"

$a "1/3 - Script bash, hecho."
	$a -e "#!/bin/bash \n# $main.sh \n \nwhile true; \ndo" > $main.sh
	$a -e "systemctl status $nomServ.service | head -3 | tail -1 | grep \"(running)\" > /dev/null \n" >> $main.sh
	$a '	if [ $? = 0 ];' >> $main.sh
	$a -e "	then \n		python $main-on.txt > /dev/null \n		$a \"LED $nomServ on\" \n	else" >> $main.sh
	$a -e "		python $main-on.txt > /dev/null \n		$a \"LED $nomServ off\" \n	fi \n \ndone" >> $main.sh

	chmod +x $main.sh


servLED="LED-$pin-$nomServ"
	#Script python de encendido
$a "2/3 - Script python encendido, hecho."

	$a -e "#!/bin/python \n# $servLED.py \n \nimport RPi.GPIO as GPIO \nimport time \n" > $servLED-on.py
	$a -e "GPIO.setmode(GPIO.BOARD) \nGPIO.setup($pin,GPIO.OUT) \n" >> $servLED-on.py
	$a -e "GPIO.output($pin,1) \nprint (\"LED on\") \ntime.sleep(2) \n \nGPIO.cleanup()" >> $servLED-on.py

	#Script python de apagado
$a "3/3 - Script python apagado, hecho."

	sed 's/(2,1)/(2,0)/g' $servLED-on.py > $servLED-temp.py
	sed 's/print ("LED on")/print ("LED off")/g' $servLED-temp.py > $servLED-off.py
	rm -r $servLED-temp.py


#-----------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------


$a
# Crear servicio systemd
$a "Servicios controlar script .sh anterior:"
	# Servicios systemd
servicio="LED-$pin-$nomServ-servicio.service"

$a "1/ - Servicio para $nomServ, hecho."
	




else
	$a "Saliendo..."
	exit

fi


# Fin script
