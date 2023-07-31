SELECT * FROM AIRBNB.dev.dim_listings_cleansed l
INNER JOIN AIRBNB.dev.fct_reviews r
USING (listing_id)
WHERE l.created_at >= r.review_date