# Tema 4 - Controlling Access to Files with

- Interpreting File ACLs
- Securing Files with ACLs
- Securing Files with ACLs

## Interpreting File ACLs

- [Temas de ACLs.].
- Usuarios y grupos que estén en una ACL sin otra categoría se llaman _named users_ y _named groups_.
- Las _acls_ requiere soporte del sistema de ficheros.
- Un símbolo "+" en el `ls -l` significa que dicho fichero tiene ACLs.
- Usar `chmod` en un fichero con ACL **NO PERMITE** cambiar permisos de grupo. Para eso se usará `setfacl -m g::perms file`. Hacerlo "a pelo" con `chmod` cambiará la máscara de las ACLs.
- La máscara de ACLs limita todos los permisos efectivos de _named users_ y _named groups_ para que no puedan ser superiores.

### ACLs en directorio

- También conocidas como _Default ACLs_
- Al aplicarse acls a un directorio sirven para que los ficheros creados en su interior hereden esas ACLs.
- Las ACLs de ficheros creados no pueden ganar más permisos de los que confiera el umask.
- Es necesario añadir `d:` antes de la ACL que queramos añadir por defecto. P.ej.: `d:g::r--`

**La máscara se recalcula con cada operación de setfacl, aunque sea explícita**.

Para evitarlo usar `setfacl` con `-n` o volver a establecer la máscara uan vez cambiado.

## Securing Files with ACLs

- Usar `setfacl` para otorgar acls.
- `setfacl -m` actualiza ACLs. Con `--set-file` los sobreescribe.
- Copiar acls: `getfacl /path/to/file | setfacl --set-file=- /path/to/file2`.
- `setfacl -R` permite cambiar de forma recursiva.
- Para borrar acls: `setfacl -x`
- Para borrar ACLs de directorio usar `setfacl -k`

Copia de seguridad de TODAS las ACLs:

`getfacl -R / > copia_acls.txt`

Restaurar la copia:

`setfacl --restore=copia_acls.txt`

# Mans importantes

- man:acl
- man:getfacl
- **Aprender a hacer persistentes los logs de journald** (hace falta crear y tener ACL en `/var/log/journal`)

# Sumario

In this chapter, you learned:

- ACLs provide fine-grained access control to files and directories.
- The getfacl command displays the ACLs on a file or directory.
- The setfacl command sets, modifies, and removes default and standard ACLs on files and directories.
- Use default ACLs for controlling new files and directories permissions.
- Red Hat Enterprise Linux uses systemd and udev to apply predefined ACLs on devices, folders, and files.
