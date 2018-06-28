drop table if exists ${var:DB}.supplier;
create external table ${var:DB}.supplier (S_SUPPKEY BIGINT,
 S_NAME STRING,
 S_ADDRESS STRING,
 S_NATIONKEY BIGINT,
 S_PHONE STRING,
 S_ACCTBAL DOUBLE,
 S_COMMENT STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT} 
LOCATION '${var:LOCATION}/supplier/';

drop table if exists ${var:KUDU_DB_NAME}.supplier;
CREATE TABLE ${var:KUDU_DB_NAME}.supplier
PRIMARY KEY (S_SUPPKEY)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
AS SELECT * FROM ${var:DB}.supplier;