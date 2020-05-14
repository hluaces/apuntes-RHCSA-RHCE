1. Which command displays all the user jobs that are currently scheduled to run as
deferred jobs?

    a. atq
    b. atrm
    c. at -c
    d. at --display

2. Which command removes the deferred user job that has the job number 5?

    a. at -c 5
    b. atrm 5
    c. at 5
    d. at --delete 5

3. Which command displays all the recurring user jobs scheduled for the currently logged- in user?

    a. crontab -r
    b. crontab -l
    c. crontab -u
    d. crontab -V

4. Which job format executes /usr/local/bin/daily_backup hourly from 9 a.m. to
6 p.m. on all days from Monday through Friday?

    a. `00 * * * Mon-Fri /usr/local/bin/daily_backup`
    b. `* */9 * * Mon-Fri /usr/local/bin/daily_backup`
    c. `00 */18 * * * /usr/local/bin/daily_backup`
    d. `00 09-18 * * Mon-Fri /usr/local/bin/daily_backup`

5. Which directory contains the shell scripts intended to run on a daily basis?

    a. /etc/cron.d
    b. /etc/cron.hourly
    c. /etc/cron.daily
    d. /etc/cron.weekly

6. Which configuration file defines the settings for the system jobs that run on a daily, weekly, and monthly basis?

    a. /etc/crontab
    b. /etc/anacrontab
    c. /etc/inittab
    d. /etc/sysconfig/crond

7. Which systemd unit regularly triggers the cleanup of the temporary files?

    a. systemd-tmpfiles-clean.timer
    b. systemd-tmpfiles-clean.service
    c. dnf-makecache.timer
    d. unbound-anchor.timer

== BEGIN Respuestas (BASE64) ==
MWEgfCAyYiB8IDNiIHwgNGQgfCA1YyB8IDZiICB8IDdh
== END Respuestas (BASE64) ==


































La pregunta 6 es confusa. Lo que pregunta es en qué fichero se define la configuración que determina cómo se ejecutan esas tareas, no que permita ejecutar tareas. Dicho fichero es anacrontab, que es el que tiene el "run parts"
