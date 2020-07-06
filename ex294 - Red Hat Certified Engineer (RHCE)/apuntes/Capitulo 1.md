# Tema 1 - Introducing Ansible

- What is Ansible
- Ansible installation

## What is Ansible

- Infrastructure as code on YAML files.
- Mitiga error humano.
- Simple, potente y sin agente.
- Multiplataforma.

## Arquitectura de Ansible

Hay dos tipos de hosts:

- _managed host_: Máquinas que son administradas por Ansible.
- _control host_: Máquina en la que se instala Ansible y que configura los _managed hosts_.
- _inventario_: Conjunto de ficheros que almacena la lista de _managed hosts_ por Ansible.

## Instalación de Ansible

Para el _control host_ hay dos formas:

- Repos del DVD (sin soporte).
- Con soporte: usar la suscripción _"Red Hat Ansible Automation"_.

En RHEL8 puede usarse el paquete `platform-python` para usar Ansible sin instalar Python.

Para los _managed hosts_:

- Necesita _python_ (>=3.5 o >=2.6)

Nótese que el módulo `raw` no necesita Python, por lo que puede usarse para instalarlo previo a ejecutar de forma normal Ansible.

Los módulos para Windows requieren PowerShell 3.0+.

# Preguntas

- ¿En los exámenes es necesario gestionar las suscripciones de Ansible?

# Enlaces interesantes

- https://www.ansible.com
- https://www.ansible.com/how-ansible-works
- https://access.redhat.com/ansible-top-support-policies
- http://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
- https://docs.ansible.com/ansible/latest/user_guide/windows.html
- https://docs.ansible.com/ansible/latest/network/index.html

# Sumario

- Automation is a key tool to mitigate human error and quickly ensure that your IT infrastructure is in a consistent, correct state.
- Ansible is an open source automation platform that can adapt to many different workflows and environments.
- Ansible can be used to manage many different types of systems, including servers running Linux, Microsoft Windows, or UNIX, and network devices.
- Ansible Playbooks are human-readable text files that describe the desired state of an IT infrastructure.
- Ansible is built around an agentless architecture in which Ansible is installed on a control node and clients do not need any special agent software.
- Ansible connects to managed hosts using standard network protocols such as SSH, and runs code or commands on the managed hosts to ensure that they are in the state specified by Ansible
