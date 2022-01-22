#!/bin/bash

a=echo

#
# Este es el que tengo desde el primer día y funciona bien
#

read -p "1/2 - Número de pin GPIO (el \"█\" de la tabla): " pin
$a

if [ $pin -ge 1 ] && [ $pin -le 40 ];
then
	if [ $pin == 7 ] || [ $pin == 11 ] || [ $pin == 12 ] || [ $pin == 13 ] || [ $pin == 15 ] || [ $pin == 16 ] || [ $pin == 18 ] || [ $pin == 22 ] || [ $pin == 29 ] || [ $pin == 31 ] || [ $pin == 32 ] || [ $pin == 33 ] || [ $pin == 35 ] || [ $pin == 36 ] || [ $pin == 37 ] || [ $pin == 38 ] || [ $pin == 40 ];
	then
		$a >> /dev/null
		#$a "!El pin $pin tiene LED!"
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

$a "sigue por aqui"
