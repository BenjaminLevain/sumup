select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select transaction_id
from sumup.DEV.dim_transactions_with_stores_devices
where transaction_id is null



      
    ) dbt_internal_test