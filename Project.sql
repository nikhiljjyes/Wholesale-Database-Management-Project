--CREATE DATABASE
Create DATABASE [Wholesale Database Management System];
go
USE [Wholesale Database Management System];
go
-------------------------------------------------------------------------------------------------------
--CREATE TABLES
CREATE TABLE [Address] (
  [Address ID] INT PRIMARY KEY NOT NULL ,
  [AddressLine 1] VARCHAR(200) NOT NULL ,
  [AddressLine 2] VARCHAR(200) NOT NULL ,
  [City] VARCHAR(30) NOT NULL ,
  [State] VARCHAR(30) NOT NULL ,
  [Country] VARCHAR(30) NOT NULL ,
  [ZipCode] INT NOT NULL 
  );
  GO
  -------------------------------------------------------------------------------------------------------
CREATE TABLE [Refund] (
  [RefundOrderID] INT PRIMARY KEY NOT NULL ,
  [RefundStatus] VARCHAR(50) NOT NULL,
  [RefundAmount] Decimal(20,2) 
  );
  GO
  -------------------------------------------------------------------------------------------------------
CREATE TABLE [Transaction] (
  [TransactionID] INT PRIMARY KEY NOT NULL ,
  [TransactionMode] VARCHAR(20) NOT NULL ,
  [TransactionDate] DATE NOT NULL ,
  [TransactionTime] TIME NOT NULL ,
  [TransactionAmount] DECIMAL(20,2) NOT NULL ,
  [TransactionStatus] VARCHAR(20) NOT NULL 
  );
GO
-------------------------------------------------------------------------------------------------------
CREATE TABLE [Category] (
  [CategoryID] INT PRIMARY KEY NOT NULL ,
  [CategoryName] VARCHAR(50) NOT NULL 
  );
  GO
  -------------------------------------------------------------------------------------------------------
CREATE TABLE [Coupon] (
  [CouponCode] VARCHAR(30) PRIMARY KEY NOT NULL ,
  [DiscountPercentage] DECIMAL(4,2) NOT NULL ,
  [DateValidTill] DATE NOT NULL 
  );
 GO
 -------------------------------------------------------------------------------------------------------

CREATE TABLE [Invoice] (
  [InvoiceID] INT PRIMARY KEY NOT NULL ,
  [InvoiceDate] DATE NOT NULL ,
  [TotalAmount] Decimal(20,2) NOT NULL ,
  [SalesTax] Decimal(20,2) NOT NULL ,
  [Discount] Decimal(4,2)  ,
  [CouponCode] VARCHAR(30)  
  FOREIGN KEY ([CouponCode])
        REFERENCES [Coupon]([CouponCode])
        ON update CASCADE,
		CHECK ([Discount] <=100.00)
  );

CREATE INDEX [Coupon_FK] ON  [Invoice] ([CouponCode]);
GO
-------------------------------------------------------------------------------------------------------

