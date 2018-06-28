drop table if exists ${var:DB}.nation;
create external table ${var:DB}.nation (N_NATIONKEY BIGINT,
 N_NAME STRING,
 N_REGIONKEY BIGINT,
 N_COMMENT STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT}
LOCATION '${var:LOCATION}/nation';

drop table if exists ${var:KUDU_DB_NAME}.nation;
CREATE TABLE ${var:KUDU_DB_NAME}.nation
PRIMARY KEY (N_NATIONKEY)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
AS SELECT * FROM ${var:DB}.nation;