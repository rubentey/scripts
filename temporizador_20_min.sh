#!/bin/bash
pic=/usr/share/pixmaps/blueman/blueman-lq-100.png
notify-send "Cuenta atrás - 20 min" "Suerte" -i $pic
sleep 3
notify-send "Empezamos!" -i $pic
echo "Empezamos" $(date)
sleep 300
notify-send "Ya van 5 minutos" -i $pic
echo "5 min" $(date)
sleep 300
notify-send "Ya van 10 minutos" -i $pic
echo "10 min" $(date)
sleep 180
notify-send "Ya van 13 minutos" -i $pic
echo "13 min" $(date)
sleep 120
notify-send "Ya van 15 minutos" -i $pic
echo "15 min" $(date)
sleep 120
notify-send "Ya van 17 minutos" -i $pic
echo "17 min" $(date)
sleep 60
notify-send "Ya van 18 minutos" -i $pic
echo "18 min" $(date)
sleep 60
notify-send "Ya van 19 minutos" -i $pic
echo "19 min" $(date)
sleep 60
notify-send "Ya van 20 minutos" -i $pic
echo "20 min" $(date)

sleep 2
notify-send "Se acabó" -i $pic
