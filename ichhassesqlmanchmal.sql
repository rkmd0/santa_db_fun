-- Tim Lehmann 20251060
-- Eva Langstein 20251061
-- Felix Disselkamp 20251059
-- Erkam Dogan 20251017
-- Anne Staskiewicz 20251002

CREATE DATABASE santa_and_co_kg;

USE santa_and_co_kg;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS WarehouseInventory;
DROP TABLE IF EXISTS ReindeerDelivery;
DROP TABLE IF EXISTS ProductIngredient;
DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS Shift;
DROP TABLE IF EXISTS ElfEmployee;
DROP TABLE IF EXISTS NorthPoleWarehouse;
DROP TABLE IF EXISTS Reindeer;
DROP TABLE IF EXISTS Ingredient;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS Santa;
DROP TABLE IF EXISTS log;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================
--  BASE-TABLES
-- =========================

CREATE TABLE Santa (
    santa_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Role (
    role_id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_name     VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Product (
    product_id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(150) NOT NULL,
    description      TEXT,
    price            DECIMAL(10,2) NOT NULL,
    is_gluten_free   TINYINT(1) NOT NULL DEFAULT 0,
    is_vegan 		 TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE Ingredient (
    ingredient_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(150) NOT NULL,
    is_allergen    TINYINT(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE Customer (
    customer_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(255) NOT NULL UNIQUE,
    address       VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Reindeer (
    reindeer_id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name                   VARCHAR(100) NOT NULL,
    age                    INT NOT NULL,
    can_fly_in_snowstorm   TINYINT(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE NorthPoleWarehouse (
    warehouse_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    location       VARCHAR(150) NOT NULL,
    manager_name   VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- =========================
--  ELVES AND SHIFTS
-- =========================

CREATE TABLE ElfEmployee (
    elf_id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    email          VARCHAR(255) NOT NULL UNIQUE,
    hire_date      DATE NOT NULL,
    role_id        INT UNSIGNED NOT NULL,
    supervisor_id  INT UNSIGNED NOT NULL,
    CONSTRAINT fk_elf_role
        FOREIGN KEY (role_id) REFERENCES Role(role_id),
    CONSTRAINT fk_elf_supervisor_santa
        FOREIGN KEY (supervisor_id) REFERENCES Santa(santa_id)
) ENGINE=InnoDB;

CREATE TABLE Shift (
    shift_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    elf_id       INT UNSIGNED NOT NULL,
    start_time   DATETIME NOT NULL,
    end_time     DATETIME NOT NULL,
    CONSTRAINT fk_shift_elf
        FOREIGN KEY (elf_id) REFERENCES ElfEmployee(elf_id)
) ENGINE=InnoDB;

-- =========================
--  ORDERS
-- =========================

CREATE TABLE `Order` (
    order_id      INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT UNSIGNED NOT NULL,
    order_date    DATE NOT NULL,
    total_price   DECIMAL(10,2),
    status        ENUM("in_progress", "completed", "cancelled"),
    rating_stars  TINYINT,
    rating_text   TEXT,
    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT rating_stars
        CHECK(rating_stars BETWEEN 0 AND 5)
) ENGINE=InnoDB;


CREATE TABLE OrderItem (
    order_item_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id       INT UNSIGNED NOT NULL,
    product_id     INT UNSIGNED NOT NULL,
    quantity       INT NOT NULL,
    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    CONSTRAINT fk_orderitem_product
        FOREIGN KEY (product_id) REFERENCES Product(product_id)
) ENGINE=InnoDB;

-- =======================================
--  RELATIONS OF PRODUCTS AND INGREDIGENTS
-- =======================================

CREATE TABLE ProductIngredient (
    product_id     INT UNSIGNED NOT NULL,
    ingredient_id  INT UNSIGNED NOT NULL,
    PRIMARY KEY (product_id, ingredient_id),
    CONSTRAINT fk_productingredient_product
        FOREIGN KEY (product_id) REFERENCES Product(product_id),
    CONSTRAINT fk_productingredient_ingredient
        FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id)
) ENGINE=InnoDB;

-- =========================
--  REINDEER DELIVERIES
-- =========================

CREATE TABLE ReindeerDelivery (
    delivery_id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id          INT UNSIGNED NOT NULL,
    reindeer_id       INT UNSIGNED NOT NULL,
    departure_time    DATETIME NOT NULL,
    arrival_time      DATETIME NULL,
    delivery_status   VARCHAR(50) NOT NULL,
    CONSTRAINT fk_delivery_order
        FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    CONSTRAINT fk_delivery_reindeer
        FOREIGN KEY (reindeer_id) REFERENCES Reindeer(reindeer_id),
    UNIQUE KEY uq_delivery_order (order_id)
) ENGINE=InnoDB;

-- =========================
--  WAREHOUSE INVENTORY
-- =========================

CREATE TABLE WarehouseInventory (
    inventory_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    warehouse_id   INT UNSIGNED NOT NULL,
    ingredient_id  INT UNSIGNED NOT NULL,
    quantity       INT NOT NULL,
    CONSTRAINT fk_inventory_warehouse
        FOREIGN KEY (warehouse_id) REFERENCES NorthPoleWarehouse(warehouse_id),
    CONSTRAINT fk_inventory_ingredient
        FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id),
    UNIQUE KEY uq_inventory_wh_ingredient (warehouse_id, ingredient_id)
) ENGINE=InnoDB;

CREATE TABLE log(
	log_id	INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usr		VARCHAR(100),
    ts		DATETIME,
    ev		VARCHAR(100)
) ENGINE=InnoDB;

ALTER TABLE `Order` AUTO_INCREMENT = 4;




-- Trigger to calculate the total price for each order

DELIMITER $$

CREATE TRIGGER calc_price_after_insert
AFTER INSERT ON OrderItem
FOR EACH ROW
BEGIN
    UPDATE `Order`
    SET total_price = (
        SELECT SUM(oi.quantity * p.price)
        FROM OrderItem oi
        JOIN Product p ON oi.product_id = p.product_id
        WHERE oi.order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END$$

DELIMITER ;

-- =========================
--  INSERTS
-- =========================

INSERT INTO Santa (name, email) VALUES
('Santa Claus', 'santa@northpole.com'),
('Satan', 'mrs.claus@northpole.com'),
('Nikolaus North', 'nikolaus@northpole.com'),
('Old Saint Nick', 'oldnick@northpole.com');


INSERT INTO Role (role_name) VALUES
('Snow Sculptor'),
('Candy Designer'),
('Workshop Technician'),
('Gingerbread Architect'),
('Toy QA Specialist'),
('Magic Engineer'),
('Logistics Coordinator'),
('Stable Cleaner'),
('Gift Wrapper'),
('Holiday Spirit Manager'),
('Ice Logistics Planner'),
('Toy Painter'),
('Snow Quality Inspector');


INSERT INTO Product (name, description, price, is_gluten_free, is_vegan) VALUES
('Polar Cookie', 'Crunchy winter cookie', 2.10, 0, 0),
('Snowflake Cupcake', 'Sweet cupcake with icing', 3.50, 0, 0),
('Ice Crystal Candy', 'Transparent sugar crystals', 1.70, 1, 1),
('Candy Cane XXL', 'Extra large candy cane', 2.40, 1, 1),
('Winter Brownie', 'Moist chocolate brownie', 2.90, 0, 0),
('Elf Snack Bites', 'Vegan mini snacks', 3.10, 1, 1),
('Reindeer Oats', 'Oat cookies for athletic reindeer', 2.20, 1, 1),
('Frost Marshmallows', 'Fluffy marshmallow candy', 1.80, 1, 0),
('Choco Snow Bomb', 'Chocolate dream sphere', 2.70, 0, 0),
('Aurora Mint Shards', 'Cooling crystalline mint candy inspired by the northern lights.', 2.30, 1, 1),
('Elf Energy Bar', 'A nutrient-packed oat-free vegan bar that keeps elves energized.', 2.90, 1, 1),
('Starlight Ginger Crunch', 'A festive ginger cookie with a magical golden sparkle.', 2.50, 1, 1),
('Nut-Free Crunch', 'Crunch cookie without allergens', 2.00, 1, 1),
('Frozen Berry Chews', 'Chewy berry candy from the arctic', 2.60, 1, 1),
('Milk Snow Drops', 'Creamy snow-white drops', 2.20, 1, 0),
('Peppermint Slabs', 'Strong mint candy plates', 2.90, 1, 1);


INSERT INTO Ingredient (name, is_allergen) VALUES
('Oats', 0),
('Vanilla flavoring', 0),
('Cocoa', 1),
('Honey', 0),
('Walnut', 1),
('Hazelnut', 1),
('Coconut flakes', 0),
('Powdered sugar', 0),
('Almonds', 1),
('Vegan chocolate', 0),
('Peppermint oil', 0),
('Milk powder', 1),
('Berry extract', 0);


INSERT INTO Customer (name, email, address) VALUES
('Sofie Snow', 'sofie.snow@example.com', 'Frost Road 9'),
('Peter Polar', 'peter.polar@example.com', 'Winter Avenue 21'),
('Kira Crystal', 'kira.k@example.com', 'Iceberg Street 5'),
('Leo Blizzard', 'leo.blizzard@example.com', 'North Slope 88'),
('Mia Frostwind', 'mia.frost@example.com', 'Icicle Ring 122'),
('Tommy Tundra', 'tommy.tundra@example.com', 'Tundra Road 3'),
('Ella Icestar', 'ella.eisstern@example.com', 'Polar Street 44'),
('Ben Snow', 'ben.schnee@example.com', 'Christmas Road 11'),
('Nora Winterchild', 'nora.winter@example.com', 'Snow Chain 70'),
('Chris Crystal', 'chris.kristall@example.com', 'Cold Path 51'),
('Luna Snowfall', 'luna.snow@example.com', 'Aurora Lane 6'),
('Oliver Icewind', 'oliver.ice@example.com', 'Glacier Way 18'),
('Freya Northstar', 'freya.star@example.com', 'Polar Circle 1');


INSERT INTO Reindeer (name, age, can_fly_in_snowstorm) VALUES
('Frosthorn', 4, 1),
('Sven', 9, 1),
('Blizzardhorn', 3, 0),
('Crystalwing', 10, 1),
('Snowglider', 7, 1),
('Thunderhoof', 6, 0),
('Icejumper', 5, 1),
('Stormrunner', 11, 1),
('Whisperwind', 4, 0),
('Rudolph', 2, 1),
('Aurorastep', 6, 1),
('Frostdash', 8, 1),
('Shadowfax', 5, 0);


INSERT INTO NorthPoleWarehouse (location, manager_name) VALUES
('West Hall C', 'Elvira Ice'),
('East Hall D', 'Frosti Flash'),
('South Hall E', 'Eli Cutter'),
('North Hall F', 'Gloria Glitz'),
('Central Hall G', 'Floria Frost'),
('Warehouse H1', 'Nando North'),
('Warehouse H2', 'Tilda Tundra'),
('Warehouse I', 'Berta Blizzard'),
('Warehouse J', 'Kuno Crystal'),
('Elsas Palace', 'Elsa'),
('Ice Tunnel K', 'Hilda Hoarfrost'),
('Crystal Dome L', 'Oscar Aurora');


INSERT INTO ElfEmployee (name, email, hire_date, role_id, supervisor_id) VALUES
('Sparky Snow', 'sparky@northpole.com', '2018-12-01', 3, 1),
('Glitty Shine', 'glitty@northpole.com', '2020-05-11', 2, 1),
('Mimi Frosty', 'mimi@northpole.com', '2019-03-05', 4, 1),
('Tikki Twirl', 'tikki@northpole.com', '2021-07-12', 6, 2),
('Zuzu Zing', 'zuzu@northpole.com', '2022-09-22', 5, 2),
('Poppy Pizz', 'poppy@northpole.com', '2023-01-10', 7, 1),
('Nelly Nimbus', 'nelly@northpole.com', '2017-02-19', 8, 1),
('Dodo Dazzle', 'dodo@northpole.com', '2016-04-01', 9, 2),
('Blinky Bling', 'blinky@northpole.com', '2021-11-11', 10, 1),
('Chippy Cheer', 'chippy@northpole.com', '2022-03-14', 3, 1),
('Lilli Spark', 'lilli@northpole.com', '2024-02-01', 1, 1),
('Bobo Mint', 'bobo@northpole.com', '2023-08-15', 2, 2),
('Rina Glow', 'rina@northpole.com', '2022-10-10', 5, 1);


INSERT INTO Shift (elf_id, start_time, end_time) VALUES
(5,  '2023-12-02 08:00', '2023-12-02 16:00'),
(6,  '2023-12-02 09:00', '2023-12-02 18:00'),
(7,  '2023-12-02 10:00', '2023-12-02 19:00'),
(8,  '2023-12-03 08:00', '2023-12-03 16:00'),
(9,  '2024-12-03 09:00', '2024-12-03 18:00'),
(10, '2024-12-03 10:00', '2024-12-03 19:00'),
(3,  '2024-12-04 08:00', '2024-12-04 16:00'),
(4,  '2024-12-04 09:00', '2024-12-04 18:00'),
(2,  '2024-12-04 10:00', '2024-12-04 19:00'),
(1,  '2025-12-05 08:00', '2025-12-05 16:00'),
(11, '2025-12-06 08:00', '2025-12-06 16:00'),
(12, '2025-12-06 09:00', '2025-12-06 18:00'),
(13, '2025-12-07 10:00', '2025-12-07 19:00'),
(1, '2024-12-10 08:00', '2024-12-10 16:00'),
(1, '2024-12-15 08:00', '2024-12-15 16:00'),
(1, '2024-12-20 08:00', '2024-12-20 16:00'),
(2, '2024-12-11 10:00', '2024-12-11 19:00'),
(2, '2024-12-18 10:00', '2024-12-18 19:00'),
(2, '2024-12-28 10:00', '2024-12-28 19:00'),
(3, '2024-12-12 08:00', '2024-12-12 16:00'),
(3, '2024-12-18 08:00', '2024-12-18 16:00'),
(3, '2024-12-30 08:00', '2024-12-30 16:00'),
(4, '2024-12-13 09:00', '2024-12-13 18:00'),
(2, '2024-12-19 09:00', '2024-12-19 18:00'),
(4, '2024-12-27 09:00', '2024-12-27 18:00'),
(5, '2024-12-14 08:00', '2024-12-14 16:00'),
(5, '2024-12-20 08:00', '2024-12-20 16:00'),
(5, '2024-12-29 08:00', '2024-12-29 16:00'),
(6, '2024-12-10 09:00', '2024-12-10 18:00'),
(6, '2024-12-17 09:00', '2024-12-17 18:00'),
(6, '2024-12-25 09:00', '2024-12-25 18:00'),
(7, '2024-12-08 10:00', '2024-12-08 19:00'),
(7, '2024-12-15 10:00', '2024-12-15 19:00'),
(7, '2024-12-22 10:00', '2024-12-22 19:00'),
(8, '2024-12-05 08:00', '2024-12-05 16:00'),
(8, '2024-12-12 08:00', '2024-12-12 16:00'),
(8, '2024-12-19 08:00', '2024-12-19 16:00'),
(9, '2024-12-06 09:00', '2024-12-06 18:00'),
(9, '2024-12-13 09:00', '2024-12-13 18:00'),
(9, '2024-12-21 09:00', '2024-12-21 18:00'),
(10, '2024-12-07 10:00', '2024-12-07 19:00'),
(10, '2024-12-14 10:00', '2024-12-14 19:00'),
(10, '2024-12-23 10:00', '2024-12-23 19:00');


INSERT INTO `Order` (customer_id, order_date, total_price, status, rating_stars, rating_text) VALUES
(4, '2023-12-08', NULL, 'completed', 5, 'Great!'),
(5, '2023-12-09', NULL, 'completed', 4, 'Very good.'),
(6, '2023-12-10', NULL, 'completed', 3, 'Quite okay'),
(7, '2023-12-11', NULL, 'completed', 2, 'Bad'),
(8, '2023-12-12', NULL, 'completed', 5, 'Super tasty!'),
(9, '2024-12-13', NULL, 'completed', 4, 'Tastes good.'),
(10, '2024-12-14', NULL, 'cancelled', NULL, NULL),
(1, '2024-12-15', NULL, 'completed', 5, 'Wonderful gift'),
(2, '2024-12-16', NULL, 'completed', 5, 'Very festive'),
(3, '2025-12-15', NULL, 'in_progress', NULL, NULL),
(4, '2024-12-16', NULL, 'completed', 3, 'Average.'),
(6, '2025-12-17', NULL, 'in_progress', NULL, NULL),
(11, '2025-12-18', NULL, 'in_progress', NULL, NULL),
(12, '2025-12-19', NULL, 'in_progress', NULL, NULL),
(13, '2025-12-20', NULL, 'in_progress', NULL, NULL),
(1,  '2025-12-18', NULL, 'in_progress', NULL, NULL),
(2,  '2025-12-18', NULL, 'in_progress', NULL, NULL),
(3,  '2025-12-18', NULL, 'in_progress', NULL, NULL),
(4,  '2024-12-19', NULL, 'completed', 2, 'I did not like it.'),
(5,  '2025-12-19', NULL, 'in_progress', NULL, NULL),
(6,  '2025-12-20', NULL, 'in_progress', NULL, NULL),
(7,  '2025-12-20', NULL, 'in_progress', NULL, NULL),
(8,  '2025-12-21', NULL, 'in_progress', NULL, NULL);


INSERT INTO OrderItem (order_id, product_id, quantity) VALUES
(4, 2, 1),
(4, 3, 4),
(5, 5, 2),
(6, 8, 1),
(7, 1, 3),
(8, 10, 2),
(9, 4, 1),
(10, 6, 2),
(11, 7, 1),
(12, 9, 1),
(13, 12, 4),
(14, 14, 2),
(15, 15, 2),
(16, 16, 1),
(17, 1, 2),
(17, 3, 1),
(18, 4, 2),
(18, 10, 1),
(18, 6, 1),
(19, 2, 1),
(20, 5, 1),
(20, 9, 1),
(20, 3, 2),
(21, 6, 1),
(21, 4, 1),
(21, 3, 1),
(22, 11, 2),
(22, 7, 1),
(22, 10, 1),
(23, 4, 1),
(23, 3, 2),
(24, 12, 1),
(24, 6, 1),
(24, 3, 2),
(25, 1, 1),
(25, 3, 1),
(25, 8, 1),
(26, 9, 2),
(26, 10, 1),
(26, 3, 1);


INSERT INTO ProductIngredient (product_id, ingredient_id) VALUES
(5, 3),
(6, 5),
(7, 1),
(7, 7),
(8, 8),
(9, 3),
(10, 7),
(11, 9),
(12, 6),
(13, 10),
(14, 13),
(15, 12),
(16, 11);


INSERT INTO ReindeerDelivery (order_id, reindeer_id, departure_time, arrival_time, delivery_status) VALUES
(4, 3, '2024-12-08 18:00', '2024-12-08 22:00', 'arrived'),
(5, 5, '2024-12-09 19:00', NULL, 'in_transit'),
(6, 6, '2024-12-10 17:00', '2024-12-10 21:00', 'arrived'),
(7, 7, '2024-12-11 16:30', NULL, 'in_transit'),
(8, 8, '2024-12-12 20:00', '2024-12-13 00:30', 'arrived'),
(9, 9, '2024-12-13 21:00', NULL, 'in_transit'),
(10, 10, '2024-12-14 15:00', NULL, 'cancelled'),
(11, 2, '2024-12-15 18:00', '2024-12-15 23:00', 'arrived'),
(12, 4, '2024-12-16 19:00', NULL, 'in_transit'),
(13, 1, '2024-12-17 14:00', NULL, 'in_transit'),
(14, 11, '2025-12-18 18:00', '2025-12-18 22:00', 'arrived'),
(15, 12, '2025-12-19 19:00', NULL, 'in_transit'),
(16, 13, '2025-12-20 17:00', NULL, 'in_transit');


INSERT INTO WarehouseInventory (warehouse_id, ingredient_id, quantity) VALUES
(3, 4, 150),
(3, 1, 250),
(4, 2, 300),
(4, 5, 100),
(5, 8, 400),
(5, 3, 120),
(6, 10, 200),
(7, 9, 350),
(8, 6, 220),
(9, 7, 500),
(11, 11, 180),
(12, 12, 260),
(11, 13, 300);

-- Trigger which sets the status to completed after a rating was done.
DELIMITER $$

CREATE TRIGGER update_status
BEFORE UPDATE ON `Order`
FOR EACH ROW
BEGIN
    IF NEW.rating_stars IS NOT NULL THEN
        SET NEW.status = 'completed';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

-- Fill log table after an order has been added.
CREATE TRIGGER update_log
AFTER INSERT ON `Order`
FOR EACH ROW
BEGIN
    INSERT INTO log(usr, ts, ev)
    VALUES (user(), NOW(), 'add');
END$$

DELIMITER ;

-- =========================
--  VIEWS
-- =========================

CREATE OR REPLACE VIEW invoice_header AS
SELECT
    o.order_id AS invoice_id,
    o.order_date AS invoice_date,
    c.name AS customer_name,
    c.email AS customer_email,
    c.address AS customer_address,
    o.total_price AS invoice_total
FROM `Order` o
JOIN Customer c
    ON o.customer_id = c.customer_id;

CREATE OR REPLACE VIEW invoice_items AS
SELECT
    oi.order_id AS invoice_id,
    p.product_id,
    p.name AS item_name,
    oi.quantity,
    p.price AS unit_price,
    (oi.quantity * p.price) AS line_total
FROM OrderItem oi
JOIN Product p
    ON oi.product_id = p.product_id;
    
    

    
-- Average rating of customer Leo Blizzard
SELECT c.name, AVG(rating_stars) as average_rating 
FROM customer c
JOIN `Order` as o ON o.customer_id = c.customer_id
WHERE c.customer_id = 4 and o.rating_stars IS NOT NULL
group by c.customer_id;

-- Which product brought the most income?
SELECT 
    p.product_id,
    p.name AS product_name,
    SUM(o.total_price) AS total_sales,
    SUM(oi.quantity) AS units_sold
FROM OrderItem oi
JOIN Product p ON oi.product_id = p.product_id
JOIN `Order` o ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id
ORDER BY total_sales DESC;

-- How many shifts has the elves worked and who is the top performer?
SELECT 
    e.elf_id,
    e.name AS elf_name,
    COUNT(s.shift_id) AS shifts_worked
FROM ElfEmployee e
JOIN Shift s ON e.elf_id = s.elf_id
WHERE s.start_time BETWEEN '2024-12-01' AND '2024-12-31'
GROUP BY e.elf_id, e.name
ORDER BY shifts_worked DESC;

-- Which reindeers can fly in snowstorm?
SELECT r.name
FROM reindeer r
WHERE r.can_fly_in_snowstorm = 1;

-- Count of total employees.
SELECT
    (SELECT COUNT(*) FROM ElfEmployee) +
    (SELECT COUNT(*) FROM Santa) +
    (SELECT COUNT(*) FROM Reindeer) AS total_employees;



    




