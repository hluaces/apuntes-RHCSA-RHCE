# Tema 3 - Implementing Playbooks

- Writing and Running Playbooks
- Implementing Multiple Plays

## Configurar vim

Debido a las movidas de _vi_ se recomienda configurar el `~/vim.rc` para que sea más cómo configurar ficheros `.yaml`:

```shell
autocmd FileType yaml setlocal ai ts=2 sw=2 et
set syntax on
set number
set expandtab           " spaces instead of tabs
set tabstop=2           " 2 spaces for tabs
```

## Ejecutar un playbook

- `ansible-playbook`: ejecución normal
- `ansible-playbook -C`: ejecución _dry-run_
- `ansible-playbook --syntax-check`: comprobación de sintaxis

Cada _play_ tiene un conjunto de _hosts_ distintos.

El comando `ansible-doc -s <modulo>` genera un _play_ _placeholder_ con todas las opciones del módulo.

Pueden almacenarse módulos personalizados en los directorios `./library` de cada _playbook_ o en un directorio personalizado con la variable `ANSIBLE_LIBRARY`.

## Yaml

```yaml
---
# Esto es un comentario de yaml

variable: 'valor' # esto también es un comentario

variable: esto es una cadena

variable: 'esto es una cadena que no expande variables'

variable: "esto es una cadena que expande variables"

variable: |
    esto es una variable
    multilinea
    que conserva los saltos de línea

variable: >
    esto es una variable multilinea
    que sustituye los saltos de línea por espacios

usuario: # esto es un diccionario
    nombre: 'pepe'
    grupo: 'McPepes'
    telefono: 123456789

# lista
variable: [1,2,3,4,5]

# otro formato de lista
variable:
    - 1
    - 2
    - 3
    - 4
    - 5


```

# Mans importantes

- man:ansible-playbook

# Enlaces interesantes

- https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_checkmode.html
- https://docs.ansible.com/ansible/latest/dev_guide/developing_modules.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks.html
- https://docs.ansible.com/ansible/latest/dev_guide/developing_modules.html
- https://docs.ansible.com/ansible/latest/user_guide/modules_support.html
- https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html

# Sumario

- A play is an ordered list of tasks, which runs against hosts selected from the inventory.
- A playbook is a text file that contains a list of one or more plays to run in order.
- Ansible Playbooks are written in YAML format.
- YAML files are structured using space indentation to represent the data hierarchy.
- Tasks are implemented using standardized code packaged as Ansible modules.
- The ansible-doc command can list installed modules, and provide documentation and example code snippets of how to use them in playbooks.
- The ansible-playbook command is used to verify playbook syntax and run playbooks.
