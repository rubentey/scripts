#!/bin/bash

a=echo
web_principal="https://www.el-tiempo.net"

# -- Información adicional --
# "Página usada" https://www.el-tiempo.net
# "Información nacional" https://www.el-tiempo.net/api/json/v2/home
# "Lista de provincias" https://www.el-tiempo.net/api/json/v2/provincias
# "Lista de municipios" https://www.el-tiempo.net/api/json/v2/municipios

clear
$a " --------------------------------- "
$a "|      Bienvenid@ al visor del    |"
$a "|  tiempo listado en la Aemet vía |"
$a "|    https://www.el-tiempo.net    |"
$a " --------------------------------- "
$a "| ./aemet_provincia-municipio.sh  |"
$a " --------------------------------- "
$a
read -p "Pulsa Enter..." zzz


reset
$a "Elegir provincia:"
$a "-----------------"
$a
curl -s https://www.el-tiempo.net/api/json/v2/provincias | jq -r '.provincias' | grep "{\|CODPROV\|NOMBRE_PROVINCIA" | tr -s '{' ' ' | tr -s ',' ' ' | tr -s '"' ' ' | tail -n +2
# Posibilidades de filtrado: CODPROV, NOMBRE_PROVINCIA, CODAUTON, COMUNIDAD_CIUDAD_AUTONOMA, CAPITAL_PROVINCIA, breadcrumb
$a
$a "-----------------"
read -p "Escribe el número de 'CODPROV' de tu provincia: " cod_prov
provincia=$(curl -s https://www.el-tiempo.net/api/json/v2/provincias/$cod_prov/municipios | jq -r '.breadcrumb' | grep "name" | grep -v "Provincias\|Municipios" | tr -s '"' ' ' | tr -s ' ' '-' | cut -d '-' -f4 | tail -1)


reset
$a "Elegir municipio:"
$a "-----------------"
$a
curl -s https://www.el-tiempo.net/api/json/v2/provincias/$cod_prov/municipios | jq -r '.municipios' |  grep "{\|COD_GEO\|NOMBRE_CAPITAL" | tr -s '{' ' ' | tr -s ',' ' ' | tr -s '"' ' '
# Posibilidades de filtrado: CODIGOINE, ID_REL, COD_GEO, CODPROV, NOMBRE_PROVINCIA, NOMBRE, POBLACION_MUNI, SUPERFICIE, PERIMETRO, CODIGOINE_CAPITAL, NOMBRE_CAPITAL, POBLACION_CAPITAL, HOJA_MTN25, LONGITUD_ETRS89_REGCAN95, LATITUD_ETRS89_REGCAN95, ORIGEN_COORD, ALTITUD, ORIGEN_ALTITUD, DISCREPANTE_INE, breadcrumb
$a
$a "-----------------"
read -p "Escribe el número de 'COD_GEO' de tu municipio: " cod_mun
municipio=$(curl -s https://www.el-tiempo.net/api/json/v2/provincias/$cod_prov/municipios/$cod_mun | jq -r '.breadcrumb' | grep "name" | grep -v "Provincias\|Municipios" | tr -s '"' ' ' | tr -s ' ' '-' | cut -d '-' -f4 | tail -1)


reset
b="' "
opciones=""

read -p "[1/5] ¿Quieres que se liste el nombre del municipio? [S/n] " conf_mun
if [ ! "$conf_mun" ];
then
        b="$b \" | Provincia: \"+.municipio.NOMBRE_PROVINCIA+ "
        opciones="$opciones Municipio "
fi
$a "-----------------"

read -p "[2/5] ¿Quieres que se liste la fecha del momento? [S/n] " conf_fecha
if [ ! "$conf_fecha" ];
then
        b="$b \" | Fecha: \"+.fecha+ "
        opciones="$opciones Fecha "
fi
$a "-----------------"

read -p "[3/5] ¿Quieres que se liste la temperatura actual (ºC)? [S/n] " conf_temp_actual
if [ ! "$conf_temp_actual" ];
then
        b="$b \" | Temperatura (ºC): \"+.temperatura_actual+ "
        opciones="$opciones Temperatura_actual "
fi
$a "-----------------"

read -p "[4/5] ¿Quieres que se liste el % de humedad? [S/n] " conf_humedad
if [ ! "$conf_humedad" ];
then
        b="$b \" | Humedad (%): \"+.humedad+ "
        opciones="$opciones Humedad "
fi
$a "-----------------"

read -p "[5/5] ¿Quieres que se liste el % de lluvia? [S/n] " conf_lluvia
if [ ! "$conf_lluvia" ];
then
        b="$b \" | Lluvia (%): \"+.lluvia+ "
        opciones="$opciones Lluvia "
fi
$a "-----------------"
b="$b \" |\"'"
$a


reset
$a "Opciones elegidas: "
$a "-----------------"
$a $opciones
$a
$a
# Crear el archivo con la consulta. No he visto otra forma de hacerlo ya que sino "jq -r $b" daba error
$a "#!/bin/bash" > aemet_$provincia-$municipio.sh
$a "# Previsión del tiempo en $municipio, situado en $provincia." >> aemet_$provincia-$municipio.sh
$a "curl -s https://www.el-tiempo.net/api/json/v2/provincias/$cod_prov/municipios/$cod_mun | jq -r $b" >> aemet_$provincia-$municipio.sh

$a "Creado el archivo \"aemet_$provincia_$municipio.sh\" con este contenido: "
$a "-----------------"
cat aemet_$provincia-$municipio.sh
$a
$a
$a "Darle permisos para ejecutar"
$a "-----------------"
chmod +x aemet_$provincia-$municipio.sh
sh aemet_$provincia-$municipio.sh
#Posibilidades de filtrado: municipio, fecha, temperatura_actual, temperaturas, humedad, viento, lluvia, imagen, pronostico, proximos_dias, breadcrumb
$a

$a
$a "Si Municipio \"\$municipio\" sale vacío, es que no hay datos en la web"
$a "Prar depurar:	Codigo Provincia $cod_prov | Provincia $provincia | Codigo Municipio $cod_mun | Municipio $municipio "
$a

# Fin script
