Create DATABASE [Wholesale Database Management System];
go
USE [Wholesale Database Management System]
go
CREATE TABLE [Address] (
  [Address ID] INT PRIMARY KEY,
  [StreetName] VARCHAR(200),
  [City] VARCHAR(30),
  [State] VARCHAR(30),
  [Country] VARCHAR(30),
  [ZipCode] INT,
  );
  GO
CREATE TABLE [Refund] (
  [RefundOrderID] INT PRIMARY KEY,
  [RefundStatus] VARCHAR(50),
  [RefundAmount] Decimal(20,15)
  );
  GO
CREATE TABLE [Transaction] (
  [TransactionID] INT PRIMARY KEY,
  [TransactionMode] VARCHAR(20),
  [TransactionDate] DATE,
  [TransactionTime] TIME,
  [TransactionAmount] DECIMAL(20,5),
  [TransactionStatus] VARCHAR(20),
);
GO
CREATE TABLE [Category] (
  [CategoryID] INT PRIMARY KEY,
  [CategoryName] VARCHAR(50),
  );
  GO
CREATE TABLE [Coupon] (
  [CouponCode] Decimal(20,15) PRIMARY KEY,
  [DiscountPercentage] DECIMAL(20,5),
  [DateValidTill] DATE,
 );
 GO

CREATE TABLE [Invoice] (
  [InvoiceID] INT PRIMARY KEY,
  [InvoiceDate] DATE,
  [TotalAmount] Decimal(20,15),
  [SalesTax] Decimal(20,15),
  [Discount] Decimal(20,15),
  [CouponCode] Decimal(20,15)
  FOREIGN KEY ([CouponCode])
        REFERENCES [Coupon]([CouponCode])
        ON update CASCADE);

CREATE INDEX [Coupon_FK] ON  [Invoice] ([CouponCode]);
GO



CREATE TABLE [Employee] (
  [EmployeeID] INT PRIMARY KEY,
  [FirstName] VARCHAR(20),
  [LastName] VARCHAR(20),
  [Address ID] INT ,
  [TelephoneNumber] INT,
  [Email] VARCHAR(50),
  FOREIGN KEY ([Address ID])
        REFERENCES [Address]([Address ID])
        ON update CASCADE ON Delete CASCADE);

CREATE INDEX [Address_EMP_FK] ON  [Employee] ([Address ID]);

