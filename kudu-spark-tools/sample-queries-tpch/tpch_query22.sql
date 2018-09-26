drop view if exists q22_customer_tmp_cached;
drop view if exists q22_customer_tmp1_cached;
drop view if exists q22_orders_tmp_cached;

create view if not exists q22_customer_tmp_cached as
select
        customer._c5 as c_acctbal,
        customer._c0 as c_custkey,
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
        avg(c_acctbal) as avg_acctbal
from
        q22_customer_tmp_cached
where
        c_acctbal > 0.00;

create view if not exists q22_orders_tmp_cached as
select
        orders._c1 as o_custkey
from
        orders
group by
        o_custkey;

select
        cntrycode,
        count(1) as numcust,
        sum(c_acctbal) as totacctbal
from (
        select
                cntrycode,
                c_acctbal,
                avg_acctbal
        from
                q22_customer_tmp1_cached ct1 join (
                        select
                                cntrycode,
                                c_acctbal
                        from
                                q22_orders_tmp_cached ot
                                right outer join q22_customer_tmp_cached ct
                                on ct.c_custkey = ot.o_custkey
                        where
                                o_custkey is null
                ) ct2
) a
where
        c_acctbal > avg_acctbal
group by
        cntrycode
order by
        cntrycode;

