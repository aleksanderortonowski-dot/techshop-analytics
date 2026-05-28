-- ============================================================
-- ZADANIE 5: Segmentacja RFM
-- KPI: klasyfikacja klientów wg Recency, Frequency, Monetary
-- Techniki: 3 CTE, NTILE(5), CASE WHEN segmenty
-- ============================================================

-- ------------------------------------------------------------
-- CZĘŚĆ A: Indywidualna tabela RFM (jeden wiersz = jeden klient)
-- ------------------------------------------------------------

WITH rfm_base AS (
    SELECT
        o.customer_id,
        c.full_name,
        MAX(o.ordered_at)   AS last_order_date,
        COUNT(o.order_id)   AS frequency,
        SUM(o.total_amount) AS monetary
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.status = 'completed'
    GROUP BY o.customer_id, c.full_name
),
rfm_scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY last_order_date DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency       DESC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary        DESC) AS monetary_score
    FROM rfm_base
),
rfm_segments AS (
    SELECT *,
        (recency_score + frequency_score + monetary_score) AS rfm_total,
        CASE
            WHEN (recency_score + frequency_score + monetary_score) >= 13
                THEN 'Champions'
            WHEN (recency_score + frequency_score + monetary_score) >= 10
                THEN 'Loyal Customers'
            WHEN (recency_score + frequency_score + monetary_score) >= 7
                THEN 'Potential Loyalists'
            WHEN (recency_score + frequency_score + monetary_score) >= 4
                THEN 'At Risk'
            ELSE 'Lost'
        END AS segment
    FROM rfm_scores
)
SELECT
    customer_id,
    full_name,
    TO_CHAR(last_order_date, 'YYYY-MM-DD')  AS last_order_date,
    frequency,
    ROUND(monetary::numeric, 2)             AS monetary,
    recency_score,
    frequency_score,
    monetary_score,
    rfm_total,
    segment
FROM rfm_segments
ORDER BY rfm_total DESC, monetary DESC;


-- ------------------------------------------------------------
-- CZĘŚĆ B: Podsumowanie segmentów (agregacja po wyniku RFM)
-- ------------------------------------------------------------

WITH rfm_base AS (
    SELECT
        customer_id,
        MAX(ordered_at)   AS last_order_date,
        COUNT(order_id)   AS frequency,
        SUM(total_amount) AS monetary
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY last_order_date DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency       DESC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary        DESC) AS monetary_score
    FROM rfm_base
),
rfm_results AS (
    SELECT *,
        CASE
            WHEN (recency_score + frequency_score + monetary_score) >= 13
                THEN 'Champions'
            WHEN (recency_score + frequency_score + monetary_score) >= 10
                THEN 'Loyal Customers'
            WHEN (recency_score + frequency_score + monetary_score) >= 7
                THEN 'Potential Loyalists'
            WHEN (recency_score + frequency_score + monetary_score) >= 4
                THEN 'At Risk'
            ELSE 'Lost'
        END AS segment
    FROM rfm_scores
)
SELECT
    segment,
    COUNT(*)                     AS customers_count,
    ROUND(AVG(monetary), 2)      AS avg_clv,
    ROUND(AVG(frequency), 1)     AS avg_orders,
    ROUND(SUM(monetary), 2)      AS total_revenue
FROM rfm_results
GROUP BY segment
ORDER BY avg_clv DESC;