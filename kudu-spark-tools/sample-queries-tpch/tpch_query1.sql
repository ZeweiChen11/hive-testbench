select
	lineitem._c8,
	lineitem._c9,
	sum(lineitem._c4) as sum_qty,
	sum(lineitem._c5) as sum_base_price,
	sum(lineitem._c5 * (1 - lineitem._c6)) as sum_disc_price,
	sum(lineitem._c5 * (1 - lineitem._c6) * (1 + lineitem._c7)) as sum_charge,
	avg(lineitem._c4) as avg_qty,
	avg(lineitem._c5) as avg_price,
	avg(lineitem._c6) as avg_disc,
	count(*) as count_order
from
	lineitem
where
	lineitem._c10 <= '1998-09-16'
group by
	lineitem._c8,
	lineitem._c9
order by
	lineitem._c8,
	lineitem._c9;

