-- back compat for old kwarg name
  
  begin;
    

        insert into AIRBNB.dev.fct_reviews ("REVIEW_ID", "LISTING_ID", "REVIEW_DATE", "REVIEWER_NAME", "REVIEW_TEXT", "REVIEW_SENTIMENT")
        (
            select "REVIEW_ID", "LISTING_ID", "REVIEW_DATE", "REVIEWER_NAME", "REVIEW_TEXT", "REVIEW_SENTIMENT"
            from AIRBNB.dev.fct_reviews__dbt_tmp
        );
    commit;