with q17_part as (
  select part._c0 as p_partkey from part where  
  part._c3 = 'Brand#23'
  and part._c6 = 'MED BOX'
),
q17_avg as (
  select lineitem._c1 as t_partkey, 0.2 * avg(lineitem._c4) as t_avg_quantity
  from lineitem 
  where lineitem._c1 IN (select p_partkey from q17_part)
  group by lineitem._c1
),
q17_price as (
  select
  lineitem._c4 as l_quantity,
  lineitem._c1 as l_partkey,
  lineitem._c5 as l_extendedprice
  from
  lineitem
  where
  lineitem._c1 IN (select p_partkey from q17_part)
)
select cast(sum(l_extendedprice) / 7.0 as decimal(32,2)) as avg_yearly
from q17_avg, q17_price
where 
t_partkey = l_partkey and l_quantity < t_avg_quantity;

