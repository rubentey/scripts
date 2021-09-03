#!/bin/bash
# Hay que depurar el if $? cuando da error
a=echo
clear

$a " ---------------------------------- "
$a "| Bienvenid@ al test de escritura  |"
$a "| lectura de un dispositivo (1GB)  |"
$a " ---------------------------------- "
$a "| * Recomendado con file explorer  |"
$a "|  abierto en la unidad a testear  |"
$a " ---------------------------------- "
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
read -p "Unidad a testear: " unidad
$a
clear

lsblk -l | grep $unidad > /dev/null
if [ $? -eq 0 ];
then
    #disco=$(lsblk -l| grep $unidad | cut -d ' ' -f14,15,16,17,18,19,20)
    disco=$(df -h | grep -v "loop\|tmpfs\|boot" | grep $unidad | cut -d ' ' -f17 | grep "^/")
    $a "Se ha seleccionado: $unidad. Que tiene la ruta: $disco"
    $a

    rmTemp=$(sleep 0.2; rm -r $disco/temp.txt > /dev/null; sleep 0.2)

    $a " ---------------------------------- "
    $a "1ª Prueba escritura + lectura (1GB, a 1M el BS)..."
    $a
    $a "Escritura:"
    dd if=/dev/zero of=$disco/temp.txt bs=1M count=1024 oflag=direct status=progress
    $a
    $a "Lectura:"
    dd if=$disco/temp.txt of=/dev/null bs=1M count=1024 iflag=direct status=progress
    $a

    $rmTemp

    $a " ---------------------------------- "
    $a "2ª Prueba escritura + lectura (1GB, a 1M el BS)..."
    $a
    $a "Escritura:"
    dd if=/dev/zero of=$disco/temp.txt bs=1M count=1024 oflag=direct status=progress
    $a
    $a "Lectura:"
    dd if=$disco/temp.txt of=/dev/null bs=1M count=1024 iflag=direct status=progress
    $a

    $rmTemp

else
    clear
    read "Por favor, escriba bien el nombre de la unidad"
    sleep 3
    sh $0
fi
