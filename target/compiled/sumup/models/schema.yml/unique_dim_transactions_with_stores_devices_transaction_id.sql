
    
    

select
    transaction_id as unique_field,
    count(*) as n_records

from sumup.DEV.dim_transactions_with_stores_devices
where transaction_id is not null
group by transaction_id
having count(*) > 1


