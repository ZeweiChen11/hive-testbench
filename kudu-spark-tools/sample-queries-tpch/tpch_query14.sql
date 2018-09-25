select
	100.00 * sum(case
		when part._c4 like 'PROMO%'
			then lineitem._c5 * (1 - lineitem._c6)
		else 0
	end) / sum(lineitem._c5 * (1 - lineitem._c6)) as promo_revenue
from
	lineitem,
	part
where
	lineitem._c1 = part._c0
	and lineitem._c10 >= '1995-08-01'
	and lineitem._c10 < '1995-09-01';

