drop table if exists ${var:KUDU_DB_NAME}.lineitem;
CREATE TABLE ${var:KUDU_DB_NAME}.lineitem (_c0 BIGINT,
 _c1 BIGINT,
 _c2 BIGINT,
 _c3 INT,
 _c4 DOUBLE,
 _c5 DOUBLE,
 _c6 DOUBLE,
 _c7 DOUBLE,
 _c8 STRING,
 _c9 STRING,
 _c10 STRING,
 _c11 STRING,
 _c12 STRING,
 _c13 STRING,
 _c14 STRING,
 _c15 STRING,
 _c16 STRING,
 PRIMARY KEY (_c0, _c1)
) PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1');
