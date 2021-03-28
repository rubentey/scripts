#!/bin/bash
cat /etc/issue.net > /etc/issue
echo " " >> /etc/issue
echo "PC de Rubén" >> /etc/issue
echo " " >> /etc/issue
echo "Hostname: $(hostname)" >> /etc/issue
echo " " >> /etc/issue
echo "IP: $(hostname -I)" >> /etc/issue
echo " " >> /etc/issue


