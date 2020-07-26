Create DATABASE [Wholesale Database Management System];
go
USE [Wholesale Database Management System]
go
CREATE TABLE [Invoice] (
  [InvoiceID] <type>,
  [InvoiceDate] <type>,
  [TotalAmount] <type>,
  [SalesTax] <type>,
  [Discount] <type>,
  [CouponCode] <type>,
  PRIMARY KEY ([InvoiceID])
);

CREATE INDEX [FK] ON  [Invoice] ([CouponCode]);

CREATE TABLE [Refund] (
  [RefundOrderID] <type>,
  [RefundStatus] <type>,
  [RefundAmount] <type>,
  PRIMARY KEY ([RefundOrderID])
);

CREATE TABLE [Employee] (
  [EmployeeID] <type>,
  [FirstName] <type>,
  [LastName] <type>,
  [Address ID] <type>,
  [TelephoneNumber] <type>,
  [Email] <type>,
  PRIMARY KEY ([EmployeeID])
);

CREATE INDEX [FK] ON  [Employee] ([Address ID]);

CREATE TABLE [CustomerReturnsOrder] (
  [CustomerID] <type>,
  [OrderID] <type>,
  [InvoiceID] <type>,
  [ReturnRequestID] <type>
);

CREATE INDEX [PK, FK1] ON  [CustomerReturnsOrder] ([CustomerID]);

CREATE INDEX [PK, FK2] ON  [CustomerReturnsOrder] ([OrderID]);

CREATE INDEX [PK, FK3] ON  [CustomerReturnsOrder] ([InvoiceID]);

CREATE INDEX [PK, FK4] ON  [CustomerReturnsOrder] ([ReturnRequestID]);

CREATE TABLE [Returns] (
  [ReturnRequestID] <type>,
  [ReturnRequestDate] <type>,
  [ReturnRequestTime] <type>,
  [RefundOrderID] <type>,
  PRIMARY KEY ([ReturnRequestID])
);

CREATE INDEX [FK] ON  [Returns] ([RefundOrderID]);

CREATE TABLE [Price] (
  [ItemNo] <type>,
  [RetailPrice] <type>,
  [WholesalePrice] <type>,
  [Discount] <type>
);

CREATE INDEX [FK] ON  [Price] ([ItemNo]);

CREATE TABLE [Transportation Vendor] (
  [VendorID] <type>,
  [VendorName] <type>,
  [Address ID] <type>,
  [EmailID] <type>,
  PRIMARY KEY ([VendorID])
);

CREATE INDEX [FK] ON  [Transportation Vendor] ([Address ID]);

CREATE TABLE [Transaction] (
  [TransactionID] <type>,
  [TransactionMode] <type>,
  [TransactionDate] <type>,
  [TransactionTime] <type>,
  [TransactionAmount] <type>,
  [TransactionStatus] <type>,
  PRIMARY KEY ([TransactionID])
);

CREATE TABLE [Address] (
  [Address ID] <type>,
  [StreetName] <type>,
  [City] <type>,
  [State] <type>,
  [Country] <type>,
  [ZipCode] <type>,
  PRIMARY KEY ([Address ID])
);

CREATE TABLE [Category] (
  [ CategoryID] <type>,
  [CategoryName] <type>,
  PRIMARY KEY ([ CategoryID])
);

CREATE TABLE [Coupon] (
  [CouponCode] <type>,
  [DiscountPercentage] <type>,
  [DateValidTill] <type>,
  PRIMARY KEY ([CouponCode])
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

