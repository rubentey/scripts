read -p "1/2 - Número de pin GPIO (el \"█\" de la tabla): " pin

if [ $pin -ge 1 ] && [ $pin -le 40 ];
then
	if [ $pin -eq 7 ] || [ $pin -eq 11 ] || [ $pin -eq 12 ] || [ $pin -eq 13 ] || [ $pin -eq 15 ] || [ $pin -eq 16 ] || [ $pin -eq 18 ] || [ $pin -eq 22 ] || [ $pin -eq 29 ] || [ $pin -eq 31 ] || [ $pin -eq 32 ] || [ $pin -eq 33 ] || [ $pin -eq 35 ] || [ $pin -eq 36 ] || [ $pin -eq 37 ] || [ $pin -eq 38 ] || [ $pin -eq 40 ];
	then
                echo  "!El pin $pin tiene LED!"
        else
                echo "!El pin $pin no tiene LED!"
                echo "¡Puede dar error si sigues!"
        fi

        echo  "" > /dev/null
else
        echo "Elige del 1 al 40!"
        sleep 1.5
        clear
        sh $0
fi

