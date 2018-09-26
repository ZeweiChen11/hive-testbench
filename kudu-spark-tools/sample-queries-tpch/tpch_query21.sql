-- explain
--drop table if exists l3;
-- create table l3 stored as PARQUET as 
drop view if exists l3;
create view l3 as 
-- select l_orderkey, count(distinct l_suppkey) as cntSupp
select lineitem._c0, count(distinct lineitem._c2)
from lineitem
where lineitem._c12 > lineitem._c11 and lineitem._c0 is not null
group by lineitem._c0
having count(distinct lineitem._c2) = 1
--having cntSupp = 1
;

with location123 as (
select supplier.*, supplier._c1 as s_name from supplier, nation where
supplier._c3 = nation._c0 and nation._c1 = 'SAUDI ARABIA'
)
select s_name, count(*) as numwait
from
(
select li._c2, li._c0
from lineitem li join orders o on li._c0 = o._c0 and
                      o._c2 = 'F'
     join
     (
     select lineitem._c0, count(distinct lineitem._c2) as cntSupp
     -- select lineitem._c0, count(distinct lineitem._c2)
     from lineitem
     group by lineitem._c0
     ) l2 on li._c0 = l2._c0 and
             li._c12 > li._c11 and
             l2.cntSupp > 1
) l1 join l3 on l1._c0 = l3._c0
 join location123 s on l1._c2 = s._c0
group by
 s_name
order by
 numwait desc,
 s_name
limit 100;
