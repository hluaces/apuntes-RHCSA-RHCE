EJERCICIO

Crear un playbook para que al ejecutarlo en servera.lab.example.com tengamos un fichero  /root/hosts con el contenido siguiente:
172.25.250.10   servera.lab.example.com
172.25.250.11   serverb.lab.example.com
172.25.250.12   serverc.lab.example.com

El fichero de inventario es el siguiente:


[dev]
servera.lab.example.com
serverd.lab.example.com

[prod]
serverb.lab.example.com
serverc.lab.example.com

