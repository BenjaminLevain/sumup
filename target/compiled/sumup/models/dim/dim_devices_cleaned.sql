
WITH  __dbt__cte__src_devices as (
WITH raw_devices AS (
SELECT *  FROM SUMUP.DEV.RAW_DEVICES
)
SELECT 
    *  
FROM
    raw_devices
),src_devices AS (
  SELECT
    *
  FROM
    __dbt__cte__src_devices
)
SELECT
  id as device_id,
  type as device_type,
  store_id
FROM
  src_devices