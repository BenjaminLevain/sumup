{{
  config(
    materialized = 'view',
    )
}}
WITH src_devices AS (
  SELECT
    *
  FROM
    {{ ref('src_devices') }}
)
SELECT
  id as device_id,
  type as device_type,
  store_id
FROM
  src_devices
