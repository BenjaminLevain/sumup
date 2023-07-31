
  create or replace   view AIRBNB.dev.dim_hosts_cleansed
  
   as (
    
WITH  __dbt__cte__src_hosts as (
WITH raw_hosts AS (
SELECT *  FROM AIRBNB.raw.raw_hosts
)
SELECT 
    id as host_id,
    name as host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    raw_hosts
),src_hosts AS (
  SELECT
    *
  FROM
    __dbt__cte__src_hosts
)
SELECT
  host_id,
  CASE
    WHEN host_name is not null THEN host_name
    ELSE 'Anonymous'
  END AS host_name,
  is_superhost,
  created_at,
  updated_at
FROM
  src_hosts
  );

