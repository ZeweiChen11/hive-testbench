#!/bin/bash
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
	echo "Please build the data generator with (cd tpch-gen; make) first"
	exit 1
fi

# Tables in the TPC-H schema.
TABLES="part lineitem supplier customer orders partsupp nation region"

# Get the parameters.
SCALE=$1
DIR=$2

#[TODO]Optimize in spark
#PARALLEL_O : option parallel for lineitem and orders
#PARALLEL_P : parts partsupp
#PARALLEL_C : customer
#PARALLEL_L : nation region suppliers
if [ $SCALE -le 10 ]; then
	PARALLEL_O=2
	PARALLEL_P=2
	PARALLEL_C=2
	PARALLEL_L=2
else 
	PARALLEL_O=`echo "scale=1; $SCALE / 10" | bc`
	PARALLEL_O=`echo $PARALLEL_O|awk '{print int($PARALLEL_O)==$PARALLEL_O?$PARALLEL_O:int(int($PARALLEL_O*10/10+1))}'`
	PARALLEL_O=`echo "scale=0; $PARALLEL_O /1" | bc`
	PARALLEL_P=`echo "scale=0; $PARALLEL_O / 10" | bc`
	PARALLEL_P=`echo $PARALLEL_P|awk '{print $PARALLEL_P<2?2:$PARALLEL_P}'`
	PARALLEL_L=$SCALE
	PARALLEL_C=$PARALLEL_P
fi

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
echo "Generating data at scale factor $SCALE."
hadoop fs -rm -r -skipTrash ${DIR}/${SCALE}/
(cd tpch-gen; hadoop jar target/*.jar -d ${DIR}/${SCALE}/o -s ${SCALE} -p ${PARALLEL_O} -t orders -text; hadoop jar target/*.jar -d ${DIR}/${SCALE}/l -s ${SCALE} -p ${PARALLEL_L} -t nation -text; hadoop jar target/*.jar -d ${DIR}/${SCALE}/c -s ${SCALE} -p ${PARALLEL_C} -t customers -text; hadoop jar target/*.jar -d ${DIR}/${SCALE}/p -s ${SCALE} -p ${PARALLEL_P} -t parts -text;)
