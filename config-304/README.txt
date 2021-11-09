This directory contains the configuration files used for COMPX304-21B

./generate_connections.py generates the configuration.  At the start of
./generate_connections.py there are examples that generate networks of
different sizes.

Make sure to set config_transit=False for the final configuration.
And update welcoming_message.txt with the correct contact details.

Copy the generated AS_config.txt and external_links_config.txt (remove the
'.72' size) files into the platform/config/ directory along with the other
static configuration files, internal_links_config.txt etc.

At a minimum always allow four or more extra transit/student networks than
students. You will use these extra networks for marking and testing
labs/assignments yourself. This also leaves space for late enrolments.

Consider interspersing fully configured ASes within the transit ASes

Not all students attempt the assignment at the same time. In 2020, some
students ended up with very few BGP neighbours that they could speak with.

In 2021, I allocated ~2 extra ASes per block (6 blocks) and automatically
configured these. This allowed me to ensure that every student had at least one
fully configured neighbour in their block. You can configure these extra ASes
after starting the mini-Internet once students have completed their OSPF
assignment.

In 2021, for a class of 33, I configured the mini-Internet with 48 student
ASes.

