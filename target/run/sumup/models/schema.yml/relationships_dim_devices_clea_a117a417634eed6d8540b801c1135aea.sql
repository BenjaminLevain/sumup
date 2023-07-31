select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with child as (
    select store_id as from_field
    from sumup.DEV.dim_devices_cleaned
    where store_id is not null
),

parent as (
    select store_id as to_field
    from sumup.DEV.dim_stores_cleaned
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



      
    ) dbt_internal_test