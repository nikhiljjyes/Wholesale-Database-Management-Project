Create DATABASE [Wholesale Database Management System];
go
USE [Wholesale Database Management System]
go
CREATE TABLE [Address] (
  [Address ID] INT PRIMARY KEY NOT NULL ,
  [StreetName] VARCHAR(200) NOT NULL ,
  [City] VARCHAR(30) NOT NULL ,
  [State] VARCHAR(30) NOT NULL ,
  [Country] VARCHAR(30) NOT NULL ,
  [ZipCode] INT NOT NULL ,
  );
  GO
CREATE TABLE [Refund] (
  [RefundOrderID] INT PRIMARY KEY NOT NULL ,
  [RefundStatus] VARCHAR(50),
  [RefundAmount] Decimal(20,15)
  );
  GO
CREATE TABLE [Transaction] (
  [TransactionID] INT PRIMARY KEY NOT NULL ,
  [TransactionMode] VARCHAR(20) NOT NULL ,
  [TransactionDate] DATE NOT NULL ,
  [TransactionTime] TIME NOT NULL ,
  [TransactionAmount] DECIMAL(20,5) NOT NULL ,
  [TransactionStatus] VARCHAR(20) NOT NULL ,
);
GO
CREATE TABLE [Category] (
  [CategoryID] INT PRIMARY KEY NOT NULL ,
  [CategoryName] VARCHAR(50) NOT NULL ,
  );
  GO
CREATE TABLE [Coupon] (
  [CouponCode] Decimal(20,15) PRIMARY KEY NOT NULL ,
  [DiscountPercentage] DECIMAL(20,5) NOT NULL ,
  [DateValidTill] DATE NOT NULL ,
 );
 GO

CREATE TABLE [Invoice] (
  [InvoiceID] INT PRIMARY KEY NOT NULL ,
  [InvoiceDate] DATE NOT NULL ,
  [TotalAmount] Decimal(20,15) NOT NULL ,
  [SalesTax] Decimal(20,15) NOT NULL ,
  [Discount] Decimal(20,15) NOT NULL ,
  [CouponCode] Decimal(20,15) NOT NULL 
  FOREIGN KEY ([CouponCode])
        REFERENCES [Coupon]([CouponCode])
        ON update CASCADE);

CREATE INDEX [Coupon_FK] ON  [Invoice] ([CouponCode]);
GO

CREATE TABLE [Employee] (
  [EmployeeID] INT PRIMARY KEY NOT NULL ,
  [FirstName] VARCHAR(20) NOT NULL ,
  [LastName] VARCHAR(20) NOT NULL ,
  [Address ID] INT NOT NULL ,
  [TelephoneNumber] INT NOT NULL ,
  [Email] VARCHAR(50) NOT NULL ,
  FOREIGN KEY ([Address ID])
        REFERENCES [Address]([Address ID])
        ON update CASCADE ON Delete CASCADE);

CREATE INDEX [Address_EMP_FK] ON  [Employee] ([Address ID]);

