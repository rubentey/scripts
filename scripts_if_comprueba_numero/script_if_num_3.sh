#!/bin/bash

a=echo

#
# Esta es otra forma que he encontrado de hacerlo, pero no tira bien
#

pin_util=('7' '11' '12' '13' '15' '16' '18' '22' '29' '31' '32' '33' '35' '36' '37' '38' '40')

read -p "1/2 - Número de pin GPIO (el \"█\" de la tabla): " pin

if [ $pin -ge 1 ] && [ $pin -le 40 ];
then
   	if [[ ${pin_util[*]} == *" $pin "* ]];
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

$a "sigue por aqui"
