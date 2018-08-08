drop table if exists ${var:DB}.nation;
create external table ${var:DB}.nation (n_nationkey BIGINT,
 n_name STRING,
 n_regionkey BIGINT,
 n_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT}
LOCATION '${var:LOCATION}/nation';

drop table if exists ${var:KUDU_DB_NAME}.nation;
CREATE TABLE ${var:KUDU_DB_NAME}.nation
PRIMARY KEY (n_nationkey)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1')
AS SELECT * FROM ${var:DB}.nation;