CREATE TABLE [Employee] (
  [EmployeeID] INT PRIMARY KEY NOT NULL ,
  [FirstName] VARCHAR(20) NOT NULL ,
  [LastName] VARCHAR(20) NOT NULL ,
  [Address ID] INT NOT NULL ,
  [TelephoneNumber] VARCHAR(30) NOT NULL ,
  [Email] VARCHAR(50) NOT NULL ,
  FOREIGN KEY ([Address ID])
        REFERENCES [Address]([Address ID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [Address_EMP_FK] ON  [Employee] ([Address ID]);
GO
-------------------------------------------------------------------------------------------------------
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
GO
-------------------------------------------------------------------------------------------------------

CREATE TABLE [Customer] (
  [CustomerID] INT PRIMARY KEY NOT NULL ,
  [FirstName] VARCHAR(50) NOT NULL ,
  [LastName] VARCHAR(50) NOT NULL ,
  [TelephoneNumber] VARCHAR(30) NOT NULL ,
  [Address ID] INT NOT NULL ,
  [EmailID] VARCHAR(100) NOT NULL ,
  FOREIGN KEY ([Address ID])
        REFERENCES [Address]([Address ID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_Cust_Add] ON  [Customer] ([Address ID]);
GO
-------------------------------------------------------------------------------------------------------
CREATE TABLE [Returns] (
  [ReturnRequestID] INT PRIMARY KEY NOT NULL ,
  [ReturnRequestDate] DATE NOT NULL ,
  [ReturnRequestTime] TIME NOT NULL ,
  [RefundOrderID] INT  ,
  FOREIGN KEY ([RefundOrderID])
        REFERENCES [Refund]([RefundOrderID])
        ON update CASCADE ON Delete CASCADE);

CREATE INDEX [FK_RETURN] ON  [Returns] ([RefundOrderID]);
GO
-------------------------------------------------------------------------------------------------------

CREATE TABLE [Item] (
  [ItemNo] INT PRIMARY KEY NOT NULL ,
  [ItemName] VARCHAR(50) NOT NULL ,
  [CustomerReviews] VARCHAR(200) NOT NULL ,
  [CategoryID] INT  NOT NULL,
  FOREIGN KEY ([CategoryID])
        REFERENCES [Category]([CategoryID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_Item_cat] ON  [Item] ([CategoryID]);
GO
-------------------------------------------------------------------------------------------------------

CREATE TABLE [Distributor] (
  [DistributorID] INT PRIMARY KEY NOT NULL ,
  [DistributorName] VARCHAR(50) NOT NULL ,
  [TelephoneNumber] VARCHAR(30) NOT NULL ,
  [Address ID] INT NOT NULL ,
  [EmailID] VARCHAR(100) NOT NULL ,
  FOREIGN KEY ([Address ID])
        REFERENCES [Address]([Address ID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_D_Add] ON  [Distributor] ([Address ID]);
GO
-------------------------------------------------------------------------------------------------------
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
GO
-------------------------------------------------------------------------------------------------------
CREATE TABLE [Shipping] (
  [ShippingLabelNo] VARCHAR(50) PRIMARY KEY NOT NULL,
  [Origin] VARCHAR(50) NOT NULL,
  [Destination] VARCHAR(30) NOT NULL,
  [ShippingStatus] VARCHAR(18) NOT NULL,
  [ShippingCost] DECIMAL(20,2) NOT NULL,
  [VendorID] INT NOT NULL,
  FOREIGN KEY ([VendorID])
        REFERENCES [Transportation Vendor]([VendorID])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_Vendor] ON  [Shipping] ([VendorID]);
GO
-------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------
CREATE TABLE [Price] (
  [ItemNo] INT NOT NULL,
  [RetailPrice] DECIMAL(20,2) NOT NULL,
  [WholesalePrice] DECIMAL(20,2) NOT NULL,
  [Discount] DECIMAL(4,2) ,
  FOREIGN KEY ([ItemNo])
        REFERENCES [Item]([ItemNo])
        ON update CASCADE ON Delete CASCADE,
		CHECK ([Discount] <=100.00)
  );

CREATE INDEX [FK_ITEM] ON  [Price] ([ItemNo]);
GO
-------------------------------------------------------------------------------------------------------
CREATE TABLE [Inventory] (
  [ItemNo] INT NOT NULL,
  [QuantityInStock] INT NOT NULL,
  [Inventory Costs] DECIMAL(20,2) NOT NULL,
   FOREIGN KEY ([ItemNo])
        REFERENCES [Item]([ItemNo])
        ON update CASCADE ON Delete CASCADE
  );

CREATE INDEX [FK_I_ITEM] ON  [Inventory] ([ItemNo]);
GO
-------------------------------------------------------------------------------------------------------
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
GO
-------------------------------------------------------------------------------------------------------
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
GO
-------------------------------------------------------------------------------------------------------
CREATE TABLE [OrderItem] (
  [OrderID] INT NOT NULL,
  [ItemNo] INT NOT NULL,
  [Quantity] INT NOT NULL,
  CONSTRAINT PK_OI PRIMARY KEY([OrderID],[ItemNo]),
  CHECK ([Quantity] >=50)
  );
  
ALTER TABLE [OrderItem]
ADD CONSTRAINT FK_OI_1 FOREIGN KEY ([OrderID]) REFERENCES [Order]([OrderID]) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE [OrderItem]
ADD CONSTRAINT FK_OI_2 FOREIGN KEY ([ItemNo]) REFERENCES [Item]([ItemNo]) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX [PK_OI, FK_OI_1] ON  [OrderItem] ([OrderID]);

CREATE INDEX [PK_OI, FK_OI_2] ON  [OrderItem] ([ItemNo]);
GO
-- Table Level Constraint using a function
CREATE FUNCTION CheckFnctn()  
RETURNS int  
AS   
BEGIN  
   DECLARE @retval int  
   SELECT @retval = COUNT(*) FROM [Category]  
   RETURN @retval  
END;  
GO  
ALTER TABLE [Category]  
ADD CONSTRAINT chkRowCount CHECK (dbo.CheckFnctn() >= 1 );  
GO 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Computed Columns based on FUNCTIONS
CREATE FUNCTION ParticularMonthYearSales (@Year INT, @Month INT)
	   RETURNS DEC (20, 2)
AS
BEGIN
	DECLARE @TotalSale DEC (20, 2)
	SELECT @TotalSale = ISNULL(SUM(TransactionAmount), 0)
	FROM [Wholesale Database Management System].[dbo].[Transaction]
	WHERE YEAR(TransactionDate) = @Year AND MONTH(TransactionDate) = @Month
	RETURN @TotalSale
END;
go
--
CREATE FUNCTION MonthlySalesTax (@Year INT, @Month INT)
		RETURNS DEC (20, 2)
AS
BEGIN
	DECLARE @TotalSalesTax DEC (20, 2)
	SELECT @TotalSalesTax = ISNULL(SUM(SalesTax), 0)
	FROM [Wholesale Database Management System].[dbo].[Invoice]
	WHERE YEAR(InvoiceDate) = @Year AND MONTH(InvoiceDate) = @Month
	RETURN @TotalSalesTax
END;
go
--
CREATE FUNCTION AVGMonthlyDiscount (@Year INT, @Month INT)
		RETURNS DEC (20, 2)
AS
BEGIN
	DECLARE @AVGDiscount DEC (20, 2)
	SELECT @AVGDiscount = ISNULL(AVG(Discount), 0)
	FROM [Wholesale Database Management System].[dbo].[Invoice]
	WHERE YEAR(InvoiceDate) = @Year AND MONTH(InvoiceDate) = @Month
	RETURN @AVGDiscount
END;
go
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------
CREATE TRIGGER [dbo].transact
   ON [dbo].[Transaction]
   AFTER UPDATE
AS BEGIN
    SET NOCOUNT ON; 

 IF (SELECT D.TransactionStatus  FROM [Transaction] O inner join inserted d on o.TransactionID = d.[TransactionID]                
    WHERE D.[TransactionID] = d.[TransactionID]  )  = 'Approved'

UPDATE [Order]
    SET [OrderStatus] = 'Completed' FROM [Order] S 
    INNER JOIN CustomerOrder I ON S.[OrderID] = I.[OrderID] 
    INNER JOIN inserted D ON I.TransactionID = D.[TransactionID]    ;
ELSE
UPDATE [Order]
    SET [OrderStatus] = 'Pending' FROM [Order] S 
    INNER JOIN CustomerOrder I ON S.[OrderID] = I.[OrderID] 
    INNER JOIN inserted D ON I.TransactionID = D.[TransactionID]   ;
END
go
--
CREATE Trigger ComputeSalesTax
ON [dbo].[Invoice]
AFTER INSERT, UPDATE
AS 
BEGIN
 DECLARE @InvoiceID INT
 SET @InvoiceID = ISNULL((SELECT InvoiceID FROM inserted), (SELECT InvoiceID FROM deleted))
 UPDATE [dbo].[Invoice]
 SET SalesTax = 0.15*TotalAmount
 WHERE @InvoiceID = InvoiceID
 END;
 go
 -- 
CREATE TRIGGER ComputeInventorycosts
ON [dbo].[Inventory]
AFTER INSERT, UPDATE
AS 
BEGIN
DECLARE @Itemno INT
SET @Itemno= ISNULL((SELECT [ItemNo] FROM inserted), (SELECT [ItemNo] FROM deleted))
UPDATE [Inventory]
SET [Inventory Costs]= 0.01*QuantityInStock
WHERE @Itemno=[ItemNo]
END;
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- POPULATING DATABASE WITH TEST DATA
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1010, '53', 'Vermont', 'Toledo', 'Ohio', 'United States', '43605');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1011, '02', 'Esch', 'Bethesda', 'Maryland', 'United States', '20816');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1012, '57', 'Walton', 'Philadelphia', 'Pennsylvania', 'United States', '19196');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1013, '949', 'Elmside', 'Little Rock', 'Arkansas', 'United States', '72231');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1014, '7', 'Coleman', 'London', 'Kentucky', 'United States', '40745');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1015, '635', 'Declaration', 'Washington', 'District of Columbia', 'United States', '20244');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1016, '861', 'Dixon', 'San Antonio', 'Texas', 'United States', '78278');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1017, '9', 'Portage', 'Columbus', 'Ohio', 'United States', '43204');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1018, '9', 'Namekagon', 'Louisville', 'Kentucky', 'United States', '40233');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1019, '9278', 'Buhler', 'Arlington', 'Texas', 'United States', '76096');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1020, '21103', 'Dovetail', 'Arlington', 'Virginia', 'United States', '22225');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1021, '60', 'Cascade', 'Lexington', 'Kentucky', 'United States', '40586');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1022, '57656', 'Vernon', 'Minneapolis', 'Minnesota', 'United States', '55412');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1023, '73117', 'Nancy', 'Memphis', 'Tennessee', 'United States', '38104');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1024, '6588', 'Kensington', 'Indianapolis', 'Indiana', 'United States', '46231');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1025, '3102', 'Clyde Gallagher', 'Fresno', 'California', 'United States', '93740');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1026, '0222', 'Veith', 'Austin', 'Texas', 'United States', '78778');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1027, '05', 'Fordem', 'New York City', 'New York', 'United States', '10125');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1028, '5', 'Morningstar', 'Albuquerque', 'New Mexico', 'United States', '87195');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1029, '8494', 'Fairview', 'Scottsdale', 'Arizona', 'United States', '85271');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1030, '6665', 'Schlimgen', 'Topeka', 'Kansas', 'United States', '66611');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1031, '6076', 'Bellgrove', 'Sparks', 'Nevada', 'United States', '89436');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1032, '84', 'Schlimgen', 'Kansas City', 'Missouri', 'United States', '64153');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1033, '4881', 'Mendota', 'Lawrenceville', 'Georgia', 'United States', '30245');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1034, '80500', 'Linden', 'Raleigh', 'North Carolina', 'United States', '27635');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1035, '495', 'Rusk', 'Brooklyn', 'New York', 'United States', '11205');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1036, '72161', 'Porter', 'Las Vegas', 'Nevada', 'United States', '89115');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1037, '8', 'Ridge Oak', 'Farmington', 'Michigan', 'United States', '48335');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1038, '6', '4th', 'Aurora', 'Illinois', 'United States', '60505');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1039, '91748', 'Swallow', 'Aurora', 'Colorado', 'United States', '80045');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1040, '46', 'Mcguire', 'Fredericksburg', 'Virginia', 'United States', '22405');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1041, '361', 'Nancy', 'Knoxville', 'Tennessee', 'United States', '37919');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1042, '0226', 'Clyde Gallagher', 'Santa Barbara', 'California', 'United States', '93150');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1043, '01', 'Prairieview', 'Galveston', 'Texas', 'United States', '77554');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1044, '7', 'Buhler', 'Norfolk', 'Virginia', 'United States', '23509');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1045, '307', 'Roxbury', 'Philadelphia', 'Pennsylvania', 'United States', '19120');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1046, '780', 'Messerschmidt', 'Trenton', 'New Jersey', 'United States', '08695');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1047, '09', 'Meadow Ridge', 'Houston', 'Texas', 'United States', '77201');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1048, '52', 'Ohio', 'Louisville', 'Kentucky', 'United States', '40250');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1049, '00765', 'Maple Wood', 'Washington', 'District of Columbia', 'United States', '20599');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1050, '96442', 'Becker', 'Corona', 'California', 'United States', '92878');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1051, '6', 'Farwell', 'Sacramento', 'California', 'United States', '95852');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1052, '8949', 'American Ash', 'North Las Vegas', 'Nevada', 'United States', '89036');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1053, '22661', 'Fairfield', 'Baltimore', 'Maryland', 'United States', '21275');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1054, '28', 'Sachs', 'Charlotte', 'North Carolina', 'United States', '28247');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1055, '341', 'New Castle', 'El Paso', 'Texas', 'United States', '79999');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1056, '76', 'Rusk', 'San Francisco', 'California', 'United States', '94169');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1057, '38', 'Longview', 'Phoenix', 'Arizona', 'United States', '85025');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1058, '2', 'Orin', 'Columbia', 'South Carolina', 'United States', '29215');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1059, '82708', 'Stoughton', 'Santa Monica', 'California', 'United States', '90410');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1060, '45', 'Hazelcrest', 'Wichita', 'Kansas', 'United States', '67236');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1061, '9', 'Havey', 'Pittsburgh', 'Pennsylvania', 'United States', '15225');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1062, '3', 'Morningstar', 'Chicago', 'Illinois', 'United States', '60619');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1063, '95497', 'Transport', 'Bethesda', 'Maryland', 'United States', '20816');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1064, '18', 'Hermina', 'Dallas', 'Texas', 'United States', '75397');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1065, '735', 'Northview', 'Memphis', 'Tennessee', 'United States', '38150');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1066, '179', 'Loftsgordon', 'Sacramento', 'California', 'United States', '94230');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1067, '5208', 'Talisman', 'Salt Lake City', 'Utah', 'United States', '84105');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1068, '28', 'Pankratz', 'Murfreesboro', 'Tennessee', 'United States', '37131');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1069, '00199', 'Amoth', 'Salt Lake City', 'Utah', 'United States', '84130');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1070, '232', 'Glacier Hill', 'Houston', 'Texas', 'United States', '77060');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1071, '29', 'Tony', 'Terre Haute', 'Indiana', 'United States', '47812');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1072, '8', 'Delaware', 'Huntsville', 'Alabama', 'United States', '35810');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1073, '41303', 'Dakota', 'Lynchburg', 'Virginia', 'United States', '24515');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1074, '81', 'Graceland', 'Anchorage', 'Alaska', 'United States', '99517');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1075, '6', 'Grover', 'Kansas City', 'Missouri', 'United States', '64136');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1076, '14', 'Marcy', 'Lynchburg', 'Virginia', 'United States', '24515');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1077, '59', 'Troy', 'Roanoke', 'Virginia', 'United States', '24048');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1078, '4', 'Northfield', 'Fresno', 'California', 'United States', '93726');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1079, '38596', 'Utah', 'Montgomery', 'Alabama', 'United States', '36177');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1080, '2', 'Kennedy', 'Roanoke', 'Virginia', 'United States', '24020');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1081, '68465', 'Darwin', 'Bradenton', 'Florida', 'United States', '34282');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1082, '74', 'Dawn', 'Miami', 'Florida', 'United States', '33153');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1083, '1269', 'Stephen', 'Colorado Springs', 'Colorado', 'United States', '80925');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1084, '1502', 'Glacier Hill', 'Kansas City', 'Missouri', 'United States', '64160');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1085, '504', 'Ohio', 'Arlington', 'Texas', 'United States', '76011');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1086, '8', 'Annamark', 'Boise', 'Idaho', 'United States', '83711');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1087, '987', 'Twin Pines', 'Dallas', 'Texas', 'United States', '75397');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1088, '11', 'Orin', 'Eugene', 'Oregon', 'United States', '97405');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1089, '27', 'Forest', 'Youngstown', 'Ohio', 'United States', '44511');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1090, '5341', 'Roth', 'Jackson', 'Mississippi', 'United States', '39282');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1091, '35', 'Stoughton', 'Baton Rouge', 'Louisiana', 'United States', '70836');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1092, '7', 'Karstens', 'Lubbock', 'Texas', 'United States', '79405');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1093, '4420', 'Pawling', 'Reston', 'Virginia', 'United States', '22096');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1094, '286', 'Continental', 'Orlando', 'Florida', 'United States', '32854');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1095, '14', 'Ilene', 'Houston', 'Texas', 'United States', '77293');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1096, '0', 'Raven', 'Norman', 'Oklahoma', 'United States', '73071');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1097, '87326', 'Novick', 'Cleveland', 'Ohio', 'United States', '44105');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1098, '30166', 'Ohio', 'Elizabeth', 'New Jersey', 'United States', '07208');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1099, '1726', 'Hovde', 'Washington', 'District of Columbia', 'United States', '20540');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1100, '4', 'Porter', 'Atlanta', 'Georgia', 'United States', '30306');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1101, '5926', 'Hanson', 'Simi Valley', 'California', 'United States', '93094');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1102, '5628', 'High Crossing', 'Dearborn', 'Michigan', 'United States', '48126');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1103, '48194', 'Arapahoe', 'Wichita', 'Kansas', 'United States', '67210');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1104, '4', 'Moland', 'Tampa', 'Florida', 'United States', '33605');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1105, '28163', 'Vahlen', 'Washington', 'District of Columbia', 'United States', '20508');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1106, '7', 'Tennyson', 'Long Beach', 'California', 'United States', '90847');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1107, '280', 'Tony', 'Memphis', 'Tennessee', 'United States', '38136');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1108, '237', 'Bluestem', 'Washington', 'District of Columbia', 'United States', '20022');
insert into Address ([Address ID], [AddressLine 1], [AddressLine 2], [City], [State], [Country], [ZipCode]) values (1109, '8836', 'Clarendon', 'Washington', 'District of Columbia', 'United States', '20414');
--
select * from Address

insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2021, 'Forster', 'Gozzard', '1434702754', 'forster.gozzard@tuttocitta.it', 1027);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2022, 'Hynda', 'Sanchiz', '4533965915', 'hynda.sanchiz@usnews.com', 1010);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2023, 'James', 'Shailer', '5038239078', 'james.shailer@gov.uk', 1013);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2024, 'Sunshine', 'Deegan', '9824080157', 'sunshine.deegan@clickbank.net', 1011);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2025, 'Devinne', 'Haselden', '6717860839', 'devinne.haselden@spiegel.de', 1022);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2026, 'Victoria', 'McCuis', '7642654301', 'victoria.mccuis@google.co.uk', 1024);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2027, 'Frasco', 'Alfuso', '1505719316', 'frasco.alfuso@a8.net', 1020);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2028, 'Elfrida', 'Brando', '9458626997', 'elfrida.brando@yahoo.co.jp', 1027);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2029, 'Esteban', 'Collop', '1948717559', 'esteban.collop@linkedin.com', 1026);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2030, 'Bethina', 'Davidovicz', '2713576731', 'bethina.davidovicz@ycombinator.com', 1020);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2031, 'Farly', 'Beeken', '6454006992', 'farly.beeken@ed.gov', 1029);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2032, 'Libbie', 'Konrad', '7068244351', 'libbie.konrad@ifeng.com', 1016);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2033, 'Nita', 'Delgardillo', '7144641481', 'nita.delgardillo@fastcompany.com', 1026);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2034, 'Bethina', 'Matthessen', '5018622583', 'bethina.matthessen@statcounter.com', 1026);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2035, 'Cyril', 'Flewin', '7048104425', 'cyril.flewin@printfriendly.com', 1019);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2036, 'Alvie', 'Clemintoni', '3379400578', 'alvie.clemintoni@live.com', 1018);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2037, 'Silva', 'De Caville', '4225795199', 'silva.de caville@smh.com.au', 1019);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2038, 'Essie', 'Gullivan', '3172949708', 'essie.gullivan@theglobeandmail.com', 1012);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2039, 'Colby', 'Salan', '1086538582', 'colby.salan@desdev.cn', 1022);
insert into [Employee] ([EmployeeID], firstname, lastname, [TelephoneNumber], [Email], [Address ID]) values (2040, 'Henri', 'Hutley', '6392104211', 'henri.hutley@slashdot.org', 1023);
--
select * from Employee;

insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3031, 'Sharleen', 'Grzegorzewski', '4789423105', 'sharleen.grzegorzewski@uol.com.br', 1037);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3032, 'Blondell', 'Ramey', '7615686569', 'blondell.ramey@redcross.org', 1038);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3033, 'Judie', 'Sissot', '7861813808', 'judie.sissot@kickstarter.com', 1036);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3034, 'Dwayne', 'Bakey', '7605883954', 'dwayne.bakey@constantcontact.com', 1042);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3035, 'Vinita', 'Blackburne', '3976552263', 'vinita.blackburne@wsj.com', 1050);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3036, 'Silvan', 'Showers', '4871511828', 'silvan.showers@dion.ne.jp', 1034);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3037, 'Roxanne', 'Kermitt', '2838295133', 'roxanne.kermitt@hud.gov', 1043);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3038, 'Arty', 'Dodwell', '5944207686', 'arty.dodwell@vistaprint.com', 1042);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3039, 'Derrik', 'Carpenter', '8711124722', 'derrik.carpenter@earthlink.net', 1050);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3040, 'Rochella', 'Luckin', '6438053392', 'rochella.luckin@vinaora.com', 1038);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3041, 'Sargent', 'Harness', '8337533578', 'sargent.harness@netscape.com', 1037);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3042, 'Carlie', 'Pollok', '6963888554', 'carlie.pollok@istockphoto.com', 1034);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3043, 'Brodie', 'Korda', '9149651375', 'brodie.korda@eepurl.com', 1036);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3044, 'Tilly', 'Croose', '5171509299', 'tilly.croose@sciencedaily.com', 1039);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3045, 'Janela', 'Jobbins', '3459062403', 'janela.jobbins@yellowpages.com', 1036);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3046, 'Ladonna', 'Disney', '2553966264', 'ladonna.disney@mozilla.com', 1045);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3047, 'Fawnia', 'McCorkindale', '5392645659', 'fawnia.mccorkindale@exblog.jp', 1041);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3048, 'Sid', 'Farfolomeev', '3105638189', 'sid.farfolomeev@soup.io', 1031);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3049, 'Pat', 'Garz', '6589068101', 'pat.garz@amazon.de', 1034);
insert into [Customer] ([CustomerID], firstname, lastname, [TelephoneNumber], [EmailID], [Address ID]) values (3050, 'Nick', 'Dyott', '5668216237', 'nick.dyott@behance.net', 1033);
--
select * from Customer;

insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4041, 'healthwealth', '4063547059', 'healthwealth@ox.ac.uk', 1063);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4042, 'foodbar', '6519413236', 'foodbar@prlog.org', 1063);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4043, 'healthwealth', '1509949208', 'healthwealth@example.com', 1068);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4044, 'bookmaster', '8431209911', 'bookmaster@nbcnews.com', 1062);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4045, 'bigboytoys', '3218456224', 'bigboytoys@toplist.cz', 1051);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4046, 'bestelectronics', '2941550221', 'bestelectronics@google.com', 1059);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4047, 'sportygoods', '6185955791', 'sportygoods@tripod.com', 1067);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4048, 'toolhouse', '7887550645', 'toolhouse@ucla.edu', 1064);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4049, 'fastfixsports', '5843787355', 'fastfixsports@senate.gov', 1054);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4050, 'petfriends', '4055199587', 'petfriends@desdev.cn', 1069);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4051, 'goodlookgoods', '9575362855', 'goodlookgoods@wisc.edu', 1055);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4052, 'easygadgets', '3319422878', 'easygadgets@buzzfeed.com', 1058);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4053, 'toolhouse', '7382669503', 'toolhouse@bandcamp.com', 1065);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4054, 'bestelectronics', '2201452998', 'bestelectronics@tinyurl.com', 1068);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4055, 'bookmaster', '8767104383', 'bookmaster@hud.gov', 1054);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4056, 'bestelectronics', '3015437134', 'bestelectronics@nature.com', 1058);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4057, 'bigboytoys', '6788810729', 'bigboytoys@latimes.com', 1063);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4058, 'bookbox', '4483435942', 'bookbox@digg.com', 1070);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4059, 'petpots', '2276840419', 'petpots@stanford.edu', 1057);
insert into [Distributor] ([DistributorID], distributorname, [TelephoneNumber], [EmailID], [Address ID]) values (4060, 'petfriends', '4556155839', 'petfriends@sfgate.com', 1053);
--
select * from Distributor;

insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5051, 'Edgewire', 'edgewire@ustream.tv', 1076);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5052, 'Meedoo', 'meedoo@utexas.edu', 1073);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5053, 'Pixoboo', 'pixoboo@bluehost.com', 1087);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5054, 'Wikizz', 'wikizz@wikimedia.org', 1086);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5055, 'Roomm', 'roomm@narod.ru', 1083);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5056, 'Zoomcast', 'zoomcast@themeforest.net', 1072);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5057, 'Jabberstorm', 'jabberstorm@skype.com', 1090);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5058, 'Youspan', 'youspan@amazonaws.com', 1090);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5059, 'Skimia', 'skimia@latimes.com', 1078);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5060, 'Centidel', 'centidel@odnoklassniki.ru', 1081);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5061, 'Meevee', 'meevee@answers.com', 1072);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5062, 'Leenti', 'leenti@sbwire.com', 1085);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5063, 'Lazz', 'lazz@boston.com', 1075);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5064, 'Gigazoom', 'gigazoom@foxnews.com', 1083);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5065, 'Tazzy', 'tazzy@hugedomains.com', 1080);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5066, 'Topicshots', 'topicshots@elegantthemes.com', 1075);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5067, 'Flipbug', 'flipbug@oakley.com', 1071);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5068, 'Yacero', 'yacero@cbc.ca', 1088);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5069, 'Babbleset', 'babbleset@jugem.jp', 1087);
insert into [Transportation Vendor] ([VendorID], vendorname, [EmailID], [Address ID]) values (5070, 'Midel', 'midel@1688.com', 1078);
--
select * from [Transportation Vendor];

insert into [Category] ([CategoryID], [CategoryName]) values (6061, 'books');
insert into [Category] ([CategoryID], [CategoryName]) values (6062, 'electronics');
insert into [Category] ([CategoryID], [CategoryName]) values (6063, 'food');
insert into [Category] ([CategoryID], [CategoryName]) values (6064, 'skincare');
insert into [Category] ([CategoryID], [CategoryName]) values (6065, 'clothing');
insert into [Category] ([CategoryID], [CategoryName]) values (6066, 'sports');
insert into [Category] ([CategoryID], [CategoryName]) values (6067, 'medicine');
insert into [Category] ([CategoryID], [CategoryName]) values (6068, 'pet supply');
insert into [Category] ([CategoryID], [CategoryName]) values (6069, 'toys');
insert into [Category] ([CategoryID], [CategoryName]) values (6070, 'furniture');
select * from Category;
--
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('774255319-8', 70, '4/1/2022');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('533990875-5', 30, '2/24/2021');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('008236796-5', 50, '11/9/2023');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('924693993-X', 50, '5/26/2024');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('805590432-4', 70, '10/31/2021');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('377547501-X', 30, '7/31/2021');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('556008780-7', 10, '8/6/2021');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('027481738-1', 30, '4/4/2021');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('488720612-7', 70, '11/7/2021');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('384246740-0', 30, '4/3/2022');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('324880701-6', 50, '2/26/2021');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('786213923-2', 30, '7/4/2022');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('928539298-9', 10, '7/13/2023');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('738830427-4', 70, '8/16/2020');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('752408007-7', 10, '12/7/2021');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('760562988-5', 50, '7/13/2023');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('298388496-1', 70, '3/24/2023');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('649765558-1', 70, '2/27/2021');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('661972695-X', 50, '4/16/2023');
insert into [Coupon] ([CouponCode], [DiscountPercentage], [DateValidTill]) values ('793225184-2', 50, '9/26/2021');
--
select * from [Coupon] ;

insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7071, '8/27/2019', 2829, 424.35, 10, '774255319-8');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7072, '6/11/2020', 1938, 290.7, 20, '533990875-5');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7073, '10/23/2019', 4218, 632.7, 20, '008236796-5');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7074, '5/22/2020', 727, 109.05, 30, '924693993-X');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7075, '11/19/2019', 9197, 1379.55, 10, '805590432-4');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7076, '9/29/2019', 4294, 644.1, 20, '377547501-X');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7077, '10/7/2019', 7787, 1168.05, 40, '556008780-7');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7078, '9/5/2019', 5379, 806.85, 30, '027481738-1');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7079, '1/31/2020', 3090, 463.5, 30, '488720612-7');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7080, '3/5/2020', 7652, 1147.8, 50, '384246740-0');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7081, '6/6/2020', 4579, 686.85, 30, '324880701-6');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7082, '6/15/2020', 6173, 925.95, 50, '786213923-2');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7083, '1/13/2020', 290, 43.5, 50, '928539298-9');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7084, '9/4/2019', 3749, 562.35, 20, '738830427-4');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7085, '2/26/2020', 7234, 1085.1, 10, '752408007-7');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7086, '6/17/2020', 1015, 152.25, 50, '760562988-5');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7087, '6/21/2020', 567, 85.05, 20, '298388496-1');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7088, '4/9/2020', 5601, 840.15, 20, '649765558-1');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7089, '8/10/2019', 6909, 1036.35, 40, '661972695-X');
insert into [Invoice] ([InvoiceID], [InvoiceDate], totalamount, [SalesTax], [Discount], [CouponCode]) values (7090, '4/10/2020', 3452, 517.8, 20, '793225184-2');

