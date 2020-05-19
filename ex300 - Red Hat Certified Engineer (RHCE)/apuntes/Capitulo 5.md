# Tema 5 - Implementing Task Control

- Writing Loops and Conditional Tasks
- Implementing Handlers
- Handling Task Failure

## Writing Loops and Conditional Tasks

Una _task_ puede usar la _keyword_ `loop` para iterar sobre una lista de objetos. En cada iteración la _task_ podrá usar la variable `item` para referencia al elemento actual del bucle.

Ejemplo:

```yaml
---

- name: "Habilitar servicios"
  service:
    name: "{{ item }}"
    state: 'started'
    enabled: true
  loop: ['httpd', 'firewalld']

```

La lista del _loop_ puede expresarse como una variable o con el formato `yaml` separado, tal que:

```yaml
---

- name: "Habilitar servicios"
  service:
    name: "{{ item }}"
    state: 'started'
    enabled: true
  loop:
    - 'httpd'
    - 'firewalld'
```

Nótese que la lista puede ser de cualquier tipo de elementos, no solo de elementos sencillos. Por ejemplo, podemos iterar sobre una lista de diccionarios:

```yaml
- name: "Borrar usuario 'centos' y crear usuario 'devops'"
  user:
    name: "{{ item.name }}"
    state: "{{ item.state }}"
  loop:
    - name: 'centos'
      state: 'absent'
    - name: 'devops'
      state: 'present'
```

Antiguamente la sentencia `loop`  no existía y se usaban palabras clave compuestas del prefijo "with_" seguido de otros valores, por ejemplo: `with_items`,  `with_sequence`, etc. Estas palabras han sido _deprecadas_.

### Registrando variables en _loops_

Al hacer loops se puede usar la palabra clave `register` para guardar el resultado de cada iteración. Nótese que en ese caso la variable registrada será una lista que contendrá la salida de cada uno de las distintas llamadas de módulo realizadas.

### Ejecutando tasks de forma condicional

La palabra clave `when` permite ejecutar una _task_ o no de forma condicional. Seguido al dicha palabra clave ha de ir una expresión que, normalmente, compara una o más variables.

Nótese que en los `when` **NO** se debe utilizar la sintaxis de variables que utiliza doble llaves "`{{ variable }}`". Han de usarse las variables de forma independiente.

Un ejemplo de `when` básico:

```yaml

- name: "Activar SpamAssassin si hay más de 500mb de RAM'
  service:
    name: 'spamassassind'
    state: 'started'
    enabled: true
  when: ansible_facts.memory_mb.real.total > 500
```

Los distintos operadores que pueden usarse son:

| Operación                  | Expresión                                    |
| -------------------------- | -------------------------------------------- |
| Igualdad de strings        | ansible_distribution == 'Ubuntu'             |
| Igualdad de números        | max_memory == 512                            |
| No igualdad                | min_memory != 512                            |
| Menor que                  | min_memory < 512                             |
| Mayor que                  | min_memory > 512                             |
| Menor o igual que          | min_memory <= 512                            |
| Mayor o igual que          | min_memory >= 512                            |
| ¿Existe variable?          | min_memory is defined                        |
| ¿No existe variable?       | min_memory is not defined                    |
| ¿Es "verdadero"?           | memory_available                             |
| ¿Es "falso"?               | not memory_available                         |
| Variable está en una lista | ansible_distribution in ['Ubuntu', 'Debian'] |

En el caso de que se quieran comparar varias expresiones puede usarse una lista en lugar de una única expresión a la hora de usar `when`. En ese caso se evaluarán todas las condiciones usando un `and` lógico (es decir: solo si se cumplen las dos). Por ejemplo:

```
- name: "Instalar apache si es Ubuntu 20"
  package:
    name: 'apache2'
    state: 'present'
  when:
    - ansible_distribution == 'Ubuntu'
    - ansible_distribution_major_version == '20'
```

Alternativamente puede usarse sin la lista y obtener el mismo resultado:

```
- name: "Instalar apache si es Ubuntu 20"
  package:
    name: 'apache2'
    state: 'present'
  when: ansible_distribution == 'Ubuntu' and ansible_distribution_major_version == '20'
```
También puede usarse la palabra `or` para expresar condiciones que usen un "O" lógico y no un "Y".

Si se usa un `when` dentro de un `loop` éste será evaluado para cada iteración.

## Implementing Handlers

Los _playbooks_ de Ansible están diseñados para ser idempotentes. Esto significa que no cambian el estado de las cosas si no es necesario.

