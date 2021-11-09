#!/bin/bash
#
# enable portforwarding
# before executing this script make sure to set
# the following options in  /etc/ssh/sshd_config:
#   GatewayPorts yes
#   PasswordAuthentication yes
#   AllowTcpForwarding yes
# then restart ssh: service ssh restart

# Starting from this port, map each group's ssh port
# e.g. With an offset of 2000, G1 receives port 2001
# and the measurement host 2099.
PORT_OFFSET=52000

DIRECTORY=$(cd `dirname $0` && pwd)
source "${DIRECTORY}"/config/subnet_config.sh

readarray groups < "${DIRECTORY}"/config/AS_config.txt
group_numbers=${#groups[@]}

for ((k=0;k<group_numbers;k++)); do
    group_k=(${groups[$k]})
    group_number="${group_k[0]}"
    group_as="${group_k[1]}"

    if [ "${group_as}" != "IXP" ];then
        if command -v ufw > /dev/null 2>&1; then
            ufw allow "$((group_number+PORT_OFFSET))"
        fi
        subnet=$(subnet_ext_sshContainer "${group_number}" "sshContainer")
        ssh -i groups/id_rsa -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking no" -f -N -L 0.0.0.0:"$((group_number+PORT_OFFSET))":"${subnet%/*}":22 root@${subnet%/*}
    fi
done

# measurement
if command -v ufw > /dev/null 2>&1; then
    ufw allow $((99+PORT_OFFSET))
fi
subnet=$(subnet_ext_sshContainer "${group_number}" "MEASUREMENT")
ssh -i groups/id_rsa -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking no" -f -N -L 0.0.0.0:$((99+PORT_OFFSET)):"${subnet%/*}":22 root@${subnet%/*}


# for pid in $(ps aux | grep ssh | grep StrictHostKeyChecking | tr -s ' ' | cut -f 2 -d ' '); do sudo kill -9 $pid; done
