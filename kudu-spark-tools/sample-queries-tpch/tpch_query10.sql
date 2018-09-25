select
	customer._c0,
	customer._c1,
	sum(lineitem._c5 * (1 - lineitem._c6)) as revenue,
	customer._c5,
	nation._c1,
	customer._c2,
	customer._c4,
	customer._c7
from
	customer,
	orders,
	lineitem,
	nation
where
	customer._c0 = orders._c1
	and lineitem._c0 = orders._c0
	and orders._c4 >= '1993-07-01'
	and orders._c4 < '1993-10-01'
	and lineitem._c8 = 'R'
	and customer._c3 = nation._c0
group by
	customer._c0,
	customer._c1,
	customer._c5,
	customer._c4,
	nation._c1,
	customer._c2,
	customer._c7
order by
	revenue desc
limit 20;

