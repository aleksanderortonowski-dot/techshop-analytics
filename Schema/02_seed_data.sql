-- ============================================================
-- TechShop Polska — Dane testowe
-- Uruchom po 01_ddl.sql
-- ============================================================

-- ============================================================
-- KLIENCI (10)
-- ============================================================

INSERT INTO customers (email, full_name, country, segment) VALUES
    ('anna.kowalska@gmail.com',   'Anna Kowalska',   'PL', 'vip'),
    ('john.smith@example.com',    'John Smith',       'GB', 'regular'),
    ('maria.garcia@email.es',     'Maria Garcia',     'ES', 'new'),
    ('jan.nowak@firma.pl',        'Jan Nowak',        'PL', 'regular'),
    ('emma.mueller@gmail.de',     'Emma Mueller',     'DE', 'vip'),
    ('pierre.dubois@email.fr',    'Pierre Dubois',    'FR', 'regular'),
    ('hiroshi.tanaka@example.jp', 'Hiroshi Tanaka',   'JP', 'vip'),
    ('olga.petrenko@gmail.com',   'Olga Petrenko',    'UA', 'new'),
    ('carlos.silva@email.br',     'Carlos Silva',     'BR', 'regular'),
    ('sophie.lefebvre@mail.ca',   'Sophie Lefebvre',  'CA', 'vip');

-- ============================================================
-- PRODUKTY (15)
-- ============================================================

INSERT INTO products (name, category, price, stock_qty) VALUES
    ('iPhone 15 Pro',        'Smartfony',  4999.99,  50),
    ('MacBook Air M2',       'Laptopy',    5999.00,  30),
    ('AirPods Pro',          'Audio',       999.00, 200),
    ('Samsung Galaxy S24',   'Smartfony',  3799.00,  75),
    ('Logitech MX Master',   'Akcesoria',   599.99, 150),
    ('Kindle Paperwhite',    'Czytniki',    599.00, 100),
    ('Sony WH-1000XM5',      'Audio',      1599.00,  80),
    ('iPad Air M2',          'Tablety',    2999.00,  60),
    ('Dyson V15 Detect',     'AGD',        3499.00,  25),
    ('GoPro Hero 12',        'Kamery',     2199.00,  40),
    ('Apple Watch Series 9', 'Wearables',  1999.00,  90),
    ('Samsung 4K TV 55"',    'TV',         3299.00,  35),
    ('Bose SoundLink',       'Audio',       699.00, 120),
    ('Nintendo Switch OLED', 'Konsole',    1499.00,  60),
    ('Kindle Scribe',        'Czytniki',   1399.00,   0);

-- ============================================================
-- ZAMÓWIENIA (60+)
-- ============================================================

-- Pierwsze 5 (z zajęć 1)
INSERT INTO orders (customer_id, status, total_amount, ordered_at) VALUES
    (1, 'completed', 5998.99, NOW() - INTERVAL '30 days'),
    (1, 'completed',  999.00, NOW() - INTERVAL '15 days'),
    (2, 'pending',   3799.00, NOW() - INTERVAL '2 days'),
    (3, 'cancelled', 4999.99, NOW() - INTERVAL '60 days'),
    (4, 'completed', 6598.99, NOW() - INTERVAL '45 days');

-- Kolejne 10 (z zadania domowego 1)
INSERT INTO orders (customer_id, status, total_amount, ordered_at) VALUES
    ( 6, 'completed',  599.00, NOW() - INTERVAL '20 days'),
    ( 7, 'completed', 1599.00, NOW() - INTERVAL '10 days'),
    ( 8, 'pending',   2999.00, NOW() - INTERVAL '1 day'),
    ( 9, 'cancelled', 3499.00, NOW() - INTERVAL '25 days'),
    (10, 'completed', 2199.00, NOW() - INTERVAL '5 days'),
    ( 1, 'refunded',   999.00, NOW() - INTERVAL '50 days'),
    ( 2, 'completed',  599.99, NOW() - INTERVAL '8 days'),
    ( 3, 'pending',   4999.99, NOW() - INTERVAL '3 days'),
    ( 5, 'completed', 5999.00, NOW() - INTERVAL '12 days'),
    ( 4, 'cancelled', 1599.00, NOW() - INTERVAL '40 days');

