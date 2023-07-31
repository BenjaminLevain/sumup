
SELECT
    *
FROM
    AIRBNB.dev.dim_listings_cleansed
WHERE
    minimum_nights < 1
