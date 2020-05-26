# Tema 10 - Automating Linux Administration Tasks

- Managing Software and Subscriptions
- Managing Users and Authentication
- Managing the Boot Process and Scheduled Processes
- Managing Storage
- Managing Network Configuration

## Managing Software and Subscriptions

El módulo yum permite instalar grupos si, a la hora de especificar un `name`, este se precede de una arroba. P.ej.:

```yaml
---

- name: 'Instalar software de desarrollo'
  yum:
    name: '@development-tools'
```

La arroba también puede usarse para diferenciar el módulo de _AppStream_ siendo usado:

```yaml
---

- name: 'Instalar el AppStream de Perl'
  yum:
    name: '@perl:5.26/minimal'
    state: 'present'
```

A la hora de usar el módulo `yum` se recomienda no utilizar `loop`, puesto que eso puede causar que el módulo tarde más de lo debido. En su lugar, puede pasarse una lista al parámetro `name`, p.ej.:

```yaml
---

- name: 'Instalar varios paquetes'
  yum:
    name:
        - git
        - vim
        - bind-utils
        - python3-pip
    state: 'present'
```

El módulo `package_facts` permite recabar _facts_ sobre los paquetes instalados:

```yaml
---

- name: 'Recabar facts de paquetes instalados'
  package_facts:


- name: 'Mostrar los facts de paquetes recién recabados'
  debug:
    var: ansible_facts['packages']
```

Para que yum puede instalar paquetes de repositorios de terceros es necesario primero usar el módulo `yum_repository` para configurarlo. El módulo `rpm_key` permite importar llaves de dichos repositorios.

## Managing Users and Authentication

El módulo `user` permite crear usuarios y todos sus datos relacionados. Nótese que estos incluyen cosas como contraseña, llaves SSH, _shell_ y que el módulo ofrece valores de retorno interesantes.

Algunos valores interesantes del módulo:

| Nombre      | Descripción  |
| ----------- | -----------  |
| comment     | Establece la descripción de una cuenta. |
| group       | Grupo principal del usuario. |
| groups      | Otros grupos adicionales del usuario. Si es nulo, todos los grupos del usuario menos el principal **se borran**. |
| home        | Home directory. |
| create_home | Crea o no el directorio home. |
| system      | Especifica que sea una cuenta de usuario o no. |
| uid         | Especifica el UID del usuario. |

Otros módulos interesantes para este tipo de administración:

- `group`: para crear grupos de usuarios.
- `known_hosts`: para gestionar `/etc/ssh/known_hosts`.
- `authorized_key`: para gestionar `~/.ssh/authorized_key`.

## Managing the Boot Process and Scheduled Processes

## Managing Storage

## Managing Network Configuration

# Enlaces interesantes

- https://docs.ansible.com/ansible/latest/modules/yum_module.html
- https://docs.ansible.com/ansible/latest/modules/package_facts_module.html
- https://docs.ansible.com/ansible/latest/modules/redhat_subscription_module.html
- https://docs.ansible.com/ansible/latest/modules/rhsm_repository_module.html
- https://docs.ansible.com/ansible/latest/modules/yum_repository_module.html
- https://docs.ansible.com/ansible/latest/modules/rpm_key_module.html
- http://docs.ansible.com/ansible/latest/modules/user_module.html#user-module
- https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#how-do-i-generate-crypted-passwords-for-the-user-module
- https://docs.ansible.com/ansible/latest/modules/group_module.html#group-module
- https://docs.ansible.com/ansible/latest/modules/known_hosts_module.html#known-hosts-module
- https://docs.ansible.com/ansible/latest/modules/authorized_key_module.html#authorized-key-module
- https://docs.ansible.com/ansible/latest/plugins/lookup.html?highlight=lookup

# Mans

- man:yum
- man:yum.conf
- man:subscription-manager

# Sumario

- The yum_repository module configures a Yum repository on a managed host. For repositories that use public keys, you can verify that the key is available with the rpm_key module.
- The user and group modules create users and groups respectively on a managed host. You can configure authorized keys for a user with the authorized_key module.
- Cron jobs can be configured on managed hosts with the cron module.
- Ansible supports the configuration of logical volumes with the lvg, and lvol modules. The parted and filesystem modules support respectively the partition of devices and creation of filesystems.
- Red Hat Enterprise Linux 8 includes the network system role which supports the configuration of network interfaces on managed hosts