CREATE TABLE [Order] (
  [OrderID] INT PRIMARY KEY NOT NULL ,
  [OrderDate] DATE NOT NULL ,
  [OrderTime] TIME NOT NULL ,
  [OrderStatus] VARCHAR(20) NOT NULL ,
  [EmployeeID] INT NOT NULL ,
  FOREIGN KEY ([EmployeeID])
        REFERENCES [Employee]([EmployeeID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_O_Emp] ON  [Order] ([EmployeeID]);

CREATE TABLE [Customer] (
  [CustomerID] INT PRIMARY KEY NOT NULL ,
  [FirstName] VARCHAR(50) NOT NULL ,
  [LastName] VARCHAR(50) NOT NULL ,
  [TelephoneNumber] INT NOT NULL ,
  [Address ID] INT NOT NULL ,
  [EmailID] VARCHAR(100) NOT NULL ,
  FOREIGN KEY ([Address ID])
        REFERENCES [Address]([Address ID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_Cust_Add] ON  [Customer] ([Address ID]);

CREATE TABLE [Returns] (
  [ReturnRequestID] INT PRIMARY KEY NOT NULL ,
  [ReturnRequestDate] DATE NOT NULL ,
  [ReturnRequestTime] TIME NOT NULL ,
  [RefundOrderID] INT NOT NULL ,
  FOREIGN KEY ([RefundOrderID])
        REFERENCES [Refund]([RefundOrderID])
        ON update CASCADE ON Delete CASCADE);

CREATE INDEX [FK_RETURN] ON  [Returns] ([RefundOrderID]);
CREATE TABLE [Item] (
  [ItemNo] INT PRIMARY KEY NOT NULL ,
  [ItemName] VARCHAR(50) NOT NULL ,
  [CustomerReviews] VARCHAR(200) NOT NULL ,
  [CategoryID] INT NOT NULL ,
  FOREIGN KEY ([CategoryID])
        REFERENCES [Category]([CategoryID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_Item_cat] ON  [Item] ([CategoryID]);

CREATE TABLE [Distributor] (
  [DistributorID] INT PRIMARY KEY NOT NULL ,
  [DistributorName] VARCHAR(50) NOT NULL ,
  [TelephoneNumber] INT NOT NULL ,
  [Address ID] INT NOT NULL ,
  [EmailID] VARCHAR(100) NOT NULL ,
  FOREIGN KEY ([Address ID])
        REFERENCES [Address]([Address ID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_D_Add] ON  [Distributor] ([Address ID]);

CREATE TABLE [Transportation Vendor] (
  [VendorID] INT PRIMARY KEY NOT NULL ,
  [VendorName] VARCHAR(30) NOT NULL ,
  [Address ID] INT NOT NULL ,
  [EmailID] VARCHAR(150) NOT NULL ,
  FOREIGN KEY ([Address ID])
        REFERENCES [Address]([Address ID])
        ON update CASCADE ON Delete CASCADE  
);

CREATE INDEX [FK_T_Address] ON  [Transportation Vendor] ([Address ID]);

CREATE TABLE [Shipping] (
  [ShippingLabelNo] VARCHAR(50) PRIMARY KEY NOT NULL,
  [Origin] VARCHAR(50) NOT NULL,
  [Destination] VARCHAR(30) NOT NULL,
  [ShippingStatus] VARCHAR(18) NOT NULL,
  [ShippingCost] DECIMAL(20,15) NOT NULL,
  [VendorID] INT NOT NULL,
  FOREIGN KEY ([VendorID])
        REFERENCES [Transportation Vendor]([VendorID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_Vendor] ON  [Shipping] ([VendorID]);

CREATE TABLE [CustomerReturnsOrder] (
  [CustomerID] INT NOT NULL,
  [OrderID] INT NOT NULL,
  [InvoiceID] INT NOT NULL,
  [ReturnRequestID] INT NOT NULL,
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
  [ItemNo] INT NOT NULL,
  [RetailPrice] DECIMAL(20,5) NOT NULL,
  [WholesalePrice] DECIMAL(20,5) NOT NULL,
  [Discount] DECIMAL(20,5) NOT NULL,
  FOREIGN KEY ([ItemNo])
        REFERENCES [Item]([ItemNo])
        ON update CASCADE ON Delete CASCADE);

CREATE INDEX [FK_ITEM] ON  [Price] ([ItemNo]);

CREATE TABLE [Inventory] (
  [ItemNo] INT NOT NULL,
  [QuantityInStock] INT NOT NULL,
  [Inventory Costs] DECIMAL(20,15) NOT NULL,
   FOREIGN KEY ([ItemNo])
        REFERENCES [Item]([ItemNo])
        ON update CASCADE ON Delete CASCADE
);

CREATE INDEX [FK_I_ITEM] ON  [Inventory] ([ItemNo]);

CREATE TABLE [CustomerOrder] (
  [CustomerID] INT NOT NULL,
  [OrderID] INT NOT NULL,
  [InvoiceID] INT NOT NULL,
  [TransactionID] INT NOT NULL,
  [ShippingLabelNo] VARCHAR(50) NOT NULL,
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
  [ItemNo] INT NOT NULL,
  [DistributorID] INT NOT NULL,
    CONSTRAINT PK_ID PRIMARY KEY([ItemNo],[DistributorID])
);
ALTER TABLE [ItemDistributor]
  ADD CONSTRAINT FK_ID_1 FOREIGN KEY ([ItemNo]) REFERENCES [Item]([ItemNo]) ON DELETE NO ACTION ON UPDATE NO ACTION;
    ALTER TABLE [ItemDistributor]
ADD CONSTRAINT FK_ID_2 FOREIGN KEY ([DistributorID]) REFERENCES [Distributor]([DistributorID]) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX [PK_ID, FK_ID_1] ON  [ItemDistributor] ([ItemNo]);

CREATE INDEX [PK_ID, FK_ID_2] ON  [ItemDistributor] ([DistributorID]);


CREATE TABLE [OrderItem] (
  [OrderID] INT NOT NULL,
  [ItemNo] INT NOT NULL,
  [Quantity] INT NOT NULL,
  CONSTRAINT PK_OI PRIMARY KEY([OrderID],[ItemNo])
);
  ALTER TABLE [OrderItem]
  ADD CONSTRAINT FK_OI_1 FOREIGN KEY ([OrderID]) REFERENCES [Order]([OrderID]) ON DELETE NO ACTION ON UPDATE NO ACTION;

    ALTER TABLE [OrderItem]
ADD CONSTRAINT FK_OI_2 FOREIGN KEY ([ItemNo]) REFERENCES [Item]([ItemNo]) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX [PK_OI, FK_OI_1] ON  [OrderItem] ([OrderID]);

CREATE INDEX [PK_OI, FK_OI_2] ON  [OrderItem] ([ItemNo]);

--INSERT DATA 

