# Tema 9 - Troubleshooting Ansible

- Troubleshooting Playbooks
- Troubleshooting Ansible Managed Hosts

## Troubleshooting Playbooks

Ansible por defecto no guarda logs, pero puede usarse el valor de configuración `log_path` para activar el guardado de registros. Estos logs pueden usarse a posteriori para revisar problemas causados por los _playbooks_.

Adicionalmente puede usarse el módulo `debug` para mostrar por pantalla el contenido de una variable o expresión de forma que nos ayude a evaluar el contenido de Ansible en algún punto en concreto. El parámetro `verbosity` de dicho módulo puede usarse para controlar cuándo queremos que se muestre dicho contenido.

```yaml
---

- name: 'Mostrar la memoria libre'
  debug:
    var: ansible_facts['memfree_mb']
    verbosity: 2 # haran falta dos "uves" (-vv)
```

El comando `ansible-playbook` tiene varios parámetros que pueden ayudar en la depuración de errores:

- `--check` o `-C`: ejecuta el _playbook_ en modo _dry-run_, es decir: sin hacer cambios.
- `--step`: ejecuta el playbook paso a paso, parándose en cada _task_ y pidiendo confirmación de si se quiere ejecutar o no.
- `--start-at-task`: ejecuta el playbook desde una task en concreto. Puede usarse `--list-tasks` para buscar la que quiera ser el punto de partida.

Adicionalmente, todos los comandos de Ansible permiten especificar un valor de _verbosity_ que puede aumentarse acorde a la siguiente tabla:


| Parámetro | Descripción |
| --------- | ------------|
| `-v`      | Muestra el _output_ de los módulos que se ejecuten. |
| `-vv`     | Muestra el _input_ y el _output_ de los módulos que se ejecuten. |
| `-vvv`    | Además de lo anterior, muestra los detalles de conexión al host. |
| `-vvvv`   | Ádemás de lo anterior, muestra detalles de la ejecución subyacente de scripts en el host destino. |

## Troubleshooting Ansible Managed Hosts

El parámetro `--check`, del que ya se habló antes, es útil para diagnosticar problemas que sucedan en un host remoto sin alterar su estado.

Adicionalmente, las _tasks_ pueden definir `check_mode: false` para que éstas se ejecuten **aún cuando se esté lanzando el playbook en modo dry-run**. Esto es útil para que algunas tareas en concreto necesiten ejecutarse para que el `--check` se haga con éxito. Es habitual en tareas de tipo `command`, `raw`, etc. que solo se usen para obtener datos y no cambiar el estado del servidor.

De usarse `check_mode: true` una task siempre se ejecutaría en modo _dry-run_, al margen de lo que se haya pasado al comando `ansible-playbook`.

El parámetro `--diff` sirve para que Ansible reporte los cambios hechos en _templates_ del destino. Si se une con `--check`  dichos cambios se muestran, pero no se ejecutan.

# Enlaces interesantes

- https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html
- https://docs.ansible.com/ansible/latest/modules/debug_module.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_checkmode.html
- https://docs.ansible.com/ansible/latest/reference_appendices/test_strategies.html

# Sumario

- Ansible provides built-in logging. This feature is not enabled by default.
- The log_path parameter in the default section of the ansible.cfg configuration file specifies the location of the log file to which all Ansible output is redirected.
- The debug module provides additional debugging information while running a playbook (for example, current value for a variable).
- The -v option of the ansible-playbook command provides several levels of output verbosity. This is useful for debugging Ansible tasks when running a playbook.
- The --check option enables Ansible modules with check mode support to display the changes to be performed, instead of applying those changes to the managed hosts.
- Additional checks can be executed on the managed hosts using ad hoc commands.
