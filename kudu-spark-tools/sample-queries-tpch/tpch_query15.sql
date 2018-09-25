drop view if exists revenue_cached;
drop view if exists max_revenue_cached;

create view revenue_cached as
select
	lineitem._c2 as supplier_no,
	sum(lineitem._c5 * (1 - lineitem._c6)) as total_revenue
from
	lineitem
where
	lineitem._c10 >= '1996-01-01'
	and lineitem._c10 < '1996-04-01'
group by lineitem._c2;

create view max_revenue_cached as
select
	max(total_revenue) as max_revenue
from
	revenue_cached;

select
	supplier._c0,
	supplier._c1,
	supplier._c2,
	supplier._c4,
	total_revenue
from
	supplier,
	revenue_cached,
	max_revenue_cached
where
	supplier._c0 = supplier_no
	and total_revenue = max_revenue 
order by supplier._c0;

