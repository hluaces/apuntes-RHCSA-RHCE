# Tema 5 - Managing SELinux Security

- Changing the SELinux Enforcement Mode
- Controlling SELinux File Contexts
- Adjusting SELinux Policy with Booleans
- Investigating and Resolving SELinux Issues

## Introducción a SELinux

- Creado por la NSA para limitar a "root".
- Define "cómo" han de usarse las cosas.
    - P.ej.: un usuario puede tener acceso de escritura a un fichero binario.
    - ¿Significa eso que tenga que manipularlo con un programa inválido para tal fin?
- Permite o deniega el acceso a objetos en base a reglas de Kernel.
    - Los objetos pueden ser procesos, dispositivos, servicios, ficheros, etc.
- Para funcionar SELinux pone en marcha "políticas" que se implementan a nivel de aplicación.
- Las políticas toman como objetivo puertos, ficheros y programas.
- SELinux tiene una caché llamada M.A.C. (_Mandatory Access Control_).

Tiene tres modos de funcionamiento:

- _Enforcing_: Funcionando y aplicando sus reglas.
- _Permissive_: No aplica sus reglas, pero registra cualquier violación de las mismas. Modo de depuración.
- _Disabled_: No está funcionando.

Para cambiar modos:

- `setenforce <(0|1|2)>`: lo cambia de forma no persistente.
- Modificar `/etc/selinux/config` lo hace persistente. Requiere reboot.
- En el kernel añadir `selinux=0|1` para activar/desactivar.
- En el kernel añadir `enforcing=0|1` para _permisive_ o _enforcing_.

## Controlling SELinux File Contexts

- En sistemas con SELinux todos los ficheros y procesos están etiquetados (_labeled_).
- Los nuevos ficheros suelen heredar sus etiquetas del directorio padre. _Caveats_:
    - Si un fichero se mueve de sitio preservará su etiqueta vieja.
    - Los enlaces simbólicos no preservarán el contexto del fichero destino.
    - Comandos como `cp -a` preservan el etiquetado de origen.
- El parámetro `-Z` de comandos como `ls` o `ps` permite ver el contexto de SELinux de un archivo/proceso.

Los contextos son un conjunto de reglas definidas en base a _regexes_ que aplican un conjunto de contextos a ficheros a los que hacen match (requiere paquete `policycoreutils`):

- `semanage fcontext -l`: lista las reglas de contexto de SELinux
- `semanage fcontext -a -t <contexto> <regex directorio>`: añade una nueva entrada a la lista de reglas de contexto de forma persistente.
- `semanage fcontext -d -t <contexto> <regex directorio>`: borra una entrada de la lista de reglas de contexto.

Puede forzarse a SELinux a reaplicar los contextos a un fichero con:

- `restorecon -Fvv <fichero>`: resetea los contextos de SElinux acorde a las reglas predefinidas.
- `restorecon -RFvv <directorio>`: lo mismo, de forma recursiva.

Nótese que los contextos también pueden cambiarse con `chcon`, pero dichos cambios no sobrevivirían a un `restorecon` posterior:

- `chcon -t <contexto> <fichero>`: cambia _de forma no persistente_ el contexto de un fichero.

Para gestionar los contextos de puertos:

- `semanage port -l`
- `semanage port -a -m <type> -p <protocolo> <puerto>`: (ejemplo: `semanage port -a -m http_port_t -p TCP 12345`)

## Adjusting SELinux Policy with Booleans

- Los booleanos de SELinux son valores {1,0} que pueden alterar el comportamiento del sistema.
- El paquete `selinux-policy-doc` incluye páginas de man `*_selinux` que describen los booleanos.

Comandos para manipular booleanos:

 - `setsebool`: Establece un valor **no persistente** a un booleano. El parámetro `-P` lo hace persistente.
 - `getsebool -a`: Lista booleanos y su estado.
 - `semanage boolean -l`: Lista los booleanos, una descripción y si es persistente o no.
 - `semanage bollean -l -C`: Lista los booleanos cuyo valor sea distinto al por defecto.

