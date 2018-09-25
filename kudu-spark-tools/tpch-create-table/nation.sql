drop table if exists ${var:KUDU_DB_NAME}.nation;
create table ${var:kUDU_DB_NAME}.nation (_c0 BIGINT,
 _c1 STRING,
 _c2 BIGINT,
 _c3 STRING,
 _c4 STRING,
 PRIMARY KEY (_c0)
) PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1');
