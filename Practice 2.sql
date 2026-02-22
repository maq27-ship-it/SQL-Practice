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
