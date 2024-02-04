# US Livestock Imports
Aggregation analysis of US Livestock imports from 122 countries from 1989 to 2023.

## Understanding the Data
 - Timeperiod_id column contains month numbers instead of names. Column name renamed to 'month'.
 - Identify subclasses.
 - Identify unique countries.
 - Identify units and their relationship with subclasses. 
    - Subclasses are measured in kilograms (KG), carcass weight equivalent in pounds (CWE), dozens (DOZ), and number of discrete units (NO).

## Data Cleaning
 - Remove asterisk (*) from names of some subclasses.
 - Creating new Class column to classify subclasses into general categories (Beef, Live Cattle, Pork, Live Hogs, Poultry, Lamb, Goats, Eggs, Mixed, Other).
   
#### SOURCE DATA
https://www.ers.usda.gov/data-products/livestock-and-meat-international-trade-data/livestock-and-meat-international-trade-data/#Zipped%20CSV%20files
Data used comes in a zip file with 2 CSVs (one for imports and one for exports).

#### Units
https://www.census.gov/foreign-trade/guide/sec4.html
Most units used in the dataset are commonly known (e.g. kilogram, dozen, number of discrete units). [CWE]([url](https://www.ers.usda.gov/data-products/food-availability-per-capita-data-system/glossary/#:~:text=2%2C150.42%20cubic%20inches.-,Carcass%2Dweight%20equivalent%20(CWE),weight%20may%20or%20may%20not)) (carcass weight equivalent) is less commonly known and is measured in kilograms).
