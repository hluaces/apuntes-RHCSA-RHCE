# Tema 3 - Tuning System Performance

- Adjusting Tuning Profiles
- Influencing Process Scheduling

## Adjusting Tuning Profiles

- `tuned` tiene configuración _estática_ y _dinámica_ (que cambia con el tiempo).
- `tuned` funciona con "perfiles".
- `tuned-adm` permite elegir que perfil de _tuned_ usamos (p.ej.: `tuned-adm active`).
- `tuned-adm list` muestra los perfiles disponibles
- `tuned-adm profile <perfil>` cambia el perfil. Se puede activar más de uno.
    - En el caso de activar más de uno se ejecutarán por orden de precedencia.
- `tuned-adm recommended` recomienda que tuned usar.
- `tuned-adm off` desactiva el perfil de tuned.
- En `/usr/lib/tuned` se guardan los perfiles disponibles (ficheros tipo _ini_)

Enlaces relevantes:

- [Gitab de tuned](https://github.com/redhat-performance/tuned)
- [Redhat performance](https://github.com/redhat-performance/tuned)
- [Governors de CPU](https://www.kernel.org/doc/Documentation/cpu-freq/governors.txt)
- [Tuning de discos con tuned](https://cromwell-intl.com/open-source/performance-tuning/disks.html)
- [Scheduler de disco recomendado para virtualización](https://access.redhat.com/solutions/5427)

## Influencing Process Scheduling

- \[Explicación de threading, kernel y planificadores\].
- \[Explicación de _niceness_\].
- Puede verse el planificador en uso por un proceso con `ps axo pid,ni,cls,cmd` (valor `cls`).
- Internamente hay un nivel de _prioridad_ que puede ser inferior a _nice -20_. Con el top se ve en el campo `PR`.
- Prioridad `rt` significa "_tiempo real_" y es la prioridad máxima.

Enlaces interesantes:

- [Configurar ulimits para que un usuario pueda usar nice/renice negativos](https://access.redhat.com/solutions/61334)

# Mans importantes

- man:tuned(8)
- man:tuned.conf(5)
- man:tuned-adm(8)
- man:tuned-main.conf(5)
- man:sched
- man:nice

# Sumario

In this chapter, you learned:

- The tuned service automatically modifies device settings to meet specific system needs based on a pre-defined selected tuning profile.
- To revert all changes made to system settings by a selected profile, either switch to another profile or deactivate the tuned service.
- The system assigns a relative priority to a process to determine its CPU access. This priority is called the nice value of a process.
- The nice command assigns a priority to a process when it starts. The renice command modifies the priority of a running process.

# Preguntas

- ¿Qué tiene más prioridad `/etc/sysctl.conf` o _tuned_? -> El que se ejecute de último.
