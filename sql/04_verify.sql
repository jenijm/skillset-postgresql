DO $$
DECLARE
    user_count INTEGER;
    product_count INTEGER;
    order_count INTEGER;
    order_item_count INTEGER;
    invalid_reference_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO user_count FROM users;
    SELECT COUNT(*) INTO product_count FROM products;
    SELECT COUNT(*) INTO order_count FROM orders;
    SELECT COUNT(*) INTO order_item_count FROM order_items;

    IF user_count < 3 THEN
        RAISE EXCEPTION 'Expected at least 3 users, found %', user_count;
    END IF;

    IF product_count < 4 THEN
        RAISE EXCEPTION 'Expected at least 4 products, found %', product_count;
    END IF;

    IF order_count < 4 THEN
        RAISE EXCEPTION 'Expected at least 4 orders, found %', order_count;
    END IF;

    IF order_item_count < 6 THEN
        RAISE EXCEPTION 'Expected at least 6 order items, found %', order_item_count;
    END IF;

    SELECT COUNT(*) INTO invalid_reference_count
    FROM order_items AS oi
    LEFT JOIN orders AS o ON o.order_id = oi.order_id
    LEFT JOIN products AS p ON p.product_id = oi.product_id
    WHERE o.order_id IS NULL OR p.product_id IS NULL;

    IF invalid_reference_count > 0 THEN
        RAISE EXCEPTION 'Found % invalid order item references', invalid_reference_count;
    END IF;
END
$$;

SELECT
    (SELECT COUNT(*) FROM users) AS users,
    (SELECT COUNT(*) FROM products) AS products,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items,
    (
        SELECT SUM(oi.quantity * p.price)::NUMERIC(12, 2)
        FROM order_items AS oi
        JOIN products AS p ON p.product_id = oi.product_id
    ) AS total_revenue;

\echo 'VERIFICATION PASSED'
