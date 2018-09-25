select
	sum(lineitem._c5* (1 - lineitem._c6)) as revenue
from
	lineitem,
	part
where
	(
		part._c0 = lineitem._c1
		and part._c3 = 'Brand#32'
		and part._c6 in ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
		and lineitem._c4 >= 7 and lineitem._c4 <= 7 + 10
		and part._c5 between 1 and 5
		and lineitem._c14 in ('AIR', 'AIR REG')
		and lineitem._c13 = 'DELIVER IN PERSON'
	)
	or
	(
		part._c0 = lineitem._c1
		and part._c3 = 'Brand#35'
		and part._c6 in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
		and lineitem._c4 >= 15 and lineitem._c4 <= 15 + 10
		and part._c5 between 1 and 10
		and lineitem._c14 in ('AIR', 'AIR REG')
		and lineitem._c13 = 'DELIVER IN PERSON'
	)
	or
	(
		part._c0 = lineitem._c1
		and part._c3 = 'Brand#24'
		and part._c6 in ('LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
		and lineitem._c4 >= 26 and lineitem._c4 <= 26 + 10
		and part._c5 between 1 and 15
		and lineitem._c14 in ('AIR', 'AIR REG')
		and lineitem._c13 = 'DELIVER IN PERSON'
	);

