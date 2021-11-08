#!/bin/bash
# Builds customised versions of images for COMPX304.
# Images are saved as d_name_304 to differentiate them
# from the standard images

set -o errexit
set -o pipefail
set -o nounset

for name in ssh_304 host_304 switch_304 router_304
do
	docker build --tag=d_${name} docker_images/${name}/
done
