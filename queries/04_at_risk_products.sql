-- ============================================================
-- ZADANIE 4: Produkty "At Risk" — spadek przychodów > 30% QoQ
-- KPI: decline_pct między aktualnym a poprzednim kwartałem
-- Techniki: CTE, DATE_TRUNC quarter, LAG(), CASE WHEN, NULLIF
-- ============================================================

WITH product_quarter AS (
    SELECT
        p.product_id,
        p.name,
        p.category,
        DATE_TRUNC('quarter', o.ordered_at)  AS quarter,
        SUM(oi.qty * oi.unit_price)          AS revenue
    FROM orders o
    INNER JOIN order_items oi ON o.order_id    = oi.order_id
    INNER JOIN products    p  ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
    GROUP BY p.product_id, p.name, p.category,
             DATE_TRUNC('quarter', o.ordered_at)
),
with_prev AS (
    SELECT
        product_id,
        name,
        category,
        quarter,
        revenue                                          AS current_q_revenue,
        LAG(revenue) OVER (
            PARTITION BY product_id ORDER BY quarter
        )                                                AS prev_q_revenue
    FROM product_quarter
),
latest AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY product_id ORDER BY quarter DESC
        ) AS rn
    FROM with_prev
)
SELECT
    product_id,
    name,
    category,
    ROUND(current_q_revenue::numeric, 2)                      AS current_q_revenue,
    ROUND(prev_q_revenue::numeric, 2)                         AS prev_q_revenue,
    ROUND(((current_q_revenue - prev_q_revenue)
        / NULLIF(prev_q_revenue, 0) * 100)::numeric, 1)       AS decline_pct,
    CASE
        WHEN ((current_q_revenue - prev_q_revenue)
              / NULLIF(prev_q_revenue, 0) * 100) < -50
            THEN 'URGENT: >50% decline'
        ELSE 'WARNING: 30-50% decline'
    END                                                        AS recommendation
FROM latest
WHERE rn = 1
  AND prev_q_revenue IS NOT NULL
  AND ((current_q_revenue - prev_q_revenue)
       / NULLIF(prev_q_revenue, 0) * 100) < -30
ORDER BY decline_pct ASC;