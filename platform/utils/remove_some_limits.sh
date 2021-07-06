#!/bin/bash


light_ases=({1..2} {13..16} {27..30} {41..44} {55..58} {69..72} {83..84})
configured_ases=({3..12} {17..26} {31..40} {45..54} {59..68} {73..82})


echo ${light_ases[@]}



for asn in ${configured_ases[@]};
do
	# Start the iperf server in the background
	echo ${asn}
	id=$(docker exec -t ${asn}_L2_UNIV_student_3 ip l | grep SBLOCK | sed 's/.*@if\([0-9]*\)\:.*/\1/')
	iface_name=$(ip link | grep "^${id}:" | sed "s/^${id}: \([^@]*\)@if.*/\1/")
	echo $id $iface_name
	ovs-vsctl set interface ${iface_name} ingress_policing_rate=0
	tc qdisc del dev ${iface_name} root
	
	
	id=$(docker exec -t ${asn}_L2_UNIV_staff_3 ip l | grep SBLOCK | sed 's/.*@if\([0-9]*\)\:.*/\1/')
	iface_name=$(ip link | grep "^${id}:" | sed "s/^${id}: \([^@]*\)@if.*/\1/")
	echo $id $iface_name
	ovs-vsctl set interface ${iface_name} ingress_policing_rate=0
	tc qdisc del dev ${iface_name} root
	
	id=$(docker exec -t ${asn}_L2_UNIV_SBLOCK ip l | grep staff_3 | sed 's/.*@if\([0-9]*\)\:.*/\1/')
	iface_name=$(ip link | grep "^${id}:" | sed "s/^${id}: \([^@]*\)@if.*/\1/")
	echo $id $iface_name
	ovs-vsctl set interface ${iface_name} ingress_policing_rate=0
	tc qdisc del dev ${iface_name} root
	
	id=$(docker exec -t ${asn}_L2_UNIV_SBLOCK ip l | grep student_3 | sed 's/.*@if\([0-9]*\)\:.*/\1/')
	iface_name=$(ip link | grep "^${id}:" | sed "s/^${id}: \([^@]*\)@if.*/\1/")
	echo $id $iface_name
	ovs-vsctl set interface ${iface_name} ingress_policing_rate=0
	tc qdisc del dev ${iface_name} root
	#docker exec -t ${asn}_L2_UNIV_student_3 dpkg -i /scripts/netcat-traditional_1.10-41+b1_amd64.deb 
	#docker exec -t ${asn}_L2_UNIV_staff_3 dpkg -i /scripts/netcat-traditional_1.10-41+b1_amd64.deb 
done

