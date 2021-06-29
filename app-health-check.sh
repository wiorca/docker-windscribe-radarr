#! /bin/bash

# Check to make sure Radarr is running

QBTNX=$(pgrep Radarr | wc -l )
if [[ ${QBTNX} -ne 1 ]]
then
	echo "Radarr process not running"
	exit 1
fi

echo "Radarr is running"

exit 0
