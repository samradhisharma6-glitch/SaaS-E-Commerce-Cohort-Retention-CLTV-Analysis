CREATE DATABASE CohortRetentionDB;
GO

USE CohortRetentionDB;

select * from online_retail_final_cleaned
EXEC sp_rename 'online_retail_final_cleaned', 'Online_Retail';

SELECT *
FROM Online_Retail

--Issue 13: Invoice Month
ALTER TABLE online_retail
ADD InvoiceMonthSQL DATE;

UPDATE online_retail
SET InvoiceMonthSQL =
DATEFROMPARTS(
    YEAR(InvoiceDate),
    MONTH(InvoiceDate),
    1
);

--Issue 14: First Purchase Date

SELECT
    [Customer ID] AS CustomerID,
    MIN(InvoiceDate) AS FirstPurchaseDate
INTO CustomerFirstPurchase
FROM online_retail
GROUP BY [Customer ID];

--Issue 15: Cohort Month
SELECT
    CustomerID,
    DATEFROMPARTS(
        YEAR(FirstPurchaseDate),
        MONTH(FirstPurchaseDate),
        1
    ) AS CohortMonth
INTO CustomerCohort
FROM CustomerFirstPurchase;

--Issue 16: Cohort Index
SELECT
    r.[Customer ID] AS CustomerID,
    c.CohortMonth,
    r.InvoiceMonthSQL,

    DATEDIFF(
        MONTH,
        c.CohortMonth,
        r.InvoiceMonthSQL
    ) AS CohortIndex

INTO CohortData

FROM online_retail r
JOIN CustomerCohort c
ON r.[Customer ID] = c.CustomerID;

--Issue 17: Active Customers
SELECT
    CohortMonth,
    CohortIndex,
    COUNT(DISTINCT CustomerID) AS ActiveCustomers

INTO CohortCounts

FROM CohortData

GROUP BY
    CohortMonth,
    CohortIndex;


    --Issue 18: Retention Matrix Source
    SELECT *
FROM CohortCounts
ORDER BY
    CohortMonth,
    CohortIndex;

    --Issue 19: Retention Percentage

    WITH CohortSize AS
(
    SELECT
        CohortMonth,
        ActiveCustomers AS CohortSize
    FROM CohortCounts
    WHERE CohortIndex = 0
)

SELECT
    c.CohortMonth,
    c.CohortIndex,
    c.ActiveCustomers,
    s.CohortSize,

    ROUND(
        100.0 * c.ActiveCustomers /
        s.CohortSize,
        2
    ) AS RetentionRate

FROM CohortCounts c
JOIN CohortSize s
ON c.CohortMonth = s.CohortMonth

ORDER BY
    c.CohortMonth,
    c.CohortIndex;


    --Issue 20 Validation
    SELECT *
FROM CohortCounts
WHERE CohortIndex = 0;

EXEC sp_rename
'online_retail.[Customer ID]',
'CustomerID',
'COLUMN';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'online_retail';;
ALTER TABLE online_retail
DROP COLUMN [Column 0];


SELECT TOP 10
    Quantity,
    Price,
    Revenue,
    InvoiceDate,
    CustomerID
FROM online_retail;
------------------------------------------------------------------------------
sp_help online_retail_clean;

SELECT
    COUNT(*) AS TotalRows
FROM online_retail_clean;

SELECT TOP 5 *
FROM online_retail_clean;


------------------------------------------------------------------
SELECT TOP 10 *
FROM CohortCounts;
---------------------------------------------
WITH CohortSize AS
(
    SELECT
        CohortMonth,
        ActiveCustomers AS CohortSize
    FROM CohortCounts
    WHERE CohortIndex = 0
)

SELECT
    c.CohortMonth,
    c.CohortIndex,
    c.ActiveCustomers,
    s.CohortSize,

    ROUND(
        (100.0 * c.ActiveCustomers) / s.CohortSize,
        2
    ) AS RetentionRate

INTO RetentionMatrix

----------------------------------------------------------
SELECT TOP 10 *
FROM CohortCounts;

SELECT COUNT(*)
FROM CohortCounts;
-----------------------------------------------------------
IF OBJECT_ID('RetentionMatrix', 'U') IS NOT NULL
DROP TABLE RetentionMatrix;


-------------------------------------------------
WITH CohortSize AS
(
    SELECT
        CohortMonth,
        ActiveCustomers AS CohortSize
    FROM CohortCounts
    WHERE CohortIndex = 0
)

SELECT
    c.CohortMonth,
    c.CohortIndex,
    c.ActiveCustomers,
    s.CohortSize,
    ROUND(
        (100.0 * c.ActiveCustomers) / s.CohortSize,
        2
    ) AS RetentionRate
INTO RetentionMatrix
FROM CohortCounts c
INNER JOIN CohortSize s
    ON c.CohortMonth = s.CohortMonth;

    -----------------------------------------------------------
    SELECT TOP 20 *
FROM RetentionMatrix
ORDER BY CohortMonth, CohortIndex;
---------------------------------------------------------------------

SELECT TOP 20 *
FROM RetentionMatrix
ORDER BY CohortMonth, CohortIndex;

--------------------------------------------------------
SELECT *
FROM RetentionMatrix
WHERE CohortIndex = 0;
-----------------------------------------------------------
SELECT * FROM RetentionMatrix