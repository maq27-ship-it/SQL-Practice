-- creating database
-- CREATE DATABASE DATABASENAME
CREATE DATABASE Practice;

-- making use of database
-- USE DATABASENAME
USE Practice;

-- creating table
/* CREATE TABLE TABLENAME (COLNAME DATATYPE); */
CREATE TABLE Student
(StudentID INT, Name VARCHAR(20), Age INT, Gender VARCHAR(10)
);

SELECT * FROM Student;

-- inserting data in table
INSERT INTO Student (StudentID, Name, Age, Gender)
VALUES
(01, 'Ram', 20, 'Male'),
(02, 'Sana', 21, 'Female'),
(03, 'John', 21, 'Male'),
(04, 'Peter', 20, 'Male');

SELECT * FROM Student;

SELECT StudentID, Name, Age
From Student;

UPDATE Student
SET Age = 30
WHERE StudentID = 4;

SELECT * FROM Student;

DELETE FROM Student
WHERE StudentID = 4;

SELECT * FROM Student;

TRUNCATE TABLE Student;
SELECT * FROM Student;

DROP TABLE Student;


-- ===========================================================
-- creating database
CREATE DATABASE BesantBank;

-- use db
USE BesantBank;

CREATE TABLE Accountdetails(
     AccountID INT PRIMARY KEY,
     Name CHAR(30) NOT NULL,
     Age TINYINT CHECK(Age > 18),
     Accounttype VARCHAR(20),
     Currentbalance int
);

SELECT * FROM Accountdetails;

INSERT INTO Accountdetails VALUES
(2, 'Sana', 23, 'current', 500),
(3, 'John', 27, 'Saving', 1000),
(4, 'Peter', 25, 'Saving', 1500),
(5, 'Kiran', 27, 'Current', 5200),
(6, 'Priya', 21, 'Saving', 5500),
(7, 'Varun', 28, 'Current', 500),
(8, 'Sonu', 29, 'Saving', 2500),
(9, 'Kumar', 28, 'Saving', 2000),
(10, 'Jathin', 27, 'Current', 5000),
(11, 'Suma', 22, 'Saving', 1500);

CREATE TABLE Transactiondetails(
     TransactionID INT PRIMARY KEY AUTO_INCREMENT,
     AccountID INT,
     Transactiontype VARCHAR(10) CHECK(Transactiontype = 'Credit' OR Transactiontype = 'Debit'),
     Transactionamount INT,
     Transactiontime DATETIME DEFAULT(NOW()),
     FOREIGN KEY (AccountID) REFERENCES Accountdetails (AccountID)
);

SELECT * FROM Transactiondetails;

INSERT INTO Transactiondetails (AccountID, Transactiontype, Transactionamount)
VALUES
(7, 'Credit', 1000);

USE BesantBank;

-- step1
SELECT DISTINCT (AccountID) FROM Transactiondetails;

-- step2 
SELECT * FROM Accountdetails WHERE AccountID IN (1,7);

-- step3
SELECT * FROM Accountdetails
WHERE AccountID IN(
SELECT DISTINCT (AccountID) FROM Transactiondetails);

-- top 5 balance
SELECT Currentbalance FROM Accountdetails
ORDER BY Currentbalance DESC
LIMIT 5;

-- step 2
SELECT MIN(Currentbalance) FROM Accountdetails
WHERE Currentbalance IN(
SELECT Currentbalance FROM Accountdetails
ORDER BY Currentbalance DESC
LIMIT 5);

-- step 3
SELECT MIN(Currentbalance) FROM (
SELECT Currentbalance FROM Accountdetails
ORDER BY Currentbalance DESC
LIMIT 5) AS Topbalance;

SELECT MIN(Currentbalance) FROM (
SELECT Currentbalance FROM Accountdetails
ORDER BY Currentbalance DESC
LIMIT 2) AS Topbalance;

SELECT MAX(Currentbalance) FROM Accountdetails;

-- ======================================================================

USE college;

USE instagram;

CREATE TABLE user_information3 (
     id INT,
     age INT,
     uname VARCHAR(30) NOT NULL,
     email VARCHAR(30) UNIQUE,
     followers INT DEFAULT 0, 
     unfollowing INT,
     CONSTRAINT CHECK (age >= 13),
     PRIMARY KEY(id)
);

