-- OPTIONAL: create & select database
-- CREATE DATABASE northpole;
-- USE northpole;

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

SET FOREIGN_KEY_CHECKS = 1;

-- =========================
--  BASIS-TABELLEN
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
--  ELFEN & SCHICHTEN
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
--  BESTELLUNGEN & POSITIONEN
-- =========================

CREATE TABLE `Order` (
    order_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT UNSIGNED NOT NULL,
    order_date    DATE NOT NULL,
    total_price   DECIMAL(10,2) NOT NULL,
    status        VARCHAR(50) NOT NULL,
	rating_stars  INT,
    rating_text   TEXT,
    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
	CONSTRAINT rating_stars
		CHECK(rating_stars between 0 and 5)
) ENGINE=InnoDB;

CREATE TABLE OrderItem (
    order_item_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id       INT UNSIGNED NOT NULL,
    product_id     INT UNSIGNED NOT NULL,
    quantity       INT NOT NULL,
    price          DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    CONSTRAINT fk_orderitem_product
        FOREIGN KEY (product_id) REFERENCES Product(product_id)
) ENGINE=InnoDB;

-- =========================
--  PRODUKT–ZUTAT-BEZIEHUNGEN
-- =========================

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
--  RENTIER-LIEFERUNGEN
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
--  LAGERBESTAND
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

-- =========================
--  INDEXE
-- =========================

CREATE INDEX idx_elf_role ON ElfEmployee(role_id);
CREATE INDEX idx_elf_supervisor ON ElfEmployee(supervisor_id);
CREATE INDEX idx_shift_elf ON Shift(elf_id);

CREATE INDEX idx_order_customer ON `Order`(customer_id);
CREATE INDEX idx_order_date ON `Order`(order_date);

CREATE INDEX idx_orderitem_order ON OrderItem(order_id);
CREATE INDEX idx_orderitem_product ON OrderItem(product_id);

CREATE INDEX idx_productingredient_ingredient ON ProductIngredient(ingredient_id);

CREATE INDEX idx_delivery_order ON ReindeerDelivery(order_id);
CREATE INDEX idx_delivery_reindeer ON ReindeerDelivery(reindeer_id);

CREATE INDEX idx_inventory_warehouse ON WarehouseInventory(warehouse_id);
CREATE INDEX idx_inventory_ingredient ON WarehouseInventory(ingredient_id);