## Investigating and Resolving SELinux Issues

Cuando se sospeche que SELinux puede causar problemas:

- Cambiar temporalmente el modo de SELinux a _permissive_ (**NO** a _disabled_).
- Confirmar que el cambio soluciona el error.
- Revisar `/var/log/audit/auditlog` para ver si se detalla el problema.
- Volver a dejar SELinux como _enforcing_.

Para monitorizar problemas de SELinux:

- Revisar `/var/log/audit/auditlog`, aunque no es legible para humanos.
- Instalar el paquete `setroubleshoot-server`, que enviará el auditlog a `/var/log/messages` en un formato legible.
- El comando `sealert -l <id>` permite obtener detalles de una violación registrada.
- `sealert -a /var/log/audit/audit.log` muestra detalles de todas las violaciones registradas.
- `ausearch` permite buscar en el audit log. `-m` busca por texto. `-ts` por timestamp.

Una vez confirmado que es un problema de SELinux hemos de seguir estos pasos:

1. ¿Es correcto que deniege el acceso?, en algún caso lo que queremos hacer es un fallo de seguridad y SELinux hace su trabajo, lo que debería hacernos replantear las gestiones.
2. ¿Es un problema de contexto?, esto suele ser la causa habitual:
    - Usar comandos con `-Z` (`ps`, `ls`, etc.) para ver los contextos de los ficheros problemáticos.
    - Normalmente `restorecon` debería dejar los contextos de forma correcta.
3. Si no es de contextos, seguramente sea un problema de booleanos.
    - Usar `semanage boolean -l` con un `grep` para buscar cualquier booleano que pueda estar relacionado con nuestras gestiones.
    - Cambiar el booleano de forma temporal con `setsebool` y confirmar si se soluciona.
    - Si no se soluciona, revertir el cambio. Si se soluciona y se quiere hacer persistente usar el parámetro `-P` de `setsebool`.
4. En este punto estamos ante un BUG.


- Las violaciones de SELinux están en `/var/log/audit/auditlog` de forma no amigable para humanos.
- El paquete `troubleshoot-server` envía dichos mensajes a `messages` de forma amigable para humanos.

# Comandos

- `getenforce`: Estado de SELinux
- `ls -Z`, `ps auxfZ`: lista de archivos, procesos, ... con contextos.
- `restorecon -RFvv <directorio>`: resetea los contextos de SElinux acorde a las reglas predefinidas.
- `chcon`: añade un contexto temporal no persistente
- `runcon`: ejecuta un comando con un contexto en concreto.
- `getsebool -a`: lista todas las etiquetas.
- `semanage boolean -l`: listado de booleanos ahora y después de rebootear. Con `-c` se muestran los personalizados.
- `setsebool <boleano> on`: activa de forma persistente. Con `-P` lo hace persistente.

# Mans importantes

- man:setmanage-permissive
- Paquete (`selinux-policy-doc`).
- man:selinux(8)

# Enlaces interesantes

- https://stopdisablingselinux.com/
- https://people.redhat.com/duffy/selinux/selinux-coloring-book_A4-Stapled.pdf
- https://danwalsh.livejournal.com/69958.html
- https://docs.fedoraproject.org/en-US/Fedora/13/html/SELinux_FAQ/index.html#id3036916
- https://github.com/TresysTechnology/setools3/wiki

# Sumario

In this chapter, you learned:

- The getenforce and setenforce commands are used to manage the SELinux mode of a system.
- The semanage command is used to manage SELinux policy rules. The restorecon command applies the context defined by the policy.
- Booleans are switches that change the behavior of the SELinux policy. They can be enabled or disabled and are used to tune the policy.
- The sealert displays useful information to help with SELinux troubleshooting.
