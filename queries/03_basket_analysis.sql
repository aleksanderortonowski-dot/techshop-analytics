-- ============================================================
-- ZADANIE 3: Analiza Koszyka per kategoria produktu
-- KPI: średni koszyk, udział % w przychodzie, ranking
-- Techniki: JOIN 3 tabel, CTE, CROSS JOIN, DENSE_RANK()
-- ============================================================

WITH category_stats AS (
    SELECT
        p.category,
        ROUND(AVG(oi.qty)::numeric, 2)                        AS avg_items_per_order,
        ROUND((SUM(oi.qty * oi.unit_price)
              / COUNT(DISTINCT o.order_id))::numeric, 2)      AS avg_order_value,
        SUM(oi.qty * oi.unit_price)                           AS total_revenue
    FROM orders o
    INNER JOIN order_items oi ON o.order_id    = oi.order_id
    INNER JOIN products    p  ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
    GROUP BY p.category
),
grand AS (
    SELECT SUM(total_revenue) AS grand_total FROM category_stats
)
SELECT
    cs.category,
    cs.avg_items_per_order,
    cs.avg_order_value,
    ROUND(cs.total_revenue::numeric, 2)                             AS total_revenue,
    ROUND((cs.total_revenue / g.grand_total * 100)::numeric, 1)    AS revenue_share_pct,
    DENSE_RANK() OVER (ORDER BY cs.total_revenue DESC)              AS category_rank
FROM category_stats cs
CROSS JOIN grand g
ORDER BY total_revenue DESC;