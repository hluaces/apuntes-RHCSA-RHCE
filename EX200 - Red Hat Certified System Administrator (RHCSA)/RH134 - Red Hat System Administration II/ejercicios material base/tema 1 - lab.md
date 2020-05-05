#!/usr/bin/env bash

set -e
readonly SERVER_LIST='servera serverb'

for server in ${SERVER_LIST};
do
    file="/home/student/output-${server}"

    ssh "${server}" hostname -f >> "${file}"
    echo "#####" >> "${file}"

    ssh "${server}" lscpu |grep '^CPU' >> "${file}"
    echo "#####" >> "${file}"

    ssh "${server}" "sudo grep -vE '^(#|\s*$)' /etc/selinux/config" >> "${file}"
    echo "#####" >> "${file}"

    ssh "${server}" "sudo grep 'Failed password'" /var/log/secure >> "${file}"
    echo "#####" >> "${file}"
done

exit 0
