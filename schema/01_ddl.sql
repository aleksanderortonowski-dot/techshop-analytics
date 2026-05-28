-- ============================================================
-- TechShop Polska — Schemat bazy danych
-- Uruchom jako PIERWSZY (przed seed_data)
-- ============================================================

CREATE TABLE customers (
    customer_id  SERIAL         PRIMARY KEY,
    email        VARCHAR(255)   NOT NULL UNIQUE,
    full_name    VARCHAR(120),
    country      VARCHAR(60)    DEFAULT 'PL',
    segment      VARCHAR(30)    DEFAULT 'regular'
                 CHECK (segment IN ('vip', 'regular', 'new')),
    phone        VARCHAR(20),
    created_at   TIMESTAMP      DEFAULT NOW()
);

CREATE TABLE products (
    product_id   SERIAL         PRIMARY KEY,
    name         VARCHAR(300)   NOT NULL,
    category     VARCHAR(80),
    price        DECIMAL(10,2)  NOT NULL CHECK (price >= 0),
    stock_qty    INT            DEFAULT 0 CHECK (stock_qty >= 0),
    weight_kg    DECIMAL(5,2),
    created_at   TIMESTAMP      DEFAULT NOW()
);

CREATE TABLE orders (
    order_id         SERIAL         PRIMARY KEY,
    customer_id      INT            NOT NULL REFERENCES customers(customer_id),
    status           VARCHAR(30)    DEFAULT 'pending'
                     CHECK (status IN ('pending','completed','cancelled','refunded')),
    total_amount     DECIMAL(12,2)  CHECK (total_amount >= 0),
    ordered_at       TIMESTAMP      DEFAULT NOW(),
    updated_at       TIMESTAMP      DEFAULT NOW(),
    shipping_address TEXT
);

CREATE TABLE order_items (
    item_id     SERIAL         PRIMARY KEY,
    order_id    INT            NOT NULL REFERENCES orders(order_id),
    product_id  INT            NOT NULL REFERENCES products(product_id),
    qty         INT            NOT NULL CHECK (qty > 0),
    unit_price  DECIMAL(10,2)  NOT NULL CHECK (unit_price >= 0)
);

CREATE TABLE reviews (
    review_id   SERIAL    PRIMARY KEY,
    order_id    INT       NOT NULL REFERENCES orders(order_id),
    customer_id INT       NOT NULL REFERENCES customers(customer_id),
    product_id  INT       NOT NULL REFERENCES products(product_id),
    rating      INT       CHECK (rating BETWEEN 1 AND 5),
    comment     TEXT,
    created_at  TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- Indeksy
-- ============================================================

CREATE INDEX idx_orders_status
    ON orders(status);

CREATE INDEX idx_orders_customer_status
    ON orders(customer_id, status);

CREATE INDEX idx_orders_customer_ordered_at
    ON orders(customer_id, ordered_at DESC);

CREATE INDEX idx_reviews_product_id
    ON reviews(product_id);

CREATE INDEX idx_reviews_rating
    ON reviews(rating);

CREATE INDEX idx_customers_country
    ON customers(country);

-- ============================================================
-- Trigger: automatyczna aktualizacja updated_at w orders
-- ============================================================

CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

-- ============================================================
-- BONUS: Widok z podsumowaniem segmentów RFM
-- ============================================================

CREATE OR REPLACE VIEW rfm_summary AS
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
            WHEN (recency_score + frequency_score + monetary_score) >= 13 THEN 'Champions'
            WHEN (recency_score + frequency_score + monetary_score) >= 10 THEN 'Loyal Customers'
            WHEN (recency_score + frequency_score + monetary_score) >= 7  THEN 'Potential Loyalists'
            WHEN (recency_score + frequency_score + monetary_score) >= 4  THEN 'At Risk'
            ELSE 'Lost'
        END AS segment
    FROM rfm_scores
)
SELECT
    segment,
    COUNT(*)                 AS customers_count,
    ROUND(AVG(monetary), 2)  AS avg_clv,
    ROUND(AVG(frequency), 1) AS avg_orders,
    ROUND(SUM(monetary), 2)  AS total_revenue
FROM rfm_results
GROUP BY segment
ORDER BY avg_clv DESC;