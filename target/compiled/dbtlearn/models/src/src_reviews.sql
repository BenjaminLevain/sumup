WITH raw_reviews AS (
SELECT  * FROM AIRBNB.raw.raw_reviews
)
SELECT 
    listing_id, 
    DATE AS review_date, 
    reviewer_name,
    COMMENTS as review_text,
    SENTIMENT as review_sentiment
FROM
    raw_reviews