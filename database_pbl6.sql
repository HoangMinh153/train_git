CREATE TABLE IF NOT EXISTS Users (
  Account VARCHAR(255),
  Address VARCHAR(255),
  Mail VARCHAR(255),
  Name VARCHAR(255),
  Password VARCHAR(255),
  Phone_number VARCHAR(255),
  User_id INT PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE IF NOT EXISTS Orders (
  Date_of_orders DATE,
  Order_id INT PRIMARY KEY AUTO_INCREMENT,
  Supplier_id INT,
  Total_price VARCHAR(255),
  User_id INT AUTO_INCREMENT
);



CREATE TABLE IF NOT EXISTS Order_Details (
  Number_of_products INT,
  Order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
  Order_id  INT AUTO_INCREMENT,
  Payment_methods VARCHAR(255),
  Price INT,
  Product_id  INT AUTO_INCREMENT,
  QR VARCHAR(255),
  Status BOOLEAN
);

CREATE TABLE IF NOT EXISTS Admins (
  Account VARCHAR(255),
  Admin_id INT PRIMARY KEY AUTO_INCREMENT,
  Birth_day VARCHAR(255),
  Email VARCHAR(255),
  Name VARCHAR(255),
  Password VARCHAR(255),
  Role VARCHAR(255),
  Sex VARCHAR(255)
);
CREATE TABLE IF NOT EXISTS Products (
  Battery INT,
  Brand_id INT,
  Camera VARCHAR(255),
  CPU VARCHAR(255),
  Description VARCHAR(255),
  Discount BOOLEAN,
  Discount_percent INT,
  Input VARCHAR(255),
  Manufacturers VARCHAR(255),
  Memory INT,
  Name VARCHAR(255),
  Operating_system VARCHAR(255),
  Output VARCHAR(255),
  Price INT,
  Product_id INT PRIMARY KEY AUTO_INCREMENT,
  RAM INT,
  Remaining_quantity VARCHAR(255),
  Screen size VARCHAR(255),
  Supplier_id INT,
  Type VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Chat (
  Admin_id INT,
  Chat_content VARCHAR(255),
  Chat_id INT PRIMARY KEY AUTO_INCREMENT,
  Start_day DATE,
  Status BOOLEAN,
  User_id INT
);

CREATE TABLE IF NOT EXISTS Data_Analysis (
  Analysis_id INT PRIMARY KEY AUTO_INCREMENT,
  Order_date DATE,
  Order_id INT,
  Payment_method BOOLEAN,
  Product_id INT,
  Product_name TEXT(255),
  Product_price INT,
  Quantity INT,
  Total_amount INT
);

CREATE TABLE IF NOT EXISTS Ratings (
  Created_date DATE,
  Product_id INT,
  Rating VARCHAR(255),
  Rating_id INT PRIMARY KEY AUTO_INCREMENT,
  Review VARCHAR(255),
  User_id INT
);

CREATE TABLE IF NOT EXISTS Shopping_Cart (
  Cart_id INT PRIMARY KEY AUTO_INCREMENT,
  Order_id INT,
  Total_price INT,
  User_id INT
);

CREATE TABLE IF NOT EXISTS Suppliers (
  Address VARCHAR(255),
  Email VARCHAR(255),
  Name VARCHAR(255),
  Phone_number VARCHAR(255),
  Supplier_id INT PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE IF NOT EXISTS Brands (
  Brand_id INT PRIMARY KEY AUTO_INCREMENT,
  Details VARCHAR(255),
  Name VARCHAR(255)
);



