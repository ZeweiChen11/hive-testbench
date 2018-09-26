drop view if exists q18_tmp_cached;
drop table if exists q18_large_volume_customer_cached;

create view q18_tmp_cached as
select
	lineitem._c0,
	sum(lineitem._c4) as t_sum_quantity
from
	lineitem
where
	lineitem._c0 is not null
group by
	lineitem._c0;

create table q18_large_volume_customer_cached as
select
	customer._c1 as c_name,
	customer._c0 as c_custkey,
	orders._c0 as o_orderkey,
	orders._c4 as o_orderdate,
	orders._c3 as o_totalprice,
	sum(l._c4)
from
	customer,
	orders,
	q18_tmp_cached t,
	lineitem l
where
	customer._c0 = orders._c1
	and orders._c0 = t._c0
	and orders._c0 is not null
	and t.t_sum_quantity > 300
	and orders._c0 = l._c0
	and l._c0 is not null
group by
	customer._c1,
	customer._c0,
	orders._c0,
	orders._c4,
	orders._c3
order by
	orders._c3 desc,
	orders._c4 
limit 100;

