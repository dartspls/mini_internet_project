#!/bin/bash
#
# build all images and upload to the docker hub

set -o errexit
set -o pipefail
set -o nounset

#docker login

# If you want to use your custom docker containers and upload them into
# docker hub, change the docker username with your own docker username.
docker_name=thomahol

for name in router ixp host ssh measurement dns switch matrix vpn vlc hostm host_304 switch_304
do

	docker build --tag=d_${name} docker_images/${name}/
	container_name=d_${name}
	docker tag "${container_name}" "${docker_name}"/"${container_name}"
done
