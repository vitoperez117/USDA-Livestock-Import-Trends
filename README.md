# US Livestock Imports <img align="right" width="295" alt="USDA_ERS_logo" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/b956d243-a686-4a15-9d1c-57252aa97651">

Aggregation analysis of US Livestock imports from 122 countries from 1989 to 2023. Using Tableau, we can identify current and historical trends regarding types of livestock and livestock product imports and the countries from which US companies make purchases.

Data cleaning and aggregation were done with PostgreSQL. The finalized table was exported from SQL into a CSV with Python (SQLAlchemy). The CSV was imported into Tableau to build the final dashboard.


[<img width="800" alt="Livestock_subclasses_ss" src="https://github.com/vitoperez117/USDA-Livestock-Import-Trends/blob/main/assets/Tableau%20Screenshot.png">](https://public.tableau.com/views/USLivestockImports1989-2023/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Analysis
The USDA records various types of Livestock and Meat products with different units of measurement. To get an overview of import trends, quantities for each class (Beef, Pork, Lamb, Poultry, Eggs, Goat, Live Cattle, Live Hogs, Mixed, and Other) are aggregated irrespective of unit of measurement. However, data can still be filtered by unit of measurement in the final dashboard.

[Total Imports per Year](https://public.tableau.com/views/USLivestockImports/TotalperYear?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
Beef products overwhelmingly outnumber other imports. Pork comes in a distant second followed by significantly smaller volumes of Lamb and Poultry. Eggs, Mixed meats, products classified as 'Other', and live cattle and hogs place much lower in comparison. Depending on the product, this may suggest low demand or high domestic production.

[Import Volume per Country](https://public.tableau.com/views/USLivestockImports/VolumeandClassperCountry?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
In order of import size aggregated from 1989-2023, the top 10 sources are Canada, Australia, New Zealand, Mexico, Brazil, Denmark, Uruguay, Argentina, Nicaragua, Poland. 

[Imports by Type](https://public.tableau.com/views/USLivestockImports/TotalImportsperCountrybyYear?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link).
Examining product types, throughout the year the bulk of US imports are trimmed beef, pork, and lamb carcasses. Imports seem to observe seasonality, rising from March - August and dipping from September - February. More research is required to determine whether supply, demand, or other factors account for seasonality.


## Understanding the Data 
[Original USDA Data](https://drive.google.com/file/d/1uGs3EEyieEX6ZCbTax34iqJTpnM8ZdLS/view?usp=sharing)
1. **Rows**: There are 295,323 entries containing country of origin, year, month, import type, import amount, and unit of measurement.
2. **Categories**: There are 221 categories of livestock and livestock products. Later, these categories will be grouped into general classes (Beef, Live Cattle, Pork, Live Hogs, Poultry, Lamb, Goats, Eggs, Mixed, Other).

   

<img width="350" alt="Livestock_subclasses_ss" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/5d658631-7544-4554-a083-da4cf65464a9">

3. **Countries**: 122 (except the category 'World')
    - '**World**' denotes the combined data of all countries.
    - The dataset contains countries that no longer exist or had a name change (ex. Czechoslovakia, Federal Republic of Germany, Myanmar (Burma), USSR, Yugoslavia).

4. **Units of Measurement and their relationship with Categories**
    - Categories are measured in kilograms (KG), carcass weight equivalent in pounds (CWE), dozens (DOZ), and number of discrete units (NO).

**Original Table**
    <img width="1000" alt="Livestock_orig_table_screenshot" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/153619d5-9d30-4ad5-86c4-1192a15d38e9">


## Data Cleaning
[Cleaned Data](https://drive.google.com/file/d/1gPZ-5N-VlTjc0LpxBJl9MkR9mD7LjXof/view?usp=sharing) 
 1. Remove asterisk (*) from the names of some classes.
 2. Drop columns with impertinent information (source_id, hs_code, geography_code, attribute_desc).
 3. Drop rows for 'World' because those contain the sum of all imports from all countries.
 4. Rename/reassign countries to their current (closest) territorial boundaries.
 5. Create new Class column using a CASE statement to group 221 categories into 9 general classes which I labelled 'item_class'.
 6. Rename columns for readability (year_id as '**year**', timeperiod_id as '**month**', geography_desc as '**country**', commodity_desc as '**subclass**').
 7. Create a view with new Class column and renamed columns ("main_table").

<img width="1000" alt="Livestock_main_table_screenshot" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/74ca7a56-cd7b-4387-9852-7a0f7f1502d3">

## Data Aggregation
1. Monthly Total and Average Amount per Class per Country
   <img width="800" alt="Livestock_monthly_total_avg_class" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/e82e27a3-3b68-47f6-ac57-fde227e9d12c">

2. Yearly Total Amount per Class per Country

   <img width="650" alt="Livestock_yearly_total_class" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/20f0a069-7e2b-4b85-9914-6d09221c786d">

3. Max Imports per Month per Class per Country
   <img width="650" alt="Livestock_max_month_class" src="https://github.com/vitoperez117/US_Livestock_Imports/assets/52138860/11eeb560-302b-437e-84d1-02f82f78c7a2">

## Limitations
The data can only present purchase trends but cannot explain seasonality, preference for certain countries as suppliers, or preference for certain livestock and livestock products.

## Next Steps
1. Visualize the data on a world map where the user can click on countries to expand on country-specific import data.
2. Focus on one general class of livestock/livestock product and examine trends regarding its subclasses. 


#### SOURCE DATA

[Data](https://www.ers.usda.gov/data-products/livestock-and-meat-international-trade-data/livestock-and-meat-international-trade-data/#Zipped%20CSV%20files) used comes in a zip file with 2 CSVs (one for imports and one for exports).

#### UNITS

[Conversion Tables](https://www.census.gov/foreign-trade/guide/sec4.html)

Most units used in the dataset are commonly known (e.g. kilogram, dozen, number of discrete units). [CWE](https://www.ers.usda.gov/data-products/food-availability-per-capita-data-system/glossary/#:~:text=2%2C150.42%20cubic%20inches.-,Carcass%2Dweight%20equivalent%20(CWE),weight%20may%20or%20may%20not) (carcass weight equivalent) is the weight of meat cuts and meat products converted to an equivalent weight of a dressed carcass. Includes bone, fat, tendons, ligaments, and inedible trimmings.
