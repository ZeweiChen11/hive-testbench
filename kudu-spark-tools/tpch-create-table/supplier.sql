drop table if exists ${var:KUDU_DB_NAME}.supplier;
CREATE TABLE ${var:KUDU_DB_NAME}.supplier (_c0 BIGINT,
 _c1 STRING,
 _c2 STRING,
 _c3 BIGINT,
 _c4 STRING,
 _c5 DOUBLE,
 _c6 STRING,
 _c7 STRING,
 PRIMARY KEY (_c0)
) PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1');
