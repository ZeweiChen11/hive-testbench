drop table if exists ${var:KUDU_DB_NAME}.part;
CREATE TABLE ${var:KUDU_DB_NAME}.part (_c0 BIGINT,
 _c1 STRING,
 _c2 STRING,
 _c3 STRING,
 _c4 STRING,
 _c5 INT,
 _c6 STRING,
 _c7 DOUBLE,
 _c8 STRING,
 _c9 STRING,
 PRIMARY KEY (_c0)
) PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1');
