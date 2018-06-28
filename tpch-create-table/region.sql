drop table if exists ${var:DB}.region;
create external table ${var:DB}.region (R_REGIONKEY BIGINT,
 R_NAME STRING,
 R_COMMENT STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT}
LOCATION '${var:LOCATION}/region';

drop table if exists ${var:KUDU_DB_NAME}.region;
CREATE TABLE ${var:KUDU_DB_NAME}.region
PRIMARY KEY (R_REGIONKEY)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
AS SELECT * FROM ${var:DB}.region;
