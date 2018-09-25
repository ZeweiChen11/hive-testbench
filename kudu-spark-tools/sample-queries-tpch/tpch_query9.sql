select
	nation,
	o_year,
	sum(amount) as sum_profit
from
	(
		select
			nation._c1 as nation,
			year(orders._c4) as o_year,
			lineitem._c5 * (1 - lineitem._c6) - partsupp._c3 * lineitem._c4 as amount
		from
			part,
			supplier,
			lineitem,
			partsupp,
			orders,
			nation
		where
			supplier._c0 = lineitem._c2
			and partsupp._c1 = lineitem._c2
			and partsupp._c0 = lineitem._c1
			and part._c0 = lineitem._c1
			and orders._c0 = lineitem._c0
			and supplier._c3 = nation._c0
			and part._c1 like '%plum%'
	) as profit
group by
	nation,
	o_year
order by
	nation,
	o_year desc;