-- Duży blok historyczny (różne miesiące i kwartały)
INSERT INTO orders (customer_id, status, total_amount, ordered_at) VALUES
    ( 1, 'completed', 1999.00, NOW() - INTERVAL '170 days'),
    ( 2, 'completed', 3299.00, NOW() - INTERVAL '165 days'),
    ( 3, 'completed',  699.00, NOW() - INTERVAL '160 days'),
    ( 4, 'completed', 1499.00, NOW() - INTERVAL '155 days'),
    ( 5, 'completed', 2199.00, NOW() - INTERVAL '150 days'),
    ( 6, 'completed', 5999.00, NOW() - INTERVAL '145 days'),
    ( 7, 'completed',  999.00, NOW() - INTERVAL '140 days'),
    ( 8, 'completed', 4999.99, NOW() - INTERVAL '135 days'),
    ( 9, 'completed', 1599.00, NOW() - INTERVAL '130 days'),
    (10, 'completed', 2999.00, NOW() - INTERVAL '125 days'),
    ( 1, 'completed',  599.00, NOW() - INTERVAL '120 days'),
    ( 2, 'completed', 3799.00, NOW() - INTERVAL '115 days'),
    ( 3, 'cancelled', 1499.00, NOW() - INTERVAL '110 days'),
    ( 4, 'completed', 3299.00, NOW() - INTERVAL '105 days'),
    ( 5, 'completed',  699.00, NOW() - INTERVAL '100 days'),
    ( 6, 'completed', 1999.00, NOW() - INTERVAL  '95 days'),
    ( 7, 'pending',   2199.00, NOW() - INTERVAL  '90 days'),
    ( 8, 'completed', 5999.00, NOW() - INTERVAL  '85 days'),
    ( 9, 'completed',  999.00, NOW() - INTERVAL  '80 days'),
    (10, 'refunded',  1599.00, NOW() - INTERVAL  '75 days'),
    ( 1, 'completed', 4999.99, NOW() - INTERVAL  '70 days'),
    ( 2, 'completed', 1399.00, NOW() - INTERVAL  '68 days'),
    ( 3, 'completed', 2999.00, NOW() - INTERVAL  '65 days'),
    ( 4, 'completed',  599.99, NOW() - INTERVAL  '62 days'),
    ( 5, 'completed', 3799.00, NOW() - INTERVAL  '60 days'),
    ( 6, 'cancelled', 3299.00, NOW() - INTERVAL  '58 days'),
    ( 7, 'completed', 1499.00, NOW() - INTERVAL  '55 days'),
    ( 8, 'completed',  699.00, NOW() - INTERVAL  '52 days'),
    ( 9, 'completed', 1999.00, NOW() - INTERVAL  '48 days'),
    (10, 'completed', 5999.00, NOW() - INTERVAL  '44 days'),
    ( 1, 'completed',  999.00, NOW() - INTERVAL  '40 days'),
    ( 2, 'pending',   2199.00, NOW() - INTERVAL  '36 days'),
    ( 3, 'completed', 4999.99, NOW() - INTERVAL  '33 days'),
    ( 4, 'completed', 1599.00, NOW() - INTERVAL  '29 days'),
    ( 5, 'completed', 1399.00, NOW() - INTERVAL  '26 days'),
    ( 6, 'completed', 2999.00, NOW() - INTERVAL  '22 days'),
    ( 7, 'completed',  599.99, NOW() - INTERVAL  '18 days'),
    ( 8, 'refunded',  3799.00, NOW() - INTERVAL  '15 days'),
    ( 9, 'completed', 3299.00, NOW() - INTERVAL  '11 days'),
    (10, 'completed',  699.00, NOW() - INTERVAL   '9 days'),
    ( 1, 'completed', 1499.00, NOW() - INTERVAL   '7 days'),
    ( 2, 'completed', 1999.00, NOW() - INTERVAL   '5 days'),
    ( 3, 'pending',   5999.00, NOW() - INTERVAL   '4 days'),
    ( 4, 'completed',  999.00, NOW() - INTERVAL   '2 days'),
    ( 5, 'completed', 2199.00, NOW() - INTERVAL   '1 day');

-- ============================================================
-- POZYCJE ZAMÓWIEŃ
-- ============================================================

-- Pozycje dla zamówień 1–5 (ręczne)
INSERT INTO order_items (order_id, product_id, qty, unit_price) VALUES
    (1, 1, 1, 4999.99),
    (1, 3, 1,  999.00),
    (2, 3, 1,  999.00),
    (3, 4, 1, 3799.00),
    (4, 1, 1, 4999.99),
    (5, 2, 1, 5999.00),
    (5, 5, 1,  599.99);

-- Pozycje dla zamówień 16+ (generowane automatycznie)
INSERT INTO order_items (order_id, product_id, qty, unit_price)
SELECT
    o.order_id,
    p.product_id,
    1 + (o.order_id % 2)        AS qty,
    p.price                      AS unit_price
FROM orders o
JOIN products p ON p.product_id = 1 + (o.order_id % 15)
WHERE o.order_id > 15;

INSERT INTO order_items (order_id, product_id, qty, unit_price)
SELECT
    o.order_id,
    p.product_id,
    1                            AS qty,
    p.price                      AS unit_price
FROM orders o
JOIN products p ON p.product_id = 1 + ((o.order_id + 5) % 15)
WHERE o.order_id > 15
  AND o.order_id % 2 = 0;

-- ============================================================
-- RECENZJE
-- ============================================================

INSERT INTO reviews (order_id, customer_id, product_id, rating, comment) VALUES
    (1, 1, 1, 5, 'Świetny telefon, polecam! Bateria trzyma cały dzień.'),
    (2, 1, 3, 4, 'Dobre słuchawki, ANC działa rewelacyjnie, ale cena wysoka.'),
    (5, 4, 2, 5, 'MacBook genialny — cichy, szybki, świetna matryca.'),
    (5, 4, 5, 4, 'Solidna myszka, dużo przycisków konfigurowalnych.'),
    (1, 1, 3, 3, NULL);