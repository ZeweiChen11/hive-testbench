select
	lineitem._c0,
	sum(lineitem._c5 * (1 - lineitem._c6)) as revenue,
	orders._c4,
	orders._c7
from
	customer,
	orders,
	lineitem
where
	customer._c6 = 'BUILDING'
	and customer._c0 = orders._c1
	and lineitem._c0 = orders._c0
	and orders._c4 < '1995-03-22'
	and lineitem._c10 > '1995-03-22'
group by
	lineitem._c0,
	orders._c4,
	orders._c7
order by
	revenue desc,
	orders._c4
limit 10;

