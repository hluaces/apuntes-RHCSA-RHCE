# Tema 11 - Managing Network Security

- Managing Server Firewalls
- Controlling SELinux Port Labeling

## Managing Server Firewalls

- El Kernel implementa _netfilter_ como mecanismo para que el resto de módulos interactue con el _stack_ de _networking_.
- _iptables_ es (o era) un frontend de _netfilter_.
- Además, el Kernel también incluye otro módulo conocido como _nftables_ que mejora _netfilter_.
- _nftables_ no usa iptables -la cual se mantiene con un _symlink_- si no que usa la herramienta _nft_.
- El paquete `xtables-nft-multi` permite compatibilidad entre _iptables_ y _nft_.

_firewalld_ es un nuevo frontend de filtrado que tanto usa _iptables_ como _nft_ en función de la versión de RHEL en la que se use. Este sistema usa D-Bus para que el resto de aplicaciones se comuniquen con él.

Su funcionamiento es el siguiente:

- El tráfico se divine en _zonas_.
- Cada paquete entrante, en función de su ip origen o interfaz, se cataloga en una _zona_.
- Cada zona determina su conjunto de puertos o protocolos permitidos.

Nótese que _firewalld_ se integra con _NetworkManager_, permitiendo que éste defina a qué zona corresponde cada conexión.

Cada vez que entra un paquete se realizan estos pasos:

1. Se elige la zona que va a aplicarse acorde a estos criterios:
    - Si su dirección ip origen está en una zona, se usa esa.
    - Si no, se comprueba su interfaz entrante.
    - Si no, se usa una zona por defecto.
2. En función de la zona, se determina si el tráfico está dentro de los que permite la zona.
    - Si lo está, se acepta.
    - En caso contrario, se verifica el _target_ de la zona, que determinará qué se hace con ese tráfico.

### Zonas predefinidas

Las siguientes zonas están predefinidas en RHEL:

- _trusted_: permite todo el tráfico.
- _internal_: permite ssh, mdns, ipp-client, samba-client o dhcpv6-client.
- _home_: igual que internal.
- _work_: permite ssh, ipp-client, dhcpv6-client.
- _public_: permite ssh o dhcpv6-client. Zona por defecto de nuevas interfaces.
- _external_: permite ssh. El tráfico saliente es _masqueraded_ para que parezca que proviene de la interfaz saliente.
- _dmz_: permite ssh.
- _block_: bloquea todo el tráfico.
- _drop_: bloquea todo el tráfico sin devolver errores ICMP.

Todas las zonas anteriores, salvo _block_, permiten el tráfico entrante si está relacionado con el saliente.

Los siguientes comandos están relacionados con la gestión de zonas:

- `firewall-cmd --list-all-zones`: lista todas las zonas.

### Servicios predefinidos

Los siguientes comandos están relacionados con la gestión de servicios:

- `firewall-cmd --get-services`: lista todos los servicios.
- `firewall-cmd --list-services [zona]`: devuelve los servicios asociados a una zona.

Los siguientes ficheros están relacionados con la gestión de servicios:

- `/usr/lib/firewalld/services/*`: ficheros de definición de servicio.
- `/etc/firewalld/services/*`: override de los anteriores.

A la hora de definir -o modificar- un nuevo servicio es práctica habitual copiar de `/usr/lib/firewalld/` en `/etc/firewalld/` y modificar ahí.

### Haciendo cambios con firewall-cmd

Los cambios realizados con `firewall-cmd` son en _runtime_. Es necesario la flag `--permanent` para que éstos sean permanentes, en este caso la configuración no se aplica a _runtime_ salvo que después se haga un `firewall-cmd --reload`.

La mayoría de comandos necesitan un parámetro `--zone=<zona>` para funcionar.

Comandos más usados:

- `--get-default-zone`: devueve la zona por defecto.
- `--set-default-zone=<zona>`: establece la zona por defecto.
- `--get-zones`: lista todas las zonas existentes.
- `--get-active-zones`: muestra las zonas que tengan una IP o interfaz asociada.
- `--add-source=<CIDR>`: añade una nueva IP de origen a una zona.
- `--remove-source=<CIDR>`: elimina una IP de origen a una zona.
- `--add-interface=<INTERFACE>`: añade una nueva interfaz a una zona.
- `--change-interface=<INTERFACE>`: elimina una interfaz de una zona.
- `--list-all`: muestra todas las zonas activas y sus detalles.
- `--list-all-zones`: muestra todas las zonas y sus detalles.
- `--add-service=<SERVICE>`: añade un servicio a una zona.
- `--add-port=<PORT>/<PROTOCOL>`: añade un puerto a una zona.
- `--remove-service=<SERVICE>`: elimina un servicio de una zona.
- `--remove-port=<PORT>/<PROTOCOL>`: elimina un puerto de una zona.
- `--reload`: recarga la configuración de _firewalld_.
- `--runtime-to-permanent`: convierte **toda** la configuración de _runtime_ en persistente.

## Controlling SELinux Port Labeling

- Los puertos tienen etiquetas de SELinux.
- Cuando un proceso quiera usar o escuchar de un puerto tendrá que tener su etiqueta (recordad parámetro `-Z` de `ps`).
- Pueden gestionarse las etiquetas de los puertos con `semanage` (requiere instalar `policycoreutils-python`).

Comandos útiles:

- `semanage port -l`: listar las etiquetas de puertos conocidos.
- `semanage port -l -C`: listar las etiquetas de puertos que han sido manipulados.
- `semanage port -a -t <tag> -p <tcp|udp> <puerto>`: Añade etiquetado a un puerto.
- `semanage port -d -t <tag> -p <tcp|udp> <puerto>`: Elimina etiquetado de un puerto.
- `semanage port -m -t <tag> -p <tcp|udp> <puerto>`: Modifica etiquetado de un puerto.


**IMPORTANTE**: buena parte de la documentación de SELinux está en el paquete `selinux-policy-doc`.

# Preguntas

# Mans importantes

- man:firewall-cmd(1)
- man:firewalld(1)
- man:firewalld.zone(5)
- man:firewalld.zones(5),
- man:nft(8)
- man:semanage(8)
- man:semanage-port(8)
- man:\*\_selinux(8)

# Enlaces interesantes

# Sumario

In this chapter, you learned:

- The netfilter subsystem allows kernel modules to inspect every packet traversing the
system. All incoming, outgoing or forwarded network packets are inspected.
- The use of firewalld has simplified management by classifying all network traffic into zones.
Each zone has its own list of ports and services. The public zone is set as the default zone.
- The firewalld service ships with a number of pre-defined services. They can be listed using
the firewall-cmd --get-services command.
- Network traffic is tightly controlled by the SELinux policy. Network ports are labeled. For
example, port 22/TCP has the label ssh_port_t associated with it. When a process wants to
listen on a port, SELinux checks to see whether the label associated with it is allowed to bind that port label.
- The semanage command is used to add, delete, and modify labels.
