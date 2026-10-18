BEGIN;

-- Password values are demonstration hash strings, never plaintext passwords.
INSERT INTO users (user_id, username, email, password, created_at)
VALUES
    (1, 'anita', 'anita@example.com', '$2b$12$demoHashForAnitaNotARealPassword', '2026-01-10 09:00:00'),
    (2, 'rahul', 'rahul@example.com', '$2b$12$demoHashForRahulNotARealPassword', '2026-01-12 10:30:00'),
    (3, 'maya', 'maya@example.com', '$2b$12$demoHashForMayaNotARealPassword', '2026-01-15 14:15:00')
ON CONFLICT (user_id) DO UPDATE SET
    username = EXCLUDED.username,
    email = EXCLUDED.email,
    password = EXCLUDED.password,
    created_at = EXCLUDED.created_at;

INSERT INTO products (product_id, name, description, price, created_at)
VALUES
    (1, 'Laptop', 'Lightweight laptop with 16 GB RAM and 512 GB SSD.', 899.99, '2026-01-20 08:00:00'),
    (2, 'Wireless Mouse', 'Ergonomic wireless mouse with USB receiver.', 24.99, '2026-01-20 08:05:00'),
    (3, 'Mechanical Keyboard', 'Compact mechanical keyboard with tactile switches.', 79.50, '2026-01-20 08:10:00'),
    (4, '27-inch Monitor', 'Full HD IPS monitor with adjustable stand.', 229.00, '2026-01-20 08:15:00')
ON CONFLICT (product_id) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    created_at = EXCLUDED.created_at;

INSERT INTO orders (order_id, user_id, order_date)
VALUES
    (1, 1, '2026-02-01 10:00:00'),
    (2, 2, '2026-02-03 11:30:00'),
    (3, 1, '2026-02-05 15:45:00'),
    (4, 3, '2026-02-08 09:20:00')
ON CONFLICT (order_id) DO UPDATE SET
    user_id = EXCLUDED.user_id,
    order_date = EXCLUDED.order_date;

INSERT INTO order_items (order_item_id, order_id, product_id, quantity)
VALUES
    (1, 1, 1, 1),
    (2, 1, 2, 2),
    (3, 2, 3, 1),
    (4, 3, 4, 1),
    (5, 3, 2, 1),
    (6, 4, 3, 2)
ON CONFLICT (order_item_id) DO UPDATE SET
    order_id = EXCLUDED.order_id,
    product_id = EXCLUDED.product_id,
    quantity = EXCLUDED.quantity;

SELECT setval(pg_get_serial_sequence('users', 'user_id'), (SELECT MAX(user_id) FROM users));
SELECT setval(pg_get_serial_sequence('products', 'product_id'), (SELECT MAX(product_id) FROM products));
SELECT setval(pg_get_serial_sequence('orders', 'order_id'), (SELECT MAX(order_id) FROM orders));
SELECT setval(pg_get_serial_sequence('order_items', 'order_item_id'), (SELECT MAX(order_item_id) FROM order_items));

COMMIT;