Esto nos da la capacidad de poder ejecutar algunas tareas solo cuando se realizan cambios y, además, hacerlo al final de la ejecución de todas las _task_ actualesa, algo habitualmente usado para "reaplicar cambios".

Para esta capacidad se usan los llamados _handlers_, que son tareas que solo se ejecutan cuando una _task_ solicite su ejecución y solo si ésta reporta cambios. Para solicitar la ejecución de un _handler_ se utiliza la palabra clave `notify`. Los _playbooks_ permiten definir _handlers_ bajo la palabra clave `handlers`.

Un ejemplo de tarea que reinicia httpd si hay cambios al generar el archivo de configuración:

```yaml

- name: 'Copiar configuración de apache'
  hosts: all
  handlers:
    - name: 'reiniciar apache'
      service:
        name: 'httpd'
        state: 'restarted'
  tasks:
    - name: 'copiar configuración de apache'
      copy:
        src: 'httpd.conf'
        dest: '/etc/apache2/conf/httpd.conf'
      notify: 'reiniciar apache'
```

En el ejemplo anterior solo se llamaría al _handler_ "reiniciar apache" si la _task_ "copiar configuración de apache" reportase cambios; es decir, solo se reiniciaría apache si el fichero de configuración copiado fuese distinto al que estaba allí originalmente.

Las ventajas de los _handlers_ son:

- Si se invoca varias veces a un _handler_ éste solo se ejecutará una vez y será siempre al final del _playbook_.
- Las tareas pueden especificar varios _handlers_ en una misma palabra clave `notify`.
- Si no hubo cambios los _handlers_ no se lanzan.

## Handling Task Failure

Cuando una _task_ de Ansible falla se aborta todo el resto de la ejecución del _playbook_ **para ese host**.

Pueden omitirse los errores de una _task_ en concreto añadiendo la palabra clave `ignore_errors: true` a la _task_.

Nótese que un error causa que los _handlers_ no se ejecuten. En el caso de que sea necesario que se ejecuten a pesar de los errores habría que añadir `force_handlers: true` al _play_.

Alternativamente pueden cambiarse las condiciones de fallo del módulo usando el keyword `failed_when: <expresión booleana>`. Dicha palabra clave usa todas las idiosincrasias de la palabra clave `when`.

Un ejemplo de _task_ que falla acorde a nuestras condiciones personalizadas:

```yaml

- name: Ejecutar script
  shell: /usr/local/bin/create_users.sh
  register: _command_result
  ignore_errors: yes
  when: "'not found' in _command_result.stdout"
```

Adicionalmente el modulo `fail` puede usarse para fallar intencionalmente acorde a alguna condición, p.ej.:

```yaml

- name: 'Fallar si la memoria es inferior a 500mb'
  fail:
    msg: 'La memoria es muy baja'
  when: ansible_facts['memory_mb']['real']['free'] < 500
```

### Usando bloques para recuperar errores

Ansible permite generar _bloques_ dentro de un _playbook_. Su uso principal escapa a este tema, pero pueden utilizarse para crear bloques de tipo "try/catch":

```yaml
tasks:
  - name: Upgrade DB
    block:
      - name: upgrade the database
        shell:
            cmd: /usr/local/lib/upgrade-database

    rescue:
      - name: revert the database upgrade
        shell:
            cmd: /usr/local/lib/revert-database

    always:
      - name: always restart the database
        service:
            name: mariadb
            state: restarted
```

### Modificar cuando una tarea reporta cambios

De la misma forma que puede usarse la palabra clave `failed_when` para determinar cuándo una tarea reporta errores, puede usarse la palabra `changed_when` para cuando reporte cambios.

# Enlaces interesantes

- https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html#migrating-from-with-x-to-loop
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_tests.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#what-makes-a-valid-variable-name
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_blocks.html#error-handling

# Sumario

In this chapter, you learned:

- Loops are used to iterate over a set of values, for example, a simple list of strings, or a list of either hashes or dictionaries.
- Conditionals are used to execute tasks or plays only when certain conditions have been met.
- Handlers are special tasks that execute at the end of the play if notified by other tasks.
- Handlers are only notified when a task reports that it changed something on a managed host.
- Tasks are configured to handle error conditions by ignoring task failure, forcing handlers to be called even if the task failed, mark a task as failed when it succeeded, or override the behavior that causes a task to be marked as changed.
- Blocks are used to group tasks as a unit and to execute other tasks depending upon whether or not all the tasks in the block succeed.
