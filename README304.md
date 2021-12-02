# COMPX304 teaching notes

The original mini-Internet project provides every student with a layer 2
network and a layer 3 network. COMPX304 uses the layer 3 routers as per the
original intention of the project, for the OSPF and BGP assignment. COMPX304
repurposes the layer 2 network as the lab network; which is no longer a layer 2
network as it includes Linux routers. The lab network is connected to the layer
3 network via the TRGA router. However, this link remains unused by the current
labs and assignments but could be incorporated as an extension to link the
two.

The 304 lab tasks and assignments remain similar to previous years, but I have
updated them for the mini-Internet.

## Setup

First, configure a network that is large enough for the class size. See
[./config-304/](config-304/) for the configuration that I used in 2021 and a
script to generate networks of different sizes. Note, that only transit
networks are useable by students and that the AS size listed includes stub and
tier1 ASes. It is always better to allocate more student ASes than the class
size, you can automatically configure ASes at any time. Having extra fully
configured transit ASes interspersed within student ASes is helpful as it
ensures that students who attempt the assignment early have other ASes they
can establish BGP sessions with.

Second, run ```./start_compx304.sh```. This script performs almost all steps
necessary to run the platform and incorporates fixes for problems previously 
encountered.  It first suggests system configuration changes that you should
make, and can automatically make them. Then, presents an estimate of the
expected hardware requirements. It then starts the mini-Internet and all
supporting tools/scripts. These tools/scripts copy live information to a local
webserver. You will need to configure the webserver with an HTTPS certificate
yourself, from let's encrypt for example.

### System Requirements
The [./start_compx304.sh](./start_compx304.sh) script presents an estimate
of the system requirements based on the number of ASes configured.
Once you run the script you can cancel after the requirements are displayed so
that you do not have to start the mini-Internet.

Beyond the requirements listed, ensure the mini-Internet is running on a stable
server with a UPS as restarting the mini-Internet is non-trivial/not possible.

#### CPU
I had 12 cores in 2021. This was sufficient, but I wouldn't want fewer than
that.

#### Memory
Ask for 128GB and go from there. Run a fully configured version of the
mini-Internet and check how memory usage is sitting first.

#### Disk
Ask for 100GB - 200GB, just to be safe.

The mini-Internet itself doesn't use much disk, really just a few GBs for the
docker images. Students are unlikely to use more than 1GB of additional
storage.

That said, two things to consider that use more disk space are:
1. Local backups, I backed up the configuration hourly. This totalled about 7GB
   at the end of the paper (approx. 3 months later).
2. Docker keeps uncompressed logs of the stdout/err for each image.
After a few months of running the docker logs for all containers can total
10-100GBs of storage.
    - The way to recover space disk space quickly is ```truncate -s 0
      /var/lib/docker/containers/*/*-json.log```
    - The ```./start_compx304.sh``` script also includes a system configuration
      suggestion to add these to logrotate so they don't grow too large.


#### Firewall access

Ask for public internet and student WiFi access to be allowed to the
following TCP ports.
- 80 (you should redirect this to HTTPS)
- 443
- 52000 - 52100 (ssh connections for each group. I used 52000-52100 to avoid
  registered ports and port scanning.)

Explicitly ask for access from the student WiFi as well, otherwise, this will
be missed.

### Fully Configuring an AS

Once the mini-Internet is running, you may want to fully configure a transit AS
that has not been allocated to a student or for marking. A script to fully
configure each router in an AS is located
```platform/groups/gX/ROUTER/init_full_conf.sh```.

You can use a modified version of the script located at
`platform/utils/configure_as304.sh` to fully configure the routers within an
AS. Before running the script, update the group numbers listed on the first
'for' loop.

### Modifying ```/proc/sys/``` options (e.g. forwarding)
Students won't be able to modify ```/proc/sys/``` (e.g.
```/proc/sys/net/ipv4/all/forwarding```) themselves due to security
restrictions placed on each the docker container. This compx304 version of the
mini-Internet project configures all layer2 hosts with ```forwarding``` enabled
to allow them to be used as routers. The ```start_compx304.sh``` script then
disables forwarding on hosts, you can use this example if you need to modify
other ```/proc/sys``` settings.

### Installing extra packages on mini-Internet containers

Once running, the mini-Internet containers will not have internet access,
therefore packages cannot be installed by students using apt. It is best to
preinstall all required applications into the docker images before starting.
However, installing a package later is possible.

