-- ============================================================
-- ZADANIE 1: Customer Lifetime Value — TOP 10
-- KPI: łączna wartość zamówień per klient (tylko completed)
-- Techniki: CTE, GROUP BY, HAVING, RANK()
-- ============================================================

WITH customer_metrics AS (
    SELECT
        c.customer_id,
        c.full_name,
        c.country,
        COUNT(o.order_id)   AS total_orders,
        SUM(o.total_amount) AS clv,
        AVG(o.total_amount) AS avg_order_value,
        MIN(o.ordered_at)   AS first_order_date,
        MAX(o.ordered_at)   AS last_order_date
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.status = 'completed'
    GROUP BY c.customer_id, c.full_name, c.country
    HAVING COUNT(o.order_id) >= 1
)
SELECT
    customer_id,
    full_name,
    country,
    total_orders,
    ROUND(clv::numeric, 2)                                       AS clv,
    ROUND(avg_order_value::numeric, 2)                           AS avg_order_value,
    first_order_date::date                                       AS first_order_date,
    last_order_date::date                                        AS last_order_date,
    EXTRACT(DAY FROM (last_order_date - first_order_date))::int  AS days_active,
    RANK() OVER (ORDER BY clv DESC)                              AS clv_rank
FROM customer_metrics
ORDER BY clv_rank ASC
LIMIT 10;