    A stock finance agency is setting up a collaborative share directory to hold case files, which members of the managers group will have read and write permissions on.

    The co-founder of the agency, manager1, has decided that members of the contractors group should also be able to read and write to the share directory. However, manager1 does not trust the contractor3 user (a member of the contractors group), and as such, contractor3 should have access to the directory restricted to read-only.
    manager1 has created the users and groups, and has started the process of setting up the share directory, copying in some templates files. Because manager1 has been too busy, it falls to you to finish the job.

    Your task is to complete the setup of the share directory. The directory and all of its contents should be owned by the managers group, with the files updated to read and write for the owner and group (managers). Other users should have no permissions.

    You also need to provide read and write permissions for the contractors group, with the exception of contractor3, who only gets read permissions. Make sure your setup applies to existing and future files.

    Important information:

    - Share directory: /shares/cases on serverb.
    - The manager1 and manager2 users are members of the managers group.
    - The contractor1, contractor2, and contractor3 users are members of the contractors group.
    - Two files exist in the directory: shortlist.txt and backlog.txt.
    - All five user passwords are redhat.
    - All changes should occur to the /shares/cases directory and its files; do not adjust the / shares directory.

    1. The cases directory and its contents should belong to the managers group. New files
    added to the cases directory should automatically belong to the managers group. The
    user and group owners for the existing files should have read and write permission, and other users should have no permission at all. **Note Hint: Do not use setfacl**.

    2. Add ACL entries to the cases directory (and its contents) that allow members of the
    contractors group to have read/write access on the files and execute permission on the
    directory. Restrict the contractor3 user to read access on the files and execute permission on the directory.

    3. Add ACL entries that ensure any new files or directories in the cases directory have the correct permissions applied for all authorized users and groups.

    4. Verify that you have made your ACL and file-system changes correctly. Use ls and getfacl to review your settings on /shares/cases. As the student user, use su - user to switch first to manager1 and then to contractor1. Verify that you can write to a file, read from a file, make a directory, and write to a file in the new directory. Use ls to check the new directory permissions and getfacl to review the new directory ACL. As the student user, use su - contractor3 to switch user. Try writing to a file (it should fail) and try to make a new directory (it should fail). As the contractor3 user, you should be able to read from the shortlist.txt file in the cases directory and you should be able to read from the "test" files written in either of the new directories created by manager1 and contractor1 users.

"history"
