CREATE TABLE IF NOT EXISTS Users (
  Account TEXT(255),
  Address TEXT(255),
  Mail TEXT(255),
  Name TEXT(255),
  Password TEXT(255),
  Phone_number TEXT(255),
  User_id INT PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE IF NOT EXISTS Orders (
  Date_of_orders DATE,
  Order_id INT PRIMARY KEY AUTO_INCREMENT,
  Total_price TEXT(255),
  User_id INT AUTO_INCREMENT
);

CREATE TABLE IF NOT EXISTS Order_Details (
  Number_of_products INT,
  Order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
  Order_id  INT AUTO_INCREMENT,
  Payment_methods TEXT(255),
  Price INT,
  Product_id  INT AUTO_INCREMENT,
  QR TEXT(255),
  Status BOOLEAN
);

CREATE TABLE IF NOT EXISTS Admins (
  Account TEXT(255),
  Admin_id INT PRIMARY KEY AUTO_INCREMENT,
  Birth_day TEXT(255),
  Name TEXT(255),
  Password TEXT(255),
  Role TEXT(255)
);

CREATE TABLE IF NOT EXISTS Products (
  Battery INT,
  Camera TEXT(255),
  CPU TEXT(255),
  Description TEXT(255),
  Discount BOOLEAN,
  Discount_percent INT,
  Input TEXT(255),
  Manufacturers TEXT(255),
  Memory INT,
  Name TEXT(255),
  Operating_system TEXT(255),
  Output TEXT(255),
  Price INT,
  Product_id INT PRIMARY KEY AUTO_INCREMENT,
  RAM INT,
  Remaining_quantity TEXT(255),
  Screen size TEXT(255),
  Type TEXT(255)
);

CREATE TABLE IF NOT EXISTS Chat (
  Admin_id INT,
  chat_content TEXT(255),
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

CREATE TABLE IF NOT EXISTS Shopping_Cart (
  Cart_id INT PRIMARY KEY AUTO_INCREMENT,
  Order_id INT,
  Total_price INT,
  User_id INT
);

