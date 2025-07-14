SELECT 
	market,
    round(sum(net_sales)/ 1000000,2) AS net_sales_mln
FROM net_sales
WHERE fiscal_year = 2021
GROUP BY market
ORDER BY net_sales_mln DESC
Limit 5;

SELECT 
	c.customer,
    round(sum(net_sales)/ 1000000,2) AS net_sales_mln
FROM net_sales n
JOIN dim_customer c 
ON c.customer_code = n.customer_code
WHERE fiscal_year = 2021
GROUP BY customer
ORDER BY net_sales_mln DESC
Limit 5;

SELECT 
	p.product, 
    round(sum(net_sales)/ 1000000,2) AS net_sales_mln
FROM net_sales ns
JOIN dim_product p
ON ns.product_code = p.product_code
WHERE fiscal_year = 2021
GROUP BY product
ORDER BY net_sales_mln DESC
LIMIT 5;

-----------------
WITH CTE1 as (

select 
		 customer,
		 round(sum(net_sales)/1000000,2) as net_sales_mln
from net_sales s
join dim_customer c
	on s.customer_code=c.customer_code
where 
s.fiscal_year=2021 	
group by customer)

-----------
	with cte1 as (
		select 
                    customer, 
                    round(sum(net_sales)/1000000,2) as net_sales_mln
        	from net_sales s
        	join dim_customer c
                    on s.customer_code=c.customer_code
        	where s.fiscal_year=2021
        	group by customer)
	select 
            *,
            net_sales_mln*100/sum(net_sales_mln) over() as pct_net_sales
	from cte1
	order by net_sales_mln desc;
-----

SELECT *,
net_sales_mln * 100 / sum(net_sales_mln) OVER(PARTITION BY ) AS pct
 FROM CTE1

order by net_sales_mln desc;

----------------------------
-- TASK 

 
WITH CTE2 as(
SELECT 
	c.customer,
    c.region,
    round(sum(net_sales)/ 1000000,2) AS net_sales_mln
FROM net_sales ns
JOIN dim_customer c
	ON c.customer_code = ns.customer_code
WHERE fiscal_year = 2021
GROUP BY c.region, c.customer
)
SELECT *,
net_sales_mln * 100 / sum(net_sales_mln)  OVER(PARTITION BY region) AS market_sahre_pct
 from CTE2

ORDER BY net_sales_mln DESC;


-------------------------------------
-- TASK-- 

WITH cte1 as(
select 
	c.customer,
	c.region,
	round(sum(net_sales)/ 1000000,2) AS net_sales_mln
FROM net_sales ns
JOIN dim_customer c 
	ON ns.customer_code = c.customer_code
Where fiscal_year = 2021
GROUP BY c.region, c.customer)

SELECT *,
	net_sales_mln * 100 /sum(net_sales_mln) 
    over(PARTITION BY region) AS pct_share_region
FROM cte1
ORDER BY region, net_sales_mln DESC;

--------------------------------------------------
-- WINDOW row_num, rank, dense_rank --

WITH cte1 AS(

SELECT 
    p.division,
    p.product,
    sum(sold_quantity) AS total_qty
FROM fact_sales_monthly s
JOIN dim_product p 
	ON p.product_code = s.product_code
WHERE fiscal_year = 2021
GROUP BY p.product
),
cte2 AS (
SELECT 
*,
DENSE_RANK() OVER(PARTITION BY division ORDER BY total_qty DESC) drank
 FROM cte1)
select * from cte2
WHERE drank <=3;



-- Exercise: Window Functions: ROW_NUMBER, RANK, DENSE_RANK-- 

-- 	select
-- 		s.date,
-- 		sum(round(s.sold_quantity*g.gross_price,2)) as monthly_sales
-- 	from fact_sales_monthly s
-- 	join fact_gross_price g
-- 	    ON g.fiscal_year = get_fiscal_year(s.date) 
--         and g.product_code = s.product_code
-- 	group by date;

WITH CTE1 AS (
SELECT 
	g.market,
    c.region,
    round(sum(gross_price_total)/ 1000000,2) AS gross_sales_mln
FROM gross_sales g
join dim_customer c
ON g.customer_code = c.customer_code
WHERE g.fiscal_year = 2021
GROUP BY market
ORDER BY gross_sales_mln DESC),
cte2 as(
SELECT *,
DENSE_RANK() OVER(PARTITION BY region ORDER BY gross_sales_mln DESC) rank_
 FROM cte1)
 SELECT * from cte2
 WHERE rank_ <=2;
 

SET sql_mode = '';










