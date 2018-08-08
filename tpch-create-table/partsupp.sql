drop table if exists ${var:DB}.partsupp;
create external table ${var:DB}.partsupp (ps_partkey BIGINT,
 ps_suppkey BIGINT,
 ps_availqty INT,
 ps_supplycost DOUBLE,
 ps_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT}
LOCATION'${var:LOCATION}/partsupp';

drop table if exists ${var:KUDU_DB_NAME}.partsupp;
CREATE TABLE ${var:KUDU_DB_NAME}.partsupp
PRIMARY KEY (ps_partkey, ps_suppkey)
--PARTITION BY HASH(PS_PARTKEY, PS_SUPPKEY) PARTITIONS 16
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1')
AS SELECT * FROM ${var:DB}.partsupp;
