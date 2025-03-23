
-- JOINING ALL TABLES
SELECT 
    b.product_id,  
	p.product_name,
    p.description, 
    b.brand, 
    f.listing_price, 
	f.sale_price,
    f.discount,
	f.revenue,
    r.rating, 
    r.reviews,
    t.last_visited
INTO dbo.combined_data
FROM dbo.brands b
JOIN dbo.finance f ON b.product_id = f.product_id
JOIN dbo.product_info p ON b.product_id = p.product_id
JOIN dbo.reviews r ON b.product_id = r.product_id
JOIN dbo.traffic t ON b.product_id = t.product_id;

SELECT * 
FROM combined_data;

-- DATA CLEANING
-- Create staging table
SELECT *
INTO combined_staging
FROM combined_data;

SELECT * 
FROM combined_staging;

-- 1. Remove Any Duplicates
DELETE T
FROM
(
SELECT *, 
DupRank = ROW_NUMBER() OVER (
			  PARTITION BY product_id
			  ORDER BY product_name
			)
FROM combined_staging
) AS T
WHERE DupRank > 1;

-- 2. Standardizing data
-- Trimming leading and trailing whitespace
UPDATE combined_data
SET product_name = TRIM(product_name),
description = TRIM(description);

-- Some of the rows have the gender in proper case, some in all caps, and some are a mix. 
-- To be able to segment the clothes/footwear by gender easily, I will fix this
SELECT product_id, product_name, brand
FROM combined_staging
WHERE product_name LIKE '%men''s%';

-- Ensuring the "Men's" or "Women's" part of the product name is in same format (first letter capitalized + rest not capitalized) 
UPDATE combined_staging
SET product_name = REPLACE(product_name COLLATE Latin1_General_CI_AS, 'women''s', 'Women''s')
WHERE product_name COLLATE Latin1_General_CI_AS LIKE 'women''s%';

UPDATE combined_staging
SET product_name = REPLACE(product_name COLLATE Latin1_General_CI_AS, 'men''s', 'Men''s')
WHERE product_name COLLATE Latin1_General_CI_AS LIKE 'men''s%';

-- Ensuring there aren't any typos in the 2 brands we expect (Adidas & Nike)
SELECT COUNT(DISTINCT brand) as Num_of_brands
FROM combined_staging;

-- listing_price, sale_price, discount, and revenue are currency so they should be Decimals 
ALTER TABLE combined_staging
ALTER COLUMN listing_price DECIMAL(10, 2);

ALTER TABLE combined_staging
ALTER COLUMN sale_price DECIMAL(10, 2);

ALTER TABLE combined_staging
ALTER COLUMN discount DECIMAL(10, 2);

ALTER TABLE combined_staging
ALTER COLUMN revenue DECIMAL(10, 2);

SELECT TOP 20 product_id, product_name, brand, rating, reviews
FROM combined_staging;

-- Want rating to have 1 decimal place
ALTER TABLE combined_staging
ALTER COLUMN rating DECIMAL(10, 1);

-- Want reviews to be an integer
ALTER TABLE combined_staging
ALTER COLUMN reviews INT;

-- 3. Filter out null/blank rows
DELETE
FROM combined_staging
WHERE ((product_name IS NULL OR product_name = '') AND (description IS NULL OR description = '')) OR (brand IS NULL or brand = '')
AND listing_price IS NULL AND sale_price IS NULL AND discount IS NULL AND revenue IS NULL;


SELECT * 
FROM combined_staging;

-- INITIAL EXPLORATORY ANALYSIS

-- There are rows with one of rating or review is 0 but the other is not. Typically both are required when leaving a review
SELECT TOP 20 product_id, product_name, brand, revenue, rating, reviews, last_visited
FROM combined_staging 
WHERE ((rating = 0 AND reviews != 0) or (reviews = 0 and rating != 0));

-- There are no rows where the brand is Nike. It seems like Adidas allows ppl to leave only one or
-- reviews and ratings might be processed separately for Adidas products, causing temporary mismatches.
SELECT * 
FROM combined_staging 
WHERE ((rating = 0 AND reviews != 0) or (reviews = 0 and rating != 0))
AND brand = 'Nike';

-- Here are some questions I want to probe into using SQL
-- How do the price points of Nike and Adidas products differ?

-- Price points for each percentile - 25%, 50%, and 75%
-- Step 1: Create the temporary table
DROP TABLE IF EXISTS #price_points;

SELECT 
    brand,
    sale_price,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sale_price) OVER (PARTITION BY brand) AS low,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sale_price) OVER (PARTITION BY brand) AS medium,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sale_price) OVER (PARTITION BY brand) AS high
INTO #price_points
FROM combined_staging
WHERE brand IN ('Nike', 'Adidas');

SELECT * 
FROM #price_points
ORDER BY sale_price;