select * from [Category];
--
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8081, 'famous trials', 5, 6061);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8082, 'kite runner', 3, 6061);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8083, 'television', 1, 6062);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8084, 'microwave', 4, 6062);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8085, 'oats', 3, 6063);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8086, 'cornflakes', 3, 6063);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8087, 'face wash', 3, 6064);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8088, 'scrub', 3, 6064);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8089, 'pant', 5, 6065);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8090, 'shirt', 5, 6065);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8091, 'baseball', 5, 6066);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8092, 'hockey stick', 5, 6066);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8093, 'ibprofen', 2, 6067);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8094, 'nyquil', 1, 6067);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8095, 'pet food', 4, 6068);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8096, 'pet collar', 1, 6068);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8097, 'puzzle', 5, 6069);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8098, 'teddy bear', 2, 6069);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8099, 'table', 1, 6070);
insert into [Item] ([ItemNo], [ItemName], [CustomerReviews], [CategoryID]) values (8100, 'chair', 1, 6070);
--
select * from Item;
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9091, 'Approved', 3724.70);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9092, 'In process', 8751.67);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9093, 'Approved', 8147.27);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9094, 'Approved', 8354.36);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9095, 'Approved', 1826.93);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9096, 'In process', 6119.62);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9097, 'In process', 9106.91);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9098, 'In process', 8620.99);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9099, 'Cancelled', 9945.93);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9100, 'In process', 9568.29);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9101, 'Cancelled', 5425.42);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9102, 'In process', 1471.19);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9103, 'In process', 1300.04);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9104, 'In process', 6118.37);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9105, 'In process', 269.85);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9106, 'Cancelled', 596.67);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9107, 'Approved', 3520.96);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9108, 'Approved', 4413.68);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9109, 'Cancelled', 2241.23);
insert into [Refund] ([RefundOrderID], [RefundStatus], [RefundAmount]) values (9110, 'Approved', 8583.18);
--
select * from Refund;

insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202020, '4/22/2020', '8:31 AM', 9091);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202021, '12/31/2019', '6:04 AM', 9092);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202022, '6/14/2020', '7:31 AM', 9093);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202023, '4/16/2020', '11:56 AM', 9094);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202024, '9/11/2019', '2:08 PM', 9095);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202025, '7/18/2020', '11:17 PM', 9096);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202026, '12/4/2019', '7:56 PM', 9097);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202027, '11/25/2019', '7:21 PM', 9098);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202028, '5/19/2020', '12:33 PM', 9099);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202029, '9/17/2019', '11:19 PM', 9100);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202030, '3/12/2020', '10:26 PM', 9101);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202031, '11/14/2019', '12:22 PM', 9102);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202032, '1/25/2020', '4:42 PM', 9103);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202033, '10/30/2019', '4:20 AM', 9104);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202034, '6/7/2020', '4:57 AM', 9105);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202035, '3/19/2020', '8:46 AM', 9106);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202036, '10/19/2019', '6:57 PM', 9107);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202037, '8/19/2019', '6:47 AM', 9108);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202038, '4/5/2020', '5:55 PM', 9109);
insert into [Returns] ([ReturnRequestID], [ReturnRequestDate], [ReturnRequestTime], [RefundOrderID]) values (202039, '5/4/2020', '1:08 AM', 9110);
--
select * from Returns;

insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101010, 'Credit', '5/24/2020', '4:08 PM', 4993.51, 'Approved');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101011, 'Cash', '3/28/2020', '7:34 AM', 6648.04, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101012, 'Cash', '2/15/2020', '7:40 PM', 5372.37, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101013, 'Debit', '8/13/2019', '12:00 AM', 7991.15, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101014, 'Debit', '8/20/2019', '6:27 PM', 4551.65, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101015, 'PayPal', '3/7/2020', '10:00 AM', 2842.51, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101016, 'Debit', '10/10/2019', '10:10 PM', 6814.03, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101017, 'Credit', '5/15/2020', '5:48 PM', 5315.82, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101018, 'Debit', '2/27/2020', '5:28 AM', 102.46, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101019, 'Credit', '4/21/2020', '8:18 AM', 2183.37, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101020, 'PayPal', '9/24/2019', '9:03 AM', 5715.21, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101021, 'Debit', '4/17/2020', '3:18 AM', 2128.62, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101022, 'Cash', '2/13/2020', '6:11 PM', 8794.34, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101023, 'Debit', '5/16/2020', '11:19 AM', 9917.24, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101024, 'Cash', '8/28/2019', '4:27 AM', 8917.73, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101025, 'Cash', '1/30/2020', '2:52 AM', 4179.29, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101026, 'Debit', '8/7/2019', '5:41 PM', 1712.13, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101027, 'PayPal', '8/15/2019', '10:40 PM', 8334.48, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101028, 'Debit', '1/9/2020', '11:41 AM', 8458.03, 'Initiated');
insert into [Transaction] ([TransactionID], [TransactionMode], [TransactionDate], [TransactionTime], [TransactionAmount], [TransactionStatus]) values (101029, 'Credit', '3/24/2020', '11:52 PM', 5248.42, 'Initiated');
--
select * from [Transaction];

insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8081, '5/12/2020', '6:33 PM', 'Completed', 2021);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8082, '8/18/2019', '11:41 PM', 'Pending', 2022);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8083, '3/29/2020', '8:56 AM', 'Pending', 2023);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8084, '3/30/2020', '5:12 PM', 'Pending', 2024);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8085, '11/19/2019', '12:46 AM', 'Pending', 2025);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8086, '5/19/2020', '10:00 AM', 'Pending', 2026);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8087, '1/4/2020', '7:01 AM', 'Pending', 2027);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8088, '7/7/2020', '8:34 AM', 'Pending', 2028);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8089, '10/30/2019', '2:34 AM', 'Pending', 2029);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8090, '9/25/2019', '6:17 AM', 'Pending', 2030);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8091, '7/23/2020', '3:27 PM', 'Pending', 2031);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8092, '3/31/2020', '3:41 AM', 'Pending', 2032);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8093, '8/20/2019', '7:16 AM', 'Pending', 2033);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8094, '10/30/2019', '5:44 AM', 'Pending', 2034);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8095, '1/31/2020', '11:15 AM', 'Pending', 2035);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8096, '3/2/2020', '10:23 AM', 'Pending', 2036);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8097, '8/20/2019', '9:59 PM', 'Pending', 2037);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8098, '9/30/2019', '5:59 AM', 'Pending', 2038);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8099, '4/8/2020', '11:33 AM', 'Pending', 2039);
insert into [Order] ([OrderID], [OrderDate], [OrderTime], [OrderStatus], [EmployeeID]) values (8100, '1/1/2020', '6:23 AM', 'Pending', 2040);
--
select * from [Order];

insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303030, 'Sosnytsya', 'Água Preta', 'Delivered', 63.13, 5051);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303031, 'Lianhe', 'Jargalant', 'Pending', 75.26, 5052);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303032, 'Taza', 'Ratenggoji', 'Pending', 33.99, 5053);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303033, 'Binuangeun', 'Shuishiying', 'Pending', 50.63, 5054);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303034, 'Wu’an', 'Ždánice', 'Pending', 93.85, 5055);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303035, 'Las Terrenas', 'Vayk’', 'Pending', 57.43, 5056);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303036, 'Xom Tan Long', 'Tân Hiệp', 'Pending', 20.88, 5057);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303037, 'Sieradza', 'Liboro', 'Pending', 15.59, 5058);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303038, 'Sop Pong', 'Umm Ruwaba', 'Pending', 77.98, 5059);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303039, 'Kedungasem', 'Sepekov', 'Pending', 72.80, 5060);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303040, 'Kariya', 'El Ksour', 'Pending', 33.42, 5061);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303041, 'Phoenix', 'Nglengkong', 'Pending', 14.04, 5062);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303042, 'Tromsø', 'Krajan Curahcotok', 'Pending', 26.95, 5063);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303043, 'Nagoya-shi', 'Linshi', 'Pending', 65.92, 5064);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303044, 'Xiluo', 'La Paz', 'Pending', 62.89, 5065);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303045, 'Cascavel', 'Salinas', 'Pending', 68.36, 5066);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303046, 'Arroyo Naranjo', 'Kinsale', 'Pending', 77.59, 5067);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303047, 'Sittwe', 'Kota Bharu', 'Pending', 13.16, 5068);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303048, 'Saltpond', 'San Teodoro', 'Pending', 28.08, 5069);
insert into [Shipping] ([ShippingLabelNo], [Origin], [Destination], [ShippingStatus], [ShippingCost], [VendorID]) values (303049, 'El Benque', 'Bystřany', 'NA', 92.23, 5070);
--
select * from Shipping ;

insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8081, 250, 220, 5);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8082, 360, 330, 15);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8083, 440, 400, 5);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8084, 580, 560, 15);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8085, 600, 550, 15);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8086, 750, 710, 10);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8087, 770, 750, 10);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8088, 1010, 900, 10);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8089, 1200, 1110, 5);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8090, 1500, 1430, 5);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8091, 1550, 1500, 15);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8092, 1760, 1680, 10);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8093, 850, 800, 10);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8094, 1430, 1330, 5);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8095, 1280, 1120, 5);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8096, 1470, 1425, 5);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8097, 150, 140, 10);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8098, 1700, 1695, 10);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8099, 1300, 1225, 10);
insert into [Price] ([ItemNo], [RetailPrice], [WholesalePrice], [Discount]) values (8100, 2000, 1935, 10);

select * from Price;
--
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8081, 8081, 2126);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8082, 8082, 2809);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8083, 8083, 4927);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8084, 8084, 347);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8085, 8085, 3032);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8086, 8086, 877);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8087, 8087, 1429);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8088, 8088, 637);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8089, 8089, 1216);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8090, 8090, 4349);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8091, 8091, 2642);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8092, 8092, 936);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8093, 8093, 3316);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8094, 8094, 76);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8095, 8095, 942);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8096, 8096, 3189);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8097, 8097, 4835);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8098, 8098, 1245);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8099, 8099, 4974);
insert into [OrderItem] ([OrderID], [ItemNo], [Quantity]) values (8100, 8100, 3431);
--
select * from OrderItem;

insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3031, 8081, 7071, 101010, 303030);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3032, 8082, 7072, 101011, 303031);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3033, 8083, 7073, 101012, 303032);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3034, 8084, 7074, 101013, 303033);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3035, 8085, 7075, 101014, 303034);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3036, 8086, 7076, 101015, 303035);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3037, 8087, 7077, 101016, 303036);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3038, 8088, 7078, 101017, 303037);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3039, 8089, 7079, 101018, 303038);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3040, 8090, 7080, 101019, 303039);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3041, 8091, 7081, 101020, 303040);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3042, 8092, 7082, 101021, 303041);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3043, 8093, 7083, 101022, 303042);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3044, 8094, 7084, 101023, 303043);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3045, 8095, 7085, 101024, 303044);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3046, 8096, 7086, 101025, 303045);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3047, 8097, 7087, 101026, 303046);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3048, 8098, 7088, 101027, 303047);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3049, 8099, 7089, 101028, 303048);
insert into [CustomerOrder] ([CustomerID], [OrderID], [InvoiceID], [TransactionID], [ShippingLabelNo]) values (3050, 8100, 7090, 101029, 303049);
--
select * from CustomerOrder;

insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8081, 3513, 35.13);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8082, 1989, 19.89);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8083, 4019, 40.19);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8084, 4043, 40.43);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8085, 1043, 10.43);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8086, 4039, 40.39);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8087, 4573, 45.73);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8088, 963, 9.63);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8089, 1500, 15);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8090, 2050, 20.5);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8091, 4447, 44.47);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8092, 3322, 33.22);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8093, 184, 1.84);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8094, 527, 5.27);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8095, 2125, 21.25);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8096, 760, 7.6);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8097, 3235, 32.35);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8098, 3239, 32.39);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8099, 3893, 38.93);
insert into [Inventory] ([ItemNo], quantityinstock, [Inventory Costs]) values (8100, 1478, 14.78);
--
select * from Inventory;
--
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8081, 4041);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8082, 4042);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8083, 4043);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8084, 4044);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8085, 4045);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8086, 4046);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8087, 4047);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8088, 4048);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8089, 4049);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8090, 4050);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8091, 4051);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8092, 4052);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8093, 4053);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8094, 4054);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8095, 4055);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8096, 4056);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8097, 4057);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8098, 4058);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8099, 4059);
insert into [ItemDistributor] ([ItemNo], [DistributorID]) values (8100, 4060);

