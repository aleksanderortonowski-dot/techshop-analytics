-- ============================================================
-- ZADANIE 2: Miesięczny Trend Przychodów
-- KPI: przychód MoM, wzrost %, 3-miesięczna średnia krocząca
-- Techniki: CTE, DATE_TRUNC, LAG(), AVG() OVER, NULLIF
-- ============================================================

WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', ordered_at)  AS month,
        SUM(total_amount)                AS revenue,
        COUNT(order_id)                  AS orders_count,
        COUNT(DISTINCT customer_id)      AS unique_customers
    FROM orders
    WHERE status = 'completed'
    GROUP BY DATE_TRUNC('month', ordered_at)
),
final AS (
    SELECT
        month,
        revenue,
        orders_count,
        unique_customers,
        LAG(revenue) OVER (ORDER BY month)  AS prev_revenue,
        AVG(revenue) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        )                                    AS revenue_3m_avg
    FROM monthly_revenue
)
SELECT
    TO_CHAR(month, 'YYYY-MM')                                      AS month,
    ROUND(revenue::numeric, 2)                                     AS revenue,
    orders_count,
    unique_customers,
    ROUND((revenue / NULLIF(orders_count, 0))::numeric, 2)        AS avg_order_value,
    ROUND(((revenue - prev_revenue)
        / NULLIF(prev_revenue, 0) * 100)::numeric, 1)             AS mom_growth_pct,
    ROUND(revenue_3m_avg::numeric, 2)                             AS revenue_3m_avg
FROM final
ORDER BY month;