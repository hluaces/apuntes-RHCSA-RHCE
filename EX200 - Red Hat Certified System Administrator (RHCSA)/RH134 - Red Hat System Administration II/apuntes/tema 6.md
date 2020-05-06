# Tema 6 - Managing Basic Storage

- Adding Partitions, File Systems, and Persistent Mounts
- Managing Swap Space

## Adding Partitions, File Systems, and Persistent Mounts

### MBR

- _Master Boot Record_.
- Usado en arranque tipo BIOS.
- Tabla de particiones primarias al principio del disco.
- permite una de:
    - 4 particiones primarias
    - 3 primarias y una extendida. Las extendidas permiten crear particines lógicas en su interior hasta un total de 15 particiones.
- Tabla de particiones extendidas al principio de la partición.
- 2 TiB como máximo.

### GPT

- _GUID Partition Table_.
- Para sistemas UEFI.
- Permite 128 particiones. No hay diferencia entre primaria, extendida y lógica.
- Usa un GUID para identificar cada tabla/partición.
- Existe una tabla de particiones al principio del disco y al final.

### parted

- `parted <disco>`
- **Fijarse primero en el tipo de particionado**.
- `(parted) help`
- `(parted) help <accion>`
- **parted hace cambios de forma inmediata**
- `(parted) mklabel <tipo particionado>`: especifica el esquema de particionado
- `(parted) mkpart`: crea una partición de forma interactiva
- `udevadm settle` o `partprobe`
- `(parted) rm <numero>`: borra una partición
- `(parted) mkfs`: crea un sistema de archivos

### hacer persistente

- Editar `/etc/fstab`.
- Después de editar `/etc/fstab` hay que ejecutar `systemctl daemon-reload`.
- Puntos de montaje con UUID.
- `mount -a` monta sistemas no montados.
- En `/proc/partitions` se puede comprobar si el kernel conoce una partición

## Managing Swap Space

- Espacio en memoria secundaria para almacenar datos de memoria primaria.
- `swapon -s`: muestra los archivos de swap.
- `swapon <particion>`: activa de forma no persistente una swap.
- El punto de montaje en `/etc/fstab` es `swap`.
- La opción `pri` en fstab permite añadir un valor para especificar la prioridad de los archivos de swap. A mayor prioridad, más acceso.


### Crear una swap en disco

- Crear una partición.
-

# Preguntas

- ¿Diferencias de "udevadm settle" con "partprobe"? -> `udevadm` se ocupa de los dispositivos mientras que `partprobe` se _encargaba_ de las particiones del Kernel.

# Comandos

- `lsblk -fp`

# Mans importantes

# Enlaces interesantes

# Sumario

In this chapter, you learned:

- You use the parted command to add, modify, and remove partitions on disks with the MBR or the GPT partitioning scheme.
- You use the mkfs.xfs command to create XFS file systems on disk partitions.
- You need to add file-system mount commands to /etc/fstab to make those mounts persistent.
- You use the mkswap command to initialize swap spaces.
