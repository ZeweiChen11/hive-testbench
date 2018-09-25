select
	nation._c1,
	sum(lineitem._c5 * (1 - lineitem._c6)) as revenue
from
	customer,
	orders,
	lineitem,
	supplier,
	nation,
	region
where
	customer._c0 = orders._c1
	and lineitem._c0 = orders._c0
	and lineitem._c2 = supplier._c0
	and customer._c3 = supplier._c3
	and supplier._c3 = nation._c0
	and nation._c2 = region._c0
	and region._c1 = 'AFRICA'
	and orders._c4 >= '1993-01-01'
	and orders._c4 < '1994-01-01'
group by
	nation._c1
order by
	revenue desc;

