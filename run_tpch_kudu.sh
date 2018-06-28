#/bin/sh
set -e
SCALE=800
DIR=/user/root/tpch/
cor_node=atlas-cdh95.jf.intel.com
FILE_FORMAT="TEXTFILE"
time=`date +%Y%m%d%H%M%S`
LOG_DIR=kudu_log_${time}
if [ ! -d ${LOG_DIR} ]; then
	mkdir -p ${LOG_DIR}
fi

IMPALA_DB_NAME=tpch_impala_${SCALE}
KUDU_DB_NAME=tpch_kudu_${SCALE}

function getExecTime() {
        start=$1
        end=$2
        time_s=`echo "scale=3;$(($end-$start))/1000" | bc`
        echo "Duration: ${time_s} s"
}

function Load(){
	echo "Dropping caches..."
	echo 3 > /proc/sys/vm/drop_caches
	echo "Loading text data into external tables."
	impala-shell -i ${cor_node} -q "create database if not exists ${IMPALA_DB_NAME}"
	impala-shell -i ${cor_node} -q "create database if not exists ${KUDU_DB_NAME}"
	for t in lineitem customer nation orders part partsupp region supplier
	do
		echo 3 > /proc/sys/vm/drop_caches
		echo "Start loading ${t} ..." 2>&1 | tee -a ${LOG_DIR}/load.log
		date 2>&1 | tee -a ${LOG_DIR}/load.log
		impala-shell -i ${cor_node} -f tpch-create-table/${t}.sql -d ${IMPALA_DB_NAME} --var=DB=${IMPALA_DB_NAME} --var=LOCATION=${DIR}/${SCALE} --var=KUDU_DB_NAME=${KUDU_DB_NAME} --var=FILE_FORMAT=${FILE_FORMAT} 2>&1 | tee -a ${LOG_DIR}/load.log
		date 2>&1 | tee -a ${LOG_DIR}/load.log
		echo "End loading ${t} ..." 2>&1 | tee -a ${LOG_DIR}/load.log
	done
	echo "Loading done!"
}

function runQuery(){
	query=$1
	echo "run query ${query}..." 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}.log
	start=$(date +%s%3N)
	date 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}.log
	impala-shell -i ${cor_node} -f impala-queries-tpch/tpch_query${query}.sql -d ${KUDU_DB_NAME} 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}.log
	end=$(date +%s%3N)
	getExecTime $start $end >> ${LOG_DIR}/tpch_query${query}.log
	echo "query ${query} done!" 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}.log
}

function Read(){
	echo "Start reading..."
	impala-shell -i ${cor_node} -f tpch-create-table/read.sql -d ${KUDU_DB_NAME} >> ${LOG_DIR}/table.log
}
#Load

echo "Dropping caches..."
echo 3 > /proc/sys/vm/drop_caches
#
#echo "Sleep 2 minute..."
#sleep 2m
#
#
for n in `seq 1 22`
do
	echo "===start run query $n==="
	date
	runQuery ${n}
	date
	echo "===end query $n ==="
done

time=`date +%Y%m%d%H%M%S`
LOG_DIR=kudu_log_${time}
if [ ! -d ${LOG_DIR} ]; then
        mkdir -p ${LOG_DIR}
fi

for n in `seq 1 22`
do
        echo "===start run query $n==="
        date
        runQuery ${n}
        date
        echo "===end query $n ==="
done
