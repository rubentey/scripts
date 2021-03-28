#!/bin/bash

a=echo

# Bienvenida
$a
$a " ----------------------------------------------------------------------------------"
$a "| Bienvenid@ al asistente para crear .sh + .py para LEDs indicando servicio activo |"
$a " ----------------------------------------------------------------------------------"
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

systemctl status $nomServ | head -3 | tail -1 | grep "(running)" > /dev/null

if [ $? = 0 ];
then
        $a "¡El servicio '$nomServ' está activo!"
else
        $a "¡El servicio '$nomServ', está parado o no funciona bien!"
	$a "Mira su estado actual:"
	$a
	systemctl status $nomServ | head -10 | grep "Active:" > /dev/tty
fi
$a


# Comprobar que los datos introducidos son correctos
$a "-----------------------------------------"
$a "Has elegido el Pin GPIO numero: " $numGPIO
$a "El servicio elegido es: " $nomServ
$a "-----------------------------------------"
$a


# Verificar que los datos siguen adelante
read -p "¿Quieres continuar? [S/n] " continuar

case $continuar in
[S-s])
	$a "Comenzamos!"
	


# Crear script led service



;;

*)
	$a "Saliendo..."
	exit;;
esac


# Fin script





