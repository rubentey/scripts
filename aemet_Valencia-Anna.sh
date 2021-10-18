#!/bin/bash
# Previsión del tiempo en Anna, situado en Valencia.
curl -s https://www.el-tiempo.net/api/json/v2/provincias/46/municipios/46039 | jq -r '  " | Provincia: "+.municipio.NOMBRE_PROVINCIA+  " | Fecha: "+.fecha+  " | Temperatura (ºC): "+.temperatura_actual+  " | Humedad (%): "+.humedad+  " | Lluvia (%): "+.lluvia+  " |"'
