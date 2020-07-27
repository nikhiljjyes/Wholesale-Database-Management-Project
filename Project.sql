Create DATABASE [Wholesale Database Management System];
go
USE [Wholesale Database Management System]
go
CREATE TABLE [Invoice] (
  [InvoiceID] INT PRIMARY KEY,
  [InvoiceDate] DATE,
  [TotalAmount] Decimal(20,15),
  [SalesTax] Decimal(20,15),
  [Discount] Decimal(20,15),
  [CouponCode] Decimal(20,15)
  );

CREATE INDEX [FK] ON  [Invoice] ([CouponCode]);

CREATE TABLE [Refund] (
  [RefundOrderID] INT PRIMARY KEY,
  [RefundStatus] VARCHAR(50),
  [RefundAmount] Decimal(20,15)
  );

CREATE TABLE [Employee] (
  [EmployeeID] INT PRIMARY KEY,
  [FirstName] VARCHAR(20),
  [LastName] VARCHAR(20),
  [Address ID] INT ,
  [TelephoneNumber] VARCHAR(12),
  [Email] VARCHAR(50),
  );

CREATE INDEX [FK] ON  [Employee] ([Address ID]);

CREATE TABLE [CustomerReturnsOrder] (
  [CustomerID] INT,
  [OrderID] INT,
  [InvoiceID] INT,
  [ReturnRequestID] INT
);

CREATE INDEX [PK, FK1] ON  [CustomerReturnsOrder] ([CustomerID]);

CREATE INDEX [PK, FK2] ON  [CustomerReturnsOrder] ([OrderID]);

CREATE INDEX [PK, FK3] ON  [CustomerReturnsOrder] ([InvoiceID]);

CREATE INDEX [PK, FK4] ON  [CustomerReturnsOrder] ([ReturnRequestID]);

CREATE TABLE [Returns] (
  [ReturnRequestID] INT PRIMARY KEY,
  [ReturnRequestDate] DATE,
  [ReturnRequestTime] TIME,
  [RefundOrderID] INT,
 );

CREATE INDEX [FK] ON  [Returns] ([RefundOrderID]);

CREATE TABLE [Price] (
  [ItemNo] VARCHAR(50),
  [RetailPrice] DECIMAL(20,5),
  [WholesalePrice] DECIMAL(20,5),
  [Discount] DECIMAL(20,5)
);

CREATE INDEX [FK] ON  [Price] ([ItemNo]);

CREATE TABLE [Transportation Vendor] (
  [VendorID] INT PRIMARY KEY,
  [VendorName] VARCHAR(30),
  [Address ID] INT,
  [EmailID] VARCHAR(150)
  
);

CREATE INDEX [FK] ON  [Transportation Vendor] ([Address ID]);

CREATE TABLE [Transaction] (
  [TransactionID] INT PRIMARY KEY,
  [TransactionMode] VARCHAR(20),
  [TransactionDate] DATE,
  [TransactionTime] TIME,
  [TransactionAmount] DECIMAL(20,5),
  [TransactionStatus] VARCHAR(20),
);

CREATE TABLE [Address] (
  [Address ID] INT PRIMARY KEY,
  [StreetName] VARCHAR(200),
  [City] VARCHAR(30),
  [State] VARCHAR(30),
  [Country] VARCHAR(30),
  [ZipCode] INT,
  );

CREATE TABLE [Category] (
  [ CategoryID] INT PRIMARY KEY,
  [CategoryName] VARCHAR(50),
  );

CREATE TABLE [Coupon] (
  [CouponCode] VARCHAR(50) PRIMARY KEY,
  [DiscountPercentage] DECIMAL(20,5),
  [DateValidTill] DATE,
 );

CREATE TABLE [OrderItem] (
  [OrderID] INT,
  [ItemNo] INT,
  [Quantity] INT
);

CREATE INDEX [PK, FK1] ON  [OrderItem] ([OrderID]);

CREATE INDEX [PK, FK2] ON  [OrderItem] ([ItemNo]);

CREATE TABLE [Order] (
  [OrderID] INT PRIMARY KEY,
  [OrderDate] DATE,
  [OrderTime] TIME,
  [OrderStatus] VARCHAR(20),
  [EmployeeID] INT
  );

CREATE INDEX [FK] ON  [Order] ([EmployeeID]);

CREATE TABLE [Inventory] (
  [ItemNo] INT,
  [QuantityInStock] INT,
  [Inventory Costs] DECIMAL(20,15)
);

CREATE INDEX [FK] ON  [Inventory] ([ItemNo]);

CREATE TABLE [Customer] (
  [CustomerID] INT PRIMARY KEY,
  [FirstName] VARCHAR(50),
  [LastName] VARCHAR(50),
  [TelephoneNumber] INT,
  [Address ID] VARCHAR(200),
  [EmailID] VARCHAR(100)
  );

CREATE INDEX [FK] ON  [Customer] ([Address ID]);

CREATE TABLE [CustomerOrder] (
  [CustomerID] INT,
  [OrderID] INT,
  [InvoiceID] INT,
  [TransactionID] INT,
  [ShippingLabelNo] VARCHAR(50)
);

CREATE INDEX [PK, FK1] ON  [CustomerOrder] ([CustomerID]);

CREATE INDEX [PK, FK2] ON  [CustomerOrder] ([OrderID]);

CREATE INDEX [PK, FK3] ON  [CustomerOrder] ([InvoiceID]);

CREATE INDEX [PK, FK4] ON  [CustomerOrder] ([TransactionID]);

CREATE INDEX [PK, FK5] ON  [CustomerOrder] ([ShippingLabelNo]);

CREATE TABLE [Distributor] (
  [DistributorID] INT PRIMARY KEY,
  [DistributorName] VARCHAR(50),
  [TelephoneNumber] VARCHAR(15),
  [Address ID] VARCHAR(200),
  [EmailID] VARCHAR(100)
  );

CREATE INDEX [FK] ON  [Distributor] ([Address ID]);

CREATE TABLE [Item] (
  [ItemNo] VARCHAR(50) PRIMARY KEY,
  [ItemName] VARCHAR(50),
  [CustomerReviews] VARCHAR(200),
  [CategoryID] INT
  );

CREATE INDEX [FK] ON  [Item] ([CategoryID]);

CREATE TABLE [Shipping] (
  [ShippingLabelNo] VARCHAR(50),
  [Origin] VARCHAR(50),
  [Destination] VARCHAR(30),
  [ShippingStatus] VARCHAR(18),
  [ShippingCost] DECIMAL(20,15),
  [VendorID] INT
  );

CREATE INDEX [FK] ON  [Shipping] ([VendorID]);

CREATE TABLE [ItemDistributor] (
  [ItemNo] VARCHAR(50),
  [DistributorID] INT
);

CREATE INDEX [PK, FK1] ON  [ItemDistributor] ([ItemNo]);

CREATE INDEX [PK, FK2] ON  [ItemDistributor] ([DistributorID]);
