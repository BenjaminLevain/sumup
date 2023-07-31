
WITH  __dbt__cte__src_stores as (
WITH raw_stores AS (
SELECT *  FROM SUMUP.DEV.RAW_STORES
)
SELECT 
*
FROM
    raw_stores
),src_stores AS (
  SELECT
    *
  FROM
    __dbt__cte__src_stores
)
SELECT
  id as store_id,
  name as store_name,
  address as store_address,
  city as store_city,
  country as store_country,
  CAST(created_at as datetime) as store_creation_datetime,
  typology as store_typology,
  customer_id 
  
FROM
  src_stores