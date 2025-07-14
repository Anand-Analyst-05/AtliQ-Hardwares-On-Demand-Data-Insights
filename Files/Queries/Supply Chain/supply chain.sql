-- SET GLOBAL max_allowed_packet = 1073741824; -- 1GB
-- SET GLOBAL wait_timeout = 600;
-- SET GLOBAL net_read_timeout = 600;
-- SET GLOBAL net_write_timeout = 600;

SET sql_mode = '';

CREATE temporary table forecast_err_table
	SELECT 
		s.customer_code,
		sum(s.sold_quantity) as total_sold_qty,
		sum(s.forecast_quantity - sold_quantity) AS total_forecast_qty,
		sum((forecast_quantity - sold_quantity)) AS net_err,
		sum((forecast_quantity - sold_quantity))*100 / sum(forecast_quantity) AS net_err_pct,
		sum(abs(forecast_quantity - sold_quantity)) AS abs_err,
		sum(abs(forecast_quantity - sold_quantity))*100 / sum(forecast_quantity) AS abs_err_pct
	FROM fact_act_est s
	WHERE fiscal_year =2021
	GROUP BY s.customer_code;
SELECT 
	e.*,
    c.customer,
    c.market,
    if (abs_err_pct > 100, 0, 100-abs_err_pct) as forecast_accuracy
from forecast_err_table e
JOIN dim_customer c
USING (customer_Code)
ORDER BY forecast_accuracy desc;



-- Exercise: CTE, Temporary Tables--

-- customer_code, customer_name, market, 
-- forecast_accuracy_2020, forecast_accuracy_2021 


drop table if exists forecast_accuracy_2021;
create temporary table forecast_accuracy_2021
with forecast_err_table  as(

SELECT 
	s.customer_code as customer_code,
    c.customer as customer,
    c.market as market,
    sum(sold_quantity) AS total_sold_qty,
    sum(forecast_quantity) as total_forcast_qty,
    sum(forecast_quantity - sold_quantity) AS net_error,
    round(sum(forecast_quantity - sold_quantity) * 100 / sum(forecast_quantity),1) AS net_error_pct,
    sum(abs(forecast_quantity - sold_quantity)) AS abs_error,
    round(sum(abs(forecast_quantity - sold_quantity)) * 100 / sum(forecast_quantity),2) AS abs_error_pct
FROM fact_act_est s
JOIN dim_customer c
USING (customer_Code)
WHERE fiscal_year = 2021
GROUP BY customer_code
)

select 
*,
if (abs_error_pct > 100, 0, 100.0 - abs_error_pct) as forecast_accuracy
from forecast_err_table 
ORDER BY forecast_accuracy desc;




drop table if exists forecast_accuracy_2020;
create temporary table forecast_accuracy_2020
with forecast_err_table  as(
SELECT 
	s.customer_code as customer_code,
    c.customer as customer,
    c.market as market,
    sum(sold_quantity) AS total_sold_qty,
    sum(forecast_quantity) as total_forcast_qty,
    sum(forecast_quantity - sold_quantity) AS net_error,
    round(sum(forecast_quantity - sold_quantity) * 100 / sum(forecast_quantity),1) AS net_error_pct,
    sum(abs(forecast_quantity - sold_quantity)) AS abs_error,
    round(sum(abs(forecast_quantity - sold_quantity)) * 100 / sum(forecast_quantity),2) AS abs_error_pct
FROM fact_act_est s
JOIN dim_customer c
USING (customer_Code)
WHERE fiscal_year = 2020
GROUP BY customer_code
)

select 
*, 
if (abs_error_pct > 100, 0, 100.0 - abs_error_pct) as forecast_accuracy
from forecast_err_table 
ORDER BY forecast_accuracy desc;


select
	f_2020.customer_code as customer_code, 
    f_2020.customer as customer, 
    f_2020.market as market, 
	f_2020.forecast_accuracy as forecast_acc_2020,
	f_2021.forecast_accuracy as forecast_acc_2021

 from forecast_accuracy_2020 as f_2020
JOIN forecast_accuracy_2021 AS  f_2021
ON f_2020.customer_Code = f_2021.customer_Code
where f_2020.forecast_accuracy < f_2021.forecast_accuracy
ORDER BY forecast_acc_2020 desc;