CREATE TABLE post (
    p_id INT PRIMARY KEY,
    content varchar(100),
    user_id INT,
    foreign key (user_id) references user_information3(id)
); 


-- ============================================================================

-- create view
CREATE VIEW AccountOfTransactions AS
    -- query to be placed in view
    SELECT * FROM Accountdetails WHERE AccountID IN (
    SELECT DISTINCT(AccountID) FROM Transactiondetails);
    
    -- execute view
    SELECT * FROM AccountOfTransactions;
    
    -- insert new record in tran. table
    INSERT INTO Transactiondetails (AccountID,Transactiontype,Transactionamount)
    VALUES
    (2, 'Credit', 1000);
    
    -- execute view
    SELECT * FROM AccountOfTransactions;
    
    -- updatable view
    UPDATE AccountOfTransactions
    SET Name='Ram Prasad'
    WHERE AccountID=1;
    
    SELECT * FROM AccountOfTransactions;
    
    SELECT * FROM Accountdetails;
    
    -- un-updatable view
    CREATE VIEW BalanceInBank AS
        SELECT SUM(Currentbalance) FROM Accountdetails;
        
        SELECT * FROM BalanceInBank;
        
UPDATE BalanceInBank
SET Name='Ram' WHERE AccountId = 1;
    
    
-- =====================================================================

USE besantbank;

CREATE VIEW BankStatement AS
     SELECT * FROM Transactiondetails
     WHERE AccountID=1;
SELECT * FROM BankStatement;

-- ==================================================

SELECT 
    u.user_id,
    u.name,
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM orders o 
            WHERE o.user_id = u.user_id
        )
        THEN 'ORDERED'
        ELSE 'NO ORDER'
    END AS order_status,
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM prime_membership p 
            WHERE p.user_id = u.user_id 
              AND p.is_prime = 'Y'
        )
        THEN 'PRIME USER'
        ELSE 'NON PRIME USER'
    END AS prime_status
FROM users u;

use practice;
DROP TABLE IF EXISTS EMPLOYEE;
CREATE TABLE EMPLOYEE (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO EMPLOYEE (EmpID, Name, Department, Salary) VALUES
(1, 'Amit', 'HR', 40000),
(2, 'Neha', 'HR', 50000),
(3, 'Raj', 'HR', 45000),
(4, 'Simran', 'IT', 70000),
(5, 'Karan', 'IT', 80000),
(6, 'Vikas', 'IT', 75000),
(7, 'Pooja', 'Finance', 60000),
(8, 'Rohit', 'Finance', 65000),
(9, 'Anjali', 'Finance', 55000);

SELECT 
  E1.EmpID, 
  E1.Name, 
  E1.Department, 
  E1.Salary 
FROM EMPLOYEE E1 
WHERE E1.Salary > (
  SELECT AVG(E2.Salary) 
  FROM EMPLOYEE E2 
  WHERE E2.Department = E1.Department -- Reference to outer query! 
);

DROP TABLE IF EXISTS EMPLOYEE;

CREATE TABLE EMPLOYEE (
    EmpID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50),
    Designation VARCHAR(50),
    ManagerID VARCHAR(10)
);

INSERT INTO EMPLOYEE (EmpID, Name, Designation, ManagerID) VALUES
('E001', 'Nandan Nilekani', 'CEO', NULL),
('E045', 'Salil Parekh', 'MD & CEO', 'E001'),
('E101', 'Finance Head', 'VP Finance', 'E045'),
('E102', 'Unit Head', 'VP Operations', 'E045'),
('E201', 'Manager A', 'Manager', 'E101'),
('E202', 'Manager B', 'Manager', 'E101'),
('E301', 'Employee 1', 'Analyst', 'E201'),
('E302', 'Employee 2', 'Analyst', 'E201'),
('E303', 'Employee 3', 'Analyst', 'E202'),
('E401', 'Intern 1', 'Intern', 'E301');

WITH RECURSIVE OrgChart AS (
    SELECT 
        EmpID,
        Name,
        Designation,
        ManagerID,
        0 AS Level,
        Name AS Path
    FROM EMPLOYEE
    WHERE EmpID = 'E001'

    UNION ALL

    SELECT 
        E.EmpID,
        E.Name,
        E.Designation,
        E.ManagerID,
        OC.Level + 1,
        CONCAT(OC.Path, ' > ', E.Name)
    FROM EMPLOYEE E
    JOIN OrgChart OC 
        ON E.ManagerID = OC.EmpID
)

