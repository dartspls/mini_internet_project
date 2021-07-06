#!/bin/bash


light_ases=({1..2} {9..12} {19..22} {29..32} {39..42} {49..52} {59..60})
configured_ases=({3..8} {13..18} {23..28} {33..38} {43..48} {53..58})


echo ${light_ases[@]}



for asn in ${configured_ases[@]};
do
	# Start the iperf server in the background
	docker exec -d ${asn}_MIAMhost timeout 5m iperf3 -s -1 &
	docker exec -d ${asn}_BOSThost timeout 5m iperf3 -s -1 &

done

sleep 2

arr_len=${#configured_ases[@]}
for index in ${!configured_ases[*]};
do
	asn=${configured_ases[$(($arr_len - $index - 1))]}
	target=${configured_ases[$index]}
	docker exec -t ${asn}_PARIhost timeout 3m iperf3 -c ${target}.108.0.1 -t 20 -C bbr -Z &
	docker exec -t ${asn}_ATLAhost timeout 3m iperf3 -c ${target}.106.0.1 -t 20 -C bbr -Z &
done

#for asn in ${light_ases[@]};
#do
#	target=${configured_ases[$index]}
#	docker exec -t ${asn}_LONDhost timeout 3m iperf3 -c ${target}.108.0.1 -t 120 -C bbr &
#done

wait

