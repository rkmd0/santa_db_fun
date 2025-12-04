-- =========================
-- SANTA
-- =========================
INSERT INTO Santa (name, email)
VALUES 
('Santa Claus', 'santa@northpole.com');

-- =========================
-- ROLES
-- =========================
INSERT INTO Role (role_name)
VALUES 
('Toy Engineer'),
('Cookie Baker'),
('Gift Wrapper'),
('Sleigh Mechanic'),
('Quality Inspector');

-- =========================
-- ELF EMPLOYEES
-- =========================
INSERT INTO ElfEmployee (name, email, hire_date, role_id, supervisor_id)
VALUES
('Buddy Elf', 'buddy@northpole.com', '2018-11-12', 1, 1),
('Jingle Tinsel', 'jingle@northpole.com', '2019-10-05', 2, 1),
('Sparkle Snow', 'sparkle@northpole.com', '2020-09-20', 3, 1),
('Twinkle Frost', 'twinkle@northpole.com', '2017-12-01', 4, 1),
('Peppermint Stick', 'peppermint@northpole.com', '2021-01-15', 5, 1);

-- =========================
-- SHIFTS
-- =========================
INSERT INTO Shift (elf_id, start_time, end_time)
VALUES
(1, '2024-12-01 08:00:00', '2024-12-01 16:00:00'),
(2, '2024-12-01 08:00:00', '2024-12-01 16:00:00'),
(3, '2024-12-01 10:00:00', '2024-12-01 18:00:00'),
(4, '2024-12-02 08:00:00', '2024-12-02 16:00:00'),
(5, '2024-12-02 12:00:00', '2024-12-02 20:00:00');

-- =========================
-- PRODUCTS
-- =========================
INSERT INTO Product (name, description, price, is_gluten_free, is_seasonal)
VALUES
('Chocolate Chip Cookies', 'Fresh baked holiday cookies', 4.99, 0, 1),
('Gingerbread House Kit', 'Everything needed to build a small house', 14.99, 1, 1),
('Magic Reindeer Dust', 'Helps reindeer fly stronger', 9.49, 1, 1),
('Toy Train Deluxe', 'A premium toy train with lights', 29.99, 1, 0),
('Plush Snowman', 'Soft and cuddly snowman plush', 12.99, 1, 0),
('Candy Cane Pack', 'Pack of 10 red & white candy canes', 3.49, 0, 1);

-- =========================
-- INGREDIENTS
-- =========================
INSERT INTO Ingredient (name, is_allergen)
VALUES
('Flour', 1),
('Sugar', 0),
('Chocolate', 0),
('Ginger Spice', 0),
('Marshmallow', 0),
('Corn Syrup', 0);

-- =========================
-- PRODUCT INGREDIENTS
-- =========================
INSERT INTO ProductIngredient (product_id, ingredient_id)
VALUES
-- Chocolate Chip Cookies
(1, 1),
(1, 2),
(1, 3),

-- Gingerbread House Kit
(2, 1),
(2, 2),
(2, 4),

-- Candy Cane Pack
(6, 2),
(6, 6);

-- =========================
-- CUSTOMERS
-- =========================
INSERT INTO Customer (name, email, address)
VALUES
('Kevin McCallister', 'kevin@homealone.com', '671 Lincoln Ave'),
('Cindy Lou Who', 'cindy@whoville.com', '3 Who Street'),
('Frosty The Snowman', 'frosty@snow.com', 'Frozen Forest 12'),
('Ebenezer Scrooge', 'scrooge@london.uk', '221B Christmas Lane');

-- =========================
-- ORDERS
-- =========================
INSERT INTO `Order` (customer_id, order_date, total_price, status)
VALUES
(1, '2024-12-10', 19.98, 'Processing'),
(2, '2024-12-11', 29.98, 'Delivered'),
(3, '2024-12-12', 12.99, 'Shipped'),
(4, '2024-12-13', 44.98, 'Processing');

-- =========================
-- ORDER ITEMS
-- =========================
INSERT INTO OrderItem (order_id, product_id, quantity, price)
VALUES
-- Order 1: Kevin
(1, 1, 2, 4.99),

-- Order 2: Cindy Lou
(2, 2, 2, 14.99),

-- Order 3: Frosty
(3, 5, 1, 12.99),

-- Order 4: Scrooge
(4, 4, 1, 29.99),
(4, 6, 2, 3.49);

-- =========================
-- REINDEER
-- =========================
INSERT INTO Reindeer (name, age, can_fly_in_snowstorm)
VALUES
('Rudolph', 5, 1),
('Dasher', 7, 1),
('Dancer', 6, 1),
('Prancer', 8, 1),
('Vixen', 5, 0);

-- =========================
-- REINDEER DELIVERIES
-- =========================
INSERT INTO ReindeerDelivery (order_id, reindeer_id, departure_time, arrival_time, delivery_status)
VALUES
(2, 1, '2024-12-11 18:00:00', '2024-12-11 20:30:00', 'Delivered'),
(3, 2, '2024-12-12 19:00:00', NULL, 'In Transit');

-- =========================
-- WAREHOUSE
-- =========================
INSERT INTO NorthPoleWarehouse (location, manager_name)
VALUES
('Main North Pole Storage', 'Winterberry Frost'),
('South Pole Backup Depot', 'Chilly McFreeze');

-- =========================
-- WAREHOUSE INVENTORY
-- =========================
INSERT INTO WarehouseInventory (warehouse_id, ingredient_id, quantity)
VALUES
-- Main Warehouse
(1, 1, 500),
(1, 2, 300),
(1, 3, 150),
(1, 4, 200),

-- Backup Depot
(2, 1, 100),
(2, 2, 80),
(2, 6, 60);
