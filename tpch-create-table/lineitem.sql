drop table if exists ${var:DB}.lineitem;
create external table ${var:DB}.lineitem 
(L_ORDERKEY BIGINT,
 L_PARTKEY BIGINT,
 L_SUPPKEY BIGINT,
 L_LINENUMBER INT,
 L_QUANTITY DOUBLE,
 L_EXTENDEDPRICE DOUBLE,
 L_DISCOUNT DOUBLE,
 L_TAX DOUBLE,
 L_RETURNFLAG STRING,
 L_LINESTATUS STRING,
 L_SHIPDATE STRING,
 L_COMMITDATE STRING,
 L_RECEIPTDATE STRING,
 L_SHIPINSTRUCT STRING,
 L_SHIPMODE STRING,
 L_COMMENT STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS ${var:FILE_FORMAT} 
--STORED AS ${var:FILE_FORMAT} 
LOCATION '${var:LOCATION}/lineitem';

drop table if exists ${var:KUDU_DB_NAME}.lineitem;
CREATE TABLE ${var:KUDU_DB_NAME}.lineitem
PRIMARY KEY (L_ORDERKEY, L_PARTKEY)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU
AS SELECT * FROM ${var:DB}.lineitem; 