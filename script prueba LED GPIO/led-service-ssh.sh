#!/bin/bash

a=echo
ruta_actual=$(pwd)

# Bienvenida
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
	sudo sh $0 #si lo ve manuela, me mata
	

elif [ $menu_inicio -eq 2 ];
then
	$a "2 - Consultar LEDs y servicio asignado"
		if [ "\$(ls /etc/GPIO_LED_SH_PY/ | grep -v \".py\")" ];
		then
			$a
			$a "Actualmente en uso (/etc/GPIO_LED_SH_PY/):"
			$a "-------------------"
			ls /etc/GPIO_LED_SH_PY/ | grep -v ".py"
			$a
		else
			$a "No se han encontrado"
			$a
		fi

elif [ $menu_inicio -eq 3 ];
then
	$a "3 - Asignar servicio a un LED"
	$a "------------------------------"
	$a
	# Introducir número de GPIO para el LED y escribir nombre servicio
	$a "Actualmente en uso (/etc/GPIO_LED_SH_PY/):"
	$a "-------------------"
	ls /etc/GPIO_LED_SH_PY/ | grep -v ".py"
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
				$a "¡El pin $pin tiene LED!"
			else
				$a "¡El pin $pin no tiene LED!"
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


		# Crear .sh led estado, .py led encendido, y .py led apagado
		$a "Scripts estado, encendido, y apagado:"
		#Script bash comprueba si activo / apagado X servicio
		

		$a "1/4 - Script, crear ruta carpeta, hecho."
			if [ -d /etc/GPIO_LED_SH_PY ]
			then
				$a "Ya existe la ruta."
			else
				mkdir -p /etc/GPIO_LED_SH_PY
				#chmod 777 /etc/GPIO_LED_SH_PY
				# quizá mejor poner un "chown root:root"
			fi


		$a "2/4 - Script bash estado servicio, hecho."
			#main="LED-$pin-$nomServ"
			#nomFinalSH="/etc/GPIO_LED_SH_PY/$main"

			Fichero_SH=/etc/GPIO_LED_SH_PY/LED-$pin-$nomServ.sh
			Fichero_Py=/etc/GPIO_LED_SH_PY/LED-$pin-$nomServ
			Fichero_Py_on=$Fichero_Py-on.py
			Fichero_Py_off=$Fichero_Py-off.py

			$a "#!/bin/bash" > $Fichero_SH
			$a "# $Fichero_SH" >> $Fichero_SH
			$a "" >> $Fichero_SH
			$a "while true;" >> $Fichero_SH
			$a "do" >> $Fichero_SH
			$a "systemctl status $nomServ.service | head -3 | tail -1 | grep \"(running)\" > /dev/null" >> $Fichero_SH
			$a '	if [ $? = 0 ];' >> $Fichero_SH
			$a "    then" >> $Fichero_SH
			$a "        python $Fichero_Py_on > /dev/null" >> $Fichero_SH
			$a "        echo \"LED $pin $nomServ on\"" >> $Fichero_SH
			$a "    else" >> $Fichero_SH
			$a "        python $Fichero_Py_off > /dev/null" >> $Fichero_SH
			$a "        echo \"LED $pin $nomServ off\"" >> $Fichero_SH
			$a "    fi" >> $Fichero_SH
			$a "sleep 0.1" >> $Fichero_SH
			$a "done" >> $Fichero_SH

			chmod +x $Fichero_SH


		#Script python de encendido
		$a "3/4 - Script python encendido, hecho."


			$a "#!/bin/python" > $Fichero_Py_on
			$a "# Pin: $pin	Service: $nomServ" >> $Fichero_Py_on
			$a "" >> $Fichero_Py_on
			$a "import RPi.GPIO as GPIO" >> $Fichero_Py_on
			$a "" >> $Fichero_Py_on
			$a "GPIO.setmode(GPIO.BOARD)" >> $Fichero_Py_on
			$a "GPIO.setup($pin,GPIO.OUT)" >> $Fichero_Py_on
			$a "" >> $Fichero_Py_on
			$a "GPIO.output($pin,1)" >> $Fichero_Py_on
			$a "print (\"LED $nomServ on\")" >> $Fichero_Py_on
			$a "GPIO.cleanup()" >> $Fichero_Py_on


		#Script python de apagado
		$a "4/4 - Script python apagado, hecho."


			sed 's/,1)/,0)/g' $Fichero_Py_on > $Fichero_Py-temp.py
			sed 's/on")/off")/g' $Fichero_Py-temp.py > $Fichero_Py_off
			rm -r $Fichero_Py-temp.py
			$a

		#------------------------------------------------------------------------

		$a
		# Crear servicio systemd
		$a "Servicios controlar script .sh anterior:"
		# Servicios systemd

		$a "1/3 - Servicio, crear ruta carpeta, hecho."
			# puede que no haya que crear carpeta
			#if [ -d /etc/systemd/system/ ]
			#then
			#	$a "Ya existe la ruta."
			#else
			#	mkdir -p /etc/systemd/system/
			# quizá mejor poner un "chown root:root"
			#fi

		
		$a "2/3 - Servicio, crear archivo .service de $nomServ, hecho."
			Ruta_LED_Servicio=/etc/systemd/system/LED-$pin-$nomServ-servicio.service

			$a "[Unit]" > $Ruta_LED_Servicio
			$a "Description= Servicio de $nomServ para LED en GPIO $pin" >> $Ruta_LED_Servicio
			$a "Documentation=Para + info, mi GitHub: https://github.com/rubentey/scripts" >> $Ruta_LED_Servicio
			$a "After=systemd-user-sessions.service" >> $Ruta_LED_Servicio
			$a "Wants=network.target" >> $Ruta_LED_Servicio
			$a "" >> $Ruta_LED_Servicio
			$a "[Service]" >> $Ruta_LED_Servicio
			$a "Type=simple" >> $Ruta_LED_Servicio
			$a "ExecStart=/usr/bin/anydesk --service" >> $Ruta_LED_Servicio
			$a "" >> $Ruta_LED_Servicio
			$a "[Install]" >> $Ruta_LED_Servicio
			$a "WantedBy=multi-user.target" >> $Ruta_LED_Servicio

		
		$a "3/3 - Servicio, habilitar, recargar, reiniciarlo, hecho."
			LED_Servicio=LED-$pin-$nomServ-servicio

			systemctl enable $LED_Servicio
			systemctl daemon-reload
			systemctl restart $LED_Servicio


		#------------------------------------------------------------------------


		# Resumen de lo que se ha hecho
		#reset
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

			systemctl status $sysServ.service | head -3 | tail -1 | grep "Active:" > /dev/tty

		$a
		$a
		$a " -------------------------------------- "
		$a "| Archivos creados para este servicio: |"
		$a " -------------------------------------- "
		$a
			$a "En /etc/GPIO_LED_SH_PY/ para guardar los scripts:"
			ls /etc/GPIO_LED_SH_PY/ | grep "LED-$pin"
			$a
			$a "En /etc/systemd/system/ para guardar los servicios:"
			ls /etc/systemd/system/ | grep "LED-$pin"

		$a
		$a
		$a " ------------------------------------------------------ "
		$a "| Todos los servicios con LEDs (/etc/GPIO_LED_SH_PY/): |"
		$a " ------------------------------------------------------ "
		$a
		ls /etc/GPIO_LED_SH_PY/ | grep -v ".py"
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
	$a
	$a "Antes en uso (/etc/GPIO_LED_SH_PY/):"
	$a "-------------------"
	ls /etc/GPIO_LED_SH_PY/ | grep -v ".py"
	$a
	$a
	read -p "Escribe el número concreto del que quieres eliminar: " eliminar_pin
	
	if [ "$eliminar_pin" ];
	then
		$a
		eliminar_servicio=$(ls /etc/systemd/system/ | grep "servicio.service" | grep $eliminar_pin)
			if [ $?  = 0 ];
			then
				$a "Parar $eliminiar_servicio"
				systemctl stop $eliminar_servicio
				$a "Deshabilitar $eliminar_servicio"
				systemctl disable $eliminar_servicio
				$a "Quitar $eliminar_servicio del sistema"
				cd /etc/systemd/system/
				rm -r $eliminar_servicio

				cd /etc/GPIO_LED_SH_PY/
				eliminar_sh=$(ls /etc/GPIO_LED_SH_PY | grep "LED-$eliminar_pin" | grep ".sh")
				rm -r $eliminar_sh

				eliminar_py_on=$(ls /etc/GPIO_LED_SH_PY | grep "LED-$eliminar_pin" | grep "on.py")
				rm -r $eliminar_py_on

				eliminar_py_off=$(ls /etc/GPIO_LED_SH_PY | grep "LED-$eliminar_pin" | grep "off.py")
				python $eliminar_py_off
				rm -r $eliminar_py_off

				$a
				$a "Ahora en uso (/etc/GPIO_LED_SH_PY/):"
				$a "-------------------"
				ls /etc/GPIO_LED_SH_PY/ | grep -v ".py"
				$a
				$a 
			else
				$a "No se ha encontrado ese número..."
				$a
				sleep 1
			fi
	else
		$a "Número erróneo..."
		$a
		sleep 1
	fi

else
	$a "Esa opción no está en el menú..."
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
