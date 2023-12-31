Welcome to my take home challenge. You will find :
- How to setup the environment to make the project worked
- How I built this project (design , asumptions , queries , answers to questions)

# Environment Setup

I decided to indicate how install my dbt project. I took back instructions from the class I have done on the udemy platform and adapted it with my project

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

## General remarks on my work

- I'm quite happy of what I have done
- I was doing the transformation layer of the ELT with a python project at Iziwork so before doing the test I finished the complete-dbt-data-build-tool-bootcamp on udemy platform and after that it was quite intuitive to make the challenge.
- Thus I'm opened to feedbacks  but I found dbt  really cool and useful for building a robust and really developped transformation layer of your data and thus answer precisely the stakeholder questions.
  

## Design of my dbt project

You will find the main explanations of how this repetory is built

``` seed folder ```
- The raw data have been loaded into the seed files but I could have also loaded them in a S3 bucket and then called them directly from snowflake

``` model folder ```
- The models associated to this raw data are int the subfolder ``` src ```
- The models associated to the cleaned version are in the subfolder ``` dim ```
- Then I created also a full enriched table of the transaction object called **dim_transactions_with_stores_devices.sql**
- At least I created some mart views for answering the different business questions located in the subfolder ``` mart ```
- I decided to do generic tests and description in the ``` schema.yml ``` files

``` asset folder ```
- I put the screenshot and more generally speaking all the png files in this folder

  ``` macro folder ```
- In the macro folder, I have created a macro which enabled me to make a test on a column ( amount column)



## Answerto the questions

### Assumption for queries for answering the questions
- For all questions, I took only the transactions with the status **accepted**
- I undestood that the trasaction table was only transactions in euro even if the store country was not in the euro zone but in case I misunderstood I had created also a calculated fied in the transaction table to  know if the country of the transaction was in the Euro zone in order to filter on this field if necssary
- for Q5 I took only stores who made at least 5 transactions to calculate the average number of days to make five transactions


### Q1: Top 10 stores per transacted amount
#### Result 

Here is the result 
![Q1_answer](/Q1_answer.png)


#### SQL queries associated
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


#### SQL queries associated

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


#### SQL queries associated

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


#### SQL queries associated

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


#### SQL queries associated

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

### Approach for sharing results with other teams

To share efficiently the results with the business teams , I would do the several things on the top of this transformation layer made <ith dbt 

- I would use dashboarding and visualization tools like Tableau, Looker, Power BI, or Metabase to create interactive and easy-to-understand dashboards.
- Thanks to the mart models, employees could do self service analytics to their business question. This would allows them to explore the data and create their own reports and visualizations.
- And of course I would send them the Data dictionnary and documention link I would have generated in my dbt project in order to be sure we are aligned on the definitions used to calculated the metrics

To ensure I am still able to make changes in a controlled way

- I would do many tests by writing automated tests for the different dbt models using which ensure that tests cover different scenarios and edge cases to catch potential issues early in the development process.

- Whenever possible, I would try to make my dbt models to be incremental so that they only process new or changed data. This minimizes the risk of affecting downstream models with large-scale transformations.

- Being  mindful of the dependencies between modelsand try to avoid making breaking changes to upstream models without understanding the impact on downstream models.

### Confidence in my data by my stakeholders

It is also same answers as above. To be sure that they trus the data generated by my dbt project, I would do 
- As many as necessary automated testings
- Detailled Data documentation thanks to dbt or tools such as castor
- A data governance framework to ensure quality andd security of the datas
- Being transparent of the transformations made ( come a litle bit in making a detailled documentation)

