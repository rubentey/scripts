#!/usr/bin/env python3
import os
op_main = 0
dir = os.getcwd()
#metodo comandos_basicos
def comandos_basicos():
    op_menu = 0
    #bucle hasta que el usuario tecle 10
    while (op_menu != 10):
        try:
            print("++++++++++++++++++++++++++++++++++++++++++++++++")
            print("|                COMANDOS BASICO               |")
            print("|          Esta trabajando en " + dir + "      |")
            print("|++++++++++++++++++++++++++++++++++++++++++++++|")
            print("|          1.Listar contenido                  |")
            print("|          2.Crear directorio                  |")
            print("|          3.Crear fichero vacio               |")
            print("|          4.Escribir en fichero               |")
            print("|          5.Leer fichero                      |")
            print("|          6.Cambiar nombre directrio/fichero  |")
            print("|          7.Comparar dos fichero              |")
            print("|          8.Ver la ruta actual                |")
            print("|          9.Eliminar directorio/fichero       |")
            print("|          10.Salir                            |")
            print("|++++++++++++++++++++++++++++++++++++++++++++++|")
            op_menu = (input("|Introduzca opcion menu:                       |"))
            print("++++++++++++++++++++++++++++++++++++++++++++++++")
            #si la opcion introducida no es numerica se lanza excepcion
            if (not op_menu.isdigit()):
                raise ValueError("ERROR: Debe introducir valores enteros")
            #pasamos el valor a int
            op_menu = int(op_menu)
            #si la opcion no es ninguna del menu se lanza excepcion
            if (op_menu != 1 and op_menu != 2 and op_menu != 3 and op_menu != 4 and op_menu != 5 and op_menu != 6 and op_menu != 7
                    and op_menu != 8 and op_menu != 9 and op_menu != 10):
                raise ValueError("ERROR: Opcion incorrecta")
            print("")
            #funciones de cada opcion del menu
            if (op_menu == 1):
                comando = "ls -l"
                os.system(comando)
            elif (op_menu == 2):
                nombre_carpeta = str(input("Introduzca nombre del directorio: "))
                comando = "mkdir " + nombre_carpeta
                if (not os.path.exists(nombre_carpeta)):
                    print("Se ha creado el directorio con nombre " + nombre_carpeta)
                os.system(comando)
            elif (op_menu == 3):
                nom_fichero = str(input("Introduzca el nombre del fichero a crear: "))
                comando = "touch " + nom_fichero
                if (not os.path.exists(nom_fichero)):
                    print("Se ha creado el fichero vacio con nombre " + nom_fichero)
                os.system(comando)
            elif (op_menu == 4):
                nom_fichero = str(input("Introduzca nombre del fichero: "))
                comando = "nano " + nom_fichero
                if (os.path.exists(nom_fichero)):
                    os.system(comando)
                else:
                    print("No existe el fichero " + nom_fichero)
            elif (op_menu == 5):
                nom_fichero = str(input("Introduzca el nombre del fichero a leer: "))
                print(" ")
                comando = "cat " + nom_fichero
                os.system(comando)
            elif (op_menu == 6):
                nom_fichero_actual = str(input("Introduzca el nombre del directorio/fichero actual: "))
                nom_fichero_new = str(input("Introduzca el nombre del directorio/fichero al que desea cambiar: "))
                comando = "mv " + nom_fichero_actual + " " + nom_fichero_new
                if (not os.path.exists(nom_fichero_new)):
                    print("Se ha cambiado el nombre de " + nom_fichero_actual + " a " + nom_fichero_new)
                os.system(comando)
            elif (op_menu == 7):
                nom_fichero_1 = str(input("Introduzca el nombre del fichero 1: "))
                nom_fichero_2 = str(input("Introduzca el nombre del fichero 2: "))
                print(" ")
                comando = "diff " + nom_fichero_1 + " " + nom_fichero_2
                os.system(comando)
            elif (op_menu == 8):
                os.system('pwd')
            elif (op_menu == 9):
                nombre_carpeta = str(input("Introduzca nombre del directorio a eliminar: "))
                comando = "rm -r " + nombre_carpeta
                if (os.path.exists(nombre_carpeta)):
                    print("Se ha eliminado el directorio con nombre " + nombre_carpeta)
                os.system(comando)
            elif (op_menu == 10):
                print("Gracias por usar el apartado de Gestion usuario")
            print("")
            #imprime el comando empleado
            if (op_menu == 1 or op_menu == 2 or op_menu == 3 or op_menu == 4 or op_menu == 5 or op_menu == 6 or op_menu == 7
                    or op_menu == 8 or op_menu == 9):
                print("Comando empleado : " + comando)

        except ValueError as e:
            print(e)

