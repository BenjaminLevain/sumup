

WITH transaction_enriched AS (
    SELECT * FROM sumup.DEV.dim_transactions_with_stores_devices
)

SELECT
store_country,
store_typology,
avg(transaction_amount) as avg_amount,
count(distinct transaction_id) as nb_distinct_transactions
FROM transaction_enriched
WHERE transaction_status = 'accepted'
GROUP BY 1,2
ORDER BY avg_amount desc