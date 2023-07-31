{{ config(
  materialized = 'table',
) }}

WITH transaction_enriched AS (
    SELECT * FROM {{ ref('dim_transactions_with_stores_devices') }}
)

SELECT
product_name,
sum(transaction_amount) as total_amount,
count(distinct transaction_id) as nb_distinct_transactions
FROM transaction_enriched
WHERE transaction_status = 'accepted'
GROUP BY 1
ORDER BY total_amount desc
LIMIT 10