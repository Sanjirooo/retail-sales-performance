-- Retail Sales Performance 



CREATE TABLE IF NOT EXISTS fact_sales (
 transaction_id TEXT PRIMARY KEY, transaction_date TEXT NOT NULL, customer_id TEXT NOT NULL,
 product_id TEXT NOT NULL, product_name TEXT NOT NULL, category TEXT NOT NULL, region TEXT NOT NULL,
 quantity INTEGER NOT NULL, unit_price REAL NOT NULL, discount_pct REAL NOT NULL,
 total_revenue REAL NOT NULL, unit_cost REAL NOT NULL, total_cost REAL NOT NULL, profit REAL NOT NULL
);
-- KPI eksekutif
SELECT COUNT(*) orders, COUNT(DISTINCT customer_id) customers, SUM(total_revenue) revenue,
 SUM(profit) gross_profit, 1.0*SUM(profit)/NULLIF(SUM(total_revenue),0) gross_margin,
 1.0*SUM(total_revenue)/COUNT(*) average_order_value FROM fact_sales;
-- Revenue dan margin per kategori
SELECT category,SUM(total_revenue) revenue,SUM(profit) gross_profit,
 1.0*SUM(profit)/NULLIF(SUM(total_revenue),0) gross_margin,COUNT(*) orders
FROM fact_sales GROUP BY category ORDER BY revenue DESC;
-- Tren bulanan dan perubahan terhadap bulan sebelumnya
WITH monthly AS (SELECT substr(transaction_date,1,7) month,SUM(total_revenue) revenue,SUM(profit) profit
 FROM fact_sales GROUP BY substr(transaction_date,1,7))
SELECT month,revenue,profit,LAG(revenue) OVER(ORDER BY month) previous_month_revenue,
 revenue-LAG(revenue) OVER(ORDER BY month) revenue_change FROM monthly ORDER BY month;
 
-- Peringkat pelanggan dengan monetary tertinggi
WITH x AS (SELECT customer_id,COUNT(*) frequency,SUM(total_revenue) monetary FROM fact_sales GROUP BY customer_id)
SELECT *,DENSE_RANK() OVER(ORDER BY monetary DESC) value_rank FROM x ORDER BY value_rank LIMIT 20;
