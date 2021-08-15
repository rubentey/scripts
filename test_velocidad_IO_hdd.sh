#!/bin/bash
# Hay que depurar el if $? cuando da error
a=echo

clear
$a " ---------------------------------"
$a "| Bienvenid@ al test de escritura |"
$a "|   / lectura de un dispositivo   |"
$a " ---------------------------------"
$a "|* Recomendado con file explorer  |"
$a "|  abierto en la unidad a testear |"
$a " ---------------------------------"
$a
sleep 0.3

$a "Listado de unidades detectadas:"
$a
lsblk -l | grep -v "loop\|NAME\|disk"
$a

$a "  ^"
$a "  |"
$a
read -p "Escribe nombre de unidad a testear: " unidad
$a
clear

lsblk -l | grep $unidad > /dev/null
if [ $? -eq 0 ];
then
    disco=$(lsblk -l| grep $unidad | cut -d ' ' -f14,15,16,17,18,19,20)
    $a "Se ha seleccionado: $unidad. Que tiene la ruta: $disco"
    $a

    $a " ------------------------------------------------"
    $a "1ª Prueba escritura + lectura (1GB, a 1M el BS)..."
    $a
    $a "Escritura..."
    dd if=/dev/zero of=$disco/temp.txt bs=1M count=1024 oflag=direct status=progress
    $a

    $a "Lectura..."
    dd if=$disco/temp.txt of=/dev/null bs=1M count=1024 iflag=direct status=progress
    $a

    sleep 0.2
    rm -r $disco/temp.txt > /dev/null
    sleep 0.2

    $a " ------------------------------------------------"
    $a "2ª Prueba escritura + lectura (1GB, a 1M el BS)..."
    $a
    $a "Escritura..."
    dd if=/dev/zero of=$disco/temp.txt bs=1M count=1024 oflag=direct status=progress
    $a

    $a "Lectura..."
    dd if=$disco/temp.txt of=/dev/null bs=1M count=1024 iflag=direct status=progress
    $a

    sleep 0.2
    rm -r $disco/temp.txt > /dev/null
    sleep 0.2

else
    clear
    read "Por favor, escriba bien el nombre de la unidad"
    sleep 3
    sh $0
fi
