CREATE OR REPLACE VIEW vw_invoice_header AS
SELECT
    o.order_id AS invoice_id,
    o.order_date AS invoice_date,
    c.customer_id,
    c.name AS customer_name,
    c.email AS customer_email,
    c.address AS customer_address,
    o.total_price AS invoice_total,
    o.status AS invoice_status,
    o.rating_stars,
    o.rating_text,
    
    rd.reindeer_id,
    r.name AS reindeer_name,
    rd.departure_time,
    rd.arrival_time,
    rd.delivery_status
FROM `Order` o
JOIN Customer c
    ON o.customer_id = c.customer_id
LEFT JOIN ReindeerDelivery rd
    ON o.order_id = rd.order_id
LEFT JOIN Reindeer r
    ON r.reindeer_id = rd.reindeer_id;



CREATE OR REPLACE VIEW vw_invoice_items AS
SELECT
    oi.order_id AS invoice_id,
    p.product_id,
    p.name AS item_name,
    oi.quantity,
    oi.price AS unit_price,
    (oi.quantity * oi.price) AS line_total
FROM OrderItem oi
JOIN Product p
    ON oi.product_id = p.product_id;
