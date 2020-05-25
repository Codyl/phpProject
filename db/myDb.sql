--CREATE DATABASE container_packaging;

/*
* Bins
* Can add flag for primary bin but 
*/
DROP TABLE IF EXISTS binsKy cascade;
CREATE TABLE binsKy (
  bin_id serial8,
  name varchar(12),
  is_pick_bin boolean,
  area varchar(1),
  row int,
  rack int,
  shelf_lvl int,
  CHECK (area = 'A' OR area = 'B'),
  CHECK (row > 0 AND row <= 15),
  CHECK (rack > 0 AND rack < 32),
  CHECK (shelf_lvl > 0 AND shelf_lvl < 8),
  PRIMARY KEY (bin_id)
);
--ALTER
-- ALTER TABLE bins
--INSERT
INSERT INTO binsKy (is_pick_bin, area, row, rack, shelf_lvl)
VALUES 
(false, 'A', 1, 1, 1),
(true,  'A', 1, 1, 2),
(false, 'A', 1, 1, 3),
(false, 'A', 1, 2, 1),
(false, 'A', 1, 2, 2),
(false, 'A', 1, 2, 3),
(false, 'B', 1, 1, 1),
(false, 'B', 1, 2, 1),
(false, 'A', 2, 1, 1),
(false, 'A', 2, 1, 2),
(false, 'A', 15, 1, 2),
(false, 'A', 15, 1, 3);

SELECT area, row, rack, shelf_lvl,
concat(area, ':', row, ':', rack, ':', shelf_lvl) AS name
FROM binsKy;

DROP TABLE IF EXISTS binsIdaho cascade;
CREATE TABLE binsIdaho (
  bin_id serial8,
  name varchar(12),
  is_pick_bin boolean,
  area varchar(1),
  row int,
  rack int,
  shelf_lvl int,
  CHECK (area = 'A' OR area = 'B'),
  CHECK (row > 0 AND row <= 15),
  CHECK (rack > 0 AND rack < 32),
  CHECK (shelf_lvl > 0 AND shelf_lvl < 8),
  PRIMARY KEY (bin_id)
);
--ALTER
-- ALTER TABLE bins
--INSERT
INSERT INTO binsIdaho (is_pick_bin, area, row, rack, shelf_lvl)
VALUES 
(false, 'A', 1, 1, 1),
(true,  'A', 1, 1, 2),
(false, 'A', 1, 1, 3),
(false, 'A', 1, 2, 1),
(false, 'A', 1, 2, 2),
(false, 'A', 1, 2, 3),
(false, 'B', 1, 1, 1),
(false, 'B', 1, 2, 1),
(false, 'A', 2, 1, 1),
(false, 'A', 2, 1, 2);

SELECT area, row, rack, shelf_lvl,
concat(area, ':', row, ':', rack, ':', shelf_lvl) AS name
FROM binsIdaho;
/*
*COUNTS
*/
DROP TABLE IF EXISTS countsKy cascade;
CREATE TABLE countsKy (
  counts_id serial8,
  count_date DATE,
  qty_start int,
  qty_end int,
  exceedsLimit boolean,
  PRIMARY KEY (counts_id)
);
--ALTER
--INSERT
INSERT INTO countsKy (count_date, qty_start, qty_end, exceedsLimit)
VALUES ('12/10/2019', 0, 100, false),
 ('12/21/2019', 100, 100, false),
 ('1/10/2018', 200, 0, false);

DROP TABLE IF EXISTS countsIdaho cascade;
CREATE TABLE countsIdaho (
  counts_id serial8,
  count_date DATE,
  qty_start int,
  qty_end int,
  exceedsLimit boolean,
  PRIMARY KEY (counts_id)
);
--ALTER
--INSERT
INSERT INTO countsIdaho (count_date, qty_start, qty_end, exceedsLimit)
VALUES ('12/10/2019', 0, 100, false),
 ('12/21/2019', 100, 100, false),
 ('1/10/2018', 200, 0, false);
/*
* ITEMS
*/
DROP TABLE IF EXISTS items cascade;
CREATE TABLE items (
  item_id serial8 NOT NULL,
  name varchar(100) NOT NULL UNIQUE,
  cost float8 NOT NULL,
  description varchar(100),
  qoh int NOT NULL,
  qty_avail int NOT NULL,
  case_qty int NOT NULL,
  case_lyr int NOT NULL,
  PRIMARY KEY (item_id)
);
--ALTER TABLE here

