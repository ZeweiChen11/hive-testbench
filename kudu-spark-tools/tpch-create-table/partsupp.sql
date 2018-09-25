drop table if exists ${var:KUDU_DB_NAME}.partsupp;
CREATE TABLE ${var:KUDU_DB_NAME}.partsupp (_c0 BIGINT,
 _c1 BIGINT,
 _c2 INT,
 _c3 DOUBLE,
 _c4 STRING,
 _c5 STRING,
 PRIMARY KEY (_c0, _c1)
)PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1');
