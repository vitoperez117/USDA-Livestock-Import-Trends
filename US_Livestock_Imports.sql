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

--BIG PICTURE

--Number of Imports from each Country per Year
SELECT year_id, geography_desc, COUNT (commodity_desc) AS imports
FROM livestock_import
WHERE commodity_desc LIKE '%bovine%' OR commodity_desc LIKE '%beef%' 
OR commodity_desc LIKE '%veal%' OR commodity_desc LIKE '%cattle%' OR commodity_desc LIKE '%cow%'
AND commodity_desc NOT LIKE '%pork%' AND commodity_desc NOT LIKE '%swine%'
GROUP BY geography_desc, year_id
ORDER BY year_id;

--Identify Subclasses
CREATE VIEW subclasses AS
SELECT DISTINCT commodity_desc
FROM livestock_import;

--Remove Asterisk from commodity_desc column
UPDATE livestock_import SET commodity_desc = REPLACE(commodity_desc, '*', '')

--Create view for new clean table
CREATE VIEW main_table AS
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

--Country List
CREATE VIEW countries AS
SELECT DISTINCT geography_desc
FROM livestock_import;
--122 countries

--Units List
CREATE VIEW units AS
SELECT DISTINCT unit_desc
FROM livestock_import;
--CWE, DOZ, KG, NO

--Timeperiod List
CREATE VIEW timeperiods AS
SELECT DISTINCT timeperiod_id
FROM livestock_import;
-- 1-12 (months)

--Total Imports per Class per Month
SELECT geography_desc, year, month, item_class, SUM (amount) AS total_amount, unit_desc
FROM main_table
GROUP BY 1, 2, 3, 4, 6
ORDER BY 1, 2, 3, 6;

--Total Imports per Subclass per Month
SELECT year, month, subclass, SUM(amount) AS avg_amount, unit_desc
FROM main_table
GROUP BY year, month, subclass, unit_desc
ORDER BY 1, 2, 3, 5;

--Average Imports per Class per Year
SELECT year, item_class, AVG (amount) AS avg_amount, unit_desc
FROM main_table
GROUP BY year, item_class, unit_desc
ORDER BY 1, 2, 4;

--Total Imports per Class per Year
SELECT geography_desc, year, item_class,
SUM(amount) AS yearly_total,
unit_desc
FROM main_table
GROUP BY geography_desc, year, item_class, unit_desc
ORDER BY geography_desc;

--Max Imports per Class per Year
SELECT geography_desc, year, month, item_class,
MAX(amount) AS largest_import,
unit_desc
FROM main_table
GROUP BY geography_desc, year, month, item_class, unit_desc
ORDER BY year, month, geography_desc, item_class;


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
