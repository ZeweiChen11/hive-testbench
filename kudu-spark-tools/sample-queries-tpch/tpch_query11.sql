drop view if exists q11_part_tmp_cached;
drop view if exists q11_sum_tmp_cached;

create view q11_part_tmp_cached as
select
	partsupp._c0 as part_key,
	sum(partsupp._c3 * partsupp._c2) as part_value
from
	partsupp,
	supplier,
	nation
where
	partsupp._c1 = supplier._c0
	and supplier._c3 = nation._c0
	and nation._c1 = 'GERMANY'
group by partsupp._c0;

create view q11_sum_tmp_cached as
select
	sum(part_value) as total_value
from
	q11_part_tmp_cached;

select
	part_key as key, part_value as value
from (
	select
		part_key,
		part_value,
		total_value
	from
		q11_part_tmp_cached join q11_sum_tmp_cached
) a
where
	part_value > total_value * 0.0001
order by
	value desc;

