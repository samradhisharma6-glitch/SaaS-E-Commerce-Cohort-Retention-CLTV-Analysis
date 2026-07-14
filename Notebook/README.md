Week 1: Data Cleaning \& Wrangling Report



**Key Insights**

* The Online Retail dataset contained missing values, primarily in the CustomerID and Description columns.
* Records with missing CustomerID were removed because customer identification is essential for cohort retention analysis.
* Cancelled and refunded transactions were identified and excluded to ensure that only valid purchases were analyzed.
* Duplicate records were detected and removed to improve data accuracy and prevent inflated customer activity metrics.
* Transaction dates were standardized into a proper datetime format, enabling time-based analysis.
* A new Revenue column was created using Quantity × Price, allowing revenue-based customer analysis.
* Customer acquisition cohorts were established by identifying each customer's first purchase month.
* The final cleaned dataset contained 779,425 valid transactions and was ready for cohort retention analysis.
* Data quality issues were successfully addressed, resulting in a reliable dataset for SQL-based retention calculations and business insights.



**Week 1 Outcome**



Successfully transformed raw retail transaction data into a clean, structured, and analysis-ready dataset suitable for cohort retention analysis, customer behaviour tracking, and future CLTV calculations.

