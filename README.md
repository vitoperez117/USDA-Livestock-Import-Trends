# US Livestock Imports <img align="right" width="347" alt="USDA_ERS_logo" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/b956d243-a686-4a15-9d1c-57252aa97651">

Aggregation analysis of US Livestock imports from 122 countries from 1989 to 2023.

## Understanding the Data
 - Timeperiod_id column contains month numbers instead of names. Column name renamed to 'month'.
 - Identify subclasses.
 - Identify unique countries.
 - Identify units and their relationship with subclasses. 
    - Subclasses are measured in kilograms (KG), carcass weight equivalent in pounds (CWE), dozens (DOZ), and number of discrete units (NO).

<img width="1187" alt="Livestock_orig_table_screenshot" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/153619d5-9d30-4ad5-86c4-1192a15d38e9">

## Data Cleaning
 - Remove asterisk (*) from names of some subclasses.
 - Drop columns that have redundant information (source_id, hs_code, geography_code, attribute_desc) and rename columns for readability (year_id as 'year', timeperiod_id as 'month', commodity_desc as 'subclass')
 - Creating new Class column using a case statement to classify subclasses into general categories (Beef, Live Cattle, Pork, Live Hogs, Poultry, Lamb, Goats, Eggs, Mixed, Other).
 - Create a view with new Class column and renamed columns. 

<img width="1187" alt="Livestock_main_table_screenshot" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/74ca7a56-cd7b-4387-9852-7a0f7f1502d3">

## Data Aggregation
 - Monthly Average per Class per Country
 - Monthly Average per Subclass per Country
 - Total Amount per Month per Class per Country
 - Total Amount per Year per Class per Country
 - Max Imports per Month per Class per Country

#### SOURCE DATA

[Data](https://www.ers.usda.gov/data-products/livestock-and-meat-international-trade-data/livestock-and-meat-international-trade-data/#Zipped%20CSV%20files) used comes in a zip file with 2 CSVs (one for imports and one for exports).

#### UNITS

[Conversion Tables](https://www.census.gov/foreign-trade/guide/sec4.html)

Most units used in the dataset are commonly known (e.g. kilogram, dozen, number of discrete units). [CWE](https://www.ers.usda.gov/data-products/food-availability-per-capita-data-system/glossary/#:~:text=2%2C150.42%20cubic%20inches.-,Carcass%2Dweight%20equivalent%20(CWE),weight%20may%20or%20may%20not) (carcass weight equivalent) is less commonly known and is measured in kilograms.
