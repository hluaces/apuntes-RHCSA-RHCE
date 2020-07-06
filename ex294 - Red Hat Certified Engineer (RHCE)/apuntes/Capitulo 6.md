# Tema 6 - Deploying Files to Managed Hosts

- Modifying and Copying Files to Hosts
- Deploying Custom Files with Jinja2 Templates

## Modifying and Copying Files to Hosts

Los siguientes módulos están dentro de la colección _Files_:

- `synchronize`: Módulo interfaz de `rsync`.
- `lineinfile`: Añade o elimina líneas de texto en ficheros.
- `blockinfile`: Añade o elimina bloques de texto a ficheros.
- `copy`: Copia ficheros desde local a remoto,
- `fetch`: Copia ficheros desde remoto a local.
- `file `: Crea ficheros y directorios. Cambia permisos, contextos de ficheros.
- `stat`: Obtiene metainformación de archivos y directorios.

### File y SELINUX

Usar el módulo `file` con el parámetro _setype_ cambia el contexto de un fichero pero de forma no persistente.

Para hacerlo de forma persistente es necesario:

1. Usar el módulo `sefcontext` para hacerlo persistente.
2. Realizar la llamada apropiada a `file` o usar un `restorecon` en _raw_, _command_, etc.

Ejemplo:

```
---
- name: 'Change file selinux context'
  file:
    path: '/etc/ssh/sshd.config'
    setype: 'etc_t'

- name: 'make selinux context persistent'
  sefcontext:
    path: '/etc/ssh/sshd.config'
    setype: 'etc_t'
    state: 'present'
```

## Deploying Custom Files with Jinja2 Templates

Algunos módulos permiten usar el motor de _templates_ Jinja2 para crear ficheros de forma dinámica:

- `template`

Los ficheros de Jinja2 se caracterizan por usar una sintáxis especial para jugar con variables, bucles y estructuras lógicas. Éstas se mencionan a continuación:

- `{% <expresion> %}`: expresión lógica: bucles, condicionales, etc.
- `{{ <variable> }}`: expansión del valor de una variable.
- `{# comentario #}`: comentario que **SOLO** se vera en el template. Éste no se generará con el fichero.

Ejemplo de fichero con Jinja2:

```python
# {{ ansible_managed }}
# DO NOT MAKE LOCAL MODIFICATIONS TO THIS FILE AS THEY WILL BE LOST
Port {{ ssh_port }}
ListenAddress {{ ansible_facts['default_ipv4']['address'] }}
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
```

Nótese el uso de `ansible_managed`, una variable especial que se expande a "_Managed by Ansible_", personalizable en el `ansible.cfg`.

### Estructuras de Jinja2

Bucles foreach/for:

```python
{% for user in users %}
   Usuario #{{ loop.index }}: {{ user }}
{% endfor %}
```

Condicional:

```python

{% if '1.1.1.1' in ansible_fqdn['nameservers'] %}
    Estás usando nameservers de CloudFlare
{% endif %}
```

### Filtros y tests de Jinja2

Jinja2 permite el uso de filtros, que son funciones que se le aplican a las variables para que su valor sea transformado.

Los filtros se reconocen por un "pipe" (`|`) que sigue a una variable y va precedido del filtro a aplicar.

Por ejemplo, para convertir una variable a JSON podríamos usar:

```yaml
{{ output | to_json }}
```

Los _tests_ permiten enriquecer variables en las estructuras lógicas condicionales. Se reconocen por la palabra clave `is` seguida del nombre del test a aplicar.

Algunos ejemplos:

```yaml
{{ 'hola' is regex('^ho(l|L)a$') }}
```


# mans

- man:ansible-doc(1)
- man:chmod(1)
- man:chown(1)
- man:rsync(1)
- man:touch(1)
- man:stat(1)

# Enlaces interesantes

- https://docs.ansible.com/ansible/latest/modules/list_of_files_modules.html
- https://docs.ansible.com/ansible/latest/modules/template_module.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html

# Sumario

- The Files modules library includes modules that allow you to accomplish most tasks related to file management, such as creating, copying, editing, and modifying permissions and other attributes of files.
- You can use Jinja2 templates to dynamically construct files for deployment.
- A Jinja2 template is usually composed of two elements: variables and expressions. Those variables and expressions are replaced with values when the Jinja2 template is rendered.
- Jinja2 filters transform template expressions from one kind or format of data into another.
