with q17_part as (
  select part._c0 from part where  
  part._c3 = 'Brand#23'
  and part._c6 = 'MED BOX'
),
q17_avg as (
  select lineitem._c1 as t_partkey, 0.2 * avg(lineitem._c4) as t_avg_quantity
  from lineitem 
  where lineitem._c1 IN (select part._c0 from q17_part)
  group by lineitem._c1
),
q17_price as (
  select
  lineitem._c4,
  lineitem._c1,
  lineitem._c5
  from
  lineitem
  where
  lineitem._c1 IN (select part._c0 from q17_part)
)
select cast(sum(lineitem._c5) / 7.0 as decimal(32,2)) as avg_yearly
from q17_avg, q17_price
where 
t_partkey = lineitem._c1 and lineitem._c4 < t_avg_quantity;