The easiest way to install a package is to utilise the course scripts mount.
Files placed in `./platform/config/course_scripts/` are accessible within the
containers at the path `/scripts/`.

For example, consider installing netcat to all L2 hosts. (Not that you should
need to do this now as netcat is now included in the host image.)
1. Enter an instance of docker container where you want to install the package.
   For this example, we use the L2 host east-1 from group 10.
```rsanger@mini:~$ docker exec -it 10_L2_UNIV_east-1 bash```

2. Run the apt command to install the required package with ```--print-uris```
   option to find a list of dependencies that need to be installed.
```
root@east-1:/# apt install --print-uris --no-install-recommends netcat
...
After this operation, 173 kB of additional disk space will be used.
'http://deb.debian.org/debian/pool/main/n/netcat/netcat-traditional_1.10-41+b1_amd64.deb' netcat-traditional_1.10-41+b1_amd64.deb 66992 MD5Sum:34cd3767eaab5bfbf7aa1ad7752e3019
'http://deb.debian.org/debian/pool/main/n/netcat/netcat_1.10-41_all.deb' netcat_1.10-41_all.deb 8962 MD5Sum:ec4bc75c60f49b670ea902c4b76d543d
```
3. On the mini-Internet server, download the packages listed to
   `./platform/config/course_scripts/`
4. Use dpkg to install the packages in the order listed on the test machine,
   and verify the package installs correctly.
```root@east-1:/# dpkg -i /scripts/netcat-traditional_1.10-41+b1_amd64.deb /scripts/netcat_1.10-41_all.deb```

5. Write a script to install on all hosts, you can find examples in
   [./platform/utils/](./platform/utils/). The following bash script installs
netcat to all east-1 and east-2 hosts. The filters (```-f name=east-1 -f
name=east-2```) match any container with either east-1 or east-2 in their name,
you could add additional filters to include more hosts.
```
for container in $(docker ps -f name=east-1 -f name=east-2 --format="{{.Names}}"); do
    docker exec "$container" dpkg -i /scripts/netcat-traditional_1.10-41+b1_amd64.deb /scripts/netcat_1.10-41_all.deb
done
```


## Troubleshooting

### Students losing ssh access

I didn't encounter any problems with students losing ssh access this year.
Each container image has a limit of 100 processes and it was previously
possible that uncleanly closed would reach this limit and prevent future logins
(this is fixed now.)

If students cannot access their ssh container
1. On the server, an ssh process forwards each groups ssh port to make it
   publicly accessible. Check that this port forward hasn't died:
```rsanger@mini:~$ netstat -tnl```
If it has run the ```portforwarding.sh``` script in the ```platform/```
directory again.
2. Use docker to access ssh container and check for the running processes, if
   sshd is not running start it again using.
```rsanger@mini:~$ docker exec -it 10-ssh bash```
```root@g10-proxy:~# /usr/sbin/sshd```
3. Check the number of processes running on the ssh container, there is a limit
   of 100. This previously caused issues with uncleanly closed ssh sessions,
   however, this is fixed now. Kill excess processes and try logging in again.

If students can access their ssh container, but not hosts or routers.
1. The student has likely overwritten the preinstalled ssh private key. You can
   find a backup copy in ```platform/groups/gX/id_rsa```, copy this to
```.ssh/id_rsa``` on ssh container.
```rsanger@mini:~$ docker cp ./platform/groups/id_rsa 10-ssh:/root/.ssh/id_rsa```
2. If a single container cannot be reached then it is possible that ssh has
   only died in that container. Use docker to access the container and run
   ```/usr/sbin/sshd``` again. Also, check the process limit has not been
   reached or that an iptables rule is blocking the connection.

### Fix if students lock themselves out of a machine with iptables

It is possible that in the iptables lab a student accidentally blocks traffic
from the ssh port by adding rules to the INPUT chain. To fix this, you will
need to access the docker image directly and flush the rules from iptables.
For example:
```docker exec 10-L2-UNIV-east-1 iptables --flush```

### Restarting the server running the mini-Internet

There is no easy way to restart the mini-Internet project and retain student
configuration. So ensure that everything needed is installed and the system is
up-to-date before giving the class access. Once running, avoid updates and
configuration changes as restarting the mini-Internet (or components of it) is
non-trivial. While there are backups, these only save each student's router
configuration and do not save any Linux host configuration (such as those in
the lab network and those attached to routers).

### Restarting a particular container

I have not restarted containers myself, I've always entered the container and
fixed the problem instead. However, if you want to restart an individual
container, refer to the documentation in [platform/](platform/).
