#/bin/sh
set -e
SCALE=2
DIR=/user/root/tpch/
cor_node=atlas-cdh96.jf.intel.com
FILE_FORMAT="TEXTFILE"
IMPALA_HOME="/root/workspace/impala/"
IMPALA_SHELL="${IMPALA_HOME}/bin/impala-shell.sh"

IMPALA_DB_NAME=tpch_impala_${SCALE}
KUDU_DB_NAME=tpch_kudu_${SCALE}

function getExecTime() {
        start=$1
        end=$2
        time_s=`echo "scale=3;$(($end-$start))/1000" | bc`
        echo "Duration: ${time_s} s"
}

function runQuery(){
        query=$1
        round=$2
        echo "run query ${query} in round ${round}..." 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}_${round}.log
        start=$(date +%s%3N)
        date 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}_${round}.log
        ${IMPALA_SHELL} -i ${cor_node} -f sample-queries-tpch/tpch_query${query}.sql -d ${KUDU_DB_NAME} -p 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}_${round}.log
        end=$(date +%s%3N)
        getExecTime $start $end >> ${LOG_DIR}/tpch_query${query}_${round}.log
        date 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}_${round}.log
        echo "query ${query} done in round ${round} !" >> ${LOG_DIR}/tpch_query${query}_${round}.log
}


#echo "Dropping caches..."
#echo 3 > /proc/sys/vm/drop_caches
#time=`date +%Y%m%d%H%M%S`
#LOG_DIR=kudu_log_${SCALE}_${time}
#if [ ! -d ${LOG_DIR} ]; then
#       mkdir -p ${LOG_DIR}
#fi


#======run query===========
time=`date +%Y%m%d%H%M%S`
LOG_DIR=kudu_log_${SCALE}_${time}
mkdir -p ${LOG_DIR}

for n in `seq 1 22`
do
       echo "===start run query $n==="
       pssh -h ~/hosts -i "echo 3 > /proc/sys/vm/drop_caches"
       runQuery ${n} 1
       pssh -h ~/hosts -i "echo 3 > /proc/sys/vm/drop_caches"
       runQuery ${n} 2
       echo "===end query $n ==="
done

#echo 3 > /proc/sys/vm/drop_caches
#time=`date +%Y%m%d%H%M%S`
#LOG_DIR=kudu_log_${SCALE}_${time}_r2
#mkdir -p ${LOG_DIR}
#
#for n in `seq 1 22`
#do
#        echo "===start run query $n==="
#        date
#        echo 3 > /proc/sys/vm/drop_caches
#        sleep 30s
#        runQuery ${n} 0
#        date
#        sleep 30s
#        echo "===end query $n ==="
#done
#=========================

