select
	o_year,
	sum(case
		when nation = 'PERU' then volume
		else 0
	end) / sum(volume) as mkt_share
from
	(
		select
			year(orders._c4) as o_year,
			lineitem._c5 * (1 - lineitem._c6) as volume,
			n2._c1 as nation
		from
			part,
			supplier,
			lineitem,
			orders,
			customer,
			nation n1,
			nation n2,
			region
		where
			part._c0 = lineitem._c1
			and supplier._c0 = lineitem._c2
			and lineitem._c0 = orders._c0
			and orders._c1 = customer._c0
			and customer._c3 = n1._c0
			and n1._c2 = region._c0
			and region._c1 = 'AMERICA'
			and supplier._c3 = n2._c0
			and orders._c4 between '1995-01-01' and '1996-12-31'
			and part._c4 = 'ECONOMY BURNISHED NICKEL'
	) as all_nations
group by
	o_year
order by
	o_year;

