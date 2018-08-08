drop table if exists ${var:DB}.region;
create external table ${var:DB}.region (r_regionkey BIGINT,
 r_name STRING,
 r_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT}
LOCATION '${var:LOCATION}/region';

drop table if exists ${var:KUDU_DB_NAME}.region;
CREATE TABLE ${var:KUDU_DB_NAME}.region
PRIMARY KEY (r_regionkey)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1')
AS SELECT * FROM ${var:DB}.region;