-- Step 2: Compare price points between Nike and Adidas
SELECT 
    'Low' AS tier,
    MAX(CASE WHEN brand = 'Nike' THEN low END) AS Nike,
    MAX(CASE WHEN brand = 'Adidas' THEN low END) AS Adidas
FROM #price_points

UNION ALL

SELECT 
    'Medium' AS tier,
    MAX(CASE WHEN brand = 'Nike' THEN medium END) AS Nike,
    MAX(CASE WHEN brand = 'Adidas' THEN medium END) AS Adidas
FROM #price_points

UNION ALL

SELECT 
    'High' AS tier,
    MAX(CASE WHEN brand = 'Nike' THEN high END) AS Nike,
    MAX(CASE WHEN brand = 'Adidas' THEN high END) AS Adidas
FROM #price_points;

-- Nike's price points are consistently higher for each tier
SELECT 
    'Low' AS tier,
    '$' + FORMAT(ABS(MAX(CASE WHEN brand = 'Nike' THEN low END) 
             - MAX(CASE WHEN brand = 'Adidas' THEN low END)), 'N2') AS abs_difference,
    FORMAT(
        CAST(MAX(CASE WHEN brand = 'Nike' THEN low END) AS FLOAT) 
        / MAX(CASE WHEN brand = 'Adidas' THEN low END) * 100, 'N2'
    ) + '%' AS prop_difference
FROM #price_points

UNION ALL

SELECT 
    'Medium' AS tier,
    '$' + FORMAT(ABS(MAX(CASE WHEN brand = 'Nike' THEN medium END) 
             - MAX(CASE WHEN brand = 'Adidas' THEN medium END)), 'N2') AS abs_difference,
    FORMAT(
        CAST(MAX(CASE WHEN brand = 'Nike' THEN medium END) AS FLOAT) 
        / MAX(CASE WHEN brand = 'Adidas' THEN medium END) * 100, 'N2'
    ) + '%' AS prop_difference
FROM #price_points

UNION ALL

SELECT 
    'High' AS tier,
    '$' + FORMAT(ABS(MAX(CASE WHEN brand = 'Nike' THEN high END) 
             - MAX(CASE WHEN brand = 'Adidas' THEN high END)), 'N2') AS abs_difference,
    FORMAT(
        CAST(MAX(CASE WHEN brand = 'Nike' THEN high END) AS FLOAT) 
        / MAX(CASE WHEN brand = 'Adidas' THEN high END) * 100, 'N2'
    ) + '%' AS prop_difference
FROM #price_points;


-- Nike's price points are 200 - 260%  more than Adidas'

-- Step 3: Count products in each tier and calculate the percentage of all items that are in that tier
WITH tier_counts AS (
    SELECT 
        brand,
        COUNT(CASE WHEN sale_price <= low THEN 1 END) AS low_count,
        COUNT(CASE WHEN sale_price > low AND sale_price <= medium THEN 1 END) AS medium_count,
        COUNT(CASE WHEN sale_price > medium AND sale_price <= high THEN 1 END) AS high_count,
        COUNT(CASE WHEN sale_price > high THEN 1 END) AS very_high_count,
        COUNT(*) AS total_count
    FROM #price_points
    GROUP BY brand
)
SELECT 
    brand,
    low_count,
    FORMAT(CAST(low_count AS FLOAT) / total_count * 100, 'N2') + '%' AS low_percent,
    medium_count,
    FORMAT(CAST(medium_count AS FLOAT) / total_count * 100, 'N2') + '%' AS medium_percent,
    high_count,
    FORMAT(CAST(high_count AS FLOAT) / total_count * 100, 'N2') + '%' AS high_percent,
    very_high_count,
    FORMAT(CAST(very_high_count AS FLOAT) / total_count * 100, 'N2') + '%' AS very_high_percent
FROM tier_counts;

-- Despite the large difference in price points, the percentage of products in each tier is quite similar 
-- between Nike and Adidas (especially in the high and very high tiers). This could mean that both brands
-- follow similar pricing strategies in terms of product segmentation, even though Nike charges more

-- Is there a difference in the amount of discount offered between the brands?
SELECT brand, FORMAT(AVG(discount)*100, 'N2') + '%' AS discount_avg
FROM combined_staging
WHERE brand IS NOT NULL
GROUP BY brand;

-- It seems Nike doesn't offer any discounts

-- Is there any correlation between revenue and reviews? And if so, how strong is it?
SELECT *
FROM combined_staging;

-- Creating stored procedure to calculate correlation coefficient
-- correlation coefficient: r = (((count *) * sum(x*y)) - (sum(x)*sum(y))) 
--							/ sqrt(((count*)*sum(pow(x,2)) - pow(sum(x), 2)) * (count*)*sum(pow(y,2))- pow(sum(y), 2)))

IF OBJECT_ID(N'dbo.CalculateCorrelation', N'P') IS NOT NULL
    DROP PROCEDURE dbo.CalculateCorrelation;
GO

