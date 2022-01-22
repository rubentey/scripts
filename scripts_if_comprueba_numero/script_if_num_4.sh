#!/bin/bash

a=echo

#
# Esta es como la num_3 pero más compacta y sin lo de reiniciar script
#

pin_valido=('7' '11' '12' '13' '15' '16' '18' '22' '29' '31' '32' '33' '35' '36' '37' '38' '40')

read -p "1/2 - Número de pin GPIO (el \"█\" de la tabla): " pin

if [ $pin -ge 1 ] && [ $pin -le 40 ] && [[ ${pin_valido[*]} == *" $pin "* ]];
then
	$a "!El pin $pin tiene LED!"
else
	$a "!El pin $pin no tiene LED!"
	$a "¡Puede dar error si sigues!"
fi

$a "sigue por aqui"

