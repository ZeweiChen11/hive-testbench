drop table if exists ${var:KUDU_DB_NAME}.region;
CREATE TABLE ${var:KUDU_DB_NAME}.region (_c0 BIGINT,
 _c1 STRING,
 _c2 STRING,
 _c3 STRING,
 PRIMARY KEY (_c0)
) PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1');
