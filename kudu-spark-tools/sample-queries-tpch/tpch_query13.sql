select
	c_count,
	count(*) as custdist
from
	(
		select
			customer._c0,
			count(orders._c0) as c_count
		from
			customer left outer join orders on
				customer._c0 = orders._c1
				and orders._c8 not like '%unusual%accounts%'
		group by
			customer._c0
	) c_orders
group by
	c_count
order by
	custdist desc,
	c_count desc;

