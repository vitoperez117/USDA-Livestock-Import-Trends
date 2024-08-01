--SOURCE DATA
'https://www.ers.usda.gov/data-products/livestock-and-meat-international-trade-data/livestock-and-meat-international-trade-data/#Zipped%20CSV%20files'

--Units
'https://www.census.gov/foreign-trade/guide/sec4.html'

--Create Table
CREATE TABLE livestock_import (
	source_id int,
	hs_code bigint,
	commodity_desc varchar,
	geography_code int,
	geography_desc varchar,
	attribute_desc varchar,
	unit_desc varchar,
	year_id int,
	timeperiod_id int,	
	amount int);

--Import CSV
COPY livestock_import (
	source_id,
	hs_code,
	commodity_desc,
	geography_code,
	geography_desc,
	attribute_desc,
	unit_desc,
	year_id,
	timeperiod_id,	
	amount)
FROM '/Users/vito/Documents/Data_2024/LivestockMeatTrade/csv_files/LivestockMeat_Imports.csv'
DELIMITER ','
CSV HEADER;

--UNDERSTANDING THE DATA--

--Identify Subclasses
--CREATE VIEW subclasses AS
SELECT DISTINCT commodity_desc
FROM livestock_import;

--Remove Asterisk from Subclasses column
UPDATE livestock_import SET commodity_desc = REPLACE(commodity_desc, '*', '')

--Identify all Countries 
--CREATE VIEW countries AS
SELECT DISTINCT geography_desc
FROM livestock_import;
--122 countries

--Identify all Units
--CREATE VIEW units AS
SELECT DISTINCT unit_desc
FROM livestock_import;
--CWE, DOZ, KG, NO

--Identify all Timeperiods
--CREATE VIEW timeperiods AS
SELECT DISTINCT timeperiod_id
FROM livestock_import;
-- 1-12 (months)

--Number of Unique Import Types from each Country per Year
SELECT year_id, geography_desc, COUNT (commodity_desc) AS imports
FROM livestock_import
GROUP BY geography_desc, year_id
ORDER BY year_id;

--Group Subclasses into general Classes 
--CREATE VIEW main_table AS
SELECT geography_desc, year_id AS year, timeperiod_id AS month, 
CASE
		--MIX
		WHEN commodity_desc ~* 'pork' AND commodity_desc ~* 'beef'
		THEN 'Mixed'
		--BEEF
		WHEN commodity_desc ~* 'bovine' OR commodity_desc ~* 'beef' 
		OR commodity_desc ~* 'veal' OR commodity_desc ~* 'cow'
		THEN 'Beef'
        WHEN commodity_desc ~* 'cattle'
        THEN 'Live Cattle'
		--PORK
		WHEN commodity_desc ~* 'pork' OR commodity_desc ~* 'swine' OR commodity_desc ~* 'bacon'
		OR commodity_desc ~* 'ham'
		THEN 'Pork'
        WHEN commodity_desc ~* 'hog'
        THEN 'Live Hogs'
		--LAMB
		WHEN commodity_desc ~* 'lamb' OR commodity_desc ~* 'sheep' OR commodity_desc ~* 'mutton'
		THEN 'Lamb'
		--GOAT
		WHEN commodity_desc ~* 'goat'
		THEN 'Goat'
		--POULTRY
		WHEN commodity_desc ~* 'chicken' OR commodity_desc ~* 'poultry' 
		OR commodity_desc ~* 'turkey' OR commodity_desc ~* 'broiler'
		THEN 'Poultry'
		--EGGS
		WHEN commodity_desc ~* 'egg'
		THEN 'Eggs'
		ELSE 'Other'
	END AS item_class,
	commodity_desc AS subclass, amount, unit_desc
FROM livestock_import;

--Confirming if 'World' is just a total of all countries's amounts--
SELECT item_class, SUM(amount)
FROM main_table
WHERE geography_desc='World' -- totals for World only
GROUP BY item_class;

SELECT item_class, SUM(amount)
FROM main_table
WHERE NOT geography_desc='World' -- totals without World
GROUP BY item_class;

--Delete rows where geography_desc = 'World'
CREATE TABLE imports_no_world AS 
SELECT * FROM main_table; --295323 rows

DELETE FROM imports_no_world
WHERE geography_desc='World'; --213003 rows



--BASIC ANALYSIS--

--Total Imports per Class per Month
SELECT geography_desc, year, month, item_class, SUM (amount) AS total_amount, unit_desc
FROM main_table
GROUP BY 1, 2, 3, 4, 6
ORDER BY 1, 2, 3, 6;

--Total Imports per Subclass per Month
SELECT year, month, subclass, SUM(amount) AS total__amount, unit_desc
FROM main_table
GROUP BY year, month, subclass, unit_desc
ORDER BY 1, 2, 3, 5;

--Average Imports per Class per Year
SELECT year, item_class, AVG (amount) AS avg_amount, unit_desc
FROM main_table
GROUP BY year, item_class, unit_desc
ORDER BY 1, 2, 4;

--Average Imports per Subclass per Year
SELECT year, subclass, AVG (amount) AS avg_amount, unit_desc
FROM main_table
GROUP BY year, subclass, unit_desc
ORDER BY 1, 2, 4;


--Sort Data by Units

-- KG (Kilograms)
SELECT year, item_class, SUM (amount) AS total_amount, unit_desc
FROM main_table
WHERE unit_desc ~* 'KG' 
GROUP BY year, item_class, unit_desc
ORDER BY 1, 2, 4;

--CWE (Carcass Weight Equivalent)
SELECT year, item_class, SUM (amount) AS total_amount, unit_desc
FROM main_table
WHERE unit_desc ~* 'CWE'
GROUP BY year, item_class, unit_desc
ORDER BY 1, 2, 4;

--NO (Number of individual units)
SELECT year, item_class, SUM (amount) AS total_amount, unit_desc
FROM main_table
WHERE unit_desc ~* 'NO'
GROUP BY year, item_class, unit_desc
ORDER BY 1, 2, 4;

--DOZ (Dozen)
SELECT year, item_class, SUM (amount) AS total_amount, unit_desc
FROM main_table
WHERE unit_desc ~* 'DOZ'
GROUP BY year, item_class, unit_desc
ORDER BY 1, 2, 4;

--Export Main Table to CSV for use in Tableau

-- First, transform the main view to a table
-- create a copy of the result of main_table view
CREATE TABLE main_import_table AS SELECT * FROM main_table;

-- redefine view_a to its own result
CREATE OR REPLACE VIEW main_table AS SELECT * FROM main_import_table;
