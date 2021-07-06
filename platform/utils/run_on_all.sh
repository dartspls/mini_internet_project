#!/bin/bash
# Template to run a command on all AS's

light_ases=({1..2} {13..16} {27..30} {41..44} {55..58} {69..72} {83..84})
configured_ases=({3..12} {17..26} {31..40} {45..54} {59..68} {73..82})


echo ${light_ases[@]}



for asn in ${configured_ases[@]};
do
	# Start the iperf server in the background
	echo ${asn}
	#docker exec -t ${asn}_L2_UNIV_student_3 dpkg -i /scripts/netcat-traditional_1.10-41+b1_amd64.deb 
	#docker exec -t ${asn}_L2_UNIV_staff_3 dpkg -i /scripts/netcat-traditional_1.10-41+b1_amd64.deb 
done

