WITH
 t AS (
    SELECT
        *
    FROM
        sumup.DEV.dim_transactions_cleaned
),
s AS (
    SELECT * 
    FROM sumup.DEV.dim_stores_cleaned
),

d AS (
    SELECT * 
    FROM sumup.DEV.dim_devices_cleaned
)


SELECT 
    t.transaction_id,
    t.device_id,
    t.product_name,
    t.product_sku,
    t.product_category_name,
    t.transaction_amount,
    t.transaction_status,
    t.transaction_card_number,
    t.transaction_creation_date,
    t.transaction_creation_datetime,
    t.transaction_happened_datetime,
    t.transaction_happened_date,
    d.device_type,
    s.store_id,
    s.store_name,
    s.store_address,
    s.store_city,
    s.store_country,
    DATE(s.store_creation_datetime) as store_creation_date,
    s.store_creation_datetime,
    s.store_typology,
    s.customer_id,
    CASE WHEN s.store_country IN ('Austria', 'Belgium', 'Croatia', 'Cyprus', 'Estonia', 'Finland', 'France', 'Germany',
     'Greece', 'Ireland', 'Italy', 'Latvia', 'Lithuania', 'Luxembourg', 'Malta',  'Netherlands', 'Portugal', 
     'Slovakia', 'Slovenia', 'Spain') THEN True else False end as transaction_made_in_euros
FROM t
LEFT JOIN d ON (t.device_id = d.device_id)
LEFT JOIN s ON (s.store_id = d.store_id)