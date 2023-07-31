
  create or replace   view AIRBNB.dev.src_hosts
  
   as (
    WITH raw_hosts AS (
SELECT * FROM AIRBNB.RAW.RAW_HOSTS
)
SELECT 
    id as host_id,
    name as host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    raw_hosts
  );

