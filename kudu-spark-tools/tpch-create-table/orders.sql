drop table if exists ${var:KUDU_DB_NAME}.orders;
CREATE TABLE ${var:KUDU_DB_NAME}.orders (_c0 BIGINT,
 _c1 BIGINT,
 _c2 STRING,
 _c3 DOUBLE,
 _c4 STRING,
 _c5 STRING,
 _c6 STRING,
 _c7 INT,
 _c8 STRING,
 _c9 STRING,
 PRIMARY KEY (_c0)
) PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1');
