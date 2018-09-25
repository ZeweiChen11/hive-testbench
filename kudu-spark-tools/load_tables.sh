#!/bin/bash
# This is to load TPC-H tables into kudu using spark-submit
# Before executing this script, please build kudu-spark-tools in kudu project.
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

time=`date +%Y%m%d%H%M%S`
LOG_DIR=kudu_log_${time}
if [ ! -d ${LOG_DIR} ]; then
       mkdir -p ${LOG_DIR}
fi

source /home/bduser/impala/bin/impala-config.sh

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

for table in nation region supplier
do
    ${IMPALA_SHELL} -f tpch-create-table/${t}.sql -d ${KUDU_DB_NAME} --var=KUDU_DB_NAME=${KUDU_DB_NAME}
    load_table ${table} /user/root/tpch/${SCALE}/${table}/data-m-*
done

${IMPALA_SHELL} -f tpch-create-table/customer.sql -d ${KUDU_DB_NAME} --var=KUDU_DB_NAME=${KUDU_DB_NAME}
for i in {0..1}
do
    load_table customer /user/root/tpch/${SCALE}/customer/data-m-0${i}*
done

${IMPALA_SHELL} -f tpch-create-table/part.sql -d ${KUDU_DB_NAME} --var=KUDU_DB_NAME=${KUDU_DB_NAME}
for i in {0..1}
do
    load_table part /user/root/tpch/${SCALE}/part/data-m-0${i}*
done

${IMPALA_SHELL} -f tpch-create-table/partsupp.sql -d ${KUDU_DB_NAME} --var=KUDU_DB_NAME=${KUDU_DB_NAME}
for i in {00..19}
do
    load_table partsupp /user/root/tpch/${SCALE}/partsupp/data-m-0${i}*
done

${IMPALA_SHELL} -f tpch-create-table/orders.sql -d ${KUDU_DB_NAME} --var=KUDU_DB_NAME=${KUDU_DB_NAME}
for i in {00..19}
do
    load_table orders /user/root/tpch/${SCALE}/orders/data-m-0${i}*
done

${IMPALA_SHELL} -f tpch-create-table/lineitem.sql -d ${KUDU_DB_NAME} --var=KUDU_DB_NAME=${KUDU_DB_NAME}
for i in {000..199}
do
    load_table lineitem /user/root/tpch/${SCALE}/lineitem/data-m-0${i}*
done
