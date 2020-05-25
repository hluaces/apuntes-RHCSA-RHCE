# Tema 8 - Simplifying Playbooks with Roles

- Describing Role Structure
- Reusing Content with System Roles
- Creating Roles
- Deploying Roles with Ansible Galaxy

## Describing Role Structure

La estructura de un rol es la siguiente:

```
[user@host roles]$ tree user.example
user.example/
    ├── defaults
    |   └── main.yml
    ├── files
    ├── handlers
    ├── main.yml
    |   ├── meta
    |   └── main.yml
    ├── README.md
    ├── tasks
    |   └── main.yml
    ├── templates
    ├── tests
    ├── inventory
    |   └── test.yml
    └── vars
        └── main.yml
```

Que corresponde a:

- `defaults/`: El archivo `main.yml` define las variables que usa el rol y que pueden ser sobreescritas al ejecutarse.
- `files/`: Directoro que contiene ficheros **estaticos** que pueden ser usados por módulos que trabajen con ficheros (`copy` o `synchronize`, por ejemplo).
- `meta/`: El archivo `main.yml` contiene metainformación del autor, licencia, dependencias, etc. para el rol.
meta The main.yml file in this directory contains information about the role,
- `templates/`: Ficheros **dinámicos** utilizados por módulos que requieran _templates_ en Jinja2, como `template`.
- `tests/`: Fichero que contiene un fichero `inventory` y un `test.yml` que pueden usarse para probar el rol.
- `vars/`: El fichero `main.yml` contiene las variables del rol que no pueden sobreescribirse. Suelen ser usadas a nivel interno por el propio rol.


Para usar roles en un _playbook_ podemos hacerlo así (nótese el uso de `vars:` para sobreescribir las variables del rol):

```yaml
---

- name: 'Ejemplo de roles'
  hosts: all
  roles:
    - role: 'apache'
    - role: 'mysql'
      vars:
        port: 1234
        host: localhost
```
A la hora de ejecutar un _playbook_ se hace lo siguiente:

- Se ejecutan las _tasks_ de la sección `pre_tasks`.
- Se ejecutan los roles.
- Se ejecutan las _tasks_ de la sección `tasks`.
- Se ejecutan las _tasks_ de la sección `post_tasks`.
- Se ejecutan los _handlers_.

Los roles pueden importarse desde una _task_ usando los módulos `import_role` e `include_role`.

Para usar los roles puede ser necesario especificar el valor `roles_path` en la configuración de Ansible.

## Reusing Content with System Roles


## Creating Roles

Puede usarse el comando `ansible-galaxy init <nombre del rol>` para crear una estructura de rol vacía.

## Deploying Roles with Ansible Galaxy

Ejemplo de fichero `requirements.yml` con repos de git:

```yaml
---

- name: 'namespace.ejemplo'
  src: git@git.example.com:namespace/ejemplo
  version: v1.4
  scm: git
```

# Enlaces interesantes

- https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html
- https://access.redhat.com/articles/3050101
- https://linux-system-roles.github.io/
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html#using-roles
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html
- https://galaxy.ansible.com
- https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html

# Mans

- man:ansible-galaxy

# Sumario

- Roles organize Ansible code in a way that allows reuse and sharing.
- Red Hat Enterprise Linux System Roles are a collection of tested and supported roles intended to help you configure host subsystems across versions of Red Hat Enterprise Linux.
- Ansible Galaxy [https://galaxy.ansible.com] is a public library of Ansible roles written by Ansible users. The ansible-galaxy command can search for, display information about, install, list, remove, or initialize roles.
-  External roles needed by a playbook may be defined in the roles/requirements.yml file. The ansible-galaxy install -r roles/requirements.yml command uses this file to install the roles on the control node.
