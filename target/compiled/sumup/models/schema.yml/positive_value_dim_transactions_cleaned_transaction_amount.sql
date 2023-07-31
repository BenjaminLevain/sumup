
SELECT
    *
FROM
    sumup.DEV.dim_transactions_cleaned
WHERE
    transaction_amount < 1
