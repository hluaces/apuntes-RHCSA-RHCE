# Tema 10 - Controlling the Boot Process

- Selecting the Boot Target
- Resetting the Root Password
- Repairing File System Issues at Boot

## Orden del boot

- Se arranca POST.
- POST busca una de dos:
    - Dispositivos con UEFI en el orden especificado en su firmware.
    - Un MBR en todos los discos en el orden especificado en el firmware.
- El sistema lee el sector de arranque y le pasa el control.
- Se inicia el gestor de arranque GRUB y muestra las opciones configuradas.
- Al elegir una opción se carga el Kernel y el _initramfs_ seleccionado.
- Grub le cede el control al Kernel.
- El Kernel inicializa el hardware usando los drivers del _initramfs_.
- El kernel inicializa la unit _initrd.target_.
- Acto seguido, el Kernel ejecuta `/sbin/init` (systemd).
    - Esto puede cambiarse especificando el parámetro `init` del Kernel.
- Se monta el directorio raíz en `/sysroot`.
- El Kernel se monta en `/sysroot` y se reejecuta, junto con `init`.
- systemd busca el _target_ por defecto y toma el control desde ahí.

## Target

Systemd introduce los `target` que no son más que agrupaciones de un conjunto de unidades.

- `systemctl get-default`: muestra el target por defecto.
- `systemctl set-default`: establece el target por defecto.
- `systemctl get-dependencies <target>`: muestra dependencias de un target.
- `systemctl isolate <target>`: cambia a un target.
- `systemctl enable debug.shell`: Activa la shell de depuración
- `systemctl list-jobs`: muestra cuelges de unidades en boot

## Targets más habituales

- `graphical.target`: Soporte con múltiples logins y terminales gráficos.
- `multi-user.target`: Múltiples logins y terminales de texto.
- `rescue.target`: prompt con _sulogin_ después de inicializar kernel.
- `emergency.target`: prompt ocn _sulogin_ antes de que el kernel tome el control de `/sysroot`.

`systemctl list-dependencies <target>` muestra los detalles de qué carga cada _target_.

Para ver todos los targets usar `systemctl list-units --type=target --all`

## Cambiar de target en runtime

Puede usarse el comando `systemctl isolate <target>` para cambiar de _target_ en caliente.

Solo se puede cambiar a los _target_ que definan `AllowIslolate=yes` en su _unitfile_.

Al cambiar a otro _target_ se desactivan las _unit_ que no sean necesarias.

## Opciones de booteo del Kernel

- Cambiar target desde kernel: `systemd.unit=<target.target>`.
- Iniciar en initramfs: añadir `rd.break` a la línea.
- Iniciar en shell de depuración systemd: `debug.shell=1`.

**OJO**: si se usa emergency o rescue para cambiar un fichero como el `shadow` éste perderá datos de selinux. Será necesario iniciar con `enforcing=0`, cambiar los _labels_ que sean pertinentes e iniciar de nuevo el modo `enforcing`.

## Journald

Journald guarda información de registro de boot, pero es necesario hacerlo persistente.

Para ello:

1. Editar `/etc/systemd/journald.conf` y cambiar el `Storage=` a `persistent`.
2. Recargar `systemd-tmpfiles`.
3. Verificar que existe `/var/log/journald`.

## Resetting the Root Password

Hay varios métodos. Uno es:

1. Reiniciar el sistema.
2. Editar opciones del kernel en grub y añadir `rd.break`.
3. Se iniciará en el momento previo a que el kernel se ejecute de nuevo en `sysroot`.
4. Remontar `/sysroot` con rw.
5. `chroot /sysroot`
6. Cambiar el password
7. Reiniciar la máquina y editar el kernel para iniciar con `enforcing=0`
8. Al iniciar hacer un `restorecon /etc/shadow` para que el contexto de SELinux se aplique al fichero recién modificado.
9. Cambiar SELinux a enforcing 1 con `setenforcing 1`.

Alternativamente al paso 7 puede crearse el fichero `/.autorelabel`, que hará que SELinux etiquete todo de nuevo al iniciar.

Puede usarse el parámetro de kernel `rd.shell` para arrancar una shell de depuración de systemd.

## Repairing File System Issues at Boot

En algunos casos configuraciones erróneas de `/etc/fstab` causan que la máquina no inicie.

Algunos casos habituales son:

- **Sistema de archivos corrupto**: systemd intenta reparar el sistema de archivos. Si no puede, inicia en una consola de emergencia.
- **UUID o device inexistente en fstab**: systemd espera un tiempo a ver si el dispositivo vuelve a estar disponible. Si no es así, inicia consola de emergencia.
- **Punto de montaje inexsitente**: systemd inicia en consola de emergencia.
- **Opción no válida en fstab**: systemd inicia en consola de emergencia.

Al usar la consola de emergencia para arreglar el `fstab` es importante ejecutar `systemctl daemon-reload` o puede que el sistema no detecte los cambios.

Systemd tiene un servicio `debug-shell` que si se inicia habilita una consola de root en TTY9 durante el boot.

# Preguntas

# Comandos

- `systemd-analyze plot`: genera un `.svg` con el  arranque del sistema.

# Mans importantes

- man:systemd-fsck(8)
- man:systemd-fstab-generator(8)
- man:systemd.mount
- man:dracut.cmdline(7)
- man:systemd-journald(8)
- man:journald.conf(5),
- man:journalctl(1)
- man:systemctl

# Enlaces interesantes

# Sumario

In this chapter, you learned:

- systemctl reboot and systemctl poweroff reboot and power down a system,
respectively.
- systemctl isolate target-name.target switches to a new target at runtime.
- systemctl get-default and systemctl set-default can be used to query and set the
default target.
- Use rd.break on the kernel command line to interrupt the boot process before control is handed over from the initramfs. The root file system is mounted read-only under /sysroot.
- The emergency target can be used to diagnose and fix file-system issues
