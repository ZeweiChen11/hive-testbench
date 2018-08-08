drop table if exists ${var:DB}.supplier;
create external table ${var:DB}.supplier (s_suppkey BIGINT,
 s_name STRING,
 s_address STRING,
 s_nationkey BIGINT,
 s_phone STRING,
 s_acctbal DOUBLE,
 s_comment STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT} 
LOCATION '${var:LOCATION}/supplier/';

drop table if exists ${var:KUDU_DB_NAME}.supplier;
CREATE TABLE ${var:KUDU_DB_NAME}.supplier
PRIMARY KEY (s_suppkey)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1')
AS SELECT * FROM ${var:DB}.supplier;
