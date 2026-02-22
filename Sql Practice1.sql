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
 
