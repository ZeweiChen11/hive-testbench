drop table if exists ${var:DB}.orders;
create external table ${var:DB}.orders (o_orderkey BIGINT,
 o_custkey BIGINT,
 o_orderstatus STRING,
 o_totalprice DOUBLE,
 o_orderdate STRING,
 o_orderpriority STRING,
 o_clerk STRING,
 o_shippriority INT,
 o_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT}
LOCATION '${var:LOCATION}/orders';

drop table if exists ${var:KUDU_DB_NAME}.orders;
CREATE TABLE ${var:KUDU_DB_NAME}.orders
PRIMARY KEY (o_orderkey)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1')
AS SELECT * FROM ${var:DB}.orders;
