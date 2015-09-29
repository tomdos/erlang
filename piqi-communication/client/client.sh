#!/bin/bash

function usage
{
	echo "Usage: client.sh \"my pretty message\""
}

if [ $# -ne 1 ]; then
	usage
	exit 1
fi

message=$1

echo "$message" | nc localhost 1234
