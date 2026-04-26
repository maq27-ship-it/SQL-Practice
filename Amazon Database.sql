-- =========================
-- CREATE DATABASE
-- =========================
CREATE DATABASE amazon;
USE amazon;

-- =========================
-- USERS TABLE
-- =========================
CREATE TABLE users (
    userid INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100),
    address TEXT,
    phone VARCHAR(15)
);

-- =========================
-- SELLERS TABLE
-- =========================
CREATE TABLE sellers (
    sellerid INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);

-- =========================
-- CATEGORIES TABLE
-- =========================
CREATE TABLE categories (
    categoryid INT PRIMARY KEY AUTO_INCREMENT,
    categoryname VARCHAR(100)
);

-- =========================
-- PRODUCTS TABLE
-- =========================
CREATE TABLE products (
    productid INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10,2),
    stock INT,
    categoryid INT,
    sellerid INT,
    FOREIGN KEY (categoryid) REFERENCES categories(categoryid),
    FOREIGN KEY (sellerid) REFERENCES sellers(sellerid)
);

-- =========================
-- ORDERS TABLE
-- =========================
CREATE TABLE orders (
    orderid INT PRIMARY KEY AUTO_INCREMENT,
    userid INT,
    orderdate DATE,
    status VARCHAR(50),
    FOREIGN KEY (userid) REFERENCES users(userid)
);

-- =========================
-- ORDER ITEMS TABLE
-- =========================
CREATE TABLE orderitems (
    orderitemid INT PRIMARY KEY AUTO_INCREMENT,
    orderid INT,
    productid INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (orderid) REFERENCES orders(orderid),
    FOREIGN KEY (productid) REFERENCES products(productid)
);

-- =========================
-- PAYMENTS TABLE
-- =========================
CREATE TABLE payments (
    paymentid INT PRIMARY KEY AUTO_INCREMENT,
    orderid INT,
    paymentmethod VARCHAR(50),
    amount DECIMAL(10,2),
    paymentstatus VARCHAR(50),
    FOREIGN KEY (orderid) REFERENCES orders(orderid)
);

-- =========================
-- REVIEWS TABLE
-- =========================
CREATE TABLE reviews (
    reviewid INT PRIMARY KEY AUTO_INCREMENT,
    userid INT,
    productid INT,
    rating INT,
    comment TEXT,
    FOREIGN KEY (userid) REFERENCES users(userid),
    FOREIGN KEY (productid) REFERENCES products(productid)
);

-- =========================
-- CART TABLE
-- =========================
CREATE TABLE cart (
    cartid INT PRIMARY KEY AUTO_INCREMENT,
    userid INT,
    FOREIGN KEY (userid) REFERENCES users(userid)
);

-- =========================
-- CART ITEMS TABLE
-- =========================
CREATE TABLE cartitems (
    cartitemid INT PRIMARY KEY AUTO_INCREMENT,
    cartid INT,
    productid INT,
    quantity INT,
    FOREIGN KEY (cartid) REFERENCES cart(cartid),
    FOREIGN KEY (productid) REFERENCES products(productid)
);

-- =========================
-- SAMPLE DATA INSERTION
-- =========================

-- USERS
INSERT INTO users (name, email, password, address, phone)
VALUES 
('Maqveena', 'maq@example.com', '1234', 'Mumbai', '9876543210'),
('Rahul', 'rahul@example.com', 'abcd', 'Delhi', '9123456780');

-- SELLERS
INSERT INTO sellers (name, email, phone)
VALUES 
('TechStore', 'tech@store.com', '9999999999'),
('FashionHub', 'fashion@hub.com', '8888888888');

-- CATEGORIES
INSERT INTO categories (categoryname)
VALUES 
('Electronics'),
('Clothing');

-- PRODUCTS
INSERT INTO products (name, description, price, stock, categoryid, sellerid)
VALUES 
('iPhone 14', 'Apple smartphone', 80000, 10, 1, 1),
('T-Shirt', 'Cotton T-shirt', 500, 50, 2, 2);

-- CART
INSERT INTO cart (userid)
VALUES (1), (2);

-- CART ITEMS
INSERT INTO cartitems (cartid, productid, quantity)
VALUES 
(1, 1, 1),
(2, 2, 2);

-- ORDERS
INSERT INTO orders (userid, orderdate, status)
VALUES 
(1, CURDATE(), 'Placed'),
(2, CURDATE(), 'Shipped');

-- ORDER ITEMS
INSERT INTO orderitems (orderid, productid, quantity, price)
VALUES 
(1, 1, 1, 80000),
(2, 2, 2, 500);

-- PAYMENTS
INSERT INTO payments (orderid, paymentmethod, amount, paymentstatus)
VALUES 
(1, 'UPI', 80000, 'Completed'),
(2, 'Card', 1000, 'Completed');

-- REVIEWS
INSERT INTO reviews (userid, productid, rating, comment)
VALUES 
(1, 1, 5, 'Excellent product!'),
(2, 2, 4, 'Good quality');

-- =========================
-- QUERIES 
-- =========================

-- View all users
SELECT * FROM users;

-- View all products with category
SELECT p.name AS product, c.categoryname
FROM products p
JOIN categories c ON p.categoryid = c.categoryid;

-- View orders of a user
SELECT * FROM orders WHERE userid = 1;

-- View order details
SELECT o.orderid, p.name, oi.quantity, oi.price
FROM orderitems oi
JOIN products p ON oi.productid = p.productid
JOIN orders o ON oi.orderid = o.orderid;

-- Total order amount
SELECT orderid, SUM(price * quantity) AS totalamount
FROM orderitems
GROUP BY orderid;

-- View reviews with product name
SELECT u.name, p.name AS product, r.rating, r.comment
FROM reviews r
JOIN users u ON r.userid = u.userid
JOIN products p ON r.productid = p.productid;