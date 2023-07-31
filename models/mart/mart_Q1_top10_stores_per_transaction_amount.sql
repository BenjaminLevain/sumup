{{ config(
  materialized = 'table',
) }}

WITH transaction_enriched AS (
    SELECT * FROM {{ ref('dim_transactions_with_stores_devices') }}
)

SELECT
store_id,
store_name,
sum(transaction_amount) as total_amount
FROM transaction_enriched
GROUP BY 1,2
ORDER BY total_amount desc
LIMIT 10