#!/bin/bash
# Kill likely dropped ssh sessions which have been open for an excessively
# long time

((MAXAGE=7*24*60*60)) # seconds (7*24*60*60) - one week

candidates="$(pgrep -f 'sshd: root@pts')"
for candidate in $candidates
do
	echo $(date +%s) $(stat -c %X /proc/$candidate)
	(( age_sec=$(date +%s) - $(stat -c %X /proc/$candidate) ))
	if [[ "$age_sec" -ge "$MAXAGE" ]]; then
		ps -p $candidate -o 'start_time=,args='
		kill $candidate
	fi
done

