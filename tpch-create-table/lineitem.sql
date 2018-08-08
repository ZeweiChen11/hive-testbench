drop table if exists ${var:DB}.lineitem;
create external table ${var:DB}.lineitem 
(l_orderkey BIGINT,
 l_partkey BIGINT,
 l_suppkey BIGINT,
 l_linenumber INT,
 l_quantity DOUBLE,
 l_extendedprice DOUBLE,
 l_discount DOUBLE,
 l_tax DOUBLE,
 l_returnflag STRING,
 l_linestatus STRING,
 l_shipdate STRING,
 l_commitdate STRING,
 l_receiptdate STRING,
 l_shipinstruct STRING,
 l_shipmode STRING,
 l_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT} 
--STORED AS ${var:FILE_FORMAT} 
LOCATION '${var:LOCATION}/lineitem';

drop table if exists ${var:KUDU_DB_NAME}.lineitem;
CREATE TABLE ${var:KUDU_DB_NAME}.lineitem
PRIMARY KEY (l_orderkey, l_partkey)
PARTITION BY HASH PARTITIONS 64
STORED AS KUDU
TBLPROPERTIES ('kudu.num_tablet_replicas' = '1')
AS SELECT * FROM ${var:DB}.lineitem; 
