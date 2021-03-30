#!/bin/bash

a=echo

# Bienvenida
$a
$a " ---------------------------------------------------------------------------------"
$a "| Bienvenid@ al asistente de RPi para .sh + .py, y LEDs indicando servicio activo |"
$a " ---------------------------------------------------------------------------------"
sleep 0.3
$a


# Introducir numero de GPIO para el LED y escribir nombre servicio
read -p "1/2 - Numero de GPIO (1-40, consulta tabla GPIO): " numGPIO

if [ $numGPIO -ge 1 ] && [ $numGPIO -le 40 ];
then
	$a "" >> /dev/null
else
	$a
	$a "Del 1 al 40"
	sleep 1.5
	clear
	sh $0
fi

read -p "2/2 - Nombre de Servicio (p.e.: cups.service): " nomServ
$a

systemctl status $nomServ.service | head -3 | tail -1 | grep "(running)" > /dev/null

if [ $? = 0 ];
then
        $a "¡El servicio '$nomServ' está activo!"
else
        $a "¡El servicio '$nomServ', está parado o no funciona bien!"
	$a "Mira su estado actual:"
	$a
	systemctl status $nomServ.service | head -10 | grep "Active:" > /dev/tty
fi
$a


# Comprobar que los datos introducidos son correctos
$a "-----------------------------------------"
$a "Has elegido el Pin GPIO numero: " $numGPIO
$a "El servicio elegido es: " $nomServ
$a "-----------------------------------------"
$a


# Verificar que los datos siguen adelante
read -p "¿Quieres continuar? [s/n] " continuar

if [ $continuar == 's' ] || [ $continuar == 'S' ];
then
$a


# Crear script led service, led encendido, y led apagado

	#Script bash comprueba si activo / apagado X servicio
main="LED-$numGPIO-$nomServ"

$a "1/ Script bash, hecho"
	$a -e "#!/bin/bash \n \nwhile true; \ndo" > $main.sh
	$a -e "systemctl status $nomServ.service | head -3 | tail -1 | grep \"(running)\" > /dev/null \n" >> $main.sh
	$a '	if [ $? = 0 ];' >> $main.sh
	$a -e "	then \n		python $main-on.txt > /dev/null \n		$a \"LED $nomServ on\" \n	else" >> $main.sh
	$a -e "		python $main-on.txt > /dev/null \n		$a \"LED $nomServ off\" \n	fi \n \ndone" >> $main.sh

	chmod +x $main.sh


servLED="LED-$numGPIO-service-$nomServ"
	#Script python de encendido
$a "2/ Script python encendido, hecho"

	$a -e "#!/bin/python \n \nimport RPi.GPIO as GPIO \nimport time \n" > $servLED-on.py
	$a -e "GPIO.setmode(GPIO.BOARD) \nGPIO.setup($numGPIO,GPIO.OUT) \n" >> $servLED-on.py
	$a -e "GPIO.output($numGPIO,1) \nprint (\"LED on\") \ntime.sleep(2) \n \nGPIO.cleanup()" >> $servLED-on.py

	#Script python de apagado
$a "3/ Script python apagado, hecho"

	cp $servLED-on.py $servLED-temp.py
	sed 's/(2,1)/(2,0)/g' $servLED-temp.py > $servLED-temp2.py
	sed 's/print ("LED on")/print ("LED off")/g' $servLED-temp2.py > $servLED-off.py
	rm -r $servLED-temp.py $servLED-temp2.py

	


else
	$a "Saliendo..."
	exit

fi


# Fin script

