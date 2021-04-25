#!/bin/bash

a=echo

# Bienvenida
$a
$a " -------------------------------------------------- "
$a "|  Bienvenid@ al asistente de RPi para .sh + .py,  |"
$a "|  .service, de LEDs indicando servicio activo!    |"
$a " -------------------------------------------------- "
sleep 0.4
$a

$a "Menú opciones disponibles:"
$a "--------------------------"
$a "1 - Ejecutar script con sudo (Recomendado)."
$a "2 - Consultar LEDs y servicio asignado."
$a "3 - Asignar servicio a un LED."
$a "4 - Eliminar un servicio asignado a un LED."
$a
read -p "Elige una opción (número): " menu_inicio
clear

if [ $menu_inicio -eq 1 ];
then
	$a "1 - Ejecutar script con sudo"
	reset
	$a "Ejecutando \"sudo $0\""
	sudo sh $0 #si esto lo ve mi tutora, me mata
	

elif [ $menu_inicio -eq 2 ];
then
	$a "2 - Consultar LEDs y servicio asignado"
	$a "Actualmente en uso:"
	$a "-------------------"
	ls ./GPIO_LED_SH_PY/ | grep -v ".py"
	$a


elif [ $menu_inicio -eq 3 ];
then
	$a "3 - Asignar servicio a un LED"
	$a "------------------------------"
	$a
	# Introducir número de GPIO para el LED y escribir nombre servicio
	$a "Actualmente en uso:"
	$a "-------------------"
	ls ./GPIO_LED_SH_PY/ | grep -v ".py"
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
			if [ $pin -eq 7 ] || [ $pin -eq 11 ] || [ $pin -eq 12 ] || [ $pin -eq 13 ] || [ $pin -eq 15 ] || [ $pin -eq 16 ] || [ $pin -eq 18 ] || [ $pin -eq 22 ] || [ $pin -eq 29 ] || [ $pin -eq 31 ] || [ $pin -eq 32 ] || [ $pin -eq 33 ] || [ $pin -eq 35 ] || [ $pin -eq 36 ] || [ $pin -eq 37 ] || [ $pin -eq 38 ] || [ $pin -eq 40 ];
			then
				$a "!El pin $pin tiene LED!"
			else
				$a "!El pin $pin no tiene LED!"
				$a "¡Puede dar error si sigues!"
			fi
			#$a "" > /dev/null
		else
			$a "Elige del 1 al 40!"
			sleep 1.5
			clear
			sh $0
		fi


	# Servicio a controlar del sistema
	read -p "2/2 - Nombre de servicio sin \".service\" (p.e.: cups): " nomServ
	$a

	serv_origen_status=$(systemctl status $nomServ.service | head -3 | tail -1 | grep "(running)")
	if [ "$serv_origen_status" ];
	then
	    $a "¡El servicio '$nomServ' está activo!"
	else
	    $a "¡El servicio '$nomServ', está parado o no funciona bien!"
	fi
	$a


	# Comprobar que los datos introducidos
	$a "----------------------------------------"
	$a "Has elegido el Pin GPIO número: " $pin
	$a "El servicio elegido es: " $nomServ
	$a "----------------------------------------"
	$a


	# Verificar que quiere seguir adelante
	read -p "¿Quieres continuar (Intro para continuar)? [S/n]: " continuar

	if [ ! "$continuar" ];
	then
		$a
		$a


		#------------------------------------------------------------------------

		#rutaShPy=/etc/GPIO_LED_SH_PY/
		rutaShPy=./GPIO_LED_SH_PY/


		# Crear .sh led estado, .py led encendido, y .py led apagado
		$a "Scripts estado, encendido, y apagado:"
		#Script bash comprueba si activo / apagado X servicio
		

		$a "1/4 - Script, crear ruta carpeta, hecho."
			if [ -d $rutaShPy ]
			then
				$a "Ya existe la ruta."
			else
				mkdir -p $rutaShPy
				chmod 777 $rutaShPy
				# quizá mejor poner un "chown root:root"
			fi


		$a "2/4 - Script bash estado servicio, hecho."
			main="LED-$pin-$nomServ"
			nomFinalSH="$rutaShPy$main"

			$a "#!/bin/bash" > $nomFinalSH.sh
			$a -e "#$main.sh \n" >> $nomFinalSH.sh
			$a "while true;" >> $nomFinalSH.sh
			$a "do" >> $nomFinalSH.sh
			$a -e "systemctl status $nomServ.service | head -3 | tail -1 | grep \"(running)\" > /dev/null \n" >> $nomFinalSH.sh
			$a '	if [ $? = 0 ];' >> $nomFinalSH.sh
			$a "    then" >> $nomFinalSH.sh
			$a "        python $main-on.py > /dev/null" >> $nomFinalSH.sh
			$a "        echo "LED SSH on"" >> $nomFinalSH.sh
			$a "    else" >> $nomFinalSH.sh
			$a "        python $main-off.py > /dev/null" >> $nomFinalSH.sh
			$a "        echo "LED SSH off"" >> $nomFinalSH.sh
			$a -e "    fi \n" >> $nomFinalSH.sh
			$a "sleep 0.1" >> $nomFinalSH.sh
			$a "done" >> $nomFinalSH.sh

			chmod +x $nomFinalSH.sh


		#Script python de encendido
		$a "3/4 - Script python encendido, hecho."
			servLED="LED-$pin-$nomServ"
			nomFinalPY="$rutaShPy$servLED"

			$a "#!/bin/python" > $nomFinalPY-on.py
			$a -e "#Pin: $pin	Service: $nomServ \n" >> $nomFinalPY-on.py
			$a -e "import RPi.GPIO as GPIO \n" >> $nomFinalPY-on.py
			$a "GPIO.setmode(GPIO.BOARD) " >> $nomFinalPY-on.py
			$a -e "GPIO.setup($pin,GPIO.OUT) \n" >> $nomFinalPY-on.py
			$a "GPIO.output($pin,1)" >> $nomFinalPY-on.py
			$a "print (\"LED on\")" >> $nomFinalPY-on.py
			$a "GPIO.cleanup()" >> $nomFinalPY-on.py


		#Script python de apagado
		$a "4/4 - Script python apagado, hecho."

			sed 's/,1)/,0)/g' $nomFinalPY-on.py > $nomFinalPY-temp.py
			sed 's/on")/off")/g' $nomFinalPY-temp.py > $nomFinalPY-off.py
			rm -r $nomFinalPY-temp.py
			$a

		#------------------------------------------------------------------------

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

		
		$a "2/3 - Servicio, crear archivo .service de $nomServ, hecho."
			nomFinalSRV=$rutaSysd$servicio

			$a "[Unit]" > $nomFinalSRV
			$a "Description= Servicio de $nomServ para LED en GPIO $pin" >> $nomFinalSRV
			$a "Documentation=Para + info, mi GitHub: https://github.com/rubentey/scripts" >> $nomFinalSRV
			$a "After=systemd-user-sessions.service" >> $nomFinalSRV
			$a -e "Wants=network.target \n" >> $nomFinalSRV
			$a "[Service]" >> $nomFinalSRV
			$a "Type=simple" >> $nomFinalSRV
			$a "ExecStart=/usr/bin/anydesk --service" >> $nomFinalSRV
			$a "#Restart=on-abort" >> $nomFinalSRV
			$a "#PIDFile=/var/run/anydesk.pid" >> $nomFinalSRV
			$a "#KillMode=mixed" >> $nomFinalSRV
			$a "#TimeoutStopSec=30" >> $nomFinalSRV
			$a "#User=root" >> $nomFinalSRV
			$a -e "#LimitNOFILE=100000 \n" >> $nomFinalSRV
			$a "[Install]" >> $nomFinalSRV
			$a "WantedBy=multi-user.target" >> $nomFinalSRV

			# ln -s /lib/systemd/system/$nomFinalSRV /etc/systemd/system/$nomFinalSRV
			# chmod 611 /lib/systemd/system/$nomFinalSRV
			# chown root:root /lib/systemd/system/$nomFinalSRV


		
		$a "3/3 - Servicio, habilitar, recargar, reiniciarlo, hecho."
			sysServ=LED-$pin-$nomServ-servicio

			systemctl enable $sysServ
			systemctl daemon-reload
			systemctl restart $sysServ


		#------------------------------------------------------------------------


		$a
		# Resumen de lo que se ha hecho

		reset
		$a " -------------------------------------------- "
		$a "| Servicio creado, y comprobación de estado: |"
		$a " -------------------------------------------- "
		$a
			serv_final_status=$(systemctl status $sysServ | head -3 | tail -1 | grep "(running)")
			if [ "$serv_final_status" ];
			then
			    $a "¡El servicio '$sysServ' está activo!"
			else
			    $a "¡El servicio '$sysServ', está parado o no funciona bien!"
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
			ls $rutaShPy | grep -v ".py"
		$a
		$a
		$a "Fin del programa."

	else
		$a "Saliendo..."
		sleep 1
		reset && exit
	fi


elif [ $menu_inicio -eq 4 ];
then
	$a "4 - Eliminar un servicio asignado a un LED"
	$a "wip 2021-4-25"
	$a 


else
	$a "Esa opción no está actualmente en el menú..."
	sleep 2
	reset && sh $0
fi



read -p "Intro para volver al menú [S/n]: " volver

	if [ ! "$volver" ];
	then
		reset && sh $0
	else
		$a "Hasta la proxima"
		sleep 2
		reset && exit
	fi


# Fin script

