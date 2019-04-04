#!/bin/bash
set -x
function usage {
	echo "Usage: tpch-setup.sh scale_factor [temp_directory]"
	exit 1
}

function runcommand {
	if [ "X$DEBUG_SCRIPT" != "X" ]; then
		$1
	else
		$1 2>/dev/null
	fi
}

if [ ! -f tpch-gen/target/tpch-gen-1.0-SNAPSHOT.jar ]; then
	echo "Please build the data generator with ./tpch-build.sh first"
	exit 1
fi

# Tables in the TPC-H schema.
TABLES="part lineitem supplier customer orders partsupp nation region"

# Get the parameters.
SCALE=$1
DIR=$2
BUCKETS=13
if [ "X$DEBUG_SCRIPT" != "X" ]; then
	set -x
fi

# Sanity checking.
if [ X"$SCALE" = "X" ]; then
	usage
fi
if [ X"$DIR" = "X" ]; then
	DIR=/tmp/tpch-generate
fi
if [ $SCALE -eq 1 ]; then
	echo "Scale factor must be greater than 1"
	exit 1
fi

hdfs dfs -mkdir -p ${DIR}
echo "phase starts from $PHASE."
echo "Generating data at scale factor $SCALE."
hadoop fs -rm -r -skipTrash ${DIR}/${SCALE}/
(cd tpch-gen; hadoop jar target/*.jar -d ${DIR}/${SCALE}/ -s ${SCALE} -text)
