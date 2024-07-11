# US Livestock Imports <img align="right" width="295" alt="USDA_ERS_logo" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/b956d243-a686-4a15-9d1c-57252aa97651">

Aggregation analysis of US Livestock imports from 122 countries from 1989 to 2023.

## Understanding the Data
1. **Month Column**: The month column is called 'Timeperiod_id column'. Instead of month names, it contains month numbers. Column name renamed to 'month'.
2. **Categories**: There are 221 categories of livestock and livestock products.

<img width="350" alt="Livestock_subclasses_ss" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/5d658631-7544-4554-a083-da4cf65464a9">

3. **Countries**: 122 (except the category 'World')
    - '**World**' denotes the combined data of all countries.

4. **Units of Measurement and their relationship with Categories**
    - Categories are measured in kilograms (KG), carcass weight equivalent in pounds (CWE), dozens (DOZ), and number of discrete units (NO).

**Original Table**
    <img width="1000" alt="Livestock_orig_table_screenshot" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/153619d5-9d30-4ad5-86c4-1192a15d38e9">

## Data Cleaning
 1. Remove asterisk (*) from the names of some classes.
 2. Drop columns that have redundant information (source_id, hs_code, geography_code, attribute_desc).
 3. Creating new Class column using a case statement to group 221 categories into 9 general classes which I labelled 'item_class'
     - Beef, Live Cattle, Pork, Live Hogs, Poultry, Lamb, Goats, Eggs, Mixed, Other
 4. Rename columns for readability (year_id as '**year**', timeperiod_id as '**month**', commodity_desc as '**subclass**').
 5. Create a view with new Class column and renamed columns ("main_table").

<img width="1000" alt="Livestock_main_table_screenshot" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/74ca7a56-cd7b-4387-9852-7a0f7f1502d3">

## Data Aggregation
1. Monthly Total and Average Amount per Class per Country
   <img width="800" alt="Livestock_monthly_total_avg_class" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/e82e27a3-3b68-47f6-ac57-fde227e9d12c">

2. Yearly Total Amount per Class per Country

   <img width="650" alt="Livestock_yearly_total_class" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/20f0a069-7e2b-4b85-9914-6d09221c786d">

3. Max Imports per Month per Class per Country
   <img width="650" alt="Livestock_max_month_class" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/11eeb560-302b-437e-84d1-02f82f78c7a2">


#### SOURCE DATA

[Data](https://www.ers.usda.gov/data-products/livestock-and-meat-international-trade-data/livestock-and-meat-international-trade-data/#Zipped%20CSV%20files) used comes in a zip file with 2 CSVs (one for imports and one for exports).

#### UNITS

[Conversion Tables](https://www.census.gov/foreign-trade/guide/sec4.html)

Most units used in the dataset are commonly known (e.g. kilogram, dozen, number of discrete units). [CWE](https://www.ers.usda.gov/data-products/food-availability-per-capita-data-system/glossary/#:~:text=2%2C150.42%20cubic%20inches.-,Carcass%2Dweight%20equivalent%20(CWE),weight%20may%20or%20may%20not) (carcass weight equivalent) is the weight of meat cuts and meat products converted to an equivalent weight of a dressed carcass. Includes bone, fat, tendons, ligaments, and inedible trimmings.
