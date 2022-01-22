#!/bin/bash

a=echo

#
# Este es con array que he hecho, tal como he encontrado en foros
#
# Descomentar cada vez una línea, sino es mucho archivo =
#

read -p "1/2 - Número de pin GPIO (el \"█\" de la tabla): " pin
$a



# comilla doble -> "
pin_util=("7" "11" "12" "13" "15" "16" "18" "22" "29" "31" "32" "33" "35" "36" "37" "38" "40")

# comilla simple -> '
#pin_util=('7' '11' '12' '13' '15' '16' '18' '22' '29' '31' '32' '33' '35' '36' '37' '38' '40')


# sin comilla ->
#pin_util=(7 11 12 13 15 16 18 22 29 31 32 33 35 36 37 38 40)




if [ $pin -ge 1 ] && [ $pin -le 40 ];
then
	if [[ ${pin_util[*]} == *" $pin "* ]];
	then
		#$a "" >> /dev/null
		$a "El pin $pin tiene LED!"
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

$a "sigue por aqui"
