drop table if exists ${var:DB}.part;
create external table ${var:DB}.part (p_partkey BIGINT,
 p_name STRING,
 p_mfgr STRING,
 p_brand STRING,
 p_type STRING,
 p_size INT,
 p_container STRING,
 p_retailprice DOUBLE,
 p_comment STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT} 
LOCATION '${var:LOCATION}/part/';

drop table if exists ${var:KUDU_DB_NAME}.part;
CREATE TABLE ${var:KUDU_DB_NAME}.part
PRIMARY KEY (p_partkey)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1')
AS SELECT * FROM ${var:DB}.part;
