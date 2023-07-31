select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
SELECT
    *
FROM
    sumup.DEV.dim_transactions_cleaned
WHERE
    transaction_amount < 1

      
    ) dbt_internal_test