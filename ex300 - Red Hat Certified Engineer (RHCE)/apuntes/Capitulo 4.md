# Tema 4 - Variables and facts

- Managing Variables
- Managing Secrets
- Managing Facts

## Managing Variables

Las variables pueden venir de varias fuentes, pero todas ellas se agrupan en tres grandes categorías:

- _Variables globales_: traídas desde la línea de comandos o la configuración de Ansible.
- _Variables de Play_: definidas en cada _play_ o sus estructuras relacionadsa.
- _Variables de Host_: definidas en grupos, _hosts_ individuales, _facts_ recabados o tareas individuales.

Si una variable se define en varios niveles el que tenga más preferencia prevalece.

Las variables pueden definirse de varias maneras.

**Ej. #1: directamente en un _play_**:

```yaml
---

- name: 'Play de ejemplo'
  hosts: all
  vars:
    package: 'httpd'
    port: '80'

```

**Ej. #2: en ficheros externos importados en un play**:

```yaml

- name: 'Play de ejemplo #2'
  hosts: all
  vars_files:
    - 'vars/usuarios.yml'
    - 'vars/paqueteria.yml'
```

Los ficheros de variables se definen en formato YAML:

```
---

usuarios: ['bill', 'melinda', 'marx']
```

Para usar una variable en un _play_ o _task_ solo hay que rodear su nombre de un par de dobles corchetes, p.ej.: `{{ usuarios }}`.

Cuando una variable es el primer valor de una cadena es obligatorio usar las comillas dobles `"{{ usuarios }}"`. Nótese que las comillas simples no expanden variables.

### Variables de host y grupo

Éstas son variables que se definen para cada _host_  y/o grupo. Pueden definirse de dos formas.

**Ej. 1: directamente en el inventario (deprecated)**

```
[webservers]
test.example.com environment=testing region=us
mipage.example.com environment=production region=eu

[webservers:vars]
apache_version='2.4.3'
remote_user='centos'
```

**Ej. 2: usando los directorios `host_vars`  y `group_vars`**

Esta es la forma preferida. La idea es que, en el mismo directorio de cada inventario, se pueden crear los directorios `./host_vars` y `./group_vars`.

Dentro de ellos pueden crearse una de dos:

1. Ficheros cuyo nombre sea igual al de un host o grupo de inventario terminados en la extensión `.yml`.
2. Directorios cuyo nombre sea igual al de un host o grupo de inventario y que estén repletos de ficheros `.yml` con nombres arbitrarios que serán todos importados.

Un ejemplo de estructura de variables podría ser la siguiente:

```
project
├── ansible.cfg
├── group_vars
|   │
|   ├── datacenters.yml
|   │
|   ├── datacenters1.yml
|   │
|   └── datacenters2.yml
├── host_vars
|   │
|   ├── demo1.example.com.yml
|   │
|   ├── demo2.example.com.yml
|   │
|   ├── demo3.example.com.yml
|   |
|   └── demo4.example.com.yml
|
├── inventory
└── playbook.yml
```

Alternativamente podrían usarse directorios:

```
project
├── ansible.cfg
├── group_vars
|   │
|   ├── datacenters/
|   |   ├── users.yml
|   │   └── packages.yml
|   |
|   ├── datacenters1.yml
|   |   ├── users.yml
|   │   └── packages.yml
|   |
|   └── datacenters2.yml
|       ├── users.yml
|       └── special-configuration.yml
├── host_vars
|   │
|   ├── demo1.example.com/
|   |   ├── ssh_keys.yml
|   |   ├── firewall_exceptions.yml
|   │   └── motd.yml
|   │
|   ├── demo2.example.com/
|   ├── demo3.example.com/
|   └── demo4.example.com/
|
├── inventory
└── playbook.yml
```

### Variables redefinidas

El parámetro `-e` permite redefinir variables desde CLI. Éstas tienen la máxima preferencia.

### Diccionarios

`yaml` permite crear diccionarios, tales como:

```yaml
---
usuarios:
    bob:
        nombre: 'bob'
        apellidos: 'mcenzie'
        hobbies: ['fishing']
    karl:
        nombre: 'karl'
        apellidos: 'marx'
        hobbies: ['seizing the means of production', 'idk, travelling']
```

Los valores de dichos diccionarios pueden accederse de dos formas:

```yaml
---

usuarios.bob.nombre         # equivale a 'bob'
usuarios['karl']['nombre']  # equivale a Karl. Evita problemas con carácteres especiales
```

### Capturando salida de tasks en variables

La palabra clave `register` permite obtener valores de salida de una _task_ y almacenarla en una variable, p.ej.:

```yaml
- name: 'Leer fichero "/etc/fstab"
  command: 'cat /etc/fstb'
  register: _contenidos_fstab
```

El ejemplo superior guarda el resultado de invocar el módulo `command` en la variable `_contenidos_fstab`. Nótese que el valor de retorno no es solo el `stdout`, si no un objeto compuesto de varios valores. Ver la documentación de cada módulo para más detalles sobre los valores que devuelve.

## Managing Secrets

