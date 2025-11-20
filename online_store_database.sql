CREATE DATABASE OnlineStore;
USE OnlineStore;

-- -------------------------------------

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT DEFAULT 0,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- -------------------------------------

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Address VARCHAR(200)
);

-- -------------------------------------

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- -------------------------------------

CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- -------------------------------------

INSERT INTO Categories (CategoryName) VALUES
('Electronics'), ('Clothing'), ('Home Appliances'), ('Books'), ('Sports');

INSERT INTO Products (ProductName, CategoryID, Price, Stock) VALUES
('iPhone 14', 1, 79900, 50),
('Samsung TV 55"', 1, 55999, 20),
('Bluetooth Speaker', 1, 2499, 100),
('Laptop Bag', 2, 899, 40),
('Men T-Shirt', 2, 499, 200),
('Sports Shoes', 5, 1999, 60),
('Cricket Bat', 5, 1599, 30),
('Wireless Mouse', 1, 599, 70),
('Keyboard', 1, 799, 60),
('Jeans', 2, 1199, 90),
('Hoodie', 2, 1499, 45),
('Smart Watch', 1, 2999, 35),
('Yoga Mat', 5, 499, 80);

INSERT INTO Customers (CustomerName, Email, Phone, Address) VALUES
('Arun Kumar', 'arun@gmail.com', '9876543210', 'Chennai'),
('Priya Sharma', 'priya@gmail.com', '9988776655', 'Bangalore'),
('Rahul Verma', 'rahul@gmail.com', '9887665544', 'Delhi');

INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2025-01-10', 5000),
(2, '2025-01-11', 8000),
(3, '2025-01-12', 12000);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price) VALUES
(1, 1, 1, 79900),
(1, 14, 2, 599),
(2, 5, 3, 499),
(2, 10, 1, 1999),
(3, 12, 1, 19999),
(3, 18, 1, 2999);

-- -------------------------------------
-- VIEW
-- -------------------------------------
CREATE VIEW View_ProductDetails AS
SELECT p.ProductID, p.ProductName, c.CategoryName, p.Price, p.Stock
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID;

-- -------------------------------------
-- JOIN Query 
-- -------------------------------------
SELECT o.OrderID, c.CustomerName, p.ProductName, od.Quantity, od.Price
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;

-- -------------------------------------
-- SUBQUERY 
-- -------------------------------------
SELECT CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders)
);

-- -------------------------------------
-- TRIGGER
-- -------------------------------------

CREATE TRIGGER ReduceStockAfterOrder
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    UPDATE Products
    SET Stock = Stock - NEW.Quantity
    WHERE ProductID = NEW.ProductID;

     select*from products; 

-- -------------------------------------
-- STORED PROCEDURE
-- -------------------------------------
DELIMITER $$

CREATE PROCEDURE CountProductsByCategory(IN cat_id INT)
BEGIN
    SELECT COUNT(*) AS TotalProducts
    FROM Products
    WHERE CategoryID = cat_id;
END $$

DELIMITER ;

CALL CountProductsByCategory(1);
