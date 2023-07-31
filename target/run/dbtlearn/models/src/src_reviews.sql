
  create or replace   view AIRBNB.dev.src_reviews
  
   as (
    WITH raw_reviews AS (
SELECT * FROM AIRBNB.RAW.RAW_REVIEWS
)
SELECT 
    listing_id, 
    DATE AS review_date, 
    reviewer_name,
    COMMENTS as review_text,
    SENTIMENT as review_sentiment
FROM
    raw_reviews
  );

