#!/bin/bash

# Este script instala un servidor NFS donde se ejecute para que comparta los directorios 
#          /marketing/folletos , /marketing/videos  en ro 
#         /docs  en rw, podrá escribir el usuario sin privilegios que elijas (el de la variable definada mas abajo MI_USER )

# NOTA: testeado en un rhel/centos 8 con una instalación "minimal", ip estática, firewalld y NetworkManager.

# BEST PRACTICE: Antes de nada se suele hacer : 
#                                            yum update -y ; systemctl reboot 


# Variables a las que se necesita dar valor antes de ejecutar el script:

MI_RED=""   #  aquí pon la red en la que está tu máquina virtual, p.e. 192.168.122.0/24
MI_USER=""  #  aquí pon el usuario sin privilegios que quieres usar, tiene que ser EL MISMO EN CLIENTE QUE EN SERVIDOR, lo tienes que crear en ambas mv con el mismo uid
            #  antes de ejecutar el script.
MI_PASSWORD="" # Password que quieres para el usuario
 
# cd al dir donde está este file
# Dar la ejecución a este file.
# Ejecutar el script


# software
yum install nfs-utils -y
# servicio
systemctl start nfs-server.service 
systemctl enable nfs-server.service 
# recursos
mkdir -p /marketing/{folletos,videos}
mkdir -m700 /docs
useradd ${MI_USER} 
echo ${MI_PASSWORD} | passwd --stdin ${MI_USER}
chown ${MI_USER} /docs
echo "Esto es una prueba de fichero exportado por NFS" > /docs/doc1.txt
echo "/docs  	${MI_RED}(rw,sync)" >> /etc/exports
echo "/marketing/videos   ${MI_RED}(ro,sync)" >> /etc/exports
echo "/marketing/folletos   ${MI_RED}(ro,sync)" >> /etc/exports
touch /marketing/videos/presentacion{1,2}.avi
touch /marketing/folletos/producto{1,2}.ppt
# cargar recursos
exportfs -r
# firewall
firewall-cmd --permanent --add-service nfs
firewall-cmd --reload

