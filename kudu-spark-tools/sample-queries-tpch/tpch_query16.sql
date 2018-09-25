select
	part._c3,
	part._c4,
	part._c5,
	count(distinct partsupp._c1) as supplier_cnt
from
	partsupp,
	part
where
	part._c0 = partsupp._c0
	and part._c3 <> 'Brand#34'
	and part._c4 not like 'ECONOMY BRUSHED%'
	and part._c5 in (22, 14, 27, 49, 21, 33, 35, 28)
	and partsupp._c1 not in (
		select
			supplier._c0
		from
			supplier
		where
			supplier._c6 like '%Customer%Complaints%'
	)
group by
	part._c3,
	part._c4,
	part._c5
order by
	supplier_cnt desc,
	part._c3,
	part._c4,
	part._c5;

