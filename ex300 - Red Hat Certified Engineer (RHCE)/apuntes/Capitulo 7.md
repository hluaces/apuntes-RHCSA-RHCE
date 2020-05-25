# Tema 7 - Managing Large Projects

- Selecting Hosts with Host Patterns
- Managing Dynamic Inventories
- Configuring Parallelism
- Including and Importing Files

# mans

## Selecting Hosts with Host Patterns

Al especificar límites al invocar `ansible-playbook` o `ansible`, como a la hora de configurar la palabra clave `keyword:` de un _playbook_, se pueden utilizar caracteres para seleccionar un conjunto de hosts heterogéneos de distintos grupos utilizando para ello un conjunto de operadores.

Nótese que a la hora de elegir hosts en el inventario se usa el nombre que tienen definido en el mismo, que no siempre tiene que ser un FQDN o resolver. Los nombres de inventario pueden ser arbitrarios (p.ej.: "esteservidornoexiste"). En el caso de que uno de ellos no resuelva será necesario añadir la variable `ansible_host` con un FQDN o IP que será la utilizada para conectarse a la máquina destino.

Dichos operadores son los siguientes:

- `*`: comportamiento normal de _fileglob_ que permite hacer match a más de un host de inventario. P.ej.: `servidor*` haría match con: "servidor1.example.com", "servidorweb.example.com" y "servidor3.example.com".
- `,`: la coma permite juntar unir los hosts de más de un patrón en un solo grupo. P.ej.: "servidor1,servidor2" daría como resultado un límite que haría _match_ a ambos servidores. Pueden combinarse otros operadores, p.ej.: "servidor\*,basededatos\*"
- `:`: es lo mismo que la coma `,`. Los dos puntos están en desuso.
- `&`: si se añade como prefijo de un nombre de inventario se hará una operación de intersección con el patrón que le sigue. P.ej.: `servidores,&basesdedatos,&region-eu` hará _match_ a todos los servidores que también encajen en el patrón `&basesdedatos` y `region-eu`.
- `!`: si precede a un patrón, se excluirán del resultado final todos aquellos hosts que puedan expandirse a dicho patrón. P.ej.: `servidores,!basesdedatos` hará _match_ a todos los servidores que no hagan _match_ a "basesdedatos".

Cabe destacar también que todo inventario tiene dos grupos existentes que no se requiere que sean definidos: `all` y `ungrouped`.

## Managing Dynamic Inventories

Los inventarios dinámicos son _scripts_ que al ejecutarse devuelve una lista de _hosts_ con sus variables en un formato de salida especial.

De ser correcto el formato, dichos _scripts_ podrán utilizarse para ejecutar los comandos de Ansible. Tienen el beneficio de que permite mantener inventarios grandes que no dependan de actualizar un único fichero de texto.

El comando `ansible-inventory` es muy útil para ver el contenido de un inventario dinámico, así como para ayudarnos a validar la salida de un inventario dinámico que estemos programando.

## Configuring Parallelism

Ansible ejecuta todos los _plays_ y _tasks_ de forma ordenada, no pasando a ejecutar el siguiente hasta que todos los _hosts_ hayan ejecutado su _task_.

Teóricamente Ansible podría ejecutar todas estas _tasks_ a la vez, si bien esta aproximación tiene el problema de que en inventarios muy grandes este proceso podría agotar los recursos del nodo de control.

Para evitar esto Ansible permite especificar el parámetro `forks` en su archivo de configuración (o parámetro `-f` de los comandos `ansible` y `ansible-playbook`).

Cuando el número de _forks_ no sea infinito, Ansible cogerá un grupo de servidores igual al número de _forks_ especificados y ejecutará en ellos la _task_ actual. Al terminar, ejecutará la misma _task_ en el siguiente grupo de servidores. Cuando todos hayan ejecutado la _task_ se pasará a la siguiente y se repetirá el mismo proceso.

