CREATE TABLE OnlineRetailCleaned (
    Invoice VARCHAR(20),
    StockCode VARCHAR(50),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    Price DECIMAL(10,2),
    CustomerID FLOAT,
    Country VARCHAR(100),
    Revenue DECIMAL(12,2),
    InvoiceMonth VARCHAR(20),
    CohortMonth VARCHAR(20)
);