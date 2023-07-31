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

```sql
WITH raw_hosts AS (
    SELECT
        *
    FROM
       AIRBNB.RAW.RAW_HOSTS
)
SELECT
    id AS host_id,
    NAME AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    raw_hosts
```

### Q3: Average transacted amount per store typology and country

```sql
WITH raw_hosts AS (
    SELECT
        *
    FROM
       AIRBNB.RAW.RAW_HOSTS
)
SELECT
    id AS host_id,
    NAME AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    raw_hosts
```

### Q4: Percentage of transactions per device type

```sql
WITH raw_hosts AS (
    SELECT
        *
    FROM
       AIRBNB.RAW.RAW_HOSTS
)
SELECT
    id AS host_id,
    NAME AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    raw_hosts
```

### Q5: Average time for a store to perform its 5 first transactions

```sql
WITH raw_hosts AS (
    SELECT
        *
    FROM
       AIRBNB.RAW.RAW_HOSTS
)
SELECT
    id AS host_id,
    NAME AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    raw_hosts
```

### Approach for sharing with other teams

ss

### Confidence in my data by my stakeholders

ss

