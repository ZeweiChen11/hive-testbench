#!/bin/bash
# This is to load TPC-H tables into kudu using spark-submit
# Before executing this script, please build kudu-spark-tools in kudu project.
#   git clone https://github.com/ZeweiChen11/kudu.git
#   cd kudu/java/kudu-spark-tools
#   mvn clean package -DskipTests
#
#


set -e
SCALE=2000
DIR=/user/root/tpch/
cor_node=blazers-clx03
FILE_FORMAT="TEXTFILE"
IMPALA_SHELL="/home/bduser/impala/bin/impala-shell.sh"
KUDU_HOME=/home/bduser/kudu/
#SPARK_SUBMIT=/root/zewei/spark/bin/spark-submit
SPARK_SUBMIT=spark-submit
IMPALA_VERSION=cdh #or "apache"

if [ ! -f ${KUDU_HOME}/java/kudu-spark-tools/target/kudu-spark2-tools_2.11-1.5.0.jar ]; then
        echo "Please build the kudu-spark-tools at first!"
	echo "git clone https://github.com/ZeweiChen11/kudu.git"
	echo "cd kudu/java/kudu-spark-tools"
	echo "mvn clean package -DskipTests"
        exit 1
fi

time=`date +%Y%m%d%H%M%S`
LOG_DIR=kudu_log_${time}
if [ ! -d ${LOG_DIR} ]; then
	mkdir -p ${LOG_DIR}
fi

if [ "${IMPALA_VERSION}" = "apache" ]; then
	source ${IMPALA_HOME}/bin/impala-config.sh
fi

IMPALA_DB_NAME=tpch_impala_${SCALE}
KUDU_DB_NAME=tpch_kudu_${SCALE}
#${IMPALA_SHELL} -i ${cor_node} -q "create database if not exists ${IMPALA_DB_NAME}"
${IMPALA_SHELL} -q "create database if not exists ${KUDU_DB_NAME}"

#you need to tune spark-submit parameters according to your machines.
function load_table {
    data=$2
    t=$1
    spark-submit \
    --master yarn \
    --deploy-mode client \
    --executor-cores 7 \
    --executor-memory 15g \
    --conf "spark.yarn.executor.memoryOverhead=4g" \
    --class org.apache.kudu.spark.tools.ImportExportFiles \
    ${KUDU_HOME}/java/kudu-spark-tools/target/kudu-spark2-tools_2.11-1.5.0.jar \
    --operation=import --format=csv --delimiter="|" --master-addrs=${cor_node} \
    --path=${data} --table-name="impala::tpch_kudu_${SCALE}.${t}" --table="${t}" 2>&1 | tee -a ${LOG_DIR}/load_${t}.log
}

function load(){
	#customer part partsupp lineitem suppliers
	other_table=$1
	${IMPALA_SHELL} -f tpch-create-table/${other_table}.sql -d ${KUDU_DB_NAME} --var=KUDU_DB_NAME=${KUDU_DB_NAME}
	table_file_number=`hadoop fs -ls ${DIR}/${SCALE}/${other_table} | wc -l`
	for i in `seq 0 $table_file_number`
	do
	    file_num=`printf "%05d\n" ${i}`
	    load_table customer ${DIR}/${SCALE}/${other_table}/data-m-${file_num}
	done
}

#load nation region supplier
for table in nation region supplier
do
    ${IMPALA_SHELL} -f tpch-create-table/${table}.sql -d ${KUDU_DB_NAME} --var=KUDU_DB_NAME=${KUDU_DB_NAME}
    load_table ${table} ${DIR}/${SCALE}/${table}/data-m-*
done

#load customer part partsupp lineitem suppliers
for t in customer part partsupp lineitem suppliers
do
	echo "Loading table ${t}..."
	load ${t}
done	
