
WITH  __dbt__cte__src_transactions as (
WITH raw_transactions AS (
SELECT *  FROM SUMUP.DEV.RAW_TRANSACTIONS
)
SELECT 
*
FROM
    raw_transactions
),src_transactions AS (
  SELECT
    *
  FROM
    __dbt__cte__src_transactions
)
SELECT
  id as transaction_id,
  device_id,
  product_name,
  product_sku,
  category_name as product_category_name,
  CAST(amount as integer) as transaction_amount,
  status as transaction_status,
  card_number as transaction_card_number,
  CAST(created_at as date) as transaction_creation_date,
  CAST(created_at as datetime) as transaction_creation_datetime,
  CAST(happened_at as date) as transaction_happened_date,
  CAST(happened_at as datetime) as transaction_happened_datetime
FROM
  src_transactions