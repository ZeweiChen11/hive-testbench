#/bin/sh
set -e
SCALE=2
DIR=/user/root/tpch/
cor_node=atlas-cdh96.jf.intel.com
FILE_FORMAT="TEXTFILE"
IMPALA_HOME="/root/workspace/impala/"
IMPALA_SHELL="${IMPALA_HOME}/bin/impala-shell.sh"
#time=`date +%Y%m%d%H%M%S`
#LOG_DIR=kudu_log_${time}
#if [ ! -d ${LOG_DIR} ]; then
#       mkdir -p ${LOG_DIR}
#fi

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
        ${IMPALA_SHELL} -i ${cor_node} -q "create database if not exists ${IMPALA_DB_NAME}"
        ${IMPALA_SHELL} -i ${cor_node} -q "create database if not exists ${KUDU_DB_NAME}"
#       for t in lineitem customer nation orders part partsupp region supplier
        for t in nation
        do
                echo 3 > /proc/sys/vm/drop_caches
                echo "Start loading ${t} ..." 2>&1 | tee -a ${LOG_DIR}/load.log
                date 2>&1 | tee -a ${LOG_DIR}/load.log
                ${IMPALA_SHELL} -i ${cor_node} -f tpch-create-table/${t}.sql -d ${IMPALA_DB_NAME} --var=DB=${IMPALA_DB_NAME} --var=LOCATION=${DIR}/${SCALE} --var=KUDU_DB_NAME=${KUDU_DB_NAME} --var=FILE_FORMAT=${FILE_FORMAT} --query_option=DEFAULT_SPILLABLE_BUFFER_SIZE=1MB 2>&1 | tee -a ${LOG_DIR}/load.log
                date 2>&1 | tee -a ${LOG_DIR}/load.log
                echo "End loading ${t} ..." 2>&1 | tee -a ${LOG_DIR}/load.log
        done
        echo "Loading done!"
}

function runQuery(){
        query=$1
        stream=$2
        echo "run query ${query} in ${stream}..." 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}_${stream}.log
        start=$(date +%s%3N)
        date 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}_${stream}.log
        ${IMPALA_SHELL} -i ${cor_node} -f sample-queries-tpch/tpch_query${query}.sql -d ${KUDU_DB_NAME} -p --query_option=DEFAULT_SPILLABLE_BUFFER_SIZE=1MB 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}_${stream}.log
        #${IMPALA_SHELL} -i ${cor_node} -f sample-queries-tpch/tpch_query${query}.sql -d ${KUDU_DB_NAME} -p 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}_${stream}.log
        end=$(date +%s%3N)
        getExecTime $start $end >> ${LOG_DIR}/tpch_query${query}_${stream}.log
        date 2>&1 | tee -a ${LOG_DIR}/tpch_query${query}_${stream}.log
        echo "query ${query} done in ${stream} !" >> ${LOG_DIR}/tpch_query${query}_${stream}.log
}

function runStream(){
        stream_nu=$1
        echo "run stream ${stream_nu}..." 2>&1 | tee -a ${LOG_DIR}/stream_${stream_nu}.log
        start=$(date +%s%3N)
        date 2>&1 | tee -a ${LOG_DIR}/stream_${stream_nu}.log
        ${IMPALA_SHELL} -i ${cor_node} -f stream_query/s${stream_nu}.sql -d ${KUDU_DB_NAME} 2>&1 | tee -a ${LOG_DIR}/stream_${stream_nu}.log
        end=$(date +%s%3N)
        getExecTime $start $end 2>&1 | tee -a  ${LOG_DIR}/stream_${stream_nu}.log
        date 2>&1 | tee -a ${LOG_DIR}/stream_${stream_nu}.log
        echo "Stream ${stream_nu} done!" 2>&1 | tee -a  ${LOG_DIR}/stream_${stream_nu}.log
}

#Load

echo "Dropping caches..."
echo 3 > /proc/sys/vm/drop_caches
time=`date +%Y%m%d%H%M%S`
LOG_DIR=kudu_log_${time}
if [ ! -d ${LOG_DIR} ]; then
       mkdir -p ${LOG_DIR}
fi

Load
#====run query in Stream =========
#time=`date +%Y%m%d%H%M%S`
#LOG_DIR=kudu_log_${time}_r1
#mkdir -p ${LOG_DIR}
#runStream 0 &
#runStream 1 &
#runStream 2 &
#runStream 3 &
#runStream 4 &
#
#wait
##echo "Dropping caches..."
##echo 3 > /proc/sys/vm/drop_caches
#
#time=`date +%Y%m%d%H%M%S`
#LOG_DIR=kudu_log_${time}_r2
#mkdir -p ${LOG_DIR}
#runStream 0 &
#runStream 1 &
#runStream 2 &
#runStream 3 &
#runStream 4 &

#====run query in parallel==========
#stream_query="1 2 3 10"
#
#stream_nu=0
#time=`date +%Y%m%d%H%M%S`
#LOG_DIR=kudu_log_${time}_r1
#mkdir -p ${LOG_DIR}
#
#for sq in ${stream_query}
#do
#       runQuery ${sq} ${stream_nu} &
#       let stream_nu+=1
#done
#
#wait
#
##echo 3 > /proc/sys/vm/drop_caches
#time=`date +%Y%m%d%H%M%S`
#LOG_DIR=kudu_log_${time}_r2
#mkdir -p ${LOG_DIR}
#
#stream_nu=0
#for sq in ${stream_query}
#do
#        runQuery ${sq} ${stream_nu} &
#        let stream_nu+=1
#done
#==========================

#======run query===========
#time=`date +%Y%m%d%H%M%S`
#LOG_DIR=kudu_log_${time}
#mkdir -p ${LOG_DIR}
#runQuery 22 0

#
#echo "Sleep 2 minute..."
#sleep 2m
#
#
#time=`date +%Y%m%d%H%M%S`
#LOG_DIR=kudu_log_${SCALE}_${time}_r1
#mkdir -p ${LOG_DIR}
#
#for n in `seq 1 22`
#do
#       echo "===start run query $n==="
#       date
#       echo 3 > /proc/sys/vm/drop_caches
#       runQuery ${n} 0
#       date
#       echo "===end query $n ==="
#done
#
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

