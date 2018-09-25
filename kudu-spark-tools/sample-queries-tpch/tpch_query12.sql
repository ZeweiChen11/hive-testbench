select
	lineitem._c14,
	sum(case
		when orders._c5 = '1-URGENT'
			or orders._c5 = '2-HIGH'
			then 1
		else 0
	end) as high_line_count,
	sum(case
		when orders._c5 <> '1-URGENT'
			and orders._c5 <> '2-HIGH'
			then 1
		else 0
	end) as low_line_count
from
	orders,
	lineitem
where
	orders._c0 = lineitem._c0
	and lineitem._c14 in ('REG AIR', 'MAIL')
	and lineitem._c11 < lineitem._c12
	and lineitem._c10 < lineitem._c11
	and lineitem._c12 >= '1995-01-01'
	and lineitem._c12 < '1996-01-01'
group by
	lineitem._c14
order by
	lineitem._c14;

