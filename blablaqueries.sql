SELECT 
    (SELECT COUNT(*) FROM ElfEmployee)
  + (SELECT COUNT(*) FROM Santa)
    AS total_personnel;




-- wie viele schichten haben die elfen jeweils gearbeitet
SELECT 
    e.elf_id,
    e.name AS elf_name,
    COUNT(s.shift_id) AS shifts_worked
FROM ElfEmployee e
LEFT JOIN Shift s ON e.elf_id = s.elf_id
WHERE s.start_time BETWEEN '2024-12-01' AND '2024-12-31'
GROUP BY e.elf_id, e.name
ORDER BY shifts_worked DESC;


-- wie viele deliveries ham die reindeers
SELECT 
    r.reindeer_id,
    r.name AS reindeer_name,
    COUNT(d.delivery_id) AS deliveries_handled
FROM Reindeer r
LEFT JOIN ReindeerDelivery d 
    ON r.reindeer_id = d.reindeer_id
GROUP BY r.reindeer_id, r.name
ORDER BY deliveries_handled DESC;

-- most valuable costumer
SELECT 
    c.customer_id,
    c.name AS customer_name,
    SUM(o.total_price) AS total_spent,
    COUNT(o.order_id) AS order_count
FROM Customer c
JOIN `Order` o ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;


-- top Performing products

SELECT 
    p.product_id,
    p.name AS product_name,
    SUM(oi.quantity * oi.price) AS total_revenue,
    SUM(oi.quantity) AS units_sold
FROM OrderItem oi
JOIN Product p ON oi.product_id = p.product_id
JOIN `Order` o ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.name
ORDER BY total_revenue DESC;

