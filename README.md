Welcome to your new dbt project!

# Environment Setup

## Snowflake user creation
Copy these SQL statements into a Snowflake Worksheet, select all and execute them (i.e. pressing the play button).


```sql
-- Use an admin role
USE ROLE ACCOUNTADMIN;

-- Create the `transform` role
CREATE ROLE IF NOT EXISTS transform;
GRANT ROLE TRANSFORM TO ROLE ACCOUNTADMIN;

-- Create the default warehouse if necessary
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH;
GRANT OPERATE ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;

-- Create the `dbt` user and assign to role
CREATE USER IF NOT EXISTS dbt
  PASSWORD='dbtPassword123'
  LOGIN_NAME='dbt'
  MUST_CHANGE_PASSWORD=FALSE
  DEFAULT_WAREHOUSE='COMPUTE_WH'
  DEFAULT_ROLE='transform'
  DEFAULT_NAMESPACE='SUMUP.RAW'
  COMMENT='DBT user used for data transformation';
GRANT ROLE transform to USER dbt;

-- Create our database and schemas
CREATE DATABASE IF NOT EXISTS SUMUP;
CREATE SCHEMA IF NOT EXISTS SUMUP.RAW;

-- Set up permissions to role `transform`
GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE transform; 
GRANT ALL ON DATABASE SUMUP to ROLE transform;
GRANT ALL ON ALL SCHEMAS IN DATABASE SUMUP to ROLE transform;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE SUMUP to ROLE transform;
GRANT ALL ON ALL TABLES IN SCHEMA SUMUP.RAW to ROLE transform;
GRANT ALL ON FUTURE TABLES IN SCHEMA SUMUP.RAW to ROLE transform;

```

## Snowflake data import

You paste the raw csv file in the ```seed``` folder and rename them as follow
- store.csv as raw_stores.csv
- device.csv as raw_device.csv
- transaction.csv as raw_transactions.csv

## dbt installation

Here are the commands we execute in this lesson:

```sh
create course
cd course
virtualenv venv
. venv/bin/activate
pip install dbt-snowflake==1.5.0
which dbt
```

## dbt setup
Initialize the dbt profiles folder on Mac/Linux:
```sh
mkdir ~/.dbt
```

Initialize the dbt profiles folder on Windows:
```sh
mkdir %userprofile%\.dbt
```

Create a dbt project (all platforms):
```sh
dbt init nameofyourproject (here sumup)
```

# Technical Test (Take Home Challenge) answers

ss

## General remarks on my work

ss

## Assumptions and Design of my dbt project

ss

## Answerto the questions

ss

### Q1: Top 10 stores per transacted amount
#### Result 

Here is the result 
![Q1_answer](/Q1_answer.png)


#### SQL queries 
```sql
{{ config(
  materialized = 'table',
) }}

WITH transaction_enriched AS (
    SELECT * FROM {{ ref('dim_transactions_with_stores_devices') }}
)

SELECT
store_id,
store_name,
sum(transaction_amount) as total_amount
FROM transaction_enriched
GROUP BY 1,2
ORDER BY total_amount desc
LIMIT 10
```

### Q2: Top 10 products sold

#### Result 

Here is the result 
![Q2_answer](/Q2_answer.png)


#### SQL queries 

```sql
{{ config(
  materialized = 'table',
) }}

WITH transaction_enriched AS (
    SELECT * FROM {{ ref('dim_transactions_with_stores_devices') }}
)

SELECT
product_name,
sum(transaction_amount) as total_amount,
count(distinct transaction_id) as nb_distinct_transactions
FROM transaction_enriched
WHERE transaction_status = 'accepted'
GROUP BY 1
ORDER BY total_amount desc
LIMIT 10
```

### Q3: Average transacted amount per store typology and country

#### Result 

Here is the result 
![Q3_answer](/Q3_answer.png)


#### SQL queries 

```sql
{{ config(
  materialized = 'table',
) }}

WITH transaction_enriched AS (
    SELECT * FROM {{ ref('dim_transactions_with_stores_devices') }}
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
```

### Q4: Percentage of transactions per device type

#### Result 

Here is the result 
![Q4_answer](/Q4_answer.png)


#### SQL queries 

```sql
{{ config(
  materialized = 'table',
) }}

WITH transaction_enriched AS (
    SELECT * FROM {{ ref('dim_transactions_with_stores_devices') }}
)

SELECT
device_type,
count(distinct transaction_id) as nb_distinct_transactions,
count(distinct transaction_id)/(select count(*) from SUMUP.DEV.DIM_TRANSACTIONS_WITH_STORES_DEVICES WHERE transaction_status = 'accepted') as ratio_total_number_of_tansaction
FROM SUMUP.DEV.transaction_enriched
WHERE transaction_status = 'accepted'
GROUP BY 1
ORDER BY ratio_total_number_of_tansaction desc
```

### Q5: Average time for a store to perform its 5 first transactions

#### Result 

Here is the result 
![Q5_answer](/Q5_answer.png)


#### SQL queries 

```sql
{{ config(
  materialized = 'table',
) }}

WITH transaction_enriched AS (
    SELECT * FROM {{ ref('dim_transactions_with_stores_devices') }}
),
store_cleaned AS (
    SELECT * 
    FROM {{ ref('dim_stores_cleaned') }}
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

```

### Approach for sharing with other teams

ss

### Confidence in my data by my stakeholders

ss

