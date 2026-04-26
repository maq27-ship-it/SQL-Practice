-- =========================================
-- TASK 1 — BIGBASKET NORMALIZATION PROJECT
-- =========================================

CREATE DATABASE BigBasket_Normalization;
USE BigBasket_Normalization;

-- =========================================
-- PHASE 1 — RAW TABLE (0NF)
-- =========================================
CREATE TABLE raw_orders (
    OrderID INT,
    CustomerName VARCHAR(100),
    CustomerPhone VARCHAR(50),
    CustomerCity VARCHAR(100),
    ProductIDs VARCHAR(200),
    ProductNames VARCHAR(500),
    CategoryName VARCHAR(200),
    CategoryManager VARCHAR(100),
    Quantities VARCHAR(100),
    UnitPrices VARCHAR(100),
    OrderDate DATE
);

INSERT INTO raw_orders VALUES
(1,'Anita Desai','9876543210,8765432109','Chennai','P1,P2',
 'Tata Salt,Amul Butter','Groceries,Dairy','Rohit,Priya','2,1','22,120','2024-03-01'),
(2,'Suresh Pillai','7654321098','Kochi','P3',
 'Fortune Oil','Groceries','Rohit','1','180','2024-03-01');

-- =========================================
-- PHASE 2 — 1NF (REMOVE MULTI VALUES)
-- =========================================

-- Separate phone numbers
CREATE TABLE Customer_Phone_1NF (
    OrderID INT,
    PhoneNumber VARCHAR(15),
    PRIMARY KEY (OrderID, PhoneNumber)
);

INSERT INTO Customer_Phone_1NF VALUES
(1,'9876543210'),
(1,'8765432109'),
(2,'7654321098');

-- Separate products
CREATE TABLE Order_Items_1NF (
    OrderID INT,
    ProductID VARCHAR(10),
    ProductName VARCHAR(100),
    CategoryName VARCHAR(100),
    CategoryMgr VARCHAR(100),
    Quantity INT,
    UnitPrice DECIMAL(8,2),
    PRIMARY KEY (OrderID, ProductID)
);

INSERT INTO Order_Items_1NF VALUES
(1,'P1','Tata Salt','Groceries','Rohit',2,22),
(1,'P2','Amul Butter','Dairy','Priya',1,120),
(2,'P3','Fortune Oil','Groceries','Rohit',1,180);

-- =========================================
-- PHASE 3 — 2NF (REMOVE PARTIAL DEPENDENCY)
-- =========================================

-- Product table
CREATE TABLE Product_2NF (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(100),
    CategoryName VARCHAR(100),
    CategoryMgr VARCHAR(100)
);

INSERT INTO Product_2NF VALUES
('P1','Tata Salt','Groceries','Rohit'),
('P2','Amul Butter','Dairy','Priya'),
('P3','Fortune Oil','Groceries','Rohit');

-- Order items (cleaned)
CREATE TABLE OrderItems_2NF (
    OrderID INT,
    ProductID VARCHAR(10),
    Quantity INT,
    UnitPrice DECIMAL(8,2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (ProductID) REFERENCES Product_2NF(ProductID)
);

INSERT INTO OrderItems_2NF VALUES
(1,'P1',2,22),
(1,'P2',1,120),
(2,'P3',1,180);

-- =========================================
-- PHASE 4 — 3NF (REMOVE TRANSITIVE DEPENDENCY)
-- =========================================

-- Category table
CREATE TABLE Category_3NF (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) UNIQUE,
    ManagerName VARCHAR(100)
);

INSERT INTO Category_3NF (CategoryName, ManagerName) VALUES
('Groceries','Rohit'),
('Dairy','Priya');

-- Product final
CREATE TABLE Product_3NF (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(100),
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Category_3NF(CategoryID)
);

INSERT INTO Product_3NF VALUES
('P1','Tata Salt',1),
('P2','Amul Butter',2),
('P3','Fortune Oil',1);

-- Customer table
CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100),
    CustomerCity VARCHAR(100)
);

INSERT INTO Customer (CustomerName, CustomerCity) VALUES
('Anita Desai','Chennai'),
('Suresh Pillai','Kochi');

-- Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

INSERT INTO Orders VALUES
(1,1,'2024-03-01'),
(2,2,'2024-03-01');

-- Final OrderItems (3NF)
CREATE TABLE OrderItems_3NF (
    OrderID INT,
    ProductID VARCHAR(10),
    Quantity INT,
    UnitPrice DECIMAL(8,2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product_3NF(ProductID)
);

INSERT INTO OrderItems_3NF VALUES
(1,'P1',2,22),
(1,'P2',1,120),
(2,'P3',1,180);

-- =========================================
-- TEST QUERIES (VERY IMPORTANT)
-- =========================================

-- 1. Chennai customers total order amount
SELECT c.CustomerName, SUM(oi.Quantity * oi.UnitPrice) AS TotalAmount
FROM Customer c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderItems_3NF oi ON o.OrderID = oi.OrderID
WHERE c.CustomerCity = 'Chennai'
GROUP BY c.CustomerName;

-- 2. Category with highest avg order value
SELECT cat.CategoryName, AVG(oi.Quantity * oi.UnitPrice) AS AvgValue
FROM OrderItems_3NF oi
JOIN Product_3NF p ON oi.ProductID = p.ProductID
JOIN Category_3NF cat ON p.CategoryID = cat.CategoryID
GROUP BY cat.CategoryName
ORDER BY AvgValue DESC;

-- 3. Update category manager (only 1 row should change)
UPDATE Category_3NF
SET ManagerName = 'New Manager'
WHERE CategoryName = 'Dairy';