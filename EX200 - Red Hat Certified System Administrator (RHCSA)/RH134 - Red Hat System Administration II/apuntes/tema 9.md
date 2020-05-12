# Tema 9 - Accessing Network-Attached

- Mounting Network-Attached Storage with NFS
- Automounting Network-Attached Storage

# Mounting Network-Attached Storage with NFS

* RHEL 8 solo soporta NFS 4, que usa únicamente TCP.
* NFS 3 usaba tanto TCP como UDP.
* Un servidor NFS exporta puntos de montaje que pueden ser montados por clientes.
* Dichos puntos pueden montarse con:
    * `mount`
    * `/etc/fstab`
    * `autofs` o `systemd-automount`
* Has operaciones de NFS pueden ser sínronas o asíncronas.
* Hay dos opciones importante al montar discos NFS:
    * _soft_: si NFS da timeout va probando cada cierto tiempo a ver si va OK. Puede dejar el sistema de archivos corrupto ya que no es muy estricto.
    * _hard_: cuando hay fallos de red insiste para intentar recuperar el sistema de archivos. Gasta más recursos.

Ejemplo de montaje de NFS (nótese que se usa _sync_ y no _async_ que es el valor por defecto):

```bash
mount -t nfs -o rw, sync servidor:/directorio/exportado /directorio
```

Un ejemplo de montaje en el `/etc/fstab`:

```bash
servidor:/directorio/exportado  /directorio     nfs     rw,sync     0   0
```

La configuración de NFS se hace en `/etc/nfs.conf` (antiguamente: `/etc/sysconfig/nfs.conf`).

## Usando Nfsconf

`nfsconf` es una herramienta CLI alternativa a editar el archivo de configuración.

Algunas opciones:

- `nfsconf --get <sección> <opción>`: devuelve el valor de una opción (si no está descomentado en el fichero no devuelve nada).
- `nfsconf --set <sección> <opción> <valor>`: establece un valor en el fichero.
- `nfsconf --unset <sección> <opción> <valor>`:

El comando `nfsstat -m` permite ver el estado de NFS.

Configurar NFS para utilizar solo la versión 4 puede conseguirse negando la compatibilidad con versión 3 en el archivo de configuración:

```bash
# Desactivar v3 y udp
[user@host ~]$ sudo nfsconf --set nfsd udp n
[user@host ~]$ sudo nfsconf --set nfsd vers2 n
[user@host ~]$ sudo nfsconf --set nfsd vers3
# Activar v4 y tcp
[user@host ~]$ sudo nfsconf --set nfsd tcp y
[user@host ~]$ sudo nfsconf --set nfsd vers4 y
[user@host ~]$ sudo nfsconf --set nfsd vers4.0 y
[user@host ~]$ sudo nfsconf --set nfsd vers4.1 y
[user@host ~]$ sudo nfsconf --set nfsd vers4.2 y
```

## Usando automount / autofs

Autofs permite definir puntos de montaje remotos que serán montados sólo cuando se usen y desmontados pasado un periodo de inactividad.

Ventajas:

- Montaje bajo demanda.
- No requiere ser `root` para montar bajo demanda.
- No están permanentemente conectadas, ahorrando recursos.
- No requiere configuración en el servidor.
- Los parámetros son muy parecidos a los de `mount`.

Autofs requiere el paquete `autofs`.

Para usarlo hay que crear un fichero en `/etc/auto.master.d`. En él se especifican los _directorios maestros_ (directorios raíz de puntos de montaje) y los ficheros de _mapping_, donde se especifican los recursos a montar de cada maestro. El fichero creado ha de tener extensión `.autofs`.

Un ejemplo de fichero `/etc/auto.master.d/ejemplo.autofs`:

```bash
/shares /etc/autofs.shares.conf
```

Y su correspondiente _mapping_ `/etc/autofs.shares.conf`:

```bash
nombre_directorio_local -rw,sync serverb.lab.example.com:/shares/work
```
Nótese que las opciones de montado empiezan con el carácter "-".

El autofs requiere activar el servicio `autofs`.

Hay dos tipos de mapeos: _directos_ e _indirectos_.

### Mapeos directos

Los _mapeos directos_ relacionan un recurso compartido con una ruta absoluta de un punto de montaje.

Todos los ficheros _maester_ que usen mapeos directos comienzan por `/-`, p.ej. el fichero `/etc/auto.master.d/mapeo_directo.autofs` podría ser:

```bash
/-  /etc/autofs.mapeo_directo.conf
```

Y el fichero de mapeo `/etc/autofs.mapeo_directo.conf`podría ser:

```bash
/mnt/datos -rw,sync serverb:/shares/compartido
```

### Mapeos indirectos

Los mapeos indirectos sirven para gestionar varios puntos de montaje mediante _wildcards_ en una única línea de un fichero de mapeo.

Asumiendo el siguiente fichero maestro:

```bash
/mnt /etc/mapeo_indirecto.autofs
```

Podríamos usar el siguiente fichero de mapeo:

```bash
* -rw,sync serverb:/shares/compartido/&
```

Cabe destacar los carácteres `*` y `&`. El uso de ambos permitiría que los siguientes directorios se mapeasen de forma automática:

```
/mnt/compartido -> serverb:/shares/compartido
/mnt/datos      -> serverb:/shares/imagenes
/mnt/imagenes   -> serverb:/shares/imagenes
```


## Automounting Network-Attached Storage


# Preguntas

# Comandos

- `exportfs -v`: Muestra detalles de los directorios exportados mediante nfs.

# Mans importantes

- man:automount
- man:autofs
- man:mount(8)
- man:umount(8)
- man:fstab(5)
- man:mount.nfs(8)
- man:nfs.conf(8)
- man:nfsconf(8)

# Enlaces interesantes

# Sumario

In this chapter, you learned how to:

* Mount and unmount an NFS export from the command line.
* Configure an NFS export to automatically mount at startup.
* Configure the automounter with direct and indirect maps, and describe their differences.
* Configure NFS clients to use NFSv4 using the new nfsconf tool.
