INSERT INTO Santa (name, email) VALUES
('Santa Claus', 'santa@northpole.com'),
('Satan', 'mrs.claus@northpole.com');
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
('Holiday Spirit Manager');


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
('Nut-Free Crunch', 'Crunch cookie without allergens', 2.00, 1, 1);


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
('Vegan chocolate', 0);


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
('Chris Crystal', 'chris.kristall@example.com', 'Cold Path 51');


INSERT INTO Reindeer (name, age, can_fly_in_snowstorm) VALUES
('Frosthorn', 4, 1),
('Silverhoof', 9, 1),
('Blizzardhorn', 3, 0),
('Crystalwing', 10, 1),
('Snowglider', 7, 1),
('Thunderhoof', 6, 0),
('Icejumper', 5, 1),
('Stormrunner', 11, 1),
('Whisperwind', 4, 0),
('Glownose', 2, 1);


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
('Warehouse K', 'Mila Hatwind');


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
('Chippy Cheer', 'chippy@northpole.com', '2022-03-14', 3, 1);


INSERT INTO Shift (elf_id, start_time, end_time) VALUES
(5, '2024-12-02 08:00', '2024-12-02 16:00'),
(6, '2024-12-02 09:00', '2024-12-02 18:00'),
(7, '2024-12-02 10:00', '2024-12-02 19:00'),
(8, '2024-12-03 08:00', '2024-12-03 16:00'),
(9, '2024-12-03 09:00', '2024-12-03 18:00'),
(10, '2024-12-03 10:00', '2024-12-03 19:00'),
(3, '2024-12-04 08:00', '2024-12-04 16:00'),
(4, '2024-12-04 09:00', '2024-12-04 18:00'),
(2, '2024-12-04 10:00', '2024-12-04 19:00'),
(1, '2024-12-05 08:00', '2024-12-05 16:00');


INSERT INTO `Order` (customer_id, order_date, total_price, status, rating_stars, rating_text) VALUES
(4, '2024-12-08', 4.20, 'completed', 5, 'Great!'),
(5, '2024-12-09', 7.60, 'completed', 4, 'Very good.'),
(6, '2024-12-10', 14.50, 'delivered', 3, 'Quite okay'),
(7, '2024-12-11', 6.00, 'in_progress', NULL, NULL),
(8, '2024-12-12', 9.90, 'completed', 5, 'Super tasty!'),
(9, '2024-12-13', 11.20, 'delivered', 4, 'Tastes good.'),
(10, '2024-12-14', 8.40, 'cancelled', NULL, NULL),
(1, '2024-12-15', 3.10, 'completed', 5, 'Wonderful gift'),
(2, '2024-12-16', 5.70, 'in_progress', NULL, NULL),
(3, '2024-12-17', 12.80, 'completed', 5, 'Very festive!');


INSERT INTO OrderItem (order_id, product_id, quantity, price) VALUES
(4, 2, 1, 1.20),
(4, 3, 1, 12.00),
(5, 5, 2, 2.90),
(6, 8, 1, 1.80),
(7, 1, 3, 2.50),
(8, 10, 2, 2.00),
(9, 4, 1, 3.00),
(10, 6, 2, 3.10),
(11, 7, 1, 2.20),
(12, 9, 1, 2.70);


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
(13, 10);


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
(13, 1, '2024-12-17 14:00', NULL, 'in_transit');


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
(9, 7, 500);