#metodo gestion_user
def gestion_user():
    op_menu = 0
    #bucle hasta que el usuario tecle 9
    while (op_menu != 9):
        try:
            print("++++++++++++++++++++++++++++++++++++++++++++++++")
            print("|             GESTION USUARIO                  |")
            print("|        Esta trabajando en " + dir + "        |")
            print("|++++++++++++++++++++++++++++++++++++++++++++++|")
            print("|           1.Crear usuario                    |")
            print("|           2.Eliminar usuario                 |")
            print("|           3.Dar permisos sudo                |")
            print("|           4.Crear grupo                      |")
            print("|           5.Eliminar grupo                   |")
            print("|           6.Añadir usaurio grupo             |")
            print("|           7.Eliminar usuario del grupo       |")
            print("|           8.Grupos del user                  |")
            print("|           9.Salir                            |")
            print("|++++++++++++++++++++++++++++++++++++++++++++++|")
            op_menu = (input("|Introduzca opcion menu:                       |"))
            print("++++++++++++++++++++++++++++++++++++++++++++++++")
            #si la opcion introducida no es numerica se lanza excepcion
            if (not op_menu.isdigit()):
                raise ValueError("ERROR: Debe introducir valores enteros")
            #pasamos el valor a int
            op_menu = int(op_menu)
            #si la opcion no es ninguna del menu se lanza excepcion
            if (op_menu != 1 and op_menu != 2 and op_menu != 3 and op_menu != 4 and op_menu != 5 and op_menu != 6 and op_menu != 7
                and op_menu != 8 and op_menu != 9):
                raise ValueError("ERROR: Opcion incorrecta")
            print("")
            #funciones de cada opcion del menu
            if (op_menu == 1):
                nom_usr = str(input("Introduzca nombre del usuario: "))
                comando = "sudo adduser " + nom_usr
                print("")
                os.system(comando)
                print("")
            elif (op_menu == 2):
                nom_usr = str(input("Introduzca nombre del usuario a eliminar: "))
                comando = "sudo deluser " + nom_usr
                os.system(comando)
            elif (op_menu == 3):
                nom_usr = str(input("Introduzca nombre del usuario al cual quiere poner permiso sudo: "))
                comando = "sudo adduser " + nom_usr + "sudo"
                os.system(comando)
            elif (op_menu == 4):
                nom_grp = str(input("Introduzca nombre del grupo a crear: "))
                comando = "sudo addgroup " + nom_grp
                os.system(comando)
            elif (op_menu == 5):
                nom_grp = str(input("Introduzca nombre del grupo a eliminar: "))
                comando = "sudo delgroup " + nom_grp
                os.system(comando)
            elif (op_menu == 6):
                nom_grp = str(input("Introduzca nombre del grupo : "))
                nom_usr = str(input("Introduzca nombre del usuario: "))
                comando = "sudo adduser " + nom_usr + " " + nom_grp
                os.system(comando)
            elif (op_menu == 7):
                nom_grp = str(input("Introduzca nombre del grupo : "))
                nom_usr = str(input("Introduzca nombre del usuario: "))
                comando = "sudo deluser " + nom_usr + " " + nom_grp
                os.system(comando)
            elif (op_menu == 8):
                comando = "groups"
                os.system(comando)
            elif (op_menu == 9):
                print("Gracias por usar el apartado comandos basicos")
            print("")
            # imprime el comando empleado
            if (op_menu == 1 or op_menu == 2 or op_menu == 3 or op_menu == 4 or op_menu == 5 or op_menu == 6 or op_menu == 7
                    or op_menu == 8 or op_menu == 9):
                print("Comando empleado : " + comando)

        except ValueError as e:
            print(e)


