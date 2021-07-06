#!/bin/bash
# Logs into each container an runs a script to cleanup old ssh sessions


light_ases=({1..2} {13..16} {27..30} {41..44} {55..58} {69..72} {83..84})
configured_ases=({3..12} {17..26} {31..40} {45..54} {59..68} {73..82})


echo ${light_ases[@]}



for asn in ${configured_ases[@]};
do
	# Start the iperf server in the background
	echo AS: ${asn}
	docker exec -t ${asn}_ssh /scripts/kill_old_ssh_sessions.sh
done

