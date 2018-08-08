drop table if exists ${var:DB}.customer;
create external table ${var:DB}.customer (c_custkey BIGINT,
 c_name STRING,
 c_address STRING,
 c_nationkey BIGINT,
 c_phone STRING,
 c_acctbal DOUBLE,
 c_mktsegment STRING,
 c_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT}
LOCATION '${var:LOCATION}/customer';

drop table if exists ${var:KUDU_DB_NAME}.customer;
CREATE TABLE ${var:KUDU_DB_NAME}.customer
PRIMARY KEY (c_custkey)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1')
AS SELECT * FROM ${var:DB}.customer;
