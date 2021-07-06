
docker exec -it ${1}_ATLArouter /usr/lib/frr/frr-reload 
docker exec -it ${1}_BOSTrouter /usr/lib/frr/frr-reload 
docker exec -it ${1}_NEWYrouter /usr/lib/frr/frr-reload 
docker exec -it ${1}_GENErouter /usr/lib/frr/frr-reload 
docker exec -it ${1}_PARIrouter /usr/lib/frr/frr-reload 
docker exec -it ${1}_ZURIrouter /usr/lib/frr/frr-reload 
docker exec -it ${1}_LONDrouter /usr/lib/frr/frr-reload 
