> Change the current tuning profile for serverb to balanced, a general non-specialized
tuned profile.

tuned-adm profile balanced

> Two processes on serverb are consuming a high percentage of CPU usage. Adjust each
process's nice level to 10 to allow more CPU time for other processes.

ps axo pid,cmd,ni,%cpu --sort=%cpu |tail

> Two processes on serverb are consuming a high percentage of CPU usage. Adjust each
process's nice level to 10 to allow more CPU time for other processes.

renice 10 -p X
renice 10 -p 1

