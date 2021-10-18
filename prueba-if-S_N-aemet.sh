#!/bin/bash

a=echo

b="' "
opciones=""

read -p "[1/5] ¿Quieres que se liste el nombre del municipio? [S/n] " conf_mun
if [ ! "$conf_mun" ];
then
	b="$b \"| Provincia: \"+.municipio.NOMBRE_PROVINCIA+ "
	opciones="$opciones Municipio "
fi
$a "-----------------"

read -p "[2/5] ¿Quieres que se liste la fecha del momento? [S/n] " conf_fecha
if [ ! "$conf_fecha" ];
then
	b="$b \"| Fecha: \"+.fecha+ "
	opciones="$opciones Fecha "
fi
$a "-----------------"

read -p "[3/5] ¿Quieres que se liste la temperatura actual (ºC)? [S/n] " conf_temp_actual
if [ ! "$conf_temp_actual" ];
then
	b="$b \"| Temperatura (ºC): \"+.temperatura_actual+ "
	opciones="$opciones Temperatura_actual "
fi
$a "-----------------"

read -p "[4/5] ¿Quieres que se liste el % de humedad? [S/n] " conf_humedad
if [ ! "$conf_humedad" ];
then
	b="$b \"| Humedad (%): \"+.humedad+ "
	opciones="$opciones Humedad "
fi
$a "-----------------"

read -p "[5/5] ¿Quieres que se liste el % de lluvia? [S/n] " conf_lluvia
if [ ! "$conf_lluvia" ];
then
	b="$b \"| Lluvia (%): \"+.lluvia+ "
	opciones="$opciones Lluvia "
fi
$a "-----------------"

b="$b \" |\"'"

$a
$a "Esta es la url: "
$a $b
$a
$a "Estas son las opciones elegidas: "
$a $opciones
