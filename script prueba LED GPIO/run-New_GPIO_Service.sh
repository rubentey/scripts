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


# Introducir número de GPIO para el LED y escribir nombre servicio
$a "Actualmente en uso:"
ls ./GPIO_LED_SH_PY/ | grep -v "py"
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


#Número de pin GPIO
read -p "1/2 - Número de pin GPIO (el \"█\" de la tabla): " pin
$a

if [ $pin -ge 1 ] && [ $pin -le 40 ];
then
	if [ $pin == 7 ] || [ $pin == 11 ] || [ $pin == 12 ] || [ $pin == 13 ] || [ $pin == 15 ] || [ $pin == 16 ] || [ $pin == 18 ] || [ $pin == 22 ] || [ $pin == 29 ] || [ $pin == 31 ] || [ $pin == 32 ] || [ $pin == 33 ] || [ $pin == 35 ] || [ $pin == 36 ] || [ $pin == 37 ] || [ $pin == 38 ] || [ $pin == 40 ];
	then
		$a "!El pin $pin tiene LED!"
	else
		$a "!El pin $pin no tiene LED!"
		$a "¡Puede dar error si sigues!"
	fi
else
	$a "Elige del 1 al 40!"
	sleep 1.5
	clear
	sh $0
fi



# Servicio a controlar
read -p "2/2 - Nombre de servicio sin \".service\" (p.e.: cups): " nomServ
$a. 

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

#rutaShPyLEDs=/etc/GPIO_LED_SH_PY/
rutaShPyLEDs=./GPIO_LED_SH_PY/


# Crear .sh led estado, .py led encendido, y .py led apagado
$a "Scripts estado, encendido, y apagado:"
	#Script bash comprueba si activo / apagado X servicio
main="LED-$pin-$nomServ"



$a "1/4 - Script, crear ruta carpeta, hecho."
if [ -d $rutaShPyLEDs ]
then
	$a "Ya existe la ruta."
else
	mkdir -p $rutaShPyLEDs
	chmod 777 $rutaShPyLEDs
	# quizá mejor poner un "chown root:root"
fi



$a "2/4 - Script bash estado servicio, hecho."

nomFinalSH="$rutaShPyLEDs$main"

	$a "#!/bin/bash" > $nomFinalSH.sh
	$a "#$main.sh" >> $nomFinalSH.sh
	$a "" >> $nomFinalSH.sh
	$a "while true;" >> $nomFinalSH.sh
	$a "do" >> $nomFinalSH.sh
	$a "systemctl status $nomServ.service | head -3 | tail -1 | grep \"(running)\" > /dev/null" >> $nomFinalSH.sh
	$a "" >> $nomFinalSH.sh
	$a '	if [ $? = 0 ];' >> $nomFinalSH.sh
	$a "    then" >> $nomFinalSH.sh
	$a "        python $main-on.py > /dev/null" >> $nomFinalSH.sh
	$a "        echo "LED SSH on"" >> $nomFinalSH.sh
	$a "    else" >> $nomFinalSH.sh
	$a "        python $main-off.py > /dev/null" >> $nomFinalSH.sh
	$a "        echo "LED SSH off"" >> $nomFinalSH.sh
	$a "    fi" >> $nomFinalSH.sh
	$a "" >> $nomFinalSH.sh
	$a "sleep 0.1" >> $nomFinalSH.sh
	$a "done" >> $nomFinalSH.sh

	chmod +x $nomFinalSH.sh



servLED="LED-$pin-$nomServ"
	#Script python de encendido
$a "3/4 - Script python encendido, hecho."

nomFinalPY="$rutaShPyLEDs$servLED"

$a "#!/bin/python" > $nomFinalPY-on.py
$a "#Pin: $pin	Service: $nomServ" >> $nomFinalPY-on.py
$a "" >> $nomFinalPY-on.py
$a "import RPi.GPIO as GPIO" >> $nomFinalPY-on.py
$a "" >> $nomFinalPY-on.py
$a "GPIO.setmode(GPIO.BOARD) " >> $nomFinalPY-on.py
$a "GPIO.setup($pin,GPIO.OUT) " >> $nomFinalPY-on.py
$a "" >> $nomFinalPY-on.py
$a "GPIO.output($pin,1)" >> $nomFinalPY-on.py
$a "print (\"LED on\")" >> $nomFinalPY-on.py
$a "GPIO.cleanup()" >> $nomFinalPY-on.py
$a "" >> $nomFinalPY-on.py



	#Script python de apagado
$a "4/4 - Script python apagado, hecho."

	sed 's/,1)/,0)/g' $nomFinalPY-on.py > $nomFinalPY-temp.py
	sed 's/on")/off")/g' $nomFinalPY-temp.py > $nomFinalPY-off.py
	rm -r $nomFinalPY-temp.py
