-- Q1

CREATE TABLE public.users_distinct (
    id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    created_by uuid,
    last_modified_by uuid,
    CONSTRAINT pk_user PRIMARY KEY (id)
);

INSERT INTO public.users_distinct
(id, created_at, updated_at, created_by, last_modified_by)
SELECT user_id, created_at, updated_at, created_by, last_modified_by
FROM public.user_datastore_value
WHERE value in ('24-31-315: 5 Years', '24-31-315: 6 Months')
;

-- Q2
with cte as (
    select distinct on (uou.user_id)
        uou.user_id,
        ou.display_name
    from user_organizational_unit uou 
    join organizational_unit ou on ou.id = uou.organizational_unit_id
    join tenant t on t.id = ou.tenant_id
    where t.name = 'Colorado Post'
)
select display_name, count(*) as cnt
from cte
group by display_name
order by cnt desc;

-- Q3
with ou_cp as (
    select distinct on (uou.user_id)
        uou.user_id,
        ou.display_name
    from user_organizational_unit uou 
    join organizational_unit ou on ou.id = uou.organizational_unit_id
    join tenant t on t.id = ou.tenant_id
    where t.name = 'Colorado Post'
),
ou_count as (
    select display_name, count(*) as cnt
    from ou_cp
    group by display_name
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
        ou.display_name
    FROM user_organizational_unit uou 
    JOIN organizational_unit ou ON ou.id = uou.organizational_unit_id
    JOIN tenant t ON t.id = ou.tenant_id
    WHERE t.name = 'Colorado Post'
),
ou_count AS (
    SELECT display_name, COUNT(*) AS cnt
    FROM ou_cp
    GROUP BY display_name
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
        ou.display_name
    FROM user_organizational_unit uou 
    JOIN organizational_unit ou ON ou.id = uou.organizational_unit_id
    JOIN tenant t ON t.id = ou.tenant_id
    WHERE t.name = 'Colorado Post'
),
ou_count AS (
    SELECT display_name, COUNT(*) AS cnt
    FROM ou_cp
    GROUP BY display_name
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