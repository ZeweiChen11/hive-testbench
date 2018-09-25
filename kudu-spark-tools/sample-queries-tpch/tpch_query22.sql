drop view if exists q22_customer_tmp_cached;
drop view if exists q22_customer_tmp1_cached;
drop view if exists q22_orders_tmp_cached;

create view if not exists q22_customer_tmp_cached as
select
	customer._c5,
	customer._c0,
	substr(customer._c4, 1, 2) as cntrycode
from
	customer
where
	substr(customer._c4, 1, 2) = '13' or
	substr(customer._c4, 1, 2) = '31' or
	substr(customer._c4, 1, 2) = '23' or
	substr(customer._c4, 1, 2) = '29' or
	substr(customer._c4, 1, 2) = '30' or
	substr(customer._c4, 1, 2) = '18' or
	substr(customer._c4, 1, 2) = '17';
 
create view if not exists q22_customer_tmp1_cached as
select
	avg(customer._c5) as avg_acctbal
from
	q22_customer_tmp_cached
where
	customer._c5 > 0.00;

create view if not exists q22_orders_tmp_cached as
select
	orders._c1
from
	orders
group by
	orders._c1;

select
	cntrycode,
	count(1) as numcust,
	sum(customer._c5) as totacctbal
from (
	select
		cntrycode,
		customer._c5,
		avg_acctbal
	from
		q22_customer_tmp1_cached ct1 join (
			select
				cntrycode,
				customer._c5
			from
				q22_orders_tmp_cached ot
				right outer join q22_customer_tmp_cached ct
				on ct._c0 = ot._c1
			where
				orders._c1 is null
		) ct2
) a
where
	customer._c5 > avg_acctbal
group by
	cntrycode
order by
	cntrycode;