def comandos_redes_actualizar():
    op_menu = 0
    #bucle hasta que el usuario tecle 11
    while (op_menu != 11):
        try:
            print("++++++++++++++++++++++++++++++++++++++++++++++++")
            print("|          COMANDOS REDES / ACTUALIZAR         |")
            print("|          Esta trabajando en " + dir + "      |")
            print("|++++++++++++++++++++++++++++++++++++++++++++++|")
            print("|          1.Ver infomacion de la red          |")
            print("|          2.Ver tabla de direcciones          |")
            print("|          3.Consultas al DNS                  |")
            print("|          4.Trazar una ruta                   |")
            print("|          5.Ver los puertos abiertos          |")
            print("|          6.Desactivar interfaz red           |")
            print("|          7.Activar interfaz red              |")
            print("|          8.Actualizar la lista paquetes      |")
            print("|          9.Instalar un paquete               |")
            print("|          10.Actualizar el sistema            |")
            print("|          11.Salir                            |")
            print("|++++++++++++++++++++++++++++++++++++++++++++++|")
            op_menu = (input("|Introduzca opcion menu:                       |"))
            print("++++++++++++++++++++++++++++++++++++++++++++++++")
            #si la opcion introducida no es numerica se lanza excepcion
            if (not op_menu.isdigit()):
                raise ValueError("ERROR: Debe introducir valores enteros")
            #pasamos el valor a int
            op_menu = int(op_menu)
            #si la opcion no es ninguna del menu se lanza excepcion
            if (op_menu != 1 and op_menu != 2 and op_menu != 3 and op_menu != 4 and op_menu != 5 and op_menu != 6 and op_menu != 7
                    and op_menu != 8 and op_menu != 9 and op_menu != 10 and op_menu != 11):
                raise ValueError("ERROR: Opcion incorrecta")
            print("")
            #funciones de cada opcion del menu
            if (op_menu == 1):
                comando = "ip a"
                os.system(comando)
            elif (op_menu == 2):
                comando = "route -n "
                os.system(comando)
            elif (op_menu == 3):
                consulta = str(input("Introduzca ip o nombre del DNS: "))
                comando = "dig " + consulta
                os.system(comando)
            elif (op_menu == 4):
                ruta = str(input("Introduzca ip o nombre de la ruta: "))
                comando = "traceroute " + ruta
                os.system(comando)
            elif (op_menu == 5):
                print("")
                comando = "netstat -l"
                os.system(comando)
            elif (op_menu == 6):
                nom_interfaz = str(input("Introduzca el nombre de la tarjeta intefaz(comprobar con opcion 1): "))
                comando = "sudo ifconfig " + nom_interfaz + " down"
                os.system(comando)
            elif (op_menu == 7):
                nom_interfaz = str(input("Introduzca nombre de la tarjeta intefaz(comprobar con opcion 1): "))
                comando = "sudo ifconfig " + nom_interfaz + " up"
                os.system(comando)
            elif (op_menu == 8):
                comando = "sudo apt update "
                os.system(comando)
            elif (op_menu == 9):
                nom_paquete = str(input("Introduzca nombre del paquete a instalar: "))
                comando = "sudo apt install " + nom_paquete
                os.system(comando)
            elif (op_menu == 10):
                comando = "sudo apt upgrade "
                os.system(comando)
            elif (op_menu == 11):
                print("Gracias por usar el apartado de Comandos redes / Actualizar")
            print("")
            # imprime el comando empleado
            if (op_menu == 1 or op_menu == 2 or op_menu == 3 or op_menu == 4 or op_menu == 5 or op_menu == 6 or op_menu == 7
                    or op_menu == 8 or op_menu == 9 or op_menu == 10 or op_menu == 11):
                print("Comando empleado : " + comando)

        except ValueError as e:
            print(e)

#metodo consultar_man
def consultar_man():
    print("")
    print("Tiene que teclear 'q' para salir del manual")
    nom_comando = str(input("Introduzca nombre del comamdo a consultar: "))
    comando = "man " + nom_comando
    os.system(comando)
    print("")

#principal
#bucle hasta que el usuario tecle 5
while (op_main != 5):
    try:
        print("++++++++++++++++++++++++++++++++++++++++++")
        print("|        Bienvenido/a a easy command     |")
        print("|++++++++++++++++++++++++++++++++++++++++|")
        print("|         1.Comandos basicos             |")
        print("|         2.Gestion de usuarios          |")
        print("|         3.Comados redes / Actualizar   |")
        print("|         4.Consultar manual comando     |")
        print("|         5.Salir                        |")
        print("|++++++++++++++++++++++++++++++++++++++++|")
        op_main = (input("|Introduzca opcion menu:                 |"))
        print("++++++++++++++++++++++++++++++++++++++++++")
        # si la opcion introducida no es numerica se lanza excepcion
        if (not op_main.isdigit()):
            raise ValueError("ERROR: Debe introducir valores enteros")
        # pasamos el valor a int
        op_main = int(op_main)
        # si la opcion no es ninguna del menu se lanza excepcion
        if (op_main != 1 and op_main != 2 and op_main != 3 and op_main != 4 and op_main !=5):
            raise ValueError("ERROR: Opcion incorrecta")
        # funciones de cada opcion del menu
        if (op_main == 1):
            comandos_basicos()
        elif (op_main == 2):
            gestion_user()
        elif (op_main == 3):
            comandos_redes_actualizar()
        elif (op_main == 4):
            consultar_man()
        elif (op_main == 5):
            print("Gracias por utilizar easy command")
    except ValueError as e:
        print(e)