$a

#-----------------------------------------------------------------------------------------------------


$a
# Crear servicio systemd
$a "Servicios controlar script .sh anterior:"
	# Servicios systemd
servicio="LED-$pin-$nomServ-servicio.service"
#rutaSysd=/etc/systemd/system/
rutaSysd=./LED-Servicios/

$a "1/3 - Servicio, crear ruta carpeta, hecho."
# puede que no haya que crear carpeta
if [ -d $rutaSysd ]
then
	$a "Ya existe la ruta."
else
	mkdir -p $rutaSysd
	chmod 777 $rutaSysd
	# quizá mejor poner un "chown root:root"
fi

nomFinalSRV=$rutaSysd$servicio
$a "2/3 - Servicio, crear archivo .service de $nomServ, hecho."
#	$a -e "[Unit] \nDescription=Servicio de $nomServ, para LED en GPIO $pin. \nAfter=network.target #\n" > $rutaSysd$servicio
#	$a -e "[Service] \nType=Simple \nExecStart=$rutaShPyLEDs$main.sh \nRestart=on-failure \n" >> #$rutaSysd$servicio
#	#$a -e "[Install] \nWantedBy=multi-user.target \n" >> $rutaSysd$servicio
#	$a -e "[Install] \nWantedBy=graphical.target \n" >> $rutaSysd$servicio


	$a "[Unit]" > $nomFinalSRV
	$a "Description= Servicio de $nomServ para LED en GPIO $pin" >> $nomFinalSRV
	$a "Documentation=Para + info, mi GitHub: https://github.com/rubentey/scripts" >> $nomFinalSRV
	$a "After=systemd-user-sessions.service" >> $nomFinalSRV
	$a "Wants=network.target" >> $nomFinalSRV
	$a "" >> $nomFinalSRV
	$a "[Service]" >> $nomFinalSRV
	$a "Type=simple" >> $nomFinalSRV
	$a "ExecStart=/usr/bin/anydesk --service" >> $nomFinalSRV
	$a "#Restart=on-abort" >> $nomFinalSRV
	$a "#PIDFile=/var/run/anydesk.pid" >> $nomFinalSRV
	$a "#KillMode=mixed" >> $nomFinalSRV
	$a "#TimeoutStopSec=30" >> $nomFinalSRV
	$a "#User=root" >> $nomFinalSRV
	$a "#LimitNOFILE=100000" >> $nomFinalSRV
	$a "" >> $nomFinalSRV
	$a "[Install]" >> $nomFinalSRV
	$a "WantedBy=multi-user.target" >> $nomFinalSRV


	# ln -s /lib/systemd/system/$nomFinalSRV /etc/systemd/system/$nomFinalSRV
	# chmod 611 /lib/systemd/system/$nomFinalSRV
	# chown root:root /lib/systemd/system/$nomFinalSRV

sysServ=LED-$pin-$nomServ-servicio
$a "3/3 - Servicio, habilitar, recargar, reiniciarlo, hecho."
	#systemctl stop $servicio
	systemctl enable $sysServ
	#systemctl start $sysServ
	systemctl daemon-reload
	systemctl restart $sysServ


#-----------------------------------------------------------------------------------------------------


$a
# Resumen de lo que se ha hecho

$a
$a " -------------------------------------------- "
$a "| Servicio creado, y comprobación de estado: |"
$a " -------------------------------------------- "
$a
systemctl status $sysServ | head -3 | tail -1 | grep "(running)" > /dev/null

if [ $? = 0 ];
then
        $a "¡El servicio '$servicio' está activo!"
else
        $a "¡El servicio '$servicio', está parado o no funciona bien!"
fi
$a
systemctl status $sysServ.service | head -10 | grep "Active:" > /dev/tty

$a
$a
$a " -------------------------------------- "
$a "| Archivos creados para este servicio: |"
$a " -------------------------------------- "
$a
$a "En /etc/GPIO_LED_SH_PY/ para guardar los scripts:"
#ls /etc/GPIO_LED_SH_PY/ | grep LED
ls ./GPIO_LED_SH_PY/ | grep "LED-$pin"
$a
$a "En /etc/systemd/system/ para guardar los servicios:"
#ls /etc/systemd/system/ | grep LED
ls ./LED-Servicios/ | grep "LED-$pin"

$a
$a
$a " --------------------------------------- "
$a "| Todos los servicios asignados a LEDs: |"
$a " --------------------------------------- "
$a
ls $rutaShPyLEDs | grep -v "py"

$a
$a
$a
$a "Fin del programa."


else
	$a "Saliendo..."
	exit
fi


# Fin script
