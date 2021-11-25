#!/bin/bash
#
# Upload the looking glass to the locally running running webserver
# By default "/var/www/html/" or to the path given by the first argument

set -o errexit
set -o pipefail
set -o nounset

WEBROOT=/var/www/html/
if [[ "$#" -ge 1 ]]; then
    WEBROOT="$1"
fi

# read configs
readarray groups < config/AS_config.txt
group_numbers=${#groups[@]}

while true
do
    # mkdir tmp
    for ((k=0;k<group_numbers;k++)); do
        group_k=(${groups[$k]})
        group_number="${group_k[0]}"
        group_as="${group_k[1]}"
        group_config="${group_k[2]}"
        group_router_config="${group_k[3]}"

        if [ "${group_as}" != "IXP" ];then

            readarray routers < config/$group_router_config
            n_routers=${#routers[@]}

            mkdir -p ${WEBROOT}/looking_glass/G$group_number

            for ((i=0;i<n_routers;i++)); do
                router_i=(${routers[$i]})
                rname="${router_i[0]}"
                property1="${router_i[1]}"
                property2="${router_i[2]}"

                cp "groups/g${group_number}/${rname}/looking_glass.txt" "${WEBROOT}/looking_glass/G$group_number/${rname}.txt"

                echo "$group_number" "$rname"
            done
            echo $group_number done
        else
            mkdir -p "${WEBROOT}/looking_glass/G${group_number}"

            cp "groups/g${group_number}/looking_glass.txt" "${WEBROOT}/looking_glass/G$group_number/LG.txt"
            echo "$group_number" done
        fi
    done
    sleep 120
done