CREATE TABLE [Order] (
  [OrderID] INT PRIMARY KEY,
  [OrderDate] DATE,
  [OrderTime] TIME,
  [OrderStatus] VARCHAR(20),
  [EmployeeID] INT,
  FOREIGN KEY ([EmployeeID])
        REFERENCES [Employee]([EmployeeID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_O_Emp] ON  [Order] ([EmployeeID]);

CREATE TABLE [Customer] (
  [CustomerID] INT PRIMARY KEY,
  [FirstName] VARCHAR(50),
  [LastName] VARCHAR(50),
  [TelephoneNumber] INT,
  [Address ID] INT,
  [EmailID] VARCHAR(100),
  FOREIGN KEY ([Address ID])
        REFERENCES [Address]([Address ID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_Cust_Add] ON  [Customer] ([Address ID]);

CREATE TABLE [Returns] (
  [ReturnRequestID] INT PRIMARY KEY,
  [ReturnRequestDate] DATE,
  [ReturnRequestTime] TIME,
  [RefundOrderID] INT,
  FOREIGN KEY ([RefundOrderID])
        REFERENCES [Refund]([RefundOrderID])
        ON update CASCADE ON Delete CASCADE);

CREATE INDEX [FK_RETURN] ON  [Returns] ([RefundOrderID]);
CREATE TABLE [Item] (
  [ItemNo] INT PRIMARY KEY,
  [ItemName] VARCHAR(50),
  [CustomerReviews] VARCHAR(200),
  [CategoryID] INT,
  FOREIGN KEY ([CategoryID])
        REFERENCES [Category]([CategoryID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_Item_cat] ON  [Item] ([CategoryID]);

CREATE TABLE [Distributor] (
  [DistributorID] INT PRIMARY KEY,
  [DistributorName] VARCHAR(50),
  [TelephoneNumber] INT,
  [Address ID] INT,
  [EmailID] VARCHAR(100),
  FOREIGN KEY ([Address ID])
        REFERENCES [Address]([Address ID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_D_Add] ON  [Distributor] ([Address ID]);

CREATE TABLE [Transportation Vendor] (
  [VendorID] INT PRIMARY KEY,
  [VendorName] VARCHAR(30),
  [Address ID] INT,
  [EmailID] VARCHAR(150),
  FOREIGN KEY ([Address ID])
        REFERENCES [Address]([Address ID])
        ON update CASCADE ON Delete CASCADE  
);

CREATE INDEX [FK_T_Address] ON  [Transportation Vendor] ([Address ID]);

CREATE TABLE [Shipping] (
  [ShippingLabelNo] VARCHAR(50) PRIMARY KEY,
  [Origin] VARCHAR(50),
  [Destination] VARCHAR(30),
  [ShippingStatus] VARCHAR(18),
  [ShippingCost] DECIMAL(20,15),
  [VendorID] INT,
  FOREIGN KEY ([VendorID])
        REFERENCES [Transportation Vendor]([VendorID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_Vendor] ON  [Shipping] ([VendorID]);

CREATE TABLE [CustomerReturnsOrder] (
  [CustomerID] INT,
  [OrderID] INT,
  [InvoiceID] INT,
  [ReturnRequestID] INT,
  CONSTRAINT PK_CRO PRIMARY KEY([CustomerID],[OrderID],[InvoiceID],[ReturnRequestID])
  );
  GO
  ALTER TABLE [CustomerReturnsOrder]
  ADD CONSTRAINT FK_CRO_1 FOREIGN KEY ([CustomerID]) REFERENCES [Customer]([CustomerID]) ON DELETE NO ACTION ON UPDATE NO ACTION;

    ALTER TABLE [CustomerReturnsOrder]
  ADD CONSTRAINT FK_CRO_2 FOREIGN KEY ([OrderID]) REFERENCES [Order]([OrderID]) ON DELETE NO ACTION ON UPDATE NO ACTION;

    ALTER TABLE [CustomerReturnsOrder]
  ADD CONSTRAINT FK_CRO_3 FOREIGN KEY ([InvoiceID]) REFERENCES [Invoice]([InvoiceID]) ON DELETE NO ACTION ON UPDATE NO ACTION;

    ALTER TABLE [CustomerReturnsOrder]
  ADD CONSTRAINT FK_CRO_4 FOREIGN KEY ([ReturnRequestID]) REFERENCES [Returns]([ReturnRequestID]) ON DELETE CASCADE ON UPDATE CASCADE;

  GO
CREATE INDEX [PK_CRO, FK_CRO_1] ON  [CustomerReturnsOrder] ([CustomerID]);

CREATE INDEX [PK_CRO, FK_CRO_2] ON  [CustomerReturnsOrder] ([OrderID]);

CREATE INDEX [PK_CRO, FK_CRO_3] ON  [CustomerReturnsOrder] ([InvoiceID]);

CREATE INDEX [PK_CRO, FK_CRO_4] ON  [CustomerReturnsOrder] ([ReturnRequestID]);
GO

CREATE TABLE [Price] (
  [ItemNo] INT,
  [RetailPrice] DECIMAL(20,5),
  [WholesalePrice] DECIMAL(20,5),
  [Discount] DECIMAL(20,5),
  FOREIGN KEY ([ItemNo])
        REFERENCES [Item]([ItemNo])
        ON update CASCADE ON Delete CASCADE);

CREATE INDEX [FK_ITEM] ON  [Price] ([ItemNo]);



CREATE TABLE [Inventory] (
  [ItemNo] INT,
  [QuantityInStock] INT,
  [Inventory Costs] DECIMAL(20,15),
   FOREIGN KEY ([ItemNo])
        REFERENCES [Item]([ItemNo])
        ON update CASCADE ON Delete CASCADE
);

CREATE INDEX [FK_I_ITEM] ON  [Inventory] ([ItemNo]);



CREATE TABLE [CustomerOrder] (
  [CustomerID] INT,
  [OrderID] INT,
  [InvoiceID] INT,
  [TransactionID] INT,
  [ShippingLabelNo] VARCHAR(50),
  CONSTRAINT PK_CO PRIMARY KEY([CustomerID],[OrderID],[InvoiceID],[TransactionID],[ShippingLabelNo])
);
 GO
  ALTER TABLE [CustomerOrder]
  ADD CONSTRAINT FK_CO_1 FOREIGN KEY ([CustomerID]) REFERENCES [Customer]([CustomerID]) ON DELETE NO ACTION ON UPDATE NO ACTION;

    ALTER TABLE [CustomerOrder]
  ADD CONSTRAINT FK_CO_2 FOREIGN KEY ([OrderID]) REFERENCES [Order]([OrderID]) ON DELETE NO ACTION ON UPDATE NO ACTION;
    ALTER TABLE [CustomerOrder]
  ADD CONSTRAINT FK_CO_3 FOREIGN KEY ([InvoiceID]) REFERENCES [Invoice]([InvoiceID]) ON DELETE NO ACTION ON UPDATE NO ACTION;
    ALTER TABLE [CustomerOrder]
  ADD CONSTRAINT FK_CO_4 FOREIGN KEY ([TransactionID]) REFERENCES [Transaction]([TransactionID]) ON DELETE NO ACTION ON UPDATE NO ACTION;
  ALTER TABLE [CustomerOrder]
  ADD CONSTRAINT FK_CO_5 FOREIGN KEY ([ShippingLabelNo]) REFERENCES [Shipping]([ShippingLabelNo]) ON DELETE NO ACTION ON UPDATE NO ACTION;
  GO

CREATE INDEX [PK_CO, FK_CO_1] ON  [CustomerOrder] ([CustomerID]);

CREATE INDEX [PK_CO, FK_CO_2] ON  [CustomerOrder] ([OrderID]);

CREATE INDEX [PK_CO, FK_CO_3] ON  [CustomerOrder] ([InvoiceID]);

CREATE INDEX [PK_CO, FK_CO_4] ON  [CustomerOrder] ([TransactionID]);

CREATE INDEX [PK_CO, FK_CO_5] ON  [CustomerOrder] ([ShippingLabelNo]);





CREATE TABLE [ItemDistributor] (
  [ItemNo] INT,
  [DistributorID] INT,
    CONSTRAINT PK_ID PRIMARY KEY([ItemNo],[DistributorID])
);
ALTER TABLE [ItemDistributor]
  ADD CONSTRAINT FK_ID_1 FOREIGN KEY ([ItemNo]) REFERENCES [Item]([ItemNo]) ON DELETE NO ACTION ON UPDATE NO ACTION;
    ALTER TABLE [ItemDistributor]
ADD CONSTRAINT FK_ID_2 FOREIGN KEY ([DistributorID]) REFERENCES [Distributor]([DistributorID]) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX [PK_ID, FK_ID_1] ON  [ItemDistributor] ([ItemNo]);

CREATE INDEX [PK_ID, FK_ID_2] ON  [ItemDistributor] ([DistributorID]);


CREATE TABLE [OrderItem] (
  [OrderID] INT,
  [ItemNo] INT,
  [Quantity] INT,
  CONSTRAINT PK_OI PRIMARY KEY([OrderID],[ItemNo])
);
  ALTER TABLE [OrderItem]
  ADD CONSTRAINT FK_OI_1 FOREIGN KEY ([OrderID]) REFERENCES [Order]([OrderID]) ON DELETE NO ACTION ON UPDATE NO ACTION;

    ALTER TABLE [OrderItem]
ADD CONSTRAINT FK_OI_2 FOREIGN KEY ([ItemNo]) REFERENCES [Item]([ItemNo]) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX [PK_OI, FK_OI_1] ON  [OrderItem] ([OrderID]);

CREATE INDEX [PK_OI, FK_OI_2] ON  [OrderItem] ([ItemNo]);



