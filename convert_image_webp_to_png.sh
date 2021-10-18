#!/bin/bash

echo "Conversor de imagenes .webp -> .png usando parallel"
echo ""
ls -l | grep webp
echo ""
read -p "¿Cual de las listadas? (p.e. flores.webp -> flores): " foto

parallel --eta dwebp {} -o $foto.png ::: $foto.webp

echo "Fin del script..."
