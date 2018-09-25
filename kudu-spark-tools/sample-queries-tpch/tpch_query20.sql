-- explain formatted 
with tmp1 as (
    select part._c0 from part where part._c1 like 'forest%'
),
tmp2 as (
    select supplier._c1, supplier._c2, supplier._c0
    from supplier, nation
    where supplier._c3 = nation._c0
    and nation._c1 = 'CANADA'
),
tmp3 as (
    select lineitem._c1, 0.5 * sum(lineitem._c4) as sum_quantity, lineitem._c2
    from lineitem, tmp2
    where lineitem._c10 >= '1994-01-01' and lineitem._c10 <= '1995-01-01'
    and lineitem._c2 = supplier._c0 
    group by lineitem._c1, lineitem._c2
),
tmp4 as (
    select partsupp._c0, partsupp._c1, partsupp._c2
    from partsupp 
    where partsupp._c0 IN (select part._c0 from tmp1)
),
tmp5 as (
select
    partsupp._c1
from
    tmp4, tmp3
where
    partsupp._c0 = lineitem._c1
    and partsupp._c1 = lineitem._c2
    and partsupp._c2 > sum_quantity
)
select
    supplier._c1,
    supplier._c2
from
    supplier
where
    supplier._c0 IN (select partsupp._c1 from tmp5)
order by supplier._c1;

