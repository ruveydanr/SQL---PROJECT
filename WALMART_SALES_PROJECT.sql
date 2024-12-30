CREATE DATABASE IF NOT EXISTS SalesDataWalmart;
CREATE TABLE Sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
	gross_income DECIMAL(12,4) NOT NULL,
    rating FLOAT(2,1)
    );
    
    SELECT * FROM SALES;
    
    -- data imported on table which is prepared
    
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------- FEATURE ENGINEERING ----------------------------------------------------------------------
    
-- time_of_date
SELECT 
	time,
    (CASE
		WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
	END
    ) AS time_of_date
FROM sales;

ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(20);

SELECT * FROM SALES;

UPDATE sales
SET time_of_day = 
	(CASE
		WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
	END);


-- day_name
SELECT 
	`date`,
	DAYNAME(`date`)
FROM sales;

ALTER TABLE sales
ADD COLUMN day_name VARCHAR(10);

SELECT * FROM SALES;

UPDATE sales
SET day_name = DAYNAME(`date`);

-- month_name
SELECT 
	`date`,
    MONTHNAME(`date`)
FROM sales;

ALTER TABLE sales
ADD COLUMN month_name VARCHAR(20);

UPDATE sales
SET month_name = MONTHNAME(`date`);
-- ---------------------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------    GENERIC    ---------------------------------------------------------------------
-- how many unique cities does the data have?
SELECT
   DISTINCT city
FROM sales;

-- how many unique BRANCHES does the data have?
SELECT
	DISTINCT branch
FROM sales;

-- In which city is each branch?
SELECT
	DISTINCT city,
    branch
FROM sales;
-- ----------------------------------------------------------------------------------------------------------------------------------------------


-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------    PRODUCT       ----------------------------------------------------------------------
-- How many unique product lines does the data have?
SELECT
	COUNT(DISTINCT product_line)
FROM sales;

-- What is the most common payment method?
SELECT 
	payment_method,
	COUNT(payment_method) 
FROM sales
GROUP BY payment_method
ORDER BY 2 DESC
LIMIT 1;

-- What is the most selling product line?
SELECT 
	product_line,
    COUNT(product_line)
FROM sales
GROUP BY product_line
ORDER BY 2 DESC
LIMIT 1;

-- What is the total revenue by month?
SELECT 
	month_name AS 'Month',
    SUM(total) AS total_revenue 
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT 
    month_name AS 'Month',
    SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC
LIMIT 1;

-- What product line had the largest revenue?
SELECT
	product_line,
    SUM(total) AS Revenue
FROM sales
GROUP BY product_line
ORDER BY  Revenue DESC ;

-- What is the city with the largest revenue?
SELECT 
	city,
    branch,
    SUM(total) AS Revenue
FROM sales
GROUP BY city,branch
ORDER BY Revenue DESC;

-- What product line had the largest VAT?
SELECT 
	product_line,
    MAX(VAT) AS VAT
FROM sales
GROUP BY product_line
ORDER BY VAT DESC;

-- Which branch sold more products than average product sold?
SELECT 
	branch,
    SUM(quantity) qty
FROM sales
GROUP BY branch
HAVING qty > AVG(quantity) ;

-- What is the most common product line by gender?
SELECT 
	gender,
    product_line,
    COUNT(product_line) AS common_product
FROM sales
GROUP BY gender,product_line
ORDER BY common_product DESC;

-- What is the average rating of each product line?
SELECT
	product_line,
    ROUND(AVG(rating),2) AS avg_rate
FROM sales
GROUP BY product_line
ORDER BY avg_rate DESC;
-- -----------------------------------------------------------------------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------      SALES          --------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name ='Sunday'
GROUP BY time_of_day
ORDER BY total_sales DESC ;

SELECT
	time_of_day,
    day_name,
    SUM(quantity) AS qty,
    SUM(total) AS total
FROM sales
group by time_of_day, day_name
ORDER BY total desc ;

-- Which of the customer types brings the most revenue?
SELECT 
	customer_type,
    SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	city,
    AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer type pays the most in VAT?
SELECT 
	customer_type,
    AVG(VAT) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- -----------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------   CUSTOMER   --------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT 
	DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment_method
FROM sales;

-- What is the most common customer type?
SELECT
	customer_type,
    COUNT(customer_type) AS cust_cnt
FROM sales
GROUP BY customer_type
ORDER BY cust_cnt DESC;

-- Which customer type buys the most?
SELECT 
	customer_type,
    COUNT(*) AS cst_cnt
FROM sales
GROUP  BY customer_type
ORDER BY cst_cnt DESC;

-- What is the gender of most of the customers?
SELECT
	gender,
    COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT 
	gender,
    branch,
    COUNT(*) AS gender_branch_cnt
FROM sales
GROUP BY gender, branch
ORDER BY branch ASC , gender ASC;

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
    AVG(rating) AS avg_rate
FROM sales
GROUP BY time_of_day
ORDER BY  avg_rate DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT 
	time_of_day,
    branch,
    AVG(rating) AS avg_rate
FROM sales
GROUP BY time_of_day,branch
ORDER BY avg_rate DESC;

SELECT 
	time_of_day,
    AVG(rating) AS avg_rate
FROM sales
WHERE branch = 'A'
GROUP BY time_of_day
ORDER BY avg_rate DESC ;

-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
    AVG(rating) AS avg_rate
FROM sales
GROUP BY day_name
ORDER BY  avg_rate DESC;

-- Which day of the week has the best average ratings per branch?
SELECT
	day_name,
    branch,
    AVG(rating) as avg_rate
FROM sales
WHERE branch='A'
GROUP BY day_name
ORDER BY  avg_rate DESC;

SELECT
	day_name,
    branch,
    AVG(rating) as avg_rate
FROM sales
GROUP BY day_name, branch
ORDER BY  avg_rate DESC;



