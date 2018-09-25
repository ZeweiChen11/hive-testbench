select
	sum(lineitem._c5 * lineitem._c6) as revenue
from
	lineitem
where
	lineitem._c10 >= '1993-01-01'
	and lineitem._c10 < '1994-01-01'
	and lineitem._c6 between 0.06 - 0.01 and 0.06 + 0.01
	and lineitem._c4 < 25;