SELECT 
    EmpID, 
    Name, 
    Designation, 
    Level, 
    Path
FROM OrgChart
ORDER BY Level, Name;

-- ===================================================================

USE practice;

SELECT
 TxnID,
 Amount,
 CASE
  WHEN Amount < 500 THEN 'Micro Transaction'
  WHEN Amount BETWEEN 500 AND 4999 THEN 'Small Transaction'
  WHEN Amount BETWEEN 5000 AND 49999 THEN 'Medium Transaction'
  WHEN Amount >= 50000 THEN 'Large Transaction - Flag for Review'
  ELSE 'Unknown'
 END AS TransactionCategory,
 CASE TxnType
  WHEN 'CR' THEN 'Money Received'
  WHEN 'DR' THEN 'Money Sent'
  ELSE 'Pending'
 END AS TxnDescription
FROM TXN_LEDGER
WHERE CustomerID = 'C001'
 AND TxnDate >= CURDATE() - INTERVAL 30 DAY;

-- CASE INSIDE AGGREGATE
SELECT
 VendorID,
 COUNT(*) AS TotalInvoices,
 COUNT(CASE WHEN Status = 'Paid' THEN 1 END) AS PaidCount,
 COUNT(CASE WHEN Status = 'Unpaid' THEN 1 END) AS UnpaidCount,
 SUM(CASE WHEN Status = 'Unpaid' THEN Amount ELSE 0 END) AS OutstandingAmount
FROM INVOICES
GROUP BY VendorID;

-- =========================================
-- 2. NULL HANDLING
-- =========================================
SELECT 100 + NULL;
SELECT NULL = NULL;
SELECT NULL <> NULL;

SELECT * FROM EMPLOYEE WHERE ManagerID IS NULL;
SELECT * FROM EMPLOYEE WHERE ManagerID IS NOT NULL;

SELECT PatientName,
 COALESCE(Phone, AlternatePhone, 'Not Provided') AS ContactNumber
FROM PATIENT;

SELECT ProductName,
 IFNULL(DiscountedPrice, ListPrice) AS EffectivePrice
FROM PRODUCT;

SELECT CustomerID,
 TotalRevenue / NULLIF(BookingCount, 0) AS AvgBookingValue
FROM CUSTOMER_SUMMARY;

-- =========================================
-- 3. LIKE & REGEXP
-- =========================================
SELECT BranchName, IFSC FROM BRANCH
WHERE IFSC LIKE 'HDFC%'
 AND IFSC LIKE '%MH%';

SELECT * FROM CUSTOMER WHERE Name LIKE 'Raj%';

SELECT * FROM CUSTOMER WHERE Phone LIKE '__________';

SELECT * FROM TAXPAYER
WHERE PAN REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]{1}$';

SELECT Name, Email FROM CUSTOMER
WHERE Email REGEXP '@(gmail|yahoo|hotmail)\.com$';

-- =========================================
-- 4. DATE FUNCTIONS & FILTERING
-- =========================================
SELECT CURDATE();
SELECT NOW();
SELECT YEAR(NOW());
SELECT MONTH(NOW());
SELECT DAYOFWEEK(NOW());

SELECT * FROM TRANSACTIONS
WHERE TxnDate >= NOW() - INTERVAL 30 DAY;

SELECT * FROM ORDERS
WHERE OrderDate BETWEEN '2024-04-01' AND '2024-06-30';

SELECT Name, Phone, Email FROM CUSTOMER
WHERE MONTH(DateOfBirth) = MONTH(CURDATE())
 AND DAY(DateOfBirth) = DAY(CURDATE());

SELECT LoanID, CustomerName, MaturityDate, EMIAmount
FROM LOANS L JOIN CUSTOMER C ON L.CustomerID = C.CustomerID
WHERE MaturityDate BETWEEN CURDATE() AND CURDATE() + INTERVAL 90 DAY
ORDER BY MaturityDate ASC;

SELECT COUNT(*), DAYNAME(OrderDate) AS DayName
FROM ORDERS
GROUP BY DAYNAME(OrderDate)
HAVING DayName IN ('Saturday','Sunday');

