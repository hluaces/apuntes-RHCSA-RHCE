# Tema 8 - Implementing Advanced Storage Features

- Managing Layered Storage with Stratis
- Compressing and Deduplicating Storage with VDO

# Statis

## Arquitectura

Hay soluciones comunitarias para gestionar de forma flexible el almacenamiento en base a volúmenes flexibles (léase: LVM), pero a ojos de Red Hat ninguna de estas tecnologías posee la madurez necesaria para considerarse de nivel empresarial, por lo que han sido ellos los que han desarrollado una nueva tecnología, ya madura, que gestiona este tipo de almacenamientos: _Stratis_, disponible en RHEL8.

_Stratis_ se ejecuta como un servicio que gestiona _pools_ de dispositivos físicos de almacenamiento y crea sobre ellos volúmenes de forma transparente. _Stratis_ utiliza herramientas y _drivers_ ya existentes, por lo que todas las características de almacenamiento a las que estamos acostumbrados siguen funcionando de forma normal.

La principal característica de Stratis es el _thin provisioning_, lo que implica que sus volúmenes no tienen un tamaño fijo. En su lugar, a éstos se les asigna un máximo de tamaño inicial y, a medida que crecen, van tomando automáticamente más espacio del grupo de volúmenes al que estén asociados. Dichos volúmenes también pueden reservar espacio, si fuese necesario.

Todos los sistemas de ficheros, dispositivos y volúmenes gestionados por _Stratis_ contienen metadatos y solo han de ser gestionados mediante las herramientas que _Stratis_ ofrece para tal fin.

Se pueden crear _pools_ con varios dispositivos. Sobre estos _pools_ se generan los volúmenes. Hay dos tipos de _pools_:

- Caché: Sirven para mejorar el rendimiento.
- Datos: Flexibilidad e integridad.

En la arquitectura de _Stratis_ destacan los siguientes subsistemas:

- _Backstore_: gestiona dispositivos de bloque.
- _Thinpool_: gestiona los _pools_.
- _dm-thin_: _device mapper_ para reemplazar a LVM.

_Stratis_ utiliza el demonio `stratisd` y las herramientas de cliente `stratis-cli`.

## Gestión de pools en Stratis

- `stratis pool create <nombre> <dispositivo>`: Crea un nuevo _pool_.
- `stratis pool list`: lista los _pools_ activos.
- `stratis pool add-data <pool> <dispositivo>`: Añade un dispositivo de bloque a un _pool_.
- `stratis blockdev list <pool>`: muestra los dispositivos de bloque de un _pool_.

Si existe un sistema de archivos en un dispositivo de bloques puede ser necesario destruirlo con `wipefs -a /<devicepath>`.

## Gestión de sistemas de ficheros

- `stratis filesystem create <pool> <nombre>`: crea un nuevo sistema de ficheros con nombre _nombre_ en un _pool_.
- `stratis filesystem snapshot <pool> <sistema> <nombre snapshot>`: crea un _snapshot_ de un sistema de ficheros.
- `stratis filesystem list`: lista los sistemas de ficheros existentes

## Montado de sistemas de ficheros

Todos los sistemas de ficheros gestionados por _Stratis_ se encuentran bajo el directorio `/stratis`.

Se montan en `/etc/fstab` como es de esperar, pero es necesario **montarlos con una opción que le indique a systemd que stratisd ha de ser iniciado antes de que se monten**.

Esto es importante puesto que de no hacerlo la máquina no hará _boot_.

Ejemplo de un _fstab_

```
UUID=3yat4...87aydya    /data   xfs   defaults,x-systemd-requires=stratisd.service  0   0
```

# VDO

## Descripción

VDO (_Virtual Data Optimizer_) es un driver presente en RHEL8 que permite optimizar la huella de tamaño de disco de la información mediante técnicas como la compresión o deduplicación.

Está formado por dos partes: el módulo `kvdo`, para la compresión, y el módulo `uds` para la deduplicación.

VDO se situa sobre los ficheros de bloques, pero antes de los volúmenes lógicos.

Para cualquier dato almacenado en un fichero que gestiona, VDO realiza estas tres optimizaciones:

- Elimina los ceros de los datos.
- Realiza deduplicación.
- Comprime los datos restantes.

## Implementación

VDO crea volúmenes lógicos llamados _volúmenes VDO_ que son similares a las particiones.

Un volumen VDO puede usarse como un _Physical Volume_ de LVM.

Un volumen VDO puede ser **de más tamaño** que el disco físico subyacente. De ser superior se perderá rendimiento a favor de ganar espacio.

En el caso de optar por tener más espacio es necesario monitorizar el disco con `vdostats --verbose`.

## Operaciones con VDO

- Instalar VDO requiere instalar `vdo` y `kmod-vdo`.
- Crear un volumen: `vdo create --name=<nombre> --device=<dispositivo> --vdoLogicalSize=<tamaño>`
- `vdo status` da información de los volúmenes VDO.
- `vdo list` muestra los volúmenes.

# Preguntas

- ¿Hay forma de eliminar un dispositivo de un _pool_? (ver [esta issue](https://github.com/stratis-storage/project/issues/160))

# Comandos


# Mans importantes


# Enlaces interesantes

- https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_and_managing_file_systems/
- https://computingforgeeks.com/stratis-storage-management-cheatsheet/
- https://opensource.com/article/18/4/stratis-lessons-learned
- https://stratis-storage.github.io/

# Sumario

In this chapter, you learned:

- The Stratis storage management solution implements flexible file systems that grow dynamically with data.
- The Stratis storage management solution supports thin provisioning, snapshotting, and monitoring.
- The Virtual Data Optimizer (VDO) aims to reduce the cost of data storage.
- The Virtual Data Optimizer applies zero-block elimination, data deduplication, and data compression to optimize disk space efficiency.

