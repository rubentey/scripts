#!/bin/bash

#Probado en Debian 9 y Ubuntu server 18.04

#Crear script prelogin y dar permisos
cp prelogin.sh /etc/prelogin.sh
chmod +x /etc/prelogin.sh

#Crear script /etc/rc.local y dar permisos
touch /etc/rc.local
chmod +x /etc/rc.local

#Contenido archivo
echo "#!/bin/bash"  > /etc/rc.local
echo "/etc/prelogin.sh" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local

#Reinicio del equipo
echo "Finalizado."
sleep 1
echo "Reincio en 5 segundos..."
sleep 5
systemctl reboot

