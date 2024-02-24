-- Q1

create table public.users_distinct (
    id uuid not null,
    created_at timestamp without time zone not null default now(),
    updated_at timestamp without time zone,
    created_by uuid,
    last_modified_by uuid,
    constraint pk_user_distinct primary key (id)
);

insert into public.users_distinct
(id, created_at, updated_at, created_by, last_modified_by)
select distinct on (user_id) user_id, created_at, 
    case updated_at when 'null' then null else to_timestamp(updated_at, 'yyyy-mm-dd hh24:mi:ss') end as updated_at,
    created_by, 
    case last_modified_by when 'null' then null else uuid(last_modified_by) end as last_modified_by
from public.user_datastore_value
where value in ('24-31-315: 5 Years', '24-31-315: 6 Months')
;

-- Q2
/*
Notes:
user_organization_unit table is a linkage table that link between user table and organization_unit table. 
user_id should be the foreign key to the id in user table and organizational_unit_id should be the foreign key to the id in organizational_unit table. 
*/
with ou_cp as (
    select distinct on (uou.user_id)
        uou.user_id,
        ou.name as organizational_unit_name
    from user_organizational_unit uou 
    join organizational_unit ou on ou.id = uou.organizational_unit_id
    join tenant t on t.id = ou.tenant_id
    where t.name = 'Colorado Post'
)
select organizational_unit_name, count(*) as cnt
from ou_cp
group by organizational_unit_name
order by cnt desc;

-- Q3
with ou_cp as (
    select distinct on (uou.user_id)
        uou.user_id,
        ou.name as organizational_unit_name
    from user_organizational_unit uou 
    join organizational_unit ou on ou.id = uou.organizational_unit_id
    join tenant t on t.id = ou.tenant_id
    where t.name = 'Colorado Post'
),
ou_count as (
    select organizational_unit_name, count(*) as cnt
    from ou_cp
    group by organizational_unit_name
    order by cnt desc
)
select *
from ou_count
where cnt between 100 and 135
;

-- Q4
WITH ou_cp AS (
    SELECT DISTINCT ON (uou.user_id)
        uou.user_id,
        ou.name as organization_unit_name
    FROM user_organizational_unit uou 
    JOIN organizational_unit ou ON ou.id = uou.organizational_unit_id
    JOIN tenant t ON t.id = ou.tenant_id
    WHERE t.name = 'Colorado Post'
),
ou_count AS (
    SELECT organization_unit_name, COUNT(*) AS cnt
    FROM ou_cp
    GROUP BY organization_unit_name
),
max_count AS (
    SELECT MAX(cnt) AS max_cnt
    FROM ou_count
)
SELECT
    ou_count.*,
    RANK() OVER (ORDER BY ou_count.cnt DESC) AS current_rank,
    max_count.max_cnt - ou_count.cnt AS difference
FROM
    ou_count
CROSS JOIN
    max_count;

-- 05
WITH ou_cp AS (
    SELECT DISTINCT ON (uou.user_id)
        uou.user_id,
        ou.name as organizational_unit_name
    FROM user_organizational_unit uou 
    JOIN organizational_unit ou ON ou.id = uou.organizational_unit_id
    JOIN tenant t ON t.id = ou.tenant_id
    WHERE t.name = 'Colorado Post'
),
ou_count AS (
    SELECT organizational_unit_name, COUNT(*) AS cnt
    FROM ou_cp
    GROUP BY organizational_unit_name
),
max_count AS (
    SELECT MAX(cnt) AS max_cnt
    FROM ou_count
),
rank_diff AS (
    SELECT
        ou_count.*,
        RANK() OVER (ORDER BY ou_count.cnt DESC) AS current_rank,
        max_count.max_cnt - ou_count.cnt AS difference
    FROM
        ou_count
    CROSS JOIN
        max_count
)
SELECT *, 
    CASE WHEN difference < 15 THEN 'smooth'
    ELSE 'jump_ahead' END AS jump_type
FROM rank_diff
;