-- =========================================
-- 5. GROUP BY + AGGREGATES
-- =========================================
SELECT
 B.BranchName,
 B.City,
 YEAR(T.TxnDate) AS TxnYear,
 MONTH(T.TxnDate) AS TxnMonth,
 COUNT(*) AS TotalTransactions,
 COUNT(DISTINCT T.AccountID) AS ActiveAccounts,
 SUM(CASE WHEN T.TxnType='CR' THEN T.Amount ELSE 0 END) AS TotalCredits,
 SUM(CASE WHEN T.TxnType='DR' THEN T.Amount ELSE 0 END) AS TotalDebits,
 AVG(T.Amount) AS AvgTxnAmount,
 MAX(T.Amount) AS LargestTransaction
FROM TXN_LEDGER T
JOIN ACCOUNT A ON T.AccountID = A.AccountID
JOIN BRANCH B ON A.BranchID = B.BranchID
WHERE T.TxnDate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY B.BranchName, B.City, YEAR(T.TxnDate), MONTH(T.TxnDate)
ORDER BY B.BranchName, TxnYear, TxnMonth;

-- =========================================
USE hoteldb;

SELECT RestaurantID, AVG(Rating) AS AvgRating
FROM REVIEWS
GROUP BY RestaurantID
HAVING AVG(Rating) > 4.0;

SELECT R.Name, R.City,
 COUNT(*) AS ReviewCount,
 AVG(Rev.Rating) AS AvgRating
FROM RESTAURANT R
JOIN REVIEWS Rev ON R.RestaurantID = Rev.RestaurantID
WHERE R.City = 'Bangalore'
 AND Rev.ReviewDate >= '2024-01-01'
GROUP BY R.RestaurantID, R.Name, R.City
HAVING COUNT(*) >= 100
 AND AVG(Rev.Rating) > 4.5
ORDER BY AvgRating DESC;

-- =========================================
-- 7. ROLLUP
-- =========================================
SELECT
 COALESCE(Region, 'ALL REGIONS') AS Region,
 COALESCE(Category, 'ALL CATEGORIES') AS Category,
 SUM(SalesAmount) AS TotalSales
FROM SALES_DATA
GROUP BY Region, Category WITH ROLLUP;

-- =========================================
-- 8. SELF JOIN
-- =========================================
SELECT
 E.EmpID,
 E.Name AS EmployeeName,
 E.Designation,
 M.Name AS ManagerName,
 M.Designation AS ManagerDesignation
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON E.ManagerID = M.EmpID;

SELECT
 A.Name AS Employee1,
 B.Name AS Employee2,
 A.Department,
 A.Salary AS Salary1,
 B.Salary AS Salary2,
 ABS(A.Salary - B.Salary) AS SalaryDifference
FROM EMPLOYEE A
JOIN EMPLOYEE B
 ON A.Department = B.Department
 AND A.EmpID < B.EmpID
WHERE ABS(A.Salary - B.Salary) < 5000;

-- =========================================
-- 9. NON-EQUI JOIN
-- =========================================
SELECT
 E.EmpID,
 E.Name,
 E.AnnualSalary,
 T.TaxRate,
 ROUND(E.AnnualSalary * T.TaxRate, 2) AS EstimatedTax
FROM EMPLOYEE E
JOIN TAX_BRACKET T
ON E.AnnualSalary BETWEEN T.MinIncome AND T.MaxIncome;

SELECT O.OrderID, O.PackageWeight,
 ROUND(O.PackageWeight * S.RatePerKg, 2) AS ShippingCost
FROM ORDERS O
JOIN SHIPPING_RATE S
ON O.PackageWeight BETWEEN S.MinWeight AND S.MaxWeight;

-- =========================================
-- 10. CROSS JOIN
-- =========================================
SELECT
 AG.AgeGroupLabel,
 PT.PolicyType,
 AG.BaseRiskFactor * PT.PremiumMultiplier AS CalculatedPremium
FROM AGE_GROUPS AG
CROSS JOIN POLICY_TYPES PT;

-- =========================================
-- 11. MULTI-TABLE JOIN
-- =========================================
SELECT
 O.OrderID,
 O.OrderDate,
 CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
 C.City,
 P.Title,
 B.BrandName,
 Cat.CategoryName,
 OL.Quantity,
 OL.UnitPrice,
 OL.Quantity * OL.UnitPrice AS LineTotal,
 O.DeliveryStatus
