drop table if exists ${var:DB}.part;
create external table ${var:DB}.part (P_PARTKEY BIGINT,
 P_NAME STRING,
 P_MFGR STRING,
 P_BRAND STRING,
 P_TYPE STRING,
 P_SIZE INT,
 P_CONTAINER STRING,
 P_RETAILPRICE DOUBLE,
 P_COMMENT STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT} 
LOCATION '${var:LOCATION}/part/';

drop table if exists ${var:KUDU_DB_NAME}.part;
CREATE TABLE ${var:KUDU_DB_NAME}.part
PRIMARY KEY (P_PARTKEY)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
AS SELECT * FROM ${var:DB}.part;