CREATE PROCEDURE dbo.CalculateCorrelation
    @x_column NVARCHAR(128),
    @y_column NVARCHAR(128)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    SET @sql = '
        SELECT 
            (COUNT(*) * SUM(CAST(' + @x_column + ' AS FLOAT) * CAST(' + @y_column + ' AS FLOAT)) - 
             (SUM(CAST(' + @x_column + ' AS FLOAT)) * SUM(CAST(' + @y_column + ' AS FLOAT)))) /
            SQRT(
                (COUNT(*) * SUM(SQUARE(CAST(' + @x_column + ' AS FLOAT))) - 
                 SQUARE(SUM(CAST(' + @x_column + ' AS FLOAT)))) *
                (COUNT(*) * SUM(SQUARE(CAST(' + @y_column + ' AS FLOAT))) - 
                 SQUARE(SUM(CAST(' + @y_column + ' AS FLOAT))))
            ) AS correlation_coefficient
        FROM combined_staging;
    ';

    EXEC sp_executesql @sql;
END;
GO

EXEC dbo.CalculateCorrelation @x_column = 'revenue', @y_column = 'reviews';
-- A correlation value of 0.65 suggests a moderately strong relationship  

-- Is there any correlation between revenue and ratings? And if so, how strong is it?
EXEC dbo.CalculateCorrelation @x_column = 'revenue', @y_column = 'rating';

-- Do Mens or Womens shoe contribute the most to revenue?
ALTER TABLE combined_staging 
ADD gender AS ( CASE 
        WHEN description LIKE '%Women''s%' OR product_name LIKE '%Women%' THEN 'Womens'
        WHEN description LIKE '%Men''s%' OR product_name LIKE '%Men%' THEN 'Men'
        ELSE 'Uncategorized'
    END);

SELECT 
    SUM(CASE WHEN description LIKE '%Women%' THEN 1 ELSE 0 END) AS women_count,
    SUM(CASE WHEN description LIKE '%Men%' THEN 1 ELSE 0 END) AS men_count
FROM combined_staging;
-- There are far more men's clothing/footwear than women's

SELECT 
    gender,
    COUNT(*) AS product_count,
    SUM(revenue) AS total_revenue,
    SUM(revenue) / COUNT(*) AS avg_revenue_per_product
FROM combined_staging
WHERE description LIKE '%shoes%' OR description LIKE '%footwear%' OR description LIKE '%sneaker%' OR description LIKE '%sole%'
GROUP BY gender
ORDER BY avg_revenue_per_product DESC;
-- Men's footwear contributes significantly more to revenue than women's in total, but women's footwear generate more revenue on average. 


-- Does the length of a product's description influence a product's rating and reviews?
ALTER TABLE combined_staging
ADD description_length AS LEN(description);

EXEC dbo.CalculateCorrelation @x_column = 'description_length', @y_column = 'reviews';
EXEC dbo.CalculateCorrelation @x_column = 'description_length', @y_column = 'rating';

ALTER TABLE combined_staging DROP COLUMN description_length;
GO

-- There is very little correlation between description length and reviews/rating


-- Are there any trends or gaps in the volume of reviews by month?
SELECT MONTH(last_visited) AS month, SUM(reviews) as num_of_reviews
FROM combined_staging
WHERE MONTH(last_visited) IS NOT NULL
GROUP BY MONTH(last_visited)
ORDER BY num_of_reviews DESC;

-- The first quarter produces the most sales followed by the third/fourth

-- How much of the company's stock consists of footwear items? What is the median revenue generated by these products?
SELECT *
INTO #footwear_products
FROM combined_staging
WHERE description LIKE '%shoes%' 
       OR description LIKE '%footwear%' 
       OR description LIKE '%sneaker%' 
       OR description LIKE '%sole%';

SELECT 
    CAST((SELECT COUNT(product_id) FROM #footwear_products) AS FLOAT) 
    / COUNT(product_id) * 100 AS shoe_percentage
FROM combined_staging;
-- 82.6% of the products are footwear

SELECT MAX(revenue) AS "Median"
FROM (
 SELECT revenue,
 NTILE(4) OVER(ORDER BY revenue) AS Quartile 
 FROM #footwear_products
) X
WHERE Quartile = 2;
-- Median is 3144.02

-- How does footwear's median revenue differ from clothing products?
SELECT MAX(revenue) AS "Median"
FROM (
    SELECT cs.revenue,
           NTILE(4) OVER (ORDER BY cs.revenue) AS Quartile
    FROM combined_staging cs
    LEFT JOIN #footwear_products fp ON cs.product_id = fp.product_id
    WHERE fp.product_id IS NULL -- Exclude footwear products
) X
WHERE Quartile = 2;
-- Median of clothing products is 683.73, significantly less than the median of footwear

DROP TABLE 
combined_data;

exec sp_rename 'dbo.combined_staging', 'combined'

SELECT * 
from combined;