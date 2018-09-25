drop view if exists q2_min_ps_supplycost;
create view q2_min_ps_supplycost as
select
	part._c0 as min_p_partkey,
	min(partsupp._c3) as min_ps_supplycost
from
	part,
	partsupp,
	supplier,
	nation,
	region
where
	part._c0 = partsupp._c0
	and supplier._c0 = partsupp._c1
	and supplier._c3 = nation._c0
	and nation._c2 = region._c0
	and region._c1 = 'EUROPE'
group by
	part._c0;

select
	supplier._c5,
	supplier._c1,
	nation._c1,
	part._c0,
	part._c2,
	supplier._c2,
	supplier._c4,
	supplier._c6
from
	part,
	supplier,
	partsupp,
	nation,
	region,
	q2_min_ps_supplycost
where
	part._c0 = partsupp._c0
	and supplier._c0 = partsupp._c1
	and part._c5 = 37
	and part._c4 like '%COPPER'
	and supplier._c3 = nation._c0
	and nation._c2 = region._c0
	and region._c1 = 'EUROPE'
	and partsupp._c3 = min_ps_supplycost
	and part._c0 = min_p_partkey
order by
	supplier._c5 desc,
	nation._c1,
	supplier._c1,
	part._c0
limit 100;