FROM ORDER_HEADER O
JOIN CUSTOMER C ON O.CustomerID = C.CustomerID
JOIN ORDER_LINE OL ON O.OrderID = OL.OrderID
JOIN PRODUCT P ON OL.ProductID = P.ProductID
JOIN BRAND B ON P.BrandID = B.BrandID
JOIN CATEGORY Cat ON P.CategoryID = Cat.CategoryID;

-- =========================================
-- 12. SUBQUERIES
-- =========================================
SELECT Name, Email FROM CUSTOMER
WHERE CustomerID IN (SELECT DISTINCT CustomerID FROM ORDERS);

SELECT Name, Email FROM CUSTOMER C
WHERE EXISTS (
 SELECT 1 FROM ORDERS O WHERE O.CustomerID = C.CustomerID
);

SELECT Name FROM CUSTOMER C
WHERE NOT EXISTS (
 SELECT 1 FROM ORDERS O WHERE O.CustomerID = C.CustomerID
);

-- CORRELATED SUBQUERY
SELECT
 E1.EmpID,
 E1.Name,
 E1.Department,
 E1.Salary
FROM EMPLOYEE E1
WHERE E1.Salary > (
 SELECT AVG(E2.Salary)
 FROM EMPLOYEE E2
 WHERE E2.Department = E1.Department
);

-- =========================================
-- 13. CTE
-- =========================================
WITH OrderTotals AS (
 SELECT CustomerID, SUM(Amount) AS TotalSpent
 FROM ORDERS
 WHERE Status = 'Completed'
 GROUP BY CustomerID
)
SELECT * FROM OrderTotals
WHERE TotalSpent > 50000;

-- MULTIPLE CTE
WITH
CustomerSpend AS (
 SELECT CustomerID, SUM(Amount) AS LifetimeValue
 FROM ORDERS WHERE Status = 'Delivered'
 GROUP BY CustomerID
),
CustomerTier AS (
 SELECT CustomerID, LifetimeValue,
 CASE
  WHEN LifetimeValue >= 100000 THEN 'Platinum'
  WHEN LifetimeValue >= 50000 THEN 'Gold'
  WHEN LifetimeValue >= 10000 THEN 'Silver'
  ELSE 'Bronze'
 END AS Tier
 FROM CustomerSpend
)
SELECT * FROM CustomerTier;

-- =========================================
-- 14. WINDOW FUNCTIONS
-- =========================================
SELECT
 EmpID, Name, Department, Salary,
 AVG(Salary) OVER (PARTITION BY Department) AS DeptAvgSalary
FROM EMPLOYEE;

SELECT
 TraderID,
 TraderName,
 TradingProfit,
 ROW_NUMBER() OVER (ORDER BY TradingProfit DESC) AS RowNum,
 RANK() OVER (ORDER BY TradingProfit DESC) AS RankVal,
 DENSE_RANK() OVER (ORDER BY TradingProfit DESC) AS DenseRank
FROM TRADER_PERFORMANCE;

-- =========================================
-- 15. LAG / LEAD
-- =========================================
WITH MonthlyVolume AS (
 SELECT DATE_FORMAT(TradeDate, '%Y-%m') AS TradeMonth,
 SUM(TradeValue) AS TotalVolume
 FROM TRADES
 GROUP BY DATE_FORMAT(TradeDate, '%Y-%m')
)
SELECT
 TradeMonth,
 TotalVolume,
 LAG(TotalVolume,1) OVER (ORDER BY TradeMonth) AS PrevMonth,
 LEAD(TotalVolume,1) OVER (ORDER BY TradeMonth) AS NextMonth
FROM MonthlyVolume;

-- =========================================
-- 16. RUNNING TOTAL
-- =========================================
SELECT
 OrderDate,
 DailyRevenue,
 SUM(DailyRevenue) OVER (
  ORDER BY OrderDate
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
 ) AS RunningTotal
FROM DAILY_REVENUE;

-- =========================================
USE besantbank;

SELECT
 CustomerID,
 AccountBalance,
 NTILE(4) OVER (ORDER BY AccountBalance DESC) AS Quartile
FROM ACCOUNT;

-- =============================================================================