--INSERT data below here
INSERT INTO items(name, cost, qoh, qty_avail, case_qty, case_lyr)
VALUES 
('J071CL', 0.34, 18100, -100, 400, 4),
('G841AM', 0.91, 0    , 0   , 80, 10),
('DP600' , 0.51, 100  , 100 , 1200, 7),
('J115'  , 0.91, 20    , 0   , 40, 4),
('G040'  , 1.50, 250    , 0   , 12, 20),
('M653BK', 0.21, 400    , 0   , 180, 5),
('S400'  , 0.41, 900    , 0   , 1000, 7),
('J101'  , 0.95, 12    , 0   , 100, 7),
('M654BK', 0.50, 30    , 0   , 180, 5),
('M653WH', 0.55, 188  , 0   , 180, 5),
('B500'  , 2.50, 45   , 0   , 40, 2);
SELECT * FROM items;




--Check for pick bins
-- SELECT concat(area, ':', row, ':', rack, ':', shelf_lvl) AS bin, i.name AS stored_item, b.is_pick_bin FROM items AS i
-- JOIN itemList AS b
-- ON i.item_id = il.item_id
-- JOIN bins AS il
-- ON il.bin_id = b.bin_id
-- ORDER BY b.bin_id ASC;

DROP TABLE IF EXISTS itemsKy cascade;
CREATE TABLE itemsKy(
  id serial8,
  item_id int,
  counts_id int,
  PRIMARY KEY(id),
  CONSTRAINT fk_item_id FOREIGN KEY (item_id) REFERENCES items (item_id),
  CONSTRAINT fk_counts_id FOREIGN KEY (counts_id) REFERENCES countsKy (counts_id)
);

INSERT INTO itemsKy(item_id, counts_id)
VALUES
(1,1),(2,2);
INSERT INTO itemsKy(item_id)
VALUES
(3),(4),(5),(6),(7),(8),(9),(10),(11);

--Find all counts for items in ky
SELECT items.name, items.cost, (c.qty_end - c.qty_start) AS qty_change, (c.qty_end * items.cost - c.qty_start * items.cost) AS cost FROM countsKy AS c
JOIN itemsKy AS i
ON c.counts_id = i.counts_id
JOIN items
ON items.item_id = i.item_id
ORDER BY items.name DESC;

SELECT id, I.item_id, name FROM itemsKy AS IK
JOIN items AS I
ON I.item_id = IK.item_id;

DROP TABLE IF EXISTS itemsIdaho cascade;
CREATE TABLE itemsIdaho(
  id serial8,
  item_id int,
  counts_id int,
  PRIMARY KEY(id),
  CONSTRAINT fk_item_id FOREIGN KEY (item_id) REFERENCES items (item_id),
  CONSTRAINT fk_counts_id FOREIGN KEY (counts_id) REFERENCES countsIdaho (counts_id)
);

INSERT INTO itemsIdaho(item_id, counts_id)
VALUES
(1,3);
INSERT INTO itemsIdaho(item_id)
VALUES
(4),(5),(6),(7);

SELECT id, I.item_id, name FROM itemsIdaho AS II
JOIN items AS I
ON I.item_id = II.item_id;

--Find all counts for items in Idaho
SELECT items.name, items.cost, (c.qty_end - c.qty_start) AS qty_change, (c.qty_end * items.cost - c.qty_start * items.cost) AS cost FROM countsIdaho AS c
JOIN itemsIdaho AS i
ON c.counts_id = i.counts_id
JOIN items
ON items.item_id = i.item_id
ORDER BY items.name DESC;

--Allows for multiple bins per item
DROP TABLE IF EXISTS itemListKy;
CREATE TABLE itemListKy(
  id serial8,
  item_id int NOT NULL,
  bin_id int NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_bin_id FOREIGN KEY (bin_id) REFERENCES bins (bin_id),
  CONSTRAINT fk_item_id FOREIGN KEY (item_id) REFERENCES itemsKy (id)
);

INSERT INTO itemListKy(item_id, bin_id)
VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(1,6),(6,7),(2,8),(2,9),(4,1),(5,11),(5,2),(7,10),(8,12),(9,10),(10,11),(11,1);

DROP TABLE IF EXISTS itemListIdaho;
CREATE TABLE itemListIdaho(
  id serial8,
  item_id int NOT NULL,
  bin_id int NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_bin_id FOREIGN KEY (bin_id) REFERENCES bins (bin_id),
  CONSTRAINT fk_item_id FOREIGN KEY (item_id) REFERENCES itemsIdaho (id)
);

INSERT INTO itemListIdaho(item_id, bin_id)
VALUES
(1,1),(2,6),(3,2),(4,1),(5,1),(1,2);

--Create tables
DROP TABLE IF EXISTS warehouses;
CREATE TABLE warehouses (
  warehouse_id serial8 NOT NULL,
  name varchar(100),
  PRIMARY KEY (warehouse_id)
);

--ALTER
--INSERT
INSERT INTO warehouses (name)
VALUES ('Kentucky'),('Idaho');
--SELECT