En ocasiones es necesario almacenar credenciales u otros datos secretos en variables. Puesto que almacenarlos en texto plano supone un riesgo de seguridad, se hace patente la necesidad de almacenarlos con algún tipo de cifrado.

`ansible-vault` es un comando que permite:

- Cifrar cadenas de texto arbitrarias que pueden usarse como valores de variables.
- Cifrar ficheros enteros que serán descifrados al vuelo por Ansible.

Para usarlo:

- `ansible-vault create <file>`: Crea un fichero cifrado.
- `ansible-vault edit <file>`: Edita un fichero previamente guardado.
- `ansible-vault encrypt <file>`: Encripta un fichero plano.
- `ansible-vault decrypt <file>`: Desencripta un fichero previamente cifrado.
- `ansible-vault encrypt_string <texto>`: Encripta una cadena de texto arbitraria.

El cifrado de `ansible-vault` funciona con un passphrase que puede pasarse en el _prompt_, definirse en la configuración de Ansible o definirse en un fichero que se leerá mediante el parámetro `--vault-password-file=<path>`.

Ansible intentará descifrar cualquier fichero de vault usado al vuelo. Para pasarle la contraseña hay varios métodos:

- Usar la opción  `--ask-vault-pass`, que la preguntará mediante un _prompt_.
- Usar la opción `--vault-id @prompt`, similar a la anterior.
- Usar la opción `--vault-password-file=<path>` para definir un fichero que contenga la contraseña.
- Usar la variable de entorno `ANSIBLE_VAULT_PASSWORD_FILE` para un efecto similar.
- Definir la configuración `vault_password_file` que apunte a un fichero con la contraseña.

## Managing Facts

Los _facts_ son variables auto descubiertas por Ansible al ejecutar un _playbook_ sobre un _host_. Los facts contienen información relacionada con el hardware, software, distribución, dispositivos, sistema operativo, puntos de montaje, etc.

El módulo `setup` de Ansible es el encargado de realizar esta tarea que, de forma normal, se realiza antes de lanzarse cualquier _play_.

Internamente los facts se almacenan dentro de una variable de tipo diccionario llamada `ansible_facts`.

Por ejemplo una llamada a `ansible -m setup localhost` podría devolver una parte de _facts_ como esta:

```
localhost | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "172.18.0.1",
            "192.168.66.1",
            "172.17.0.1",
            "172.19.0.1",
            "192.168.0.204"
        ],
        ...
        ...
        ...
```

A dichos valores podrían accederse de dos formas:

```yaml

# Ojo porque el prefijo "ansible_" no se usa.
- name: 'Forma 2: mostrar un fact accediendo al diccionario'
  debug:
    msg: "{{ ansible_facts['all_ipv4_addresses'] }}"
```

Un comportamiento que está siendo _deprecado_ de Ansible es que éste automáticamente convierte las variables dentro de `ansible_facts` en variables.


P.ej., en el ejemplo anterior podría accederse al valor de `all_ipv4_addresses` de dos formas:


```yaml
---
# Forma preferida
variable: "{{ ansible_facts['all_ipv4_addresses'] }}"

# Forma vieja
variable: "{{ ansible_all_ipv4_addresses }}"
```

Este comportamiento puede eliminarse modificando el valor de `inject_facts_as_vars` a false en la configuración de Ansible.

La recogida de _facts_ puede desactivarse añadiendo `gather_facts: false` a un _play_. En ocasiones puede querer hacerse esto para ahorrar tiempo en un _playbook_ que no los necesite.

Se pueden definir _facts_ personalizados que pueden usarse en _plays_ mediante la palabra clave _facts_file_ bajo una sentencia `vars`:

```yaml

- name: 'Ejemplo de custom facts'
  hosts: all
  vars:
    facts_file:
        - ./custom_facts
```

## Variables mágicas

Hay un conjunto de variables conocidas como _variables mágicas_ que pueden confundirse con _facts_ puesto que son creadas por Ansible de forma automática, si bien es importante diferenciarlas porque no son lo mismo.

Cuatro variables mágicas muy útiles son:

- `hostvars`: un diccionario que contiene todas las variables de host de todas las máquinas afectadas por el _play_.
- `group_names`: lista de todos los grupos en los que está la máquina actual.
- `groups`: lista de todos los grupos y hosts del inventario.
- `inventory_hostname`: nombre del host actual tal cual está en el inventario, que puede ser distinto a su _hostname_.

# mans

- man:ansible-vault

# Enlaces interesantes

- https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable
- https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_vault.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#best-practices-for-variables-and-vaults
- https://docs.ansible.com/ansible/latest/modules/setup_module.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#local-facts-facts-d

# Sumario

- Ansible variables allow administrators to reuse values across files in an entire Ansible project.
- Variables can be defined for hosts and host groups in the inventory file.
- Variables can be defined for playbooks by using facts and external files. They can also be defined on the command line.
- The register keyword can be used to capture the output of a command in a variable.
- Ansible Vault is one way to protect sensitive data such as password hashes and private keys for deployment using Ansible Playbooks.
- Ansible facts are variables that are automatically discovered by Ansible from a managed host.
