# Ejercicio

Match the following items to their counterparts in the table.

- default:m::rx /directory
- default:user:mary:rx /directory
- g::rw /directory
- g::rw file
- getfacl /directory
- group:hug:rwx /directory
- user::rx file
- user:mary:rx file

| Description | ACL operation |
| ----------- | ------------- |
| Display the ACL on a directory. | |
| Named user with read and execute permissions for a file. | |
| File owner with read and execute permissions for a file. | |
| Read and write permissions for a directory granted to the directory group owner. | |
| Read and write permissions for a file granted to the file group owner. | |
| Read, write, and execute permissions for a directory granted to a named group. | |
| Read and execute permissions set as the default mask. | |
| Named user granted initial read permission for new files, and read and execute permissions for new subdirectories. | |

# Respuestas

```
Scroll down

 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 v
```

| Description | ACL operation |
| ----------- | ------------- |
| Display the ACL on a directory. | getfacl /directory |
| Named user with read and execute permissions for a file. | user:mary:rx file |
| File owner with read and execute permissions for a file. | user::rx file |
| Read and write permissions for a directory granted to the directory group owner. | g::rw /directory |
| Read and write permissions for a file granted to the file group owner. | g::rw file |
| Read, write, and execute permissions for a directory granted to a named group. | group:hug:rwx /directory |
| Read and execute permissions set as the default mask. | default:m::rx /directory |
| Named user granted initial read permission for new files, and read and execute permissions for new subdirectories. | default:user:mary:rx /directory |
