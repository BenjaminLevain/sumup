select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select store_creation_date
from sumup.DEV.dim_stores_cleaned
where store_creation_date is null



      
    ) dbt_internal_test