--
select * from ItemDistributor;
--
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3031, 8081, 7071, 202020);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3032, 8082, 7072, 202021);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3033, 8083, 7073, 202022);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3034, 8084, 7074, 202023);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3035, 8085, 7075, 202024);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3036, 8086, 7076, 202025);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3037, 8087, 7077, 202026);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3038, 8088, 7078, 202027);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3039, 8089, 7079, 202028);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3040, 8090, 7080, 202029);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3041, 8091, 7081, 202030);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3042, 8092, 7082, 202031);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3043, 8093, 7083, 202032);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3044, 8094, 7084, 202033);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3045, 8095, 7085, 202034);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3046, 8096, 7086, 202035);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3047, 8097, 7087, 202036);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3048, 8098, 7088, 202037);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3049, 8099, 7089, 202038);
insert into [CustomerReturnsOrder] ([CustomerID], [OrderID], [InvoiceID], [ReturnRequestID]) values (3050, 8100, 7090, 202039);
--
select * from CustomerReturnsOrder;
GO
-----------------------------------------------------------------------------------------------------------------
-- CREATE VEIWS 
CREATE VIEW CustomerInfo
WITH ENCRYPTION, SCHEMABINDING
AS
SELECT CustomerID, FirstName, LastName, TelephoneNumber, EmailID, 
CONCAT([AddressLine 1],',',' ', [AddressLine 2],',',' ', City,',',' ', State,',',' ', Country,',',' ', ZipCode) AS Address
FROM [dbo].[Customer] c JOIN [dbo].[Address] a ON c.[Address ID] = a.[Address ID]

GO
--
CREATE VIEW OrderDetails
AS
SELECT CONCAT(FirstName, ' ', LastName) AS CustomerName, 
co.OrderID, o.OrderDate, co.InvoiceID, InvoiceDate, TotalAmount, SalesTax, Discount, OrderStatus, TransactionStatus, TransactionAmount
FROM  [dbo].[CustomerOrder] co JOIN [dbo].[Order] o ON co.OrderID = o.OrderID
							   JOIN [dbo].[Transaction] t ON co.TransactionID = t.TransactionID
							   JOIN [dbo].[Invoice] i ON co.InvoiceID = i.InvoiceID 
							   JOIN [dbo].[Customer] c ON c.CustomerID = co.CustomerID
GO
--
CREATE VIEW InvetoryDetails
AS
SELECT i.ItemNo, ItemName, QuantityInStock, [Inventory Costs]
FROM [dbo].[Item] i JOIN [dbo].[Inventory] iv ON i.ItemNo = iv.ItemNo;
GO
--
CREATE VIEW OrderDeliveryStatus
AS
SELECT CONCAT(FirstName, ' ', LastName) AS CustomerName, o.OrderID, o.OrderStatus, OrderDate, co.ShippingLabelNo, ShippingStatus
FROM [dbo].[CustomerOrder] co JOIN [dbo].[Order] o ON co.OrderID = o.OrderID
							  JOIN [dbo].[Shipping] s ON co.ShippingLabelNo = s.ShippingLabelNo
							  JOIN [dbo].[Customer] c ON c.CustomerID = co.CustomerID;
GO
--
CREATE VIEW DistributorItems
AS 
SELECT id.DistributorID, DistributorName, ItemName
FROM Distributor d JOIN ItemDistributor id ON d.DistributorID = id.DistributorID
				   JOIN Item i ON i.ItemNo = id.ItemNo;
GO
--
CREATE VIEW CustomerRefunds
AS
SELECT CONCAT(FirstName, ' ', LastName) AS CustomerName, 
cro.OrderID, cro.ReturnRequestID, ReturnRequestDate, ReturnRequestTime, RefundStatus, RefundAmount
FROM CustomerReturnsOrder cro JOIN Customer c ON cro.CustomerID = c.CustomerID
							  JOIN [dbo].[Order] o ON o.OrderID = cro.OrderID
							  JOIN [dbo].[Returns] r ON r.ReturnRequestID = cro.ReturnRequestID
							  JOIN Refund re ON r.RefundOrderID = re.RefundOrderID;
GO
--
CREATE VIEW SalesItems
AS
SELECT OrderID, io.ItemNo, ItemName, Quantity AS OrderQty
FROM OrderItem io JOIN Item i ON io.ItemNo = i.ItemNo;
GO
--
CREATE VIEW CompleteStatus
AS
SELECT CONCAT(FirstName, ' ', LastName) AS CustomerName, 
co.OrderID, o.OrderDate, co.InvoiceID, s.ShippingLabelNo, t.TransactionID, OrderStatus, TransactionStatus, TransactionAmount, ShippingStatus
FROM  [dbo].[CustomerOrder] co JOIN [dbo].[Order] o ON co.OrderID = o.OrderID
							   JOIN [dbo].[Transaction] t ON co.TransactionID = t.TransactionID
							   JOIN [dbo].[Invoice] i ON co.InvoiceID = i.InvoiceID 
							   JOIN [dbo].[Customer] c ON c.CustomerID = co.CustomerID
							   JOIN [dbo].[Shipping] s ON co.ShippingLabelNo = s.ShippingLabelNo;
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- TEST TRIGGER
UPdate [Transaction]
set [TransactionStatus] = 'Cancelled' where [TransactionID] = 101024;


SELECT * from CompleteStatus where [TransactionID] = 101024;
 go
--
 UPdate [Transaction]
set [TransactionStatus] = 'Approved' where [TransactionID] = 101022;

SELECT * from CompleteStatus where [TransactionID] = 101022 ;
go
--
UPDATE dbo.Invoice
 SET TotalAmount = 1510.23
 WHERE InvoiceID = 7071
go
 SELECT * FROM dbo.Invoice
 go
--
UPDATE [Inventory]
SET [QuantityInStock] = 4000 WHERE [ItemNo]= 8081;
SELECT * FROM [Inventory];
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Test Computed Columns based on Functions
SELECT dbo.AVGMonthlyDiscount (2020, 06) AS AVGDiscount;
go
SELECT dbo.MonthlySalesTax (2020, 05) AS TotalSalesTax;
go
SELECT dbo.ParticularMonthYearSales (2020, 01) AS TotalSales;
go
-------------------------------------------------------------------------------------------------------------------------------
-- Test Views 
SELECT * FROM CustomerInfo;
--
SELECT * FROM CompleteStatus;
GO
--
SELECT * FROM SalesItems;
GO
--
SELECT * FROM CustomerRefunds;
GO
--
SELECT * FROM DistributorItems;
GO
--
SELECT * FROM OrderDeliveryStatus;
GO
--
SELECT * FROM InvetoryDetails;
GO
--
SELECT * FROM OrderDetails
GO
--
--Clean-Up
USE Jacob_Nikhil_TEST
DROP DATABASE [Wholesale Database Management System];
go
