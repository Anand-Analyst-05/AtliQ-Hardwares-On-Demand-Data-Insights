SELECT 
*
FROM fact_sales_monthly
WHERE
customer_code=90002002 AND
get_fiscal_year(date)=2021 
ORDER BY date ASC;

SELECT 
* 
FROM fact_sales_monthly
WHERE 
customer_code = 90002002 AND
get_fiscal_year(date) = 2021 AND 
get_fiscal_quater(date) = "Q4"
ORDER BY date ASC;


-- Month
-- Product Name
-- Variant
-- Sold Quantity
-- Gross Price Per Item
-- Gross Price Total

SELECT 
	s.date, 
    s.product_code,
    p.product, 
    p.variant, 
    s.sold_quantity,
    g.gross_price, 
    round(g.gross_price * s.sold_quantity,2) AS gross_price_total
FROM fact_sales_monthly s
JOIN dim_product p
ON p.product_code = s.product_code
JOIN fact_gross_price g
	ON g.product_code = s.product_code AND
    g.fiscal_year = get_fiscal_year(s.date)
WHERE 
	customer_code = 90002002 AND
	get_fiscal_year(date)= 2021
ORDER BY date ASC
limit 1000000;

SELECT
get_fiscal_year(date) as fiscal_year,
round(sum(g.gross_price*s.sold_quantity),2) AS gross_price_total
FROM fact_sales_monthly s
JOIN fact_gross_price g
ON
g.product_code=s.product_code AND
g.fiscal_year=get_fiscal_year(date)
WHERE customer_code=90002002
GROUP BY fiscal_year
ORDER BY fiscal_year;



SELECT 
	s.date,
	SUM(g.gross_price * s.sold_quantity) AS gross_price_total
FROM fact_sales_monthly s

JOIN fact_gross_price g
ON
	g.product_code = s.product_code AND
    g.fiscal_year = get_fiscal_year(s.date)

where customer_code = 90002002
GROUP BY s.date
ORDER BY s.date ASC;



-- Generate a yearly report for Croma India where there are two columns

-- 	1. Fiscal Year
-- 	2. Total Gross Sales amount In that year from Croma

SELECT 
	get_fiscal_year(s.date) AS fiscal_year,
    SUM(ROUND(sold_quantity * g.gross_price,2)) AS yearly_sales
FROM fact_sales_monthly s
JOIN fact_gross_price g
ON 
	g.product_code = s.product_code AND
	g.fiscal_year = get_fiscal_year(s.date)
WHERE customer_code = 90002002
GROUP BY get_fiscal_year(s.date)
ORDER BY fiscal_year ASC;


SELECT 
    sum(sold_quantity) as total_qty
FROM fact_sales_monthly s
JOIN dim_customer c
ON s.customer_code = c.customer_code
WHERE get_fiscal_year(s.date) = 2021 AND c.market = "India"
GROUP BY c.market;



