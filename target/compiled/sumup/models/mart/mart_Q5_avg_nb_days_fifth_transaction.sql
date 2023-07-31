

WITH transaction_enriched AS (
    SELECT * FROM sumup.DEV.dim_transactions_with_stores_devices
),
store_cleaned AS (
    SELECT * 
    FROM sumup.DEV.dim_stores_cleaned
)

select
AVG(DATEDIFF(day, first_transaction_date, fifth_transaction_date)) AS avg_days_difference_between_first_fith_transaction
FROM
(select
store_table.store_id, 
first_transaction_date,
fifth_transaction_date
FROM store_cleaned as store_table
LEFT JOIN
(select 
store_id,
MIN(transaction_creation_date) as first_transaction_date
FROM
(select 
store_id,
transaction_creation_date,
RANK() OVER(PARTITION BY store_id Order By transaction_creation_datetime) as rank_transaction  
from transaction_enriched 
where transaction_status = 'accepted'   ) as first_transaction_by_store_table
WHERE rank_transaction = 1
GROUP BY 1) as first_date_transaction_by_store_table
ON store_table.store_id = first_date_transaction_by_store_table.store_id
LEFT JOIN
(select 
store_id,
MIN(transaction_creation_date) as fifth_transaction_date
FROM
(select 
store_id,
transaction_creation_date,
RANK() OVER(PARTITION BY store_id Order By transaction_creation_datetime) as rank_transaction  
from transaction_enriched 
where transaction_status = 'accepted'   ) as fifth_transaction_by_store_table
WHERE rank_transaction = 5
GROUP BY 1) as fifth_date_transaction_by_store_table
ON store_table.store_id = fifth_date_transaction_by_store_table.store_id) as first_and_fith_transaction_date_by_store_table
WHERE first_transaction_date is not null and fifth_transaction_date is not null