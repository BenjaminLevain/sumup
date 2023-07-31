select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with all_values as (

    select
        transaction_status as value_field,
        count(*) as n_records

    from sumup.DEV.dim_transactions_cleaned
    group by transaction_status

)

select *
from all_values
where value_field not in (
    'cancelled','refused','accepted'
)



      
    ) dbt_internal_test