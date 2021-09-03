#!/bin/bash

curl -s https://www.el-tiempo.net/api/json/v2/provincias/46/municipios/46001 | jq -r '"Tiempo -> Prov: "+.municipio.NOMBRE_PROVINCIA+ " | Día: "+.fecha+ " | Temp: " +.temperatura_actual+ "ºC | Humed: " +.humedad+ "% | Lluvia: " +.lluvia'
