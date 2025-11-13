1️⃣ Create and Load Table
CREATE TABLE zara_sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Product_Category VARCHAR(50),
    Product_Type VARCHAR(50),
    Gender VARCHAR(20),
    Country VARCHAR(50),
    Region VARCHAR(50),
    Season VARCHAR(20),
    Placement VARCHAR(50),
    Sales DECIMAL(10,2)
);

2️⃣ Initial Data Audit
-- Preview and count data
SELECT * FROM zara_sales LIMIT 10;

SELECT COUNT(*) AS total_records,
       COUNT(DISTINCT Product_Category) AS unique_categories,
       COUNT(DISTINCT Region) AS unique_regions,
       COUNT(DISTINCT Season) AS unique_seasons
FROM zara_sales;

3️⃣ Check for Missing and Duplicate Values
-- Identify missing values
SELECT 
    SUM(CASE WHEN Product_Category IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN Product_Type IS NULL THEN 1 ELSE 0 END) AS null_type,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS null_sales
FROM zara_sales;

-- Detect duplicates
SELECT Product_Category, Product_Type, Country, COUNT(*)
FROM zara_sales
GROUP BY Product_Category, Product_Type, Country
HAVING COUNT(*) > 1;

4️⃣ Data Cleaning and Standardization
-- Remove duplicates
DELETE t1 FROM zara_sales t1
JOIN zara_sales t2 
ON t1.id > t2.id 
AND t1.Product_Category = t2.Product_Category 
AND t1.Product_Type = t2.Product_Type 
AND t1.Country = t2.Country;

-- Standardize text fields
UPDATE zara_sales
SET 
    Gender = TRIM(LOWER(Gender)),
    Region = TRIM(UPPER(Region)),
    Season = TRIM(UPPER(Season)),
    Placement = TRIM(LOWER(Placement));

5️⃣ Validate Data Types and Ranges
-- Check for negative or invalid sales
SELECT * FROM zara_sales WHERE Sales < 0;

-- Ensure season and placement have valid entries
SELECT DISTINCT Season FROM zara_sales;
SELECT DISTINCT Placement FROM zara_sales;

📊 STEP 2: SQL ANALYSIS QUERIES (For Tableau Insights)
🔹 1. Sales by Product Placement
SELECT Placement, ROUND(SUM(Sales),2) AS total_sales
FROM zara_sales
GROUP BY Placement
ORDER BY total_sales DESC;


Insight: Products positioned in the Aisle area generated the highest sales performance.

🔹 2. Linen Demand by Season
SELECT Season, ROUND(SUM(Sales),2) AS total_sales
FROM zara_sales
WHERE Product_Category = 'Linen'
GROUP BY Season
ORDER BY total_sales DESC;


Insight: Linen products had minimal demand in Autumn and Winter, suggesting a need to optimize production schedules.

🔹 3. Gender-Based Sales Comparison
SELECT Gender, ROUND(SUM(Sales),2) AS total_sales
FROM zara_sales
GROUP BY Gender
ORDER BY total_sales DESC;


Insight: Women’s clothing recorded higher sales compared to Men’s clothing.

🔹 4. Regional Performance
SELECT Region, ROUND(SUM(Sales),2) AS total_sales
FROM zara_sales
GROUP BY Region
ORDER BY total_sales DESC;


Insight: China was the top-performing region, while Pakistan had the lowest sales contribution.

🔹 5. Category-Wise Sales Performance
SELECT Product_Category, ROUND(SUM(Sales),2) AS total_sales
FROM zara_sales
GROUP BY Product_Category
ORDER BY total_sales DESC;


Insight: Jackets achieved the highest sales, while Jeans recorded the lowest.