Adicionalmente Ansible permite ejecutar _rolling updates_ de forma que un grupo de servidores ejecute *todas las tasks* de un _play_ antes de pasar al siguiente. Esto se consigue con la palabra clave `serial`. Un ejemplo:

```
---

- name: 'Realizar yum update en grupos de 2 en 2'
  hosts: all
  serial: 2
  tasks:
    - name: 'Parar apache antes de actualizar'
      service:
        name: 'httpd'
        state: 'stopped'

    - name: 'Actualizar'
      command: 'yum update -y'

    - name: 'Arrancar apache'
      service:
        name: 'httpd'
        state: 'started'
```

En el ejemplo anterior se hará el proceso entero de parar Apache, actualizar e iniciar Apache para cada par de servidores. Nótese que es distinto que usar `forks`, ya que si usásemos `forks=2` sin `serial`, lo que pasaría es que caca task individual se haría de 2 en 2.

La palabra clave `max_fail_percentage` permite especificar el % de errores que un _play_ puede ejecutar antes de fallar y abortar.

## Including and Importing Files

Pueden separarse _tasks_ o _playbooks_ en ficheros externos que luego pueden ser _importados_ o _incluídos_ mediante varios mecanismos.

El primero de ellos es `import_playbook`, que permite importar un _playbook_ entero. Nótese que esto solo puede definirse al nivel más alto de un _playbook_, p.ej:


```yaml
---

- name: 'Importar playbook de instalación de apache'
  import_playbook: 'playbooks/apache.yml'

- name: 'Importar playbook de instalación de mysql'
  import_playbook: 'playbooks/mysql.yml'

- name: 'Importar playbook de instalación de php'
  import_playbook: 'playbooks/php.yml'

- name: 'Ejemplo de que se pueden meter plays por el medio'
  hosts: all
  tasks:
    - name: 'Instalar modsecurity'
      yum: name=
```

El segundo es `import_tasks`, que permite **importar** un fichero de tareas. Al **importar** se "copian y pegan" las tareas incluídas "tal cual" en el fichero importado. Esto impide usar palabras clave como `when` o `loop` a la hora de importar. La ventaja que tiene es que importa las _tags_ de forma normal.

El tercer mecanismo es `include_tasks`, que permite **incluír** un fichero de tareas. Al **incluír** se hace de forma dinámica, al contrario que con `import_tasks`, lo que permite usar palabras clave como `when` o `loop`. Nótese que en este caso no importa los _tags_, aunque permite utilizar la palabra clave `apply` para añadir nuevo etiquetado.

```yaml
---

- name: 'Importar tareas con tags de forma estática'
  import_tasks: 'tareas1.yml'

- name: 'Incluír tareas de forma dinámica'
  import_tasks: 'tareas2.yml'
  when: ansible_distribution == 'RedHat'
```

# Enlaces interesantes

- https://docs.ansible.com/ansible/latest/user_guide/intro_patterns.html
- https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html
- https://github.com/ansible/ansible/tree/stable-2.9/contrib/inventory
- http://docs.ansible.com/ansible/dev_guide/developing_inventory.html
- https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html
- https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html
- http://docs.ansible.com/ansible/playbooks_delegation.html#rolling-update-batch-size
- https://www.ansible.com/blog/ansible-performance-tuning
- https://www.youtube.com/watch?v=rRJQiHydVG4
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_includes.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html

# Mans

- man:ansible-inventory


# Sumario

In this chapter, you learned:

- Host patterns are used to specify the managed hosts to be targeted by plays or ad hoc commands.
- Dynamic inventory scripts can be used to generate dynamic lists of managed hosts from directory services or other sources external to Ansible.
- The forks parameter in the Ansible configuration file sets the maximum number of parallel connections to managed hosts.
- The serial parameter can be used to implement rolling updates across managed hosts by defining the number of managed hosts in each rolling update batch.
- You can use the import_playbook feature to incorporate external play files into playbooks.
- You can use the include_tasks or import_tasks features to incorporate external task files into playbooks.
