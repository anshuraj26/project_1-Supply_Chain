----------Supply Chain & Logistics Performance----------

--1.Geographic Bottlenecks - Identify the City and Country with the highest average delay variance.
SELECT 
	order_country, 
	order_city,  
	ROUND(VAR_SAMP(delay_variance),2) as variance_delay
FROM supply_chain
GROUP BY order_country , order_city
HAVING COUNT(order_id) >=10 
ORDER BY variance_delay DESC
LIMIT 10;


--2.Shipment Mode reliability - Compare the percentage of Late delivery vs. Shipping on time across different Shipping Mode types 
SELECT 
    shipping_mode,
    COUNT(order_id) as total_orders,
    SUM(CASE WHEN delivery_status = 'Late delivery' THEN 1 ELSE 0 END) as late_count,
    ROUND(100.0 * SUM(CASE WHEN delivery_status = 'Late delivery' THEN 1 ELSE 0 END) / COUNT(order_id), 2) as late_percentage,
    ROUND(100.0 * SUM(CASE WHEN delivery_status = 'Shipping on time' THEN 1 ELSE 0 END) / COUNT(order_id), 2) as on_time_percentage
FROM supply_chain 
GROUP BY shipping_mode
ORDER BY late_percentage DESC;


----------Financial Health & Profitability----------

--3.Market Profitability Ranking - Identify the most profitable Market on the basis of profit margins
SELECT 
    market,
    SUM(order_profit_per_order) as total_profit,
    SUM(sales) as total_sales,
    -- Calculation fixes: No "AS" inside the brackets
    ROUND(100 *(SUM(order_profit_per_order) / SUM(sales)) :: numeric , 2) AS profit_margin_pct
FROM supply_chain
GROUP BY market
ORDER BY profit_margin_pct DESC;


--4.The "Category Star" - the Category Name that ranks highest in both total Sales and total Benefit (Profit).
WITH DeptSales AS (
    SELECT 
        department_name,
        SUM(sales) as total_revenue
    FROM supply_chain
    GROUP BY department_name
),
TopDept AS (
    SELECT 
        department_name, 
        total_revenue,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC) as rank_id
    FROM DeptSales
    LIMIT 10
),
BottomDept AS (
    SELECT 
        department_name, 
        total_revenue,
        ROW_NUMBER() OVER (ORDER BY total_revenue ASC) as rank_id
    FROM DeptSales
    LIMIT 10
)
SELECT 
    t.rank_id as "Rank",
    t.department_name as "Top_Performer",
    t.total_revenue as "Top_Revenue",
    ' | ' as separator,
    b.department_name as "Bottom_Performer",
    b.total_revenue as "Bottom_Revenue"
FROM TopDept as t
JOIN BottomDept as b ON t.rank_id = b.rank_id
ORDER BY t.rank_id;


The
"Loss Leader" Analysis :
Identify which Category Name has high Sales but negative or very low Benefit
per order. 


--5.The "Loss Leader" Analysis - Identify which Category Name has high Sales but negative or very low Benefit per order. 
SELECT
	category_name,
	SUM(sales) as total_sales,
	SUM(order_profit_per_order) as total_profit,
	ROUND(100 * (SUM(order_profit_per_order) / SUM(sales)) ::numeric, 2) as profit_margin_pct
FROM supply_chain
GROUP BY category_name
HAVING SUM(sales) >0 
ORDER BY profit_margin_pct;
	


----------Customer & Segment Behavior----------

--6.Segment Value Analysis - Determine which Customer Segment drives the most Revenue and has the highest Order Frequency.
SELECT 
	customer_segment,
	SUM(sales) as total_revenue,
	COUNT(order_id) as total_orders,
	ROUND((SUM(sales) / COUNT(order_id)) ::numeric, 2) as avg_order_value
FROM supply_chain
GROUP BY customer_segment
ORDER BY total_revenue DESC;


--7.Customer Lifetime Value (CLV) Snapshot - the total Sales per Customer Id and sort to find your top 1% of customers
WITH Customer_CLV as (
SELECT 
	customer_id,
	SUM(sales) as total_sales
FROM supply_chain
GROUP BY customer_id
), 
Customer_rank as (
SELECT 
	*,
	NTILE(100) OVER(ORDER BY total_sales DESC) as percentile_rank
FROM Customer_CLV
)
SELECT
    customer_id,
    total_sales
FROM Customer_rank
WHERE percentile_rank = 1
ORDER BY total_sales DESC;


--8.Fraud Geography - Identify which Order Country or Order City has the highest percentage of orders marked as SUSPECTED_FRAUD.
SELECT 
	order_country,
	order_city,
	COUNT(order_id) as total_orders,
	ROUND(100 * SUM(CASE WHEN order_status = 'SUSPECTED_FRAUD' THEN  1 ELSE 0 END) /COUNT(order_id) ::numeric,2) as fraud_percentage
FROM supply_chain
GROUP BY order_country, order_city
HAVING COUNT(order_id) >50  --so that country with 1 order doesn't show 100% fraud
ORDER BY fraud_percentage DESC
LIMIT 10;


----------Time-Series & Trends ----------

--9.MoM and YoY Growth:Month-over-Month and Year-over-Year growth for both Revenue and Profit.
WITH Monthly_Stats as(
    SELECT 
        DATE_TRUNC('month', order_date)::DATE as report_month,
        SUM(sales) as total_sales,
        SUM(order_profit_per_order) as total_profit
    FROM supply_chain
    GROUP BY 1
),
Lagged_Stats AS (
    SELECT 
        report_month,
        total_sales,
        total_profit,
        LAG(total_sales, 1) OVER (ORDER BY report_month) as prev_month_sales,
        LAG(total_profit, 1) OVER (ORDER BY report_month) as prev_month_profit,
        LAG(total_sales, 12) OVER (ORDER BY report_month) as prev_year_sales,
        LAG(total_profit, 12) OVER (ORDER BY report_month) as prev_year_profit
    FROM Monthly_Stats
)
SELECT 
    report_month,
    ROUND((100 * (total_sales - prev_month_sales) / NULLIF(prev_month_sales, 0))::numeric, 2) as sales_mom_pct,
	ROUND((100 * (total_sales - prev_year_sales) / NULLIF(prev_year_sales, 0))::numeric, 2) as sales_yoy_pct,
	ROUND((100 * (total_profit - prev_month_profit) / NULLIF(prev_month_profit, 0))::numeric, 2) as profit_mom_pct,
	ROUND((100 * (total_profit - prev_year_profit) / NULLIF(prev_year_profit, 0))::numeric, 2) as profit_yoy_pct
FROM Lagged_Stats
ORDER BY report_month DESC;


--10.Seasonality Patterns - average Sales per month across all years to identify peak seasons 
WITH Monthly_Totals AS (
    SELECT 
        DATE_TRUNC('month', order_date)::DATE as specific_month,
        EXTRACT(MONTH FROM order_date) as month_num,
        SUM(sales) as total_monthly_revenue
    FROM supply_chain
    GROUP BY 1, 2
)
SELECT 
    month_num,
    TO_CHAR(TO_DATE(month_num::text, 'MM'), 'Month') as month_name,
    ROUND(AVG(total_monthly_revenue) ::numeric, 2) as avg_monthly_sales
FROM Monthly_Totals
GROUP BY month_num
ORDER BY month_num;