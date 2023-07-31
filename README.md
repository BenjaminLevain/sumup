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

## General remarks on my work

## Assumptions and Design of my dbt project

## Answerto the questions

### Q1: Top 10 stores per transacted amount

### Q2: Top 10 products sold

### Q3: Average transacted amount per store typology and country

### Q4: Percentage of transactions per device type

### Q5: Average time for a store to perform its 5 first transactions

### Approach for sharing with other teams

### Confidence in my data by my stakeholders

