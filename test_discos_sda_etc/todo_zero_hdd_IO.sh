#!/bin/bash
# Hay que depurar el if $? cuando da error
a=echo
clear

$a " -------------------------------- "
$a "|  Sobreescribe el disco a ceros  |"
$a " -------------------------------- "
$a "|  * Cuidado con tipo formato de  |"
$a "|  de la unidad. Posible archivo  |"
$a "| de más de 4GB (FAT32 no admite) |"
$a " -------------------------------- "
$a
sleep 0.3

$a "Listado de unidades detectadas:"
$a
#lsblk -l | grep -v "loop\|NAME\|disk"
df -h | grep -v "loop\|tmpfs\|boot" | tail -n +2
$a

$a "  ^"
$a "  |"
$a
read -p "Unidad a sobreescribir (p.e: '/dev/sda1' -> 'sda1'): " unidad
$a
clear

lsblk -l | grep $unidad > /dev/null
if [ $? -eq 0 ];
then
    #disco=$(lsblk -l| grep $unidad | cut -d ' ' -f14,15,16,17,18,19,20)
    #disco=$(df -h | grep -v "loop\|tmpfs\|boot" | grep $unidad | cut -d ' ' -f17 | grep "^/")
    disco=$(df -h | grep -v "loop\|tmpfs\|boot" | grep $unidad | tr -s ' ' '-' | cut -d '-' -f6)

    $a "Unidad/partición: $unidad"
    $a "Ruta que tiene: $disco"
    $a "Archivo creado: $disco/temp_zero.txt"
    $a
    $a " ---------------------------------- "
    $a "Creando archivo 'temp_zero.txt' en la unidad:"
    $a
    dd if=/dev/zero of=$disco/temp_zero.txt status=progress

    $a
    $a "Archivo creado. Se deberá borrar manualmente"
    $a

else
    clear
    read "Por favor, escriba bien el nombre de la unidad"
    sleep 3
    sh $0
fi
