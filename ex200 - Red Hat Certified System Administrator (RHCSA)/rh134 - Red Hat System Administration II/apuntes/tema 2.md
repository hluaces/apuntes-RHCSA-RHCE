# Tema 2 - Scheduling future tasks

- Scheduling a Deferred User Job
- Scheduling Recurring User Jobs
- Scheduling Recurring System Jobs
- Managing Temporary Files

## Scheduling a Deferred User Job

- Servicio `atd`
- Frontend comando `at`

Ejemplo #1:

```shell

echo "hola" | at 18:30
```

Ejemplo #2:



## Scheduling Recurring User Jobs

### Servicio `crond`

- ¡¡MUCHO OJO CON CRON QUE ENGAÑA MUCHO LA SINTAXIS!!, ¡¡preguntas trampa!!
- Los `/etc/cron.{daily,weekly,...}` usan `anacron` y al reiniciar recalculan trabajos a ejecutar.
- Cron no respeta reinicios. `/etc/anacrontab` sí lo hace.
- En unitfiles el prefijo `-` ante un fichero significa que lo ignore si no existe (p.ej.: `EnvironmentFile=-/etc/no/existo`)

### Systemd "timer" units

- `systemctl -t help`: muestra las distintas unidades.
- Las unidades `timer` hacen lo mismo que `at` y `cron`.
- Los servicios están en `/usr/lib/systemd/system`.
- El directorio `/etc/systemd/system` tiene preferencia respecto al anterior.
- Crear una unidad `timer`
- `systemctl cat <unidad>`
- Los `.timer` se llaman igual que la unidad estándar y definen su programación.
- `man systemd.time` muestra detalles para el timer.
- Recargar systemd: `systemctl daemon-reload`

## Ficheros temporales

El directorio `/run` es de tipo _runtime_ y está en memoria.

Los directorios `/tmp` y `/var/tmp` crean ficheros temporales.

`systemd-tmpfiles` se encarga de limpiarlos o crearlos en RHEL 7/8. Units:

- `systemd-tmpfiles-clean`
- `systemd-tmpfiles-setup`

Ambos tienen unidades _service_ y _timer_.

Estos binarios leen configuración de (ordenados por preferencia):

- `/etc/tmpfiles.d/*.conf`
- `/run/tmpfiles.d/*.conf`
- `/usr/lib/tmpfiles.d/*.conf`

Se recomienda revisar el formato de los mismos ficheros (`man tmpfiles.d`)

# Resumen

In this chapter, you learned:

* Jobs that are scheduled to run once in the future are called deferred jobs or tasks.
* Recurring user jobs execute the user's tasks on a repeating schedule.
* Recurring system jobs accomplish administrative tasks on a repeating schedule that have system-wide impact.
* The systemd timer units can execute both the deferred or recurring jobs.

# Mans importantes

- man atp, atpd, atprm
- man cron, crond
- man tmpfiles.d

# Preguntas al tutor

- Los ficheros de `/etc/tmpfiles.d` con el mismo nombre, ¿sobreescriben o extienden a sus predecesores de `/usr/lib/tmpfiles.d`? -> sobreescriben
- Cuando `systemd-tmpfiles` limpia directorios, ¿borra sus contenidos? -> depende de la configuración del fichero `.conf` (opción "r" vs opción "R").
- Los timers programados a "1d", ¿a qué hora se ejecutan? -> ??

