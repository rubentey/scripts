#!/bin/bash

a=echo
web_principal="https://www.el-tiempo.net"

# -- Información adicional --
# "Página usada" https://www.el-tiempo.net
# "Información nacional" https://www.el-tiempo.net/api/json/v2/home
# "Lista de provincias" https://www.el-tiempo.net/api/json/v2/provincias
# "Lista de municipios" https://www.el-tiempo.net/api/json/v2/municipios

clear
$a " -------------------------------- "
$a "|     Bienvenid@ al visor del    |"
$a "| tiempo listado en la Aemet vía |"
$a "|   https://www.el-tiempo.net    |"
$a " -------------------------------- "
$a "|  Crea -> ./aemet_provincia.sh  |"
$a " -------------------------------- "
$a
sleep 0.3
read -p "Pulsa Enter..." zzz


reset
$a "Elegir provincia:"
$a "-----------------"
$a
curl -s https://www.el-tiempo.net/api/json/v2/provincias | jq -r '.provincias' | grep "{\|CODPROV\|NOMBRE_PROVINCIA" | tr -s '{' ' ' | tr -s ',' ' ' | tr -s '"' ' ' | tail -n +2
# Posibilidades de filtrado: CODPROV, NOMBRE_PROVINCIA, CODAUTON, COMUNIDAD_CIUDAD_AUTONOMA, CAPITAL_PROVINCIA
$a
$a "-----------------"
read -p "Escribe el número de 'CODPROV' de tu provincia: " cod_prov


reset
$a "Elegir municipio:"
$a "-----------------"
$a
curl -s https://www.el-tiempo.net/api/json/v2/provincias/$cod_prov/municipios | jq -r '.municipios' |  grep "{\|COD_GEO\|NOMBRE_CAPITAL" | tr -s '{' ' ' | tr -s ',' ' ' | tr -s '"' ' ' | tail -n +2
# Posibilidades de filtrado: CODIGOINE, ID_REL, COD_GEO, CODPROV, NOMBRE_PROVINCIA, NOMBRE, POBLACION_MUNI, SUPERFICIE, PERIMETRO, CODIGOINE_CAPITAL, NOMBRE_CAPITAL, POBLACION_CAPITAL, HOJA_MTN25, LONGITUD_ETRS89_REGCAN95, LATITUD_ETRS89_REGCAN95, ORIGEN_COORD, ALTITUD, ORIGEN_ALTITUD, DISCREPANTE_INE
$a
$a "-----------------"
read -p "Escribe el número de 'COD_GEO' de tu municipio: " cod_mun


reset
$a "Elegir qué listar:"
$a "-----------------"
$a
curl -s https://www.el-tiempo.net/api/json/v2/provincias/$cod_prov/municipios/$cod_num | jq -r ' '
#Posibilidades de filtrado; municipio, fecha, temperatura_actual, temperaturas, humedad, viento, lluvia, imagen, pronostico, proximos_dias, breadcrumb
$a
$a "-----------------"
read -p "Escribe el : " 




$a
$a "Codigo provincia $cod_prov | Codigo Municipio $cod_mun"
$a


$a
curl -s https://www.el-tiempo.net/api/json/v2/provincias/46/municipios/46001 | jq -r '"Tiempo -> Prov: "+.municipio.NOMBRE_PROVINCIA+ " | Día: "+.fecha+ " | Temp: " +.temperatura_actual+ "ºC | Humed: " +.humedad+ "% | Lluvia: " +.lluvia'
