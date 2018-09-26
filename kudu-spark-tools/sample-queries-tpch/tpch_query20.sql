-- explain formatted 
with tmp1 as (
    select part._c0 as p_partkey from part where part._c1 like 'forest%'
),
tmp2 as (
    select supplier._c1, supplier._c2, supplier._c0 as s_suppkey
    from supplier, nation
    where supplier._c3 = nation._c0
    and nation._c1 = 'CANADA'
),
tmp3 as (
    select lineitem._c1 as l_partkey, 0.5 * sum(lineitem._c4) as sum_quantity, lineitem._c2 as l_suppkey
    from lineitem, tmp2
    where lineitem._c10 >= '1994-01-01' and lineitem._c10 <= '1995-01-01'
    and lineitem._c2 = s_suppkey 
    group by lineitem._c1, lineitem._c2
),
tmp4 as (
    select partsupp._c0 as ps_partkey, partsupp._c1 as ps_suppkey, partsupp._c2 as ps_availqty
    from partsupp 
    where partsupp._c0 IN (select p_partkey from tmp1)
),
tmp5 as (
select
    ps_suppkey
from
    tmp4, tmp3
where
    ps_partkey = ps_suppkey
    and ps_suppkey = l_suppkey
    and ps_availqty > sum_quantity
)
select
    supplier._c1,
    supplier._c2
from
    supplier
where
    supplier._c0 IN (select ps_suppkey from tmp5)
order by supplier._c1;

