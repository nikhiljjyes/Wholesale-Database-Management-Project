Create DATABASE [Wholesale Database Management System];
go
USE [Wholesale Database Management System]
go
CREATE TABLE [Invoice] (
  [InvoiceID] VARCHAR(70) PRIMARY KEY,
  [InvoiceDate] DATE,
  [TotalAmount] Decimal(20,15),
  [SalesTax] Decimal(20,15),
  [Discount] Decimal(20,15),
  [CouponCode] Decimal(20,15)
  );

CREATE INDEX [FK] ON  [Invoice] ([CouponCode]);

CREATE TABLE [Refund] (
  [RefundOrderID] VARCHAR(50) PRIMARY KEY,
  [RefundStatus] VARCHAR(50),
  [RefundAmount] Decimal(20,15)
  );

CREATE TABLE [Employee] (
  [EmployeeID] VARCHAR(50) PRIMARY KEY,
  [FirstName] VARCHAR(20),
  [LastName] VARCHAR(20),
  [Address ID] VARCHAR(100) ,
  [TelephoneNumber] VARCHAR(12),
  [Email] VARCHAR(50),
  );

CREATE INDEX [FK] ON  [Employee] ([Address ID]);

CREATE TABLE [CustomerReturnsOrder] (
  [CustomerID] VARCHAR(30),
  [OrderID] VARCHAR(50),
  [InvoiceID] VARCHAR(100),
  [ReturnRequestID] VARCHAR(100)
);

CREATE INDEX [PK, FK1] ON  [CustomerReturnsOrder] ([CustomerID]);

CREATE INDEX [PK, FK2] ON  [CustomerReturnsOrder] ([OrderID]);

CREATE INDEX [PK, FK3] ON  [CustomerReturnsOrder] ([InvoiceID]);

CREATE INDEX [PK, FK4] ON  [CustomerReturnsOrder] ([ReturnRequestID]);

CREATE TABLE [Returns] (
  [ReturnRequestID] VARCHAR (100) PRIMARY KEY,
  [ReturnRequestDate] DATE,
  [ReturnRequestTime] TIME,
  [RefundOrderID] VARCHAR(50),
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
  [VendorID] VARCHAR(50) PRIMARY KEY,
  [VendorName] VARCHAR(30),
  [Address ID] VARCHAR(100),
  [EmailID] VARCHAR(50)
  
);

CREATE INDEX [FK] ON  [Transportation Vendor] ([Address ID]);

CREATE TABLE [Transaction] (
  [TransactionID] VARCHAR(100) PRIMARY KEY,
  [TransactionMode] VARCHAR(20),
  [TransactionDate] DATE,
  [TransactionTime] TIME,
  [TransactionAmount] DECIMAL(20,5),
  [TransactionStatus] VARCHAR(20),
);

CREATE TABLE [Address] (
  [Address ID] VARCHAR(30) PRIMARY KEY,
  [StreetName] VARCHAR(100),
  [City] VARCHAR(30),
  [State] VARCHAR(30),
  [Country] VARCHAR(30),
  [ZipCode] INT,
  );

CREATE TABLE [Category] (
  [ CategoryID] VARCHAR(50) PRIMARY KEY,
  [CategoryName] VARCHAR(50),
  );

CREATE TABLE [Coupon] (
  [CouponCode] VARCHAR(50) PRIMARY KEY,
  [DiscountPercentage] DECIMAL(20,5),
  [DateValidTill] DATE,
 );



CREATE TABLE [OrderItem] (
  [OrderID] <type>,
  [ItemNo] <type>,
  [Quantity] <type>
);

CREATE INDEX [PK, FK1] ON  [OrderItem] ([OrderID]);

CREATE INDEX [PK, FK2] ON  [OrderItem] ([ItemNo]);

CREATE TABLE [Order] (
  [OrderID] <type>,
  [OrderDate] <type>,
  [OrderTime] <type>,
  [OrderStatus] <type>,
  [EmployeeID] <type>,
  PRIMARY KEY ([OrderID])
);

CREATE INDEX [FK] ON  [Order] ([EmployeeID]);

CREATE TABLE [Inventory] (
  [ItemNo] <type>,
  [QuantityInStock] <type>,
  [Inventory Costs] <type>
);

CREATE INDEX [FK] ON  [Inventory] ([ItemNo]);

CREATE TABLE [Customer] (
  [CustomerID] <type>,
  [FirstName] <type>,
  [LastName] <type>,
  [TelephoneNumber] <type>,
  [Address ID] <type>,
  [EmailID] <type>,
  PRIMARY KEY ([CustomerID])
);

CREATE INDEX [FK] ON  [Customer] ([Address ID]);

CREATE TABLE [CustomerOrder] (
  [CustomerID] <type>,
  [OrderID] <type>,
  [InvoiceID] <type>,
  [TransactionID] <type>,
  [ShippingLabelNo] <type>
);

CREATE INDEX [PK, FK1] ON  [CustomerOrder] ([CustomerID]);

CREATE INDEX [PK, FK2] ON  [CustomerOrder] ([OrderID]);

CREATE INDEX [PK, FK3] ON  [CustomerOrder] ([InvoiceID]);

CREATE INDEX [PK, FK4] ON  [CustomerOrder] ([TransactionID]);

CREATE INDEX [PK, FK5] ON  [CustomerOrder] ([ShippingLabelNo]);

CREATE TABLE [Distributor] (
  [DistributorID] <type>,
  [DistributorName] <type>,
  [TelephoneNumber] <type>,
  [Address ID] <type>,
  [EmailID] <type>,
  PRIMARY KEY ([DistributorID])
);

CREATE INDEX [FK] ON  [Distributor] ([Address ID]);

CREATE TABLE [Item] (
  [ItemNo] <type>,
  [ItemName] <type>,
  [CustomerReviews] <type>,
  [CategoryID] <type>,
  PRIMARY KEY ([ItemNo])
);

CREATE INDEX [FK] ON  [Item] ([CategoryID]);

CREATE TABLE [Shipping] (
  [ShippingLabelNo] <type>,
  [Origin] <type>,
  [Destination] <type>,
  [ShippingStatus] <type>,
  [ShippingCost] <type>,
  [VendorID] <type>,
  PRIMARY KEY ([ShippingLabelNo])
);

CREATE INDEX [FK] ON  [Shipping] ([VendorID]);

CREATE TABLE [ItemDistributor] (
  [ItemNo] <type>,
  [DistributorID] <type>
);

CREATE INDEX [PK, FK1] ON  [ItemDistributor] ([ItemNo]);

CREATE INDEX [PK, FK2] ON  [ItemDistributor] ([DistributorID]);

