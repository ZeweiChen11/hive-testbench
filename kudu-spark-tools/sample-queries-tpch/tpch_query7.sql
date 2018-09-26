select
	supp_nation,
	cust_nation,
	l_year,
	sum(volume) as revenue
from
	(
		select
			n1._c1 as supp_nation,
			n2._c1 as cust_nation,
			year(lineitem._c10) as l_year,
			lineitem._c5 * (1 - lineitem._c6) as volume
		from
			supplier,
			lineitem,
			orders,
			customer,
			nation n1,
			nation n2
		where
			supplier._c0 = lineitem._c2
			and orders._c0 = lineitem._c0
			and customer._c0 = orders._c1
			and supplier._c3 = n1._c0
			and customer._c3 = n2._c0
			and (
				(n1._c1 = 'KENYA' and n2._c1 = 'PERU')
				or (n1._c1 = 'PERU' and n2._c1 = 'KENYA')
			)
			and lineitem._c10 between '1995-01-01' and '1996-12-31'
	) as shipping
group by
	supp_nation,
	cust_nation,
	l_year
order by
	supp_nation,
	cust_nation,
	l_year;

