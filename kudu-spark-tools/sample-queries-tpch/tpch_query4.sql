select
	orders._c5,
	count(*) as order_count
from
	orders
where
	orders._c4 >= '1996-05-01'
	and orders._c4 < '1996-08-01'
	and exists (
		select
			*
		from
			lineitem
		where
			lineitem._c0 = orders._c0
			and lineitem._c11 < lineitem._c12
	)
group by
	orders._c5
order by
	orders._c5;

