select COUNT(*) from `retail sales analysis` 
--- removing NULL value from our data 

SELECT * 
FROM `retail sales analysis` 
WHERE  quantiy IS NULL
OR price_per_unit IS NULL 
OR cogs IS NULL
OR total_sale IS NULL;

delete from `retail sales analysis` 
WHERE  quantiy IS NULL
OR price_per_unit IS NULL 
OR cogs IS NULL
OR total_sale IS NULL;

select * from `retail sales analysis`
--- How many total_sales 

select COUNT(*) as total_sales from `retail sales analysis` 
--- How many unique customers we have 
select COUNT(DISTINCT(customer_id)) as total_client from `retail sales analysis`
--- How many categories we have 
select COUNT(DISTINCT(category)) as total_categ from `retail sales analysis`

--- Data analysis & Business Problems & Answers 

Q1--- all columns for sales made on 2022-11-05.

 select * from `retail sales analysis` where sale_date = '11/5/2022'
 
Q2---  retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.

SELECT 
  *
FROM `retail sales analysis`
WHERE 
    category = 'Clothing'
    AND
    DATE_FORMAT(sale_date, '%Y/%m') = '2022/11'
    AND
    quantiy >= 4
    
Q3--- calculate the total sales (total_sale) for each category.

select category,SUM(total_sale) as net_sale,
    COUNT(*) as total_orders FROM `retail sales analysis`
group by category 

Q4---  find the average age of customers who purchased items from the 'Beauty' category.

select category ,round(avg(age),2) as avg_age FROM `retail sales analysis` where category = 'Beauty' group by category

Q5--- find all transactions where the total_sale is greater than 1000.

SELECT 
  *
FROM `retail sales analysis` where total_sale > 1000 

Q6---  total number of transactions (transaction_id) made by each gender in each category.

SELECT category,gender,COUNT(*) as total_trans
  
FROM `retail sales analysis`

group by category,gender
order by category

Q7--- calculate the average sale for each month. Find out best selling month in each year. 


DESCRIBE `retail sales analysis`; 

SELECT 
    STR_TO_DATE(sale_date, '%m/%d/%Y') AS sale_date_converted, 
    EXTRACT(YEAR FROM STR_TO_DATE(sale_date, '%m/%d/%Y')) AS year, 
    EXTRACT(MONTH FROM STR_TO_DATE(sale_date, '%m/%d/%Y')) AS month
FROM `retail sales analysis`; 

ALTER TABLE `retail sales analysis`
ADD sale_date_converted DATE;

UPDATE `retail sales analysis`
SET sale_date_converted = STR_TO_DATE(sale_date, '%m/%d/%Y');

ALTER TABLE `retail sales analysis`
DROP COLUMN sale_date;

ALTER TABLE `retail sales analysis`
CHANGE sale_date_converted sale_date DATE;

SELECT 
  *
FROM `retail sales analysis`
with cte as ( SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    ROUND(AVG(total_sale),2) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rk
FROM `retail sales analysis`
GROUP BY 1, 2 )
 select year, month,avg_sale from cte where rk= 1

Q8--- find the top 5 customers based on the highest total sales .

select customer_id,SUM(total_sale) as total_sales
 from `retail sales analysis` group by customer_id order by SUM(total_sale) DESC  limit 5 

Q9---  find the number of unique customers who purchased items from each category. 

 select COUNT(DISTINCT(customer_id)) as number_customers,category from `retail sales analysis` group by category 
 
Q10--- create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17) .

with cte as (SELECT *,EXTRACT(HOUR from sale_time) as Hour,
  case when EXTRACT(HOUR from sale_time) < 12 then 'Morning'
       when EXTRACT(HOUR from sale_time) between 12 and 17 then 'Afternoon' 
       ELSE 'Evening'
  END as Shift     
FROM `retail sales analysis` )

SELECT 
    shift,
    COUNT(*) as total_orders    
FROM cte
GROUP BY shift







