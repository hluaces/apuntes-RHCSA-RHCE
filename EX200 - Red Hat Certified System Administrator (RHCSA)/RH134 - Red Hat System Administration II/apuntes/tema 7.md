# Tema 7 - Managing Logical Volumes

- Creating Logical Volumes
- Extending Logical Volumes

# Terminología LVM

- Particiones o discos -> dispositivos de bloques.
    - En parted hay que dar la marca `8e` a las particiones.
- Dichas particiones se traducen en "_Volúmenes físicos_" con marcas en el segundo sector que indican que son de LVM (conocidos como _Physical Volumes_).
- Los volúmenes físicos se agrupan en _Grupos de volúmenes_ (conocidos como _Volume Groups_)
    - Los grupos de volúmenes tienen tanto tamaño como la suma de sus volúmenes físicos.
- En cada grupo de volúmenes pueden crearse volúmenes lógicos (_Logical Volumes_), que no son más que "particiones" del grupo de volúmenes.

Extents:

- Un volumen lógico es un conjunto de _extents_ lógicos.
- Los _extents_ son la unidad mínima sobre la que funciona LVM (tal y como una _página_ es una unidad de memoria).
- Por defecto `1 extent = 4MiB`. Tamaño múltiplo de 8 y mínimo de 1KiB.
    - Un valor my usado para _extent_ es 32MiB.
- Rigurosamente hablando existent _extents_ físicos y lógicos mapeados entre sí.
    - En entornos de mirroring un _extent_ físico se mapea en más de un lógico.
- Modificar el tamaño del _extent_ hacia arriba hace que las herramientas LVM rindan mejor, pero el del sistema de archivos no se ve modificado.

# Crear y borrar

## Crear volúmenes lógicos

Para crear volúmenes lógicos hay que seguir estos pasos:

1. Identificar los discos que queremos usar para nuestro conjunto de LVM.
2. Particionar dichos discos con _parted_ estavbeciendo el flag LVM (`set lvm on`).
    - Red Hat recomienda particionar cada disco con una única partición que ocupe el 100% para LVM.
3. Crear un _Physical Volume_ en cada partición.
4. Crear un _Volume Group_ que utilice todos los _Physical Volume_.
5. Dentro del _Volume Group_ crear tantos _Logical Volume_ como queramos.
6. Formatear y montar cada _Logical Volume_ de forma normal.

Nótese que puede usarse la ruta de LVM en `/etc/fstab` sin preocuparse del UUID ya que el _devmapper_ usa internamente su UUID así que sería lo mismo.

## Borrar un volumen lógico

Básicamente hay que hacer los pasos en el orden inverso.

1. Migrar datos si es necesario.
2. Desmontar el sistema de archivos y tocar el _fstab_, si procede.
3. Eliminar el _Logical Volume_.
4. Eliminar el _Volume Group_.
5. Eliminar los _Physical Volumes_.
6. Reparticionar los discos.

# Extensión

## Extender Volume Groups

Un _Volume Group_ puede extenderse en caliente añadiéndole más _Physical Volumes_.

Para ello:

1. Particionar los nuevos discos que vayan a utilizarse.
2. Crear _Physical Volumes_ en las particiones a usar.
3. Usar el comando `vgextend <nombre grupo> <ruta volumen físico>` para añadir dicho disco al _Volume Group_.

## Extender Logical Volumes

Puede extenderse de forma normal y en caliente. Para ello:

1. Verificar que hay espacio en el _Volume Group_ con `vgdisplay` o `vgs`.
2. Usar `lvextend -L +<tamaño en M> <ruta al volumen lógico>` para extenderlo.
3. Usar las herramientas del sistema de ficheros (`resize2fs`, `xfs_grow`, etc.) para adaptarlo al nuevo espacio.
    - Alternativamente puede pasarse el parámetro `-r` a `lvextend`, si bien no es capaz de hacerlo en todos los sistemas de archivos.
4. Listo. El sistema debería haberse redimensionado.

Alternativamente `lvextend` puede usar `-l` para especificar el tamaño en _extents_ y no en M o MB.

Algunos formatos de `lvextend`:

- `lvextend -l 128`: Redimensionar a 128 _extents_.
- `lvextend -l +128`: Ampliar en 128 _extents_.
- `lvextend -L 128M`: Redimensionar a 128 MiB.
- `lvextend -L +128M`: Ampliar en 128 MiB.
- `lvextend -l +50%FREE`: Añadir el 50% del espacio libre.

### Caso especial: swap

Extender una partición de swap en LVM es parecido al proceso anterior, pero es necesario:

- Previamente desmontar la swap con `swapoff`.
- Realizar los cambios pertinentes.
- Formatear como swap con `mkswap`.
- Remontar.

# Reducción

## Reducir Volume Groups

Para reducir el tamaño de un _Volume Group_ se le puede eliminar algún _Physical Volume_ para reducir su espacio, **en cuyo caso pueden perderse datos**. Se puede realizar en caliente.

En el anterior caso de uso se puede utilizar comandos como `pmove` para mover los datos de un _Physical Volume_ a otro dentro del grupo antes de retirarlo.

Para retirar:

1. Usar el comando `pmove <ruta al volumen físico>` para mover los datos de ese volumen físico a otros dentro del grupo. No es necesario especificar cuál.
2. Usar el comando `vgreduce <grupo> <ruta al volumen físico>` para eliminar el _Physical volume_ del grupo.
3. Usar `pvremove <ruta al volumen fisico>` para eliminarlo.

## Reducir volúmenes lógicos

Esto es más complicado ya que es necesario , para empezar, que el sistema de archivos permita reducciones (_ext4_ sí, pero _xfs_) no.

En caso de que sí lo permita habría que usar un `resize2fs <path> <nuevo tamaño>` seguido de un `lvreduce -L -<tamaño a reducir> <ruta al volumen lógico>`.

Acto seguido podría reducirse volumen lógico y físico, si fuese necesario.

# Comandos

- Listado corto: `pvs`, `vgs`, `lvs`
- Listado detallado: `pvdisplay`, `vgdisplay`, `lvcreate`
- Comandos de creación: `pvcreate`, `vgcreate`, `lvcreate`
- Comandos de destrucción: `pvremove`, `vgremove`, `lvremove`

# Mans importantes

- man:vgcreate
- man:lvcreate

# Enlaces interesantes

# Sumario

In this chapter, you learned:

- LVM allows you to create flexible storage by allocating space on multiple storage devices.
- Physical volumes, volume groups, and logical volumes are managed by a variety of tools such as pvcreate, vgreduce, and lvextend.
- Logical volumes can be formatted with a file system or swap space, and they can be mounted persistently.
- Additional storage can be added to volume groups and logical volumes can be extended dynamically.
