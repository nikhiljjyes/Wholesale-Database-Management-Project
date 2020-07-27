--
--use AdventureWorks2008R2
CREATE DATABASE [Wholesale Database Management System]; 

go 

USE [Wholesale Database Management System] 

go 

CREATE TABLE [address] 
  ( 
     [address id] INT PRIMARY KEY, 
     [streetname] VARCHAR(200), 
     [city]       VARCHAR(30), 
     [state]      VARCHAR(30), 
     [country]    VARCHAR(30), 
     [zipcode]    INT, 
  ); 

go 

CREATE TABLE [refund] 
  ( 
     [refundorderid] INT PRIMARY KEY, 
     [refundstatus]  VARCHAR(50), 
     [refundamount]  DECIMAL(20, 15) 
  ); 

go 

CREATE TABLE [transaction] 
  ( 
     [transactionid]     INT PRIMARY KEY, 
     [transactionmode]   VARCHAR(20), 
     [transactiondate]   DATE, 
     [transactiontime]   TIME, 
     [transactionamount] DECIMAL(20, 5), 
     [transactionstatus] VARCHAR(20), 
  ); 

go 

CREATE TABLE [category] 
  ( 
     [categoryid]   INT PRIMARY KEY, 
     [categoryname] VARCHAR(50), 
  ); 

go 

CREATE TABLE [coupon] 
  ( 
     [couponcode]         DECIMAL(20, 15) PRIMARY KEY, 
     [discountpercentage] DECIMAL(20, 5), 
     [datevalidtill]      DATE, 
  ); 

go 

CREATE TABLE [invoice] 
  ( 
     [invoiceid]   INT PRIMARY KEY, 
     [invoicedate] DATE, 
     [totalamount] DECIMAL(20, 15), 
     [salestax]    DECIMAL(20, 15), 
     [discount]    DECIMAL(20, 15), 
     [couponcode]  DECIMAL(20, 15) 
     FOREIGN KEY ([couponcode]) REFERENCES [coupon]([couponcode]) ON UPDATE 
     CASCADE 
  ); 

CREATE INDEX [Coupon_FK] 
  ON [Invoice] ([couponcode]); 

go 

CREATE TABLE [employee] 
  ( 
     [employeeid]      INT PRIMARY KEY, 
     [firstname]       VARCHAR(20), 
     [lastname]        VARCHAR(20), 
     [address id]      INT, 
     [telephonenumber] INT, 
     [email]           VARCHAR(50), 
     FOREIGN KEY ([address id]) REFERENCES [address]([address id]) ON UPDATE 
     CASCADE ON DELETE CASCADE 
  ); 

CREATE INDEX [Address_EMP_FK] 
  ON [Employee] ([address id]); 

CREATE TABLE [customerreturnsorder] 
  ( 
     [customerid]      INT, 
     [orderid]         INT, 
     [invoiceid]       INT, 
     [returnrequestid] INT, 
     CONSTRAINT pk_cro PRIMARY KEY([customerid], [orderid], [invoiceid], 
     [returnrequestid]) 
  ); 

go 

ALTER TABLE [customerreturnsorder] 
  ADD CONSTRAINT fk_cro_1 FOREIGN KEY ([customerid]) REFERENCES 
  [Customer].[customerid] ON DELETE CASCADE ON UPDATE CASCADE; 

ALTER TABLE [customerreturnsorder] 
  ADD CONSTRAINT fk_cro_2 FOREIGN KEY ([orderid]) REFERENCES [Order].[orderid] 
  ON DELETE CASCADE ON UPDATE CASCADE; 

ALTER TABLE [customerreturnsorder] 
  ADD CONSTRAINT fk_cro_3 FOREIGN KEY ([invoiceid]) REFERENCES 
  [Invoice].[invoiceid] ON DELETE CASCADE ON UPDATE CASCADE; 

ALTER TABLE [customerreturnsorder] 
  ADD CONSTRAINT fk_cro_4 FOREIGN KEY ([returnrequestid]) REFERENCES 
  [Returns].[returnrequestid] ON DELETE CASCADE ON UPDATE CASCADE; 

go 

CREATE INDEX [PK_CRO, FK_CRO_1] 
  ON [CustomerReturnsOrder] ([customerid]); 

CREATE INDEX [PK_CRO, FK_CRO_2] 
  ON [CustomerReturnsOrder] ([orderid]); 

CREATE INDEX [PK_CRO, FK_CRO_3] 
  ON [CustomerReturnsOrder] ([invoiceid]); 

CREATE INDEX [PK_CRO, FK_CRO_4] 
  ON [CustomerReturnsOrder] ([returnrequestid]); 

go 

CREATE TABLE [returns] 
  ( 
     [returnrequestid]   INT PRIMARY KEY, 
     [returnrequestdate] DATE, 
     [returnrequesttime] TIME, 
     [refundorderid]     INT, 
     FOREIGN KEY ([refundorderid]) REFERENCES [refund]([refundorderid]) ON 
     UPDATE CASCADE ON DELETE CASCADE 
  ); 

CREATE INDEX [FK_RETURN] 
  ON [Returns] ([refundorderid]); 

CREATE TABLE [item] 
  ( 
     [itemno]          INT PRIMARY KEY, 
     [itemname]        VARCHAR(50), 
     [customerreviews] VARCHAR(200), 
     [categoryid]      INT, 
     FOREIGN KEY ([categoryid]) REFERENCES [category]([categoryid]) ON UPDATE 
     CASCADE ON DELETE CASCADE 
  ); 

CREATE INDEX [FK_Item_cat] 
  ON [Item] ([categoryid]); 

CREATE TABLE [price] 
  ( 
     [itemno]         INT, 
     [retailprice]    DECIMAL(20, 5), 
     [wholesaleprice] DECIMAL(20, 5), 
     [discount]       DECIMAL(20, 5), 
     FOREIGN KEY ([itemno]) REFERENCES [item]([itemno]) ON UPDATE CASCADE ON 
     DELETE CASCADE 
  ); 

CREATE INDEX [FK_ITEM] 
  ON [Price] ([itemno]); 

CREATE TABLE [transportation vendor] 
  ( 
     [vendorid]   INT PRIMARY KEY, 
     [vendorname] VARCHAR(30), 
     [address id] INT, 
     [emailid]    VARCHAR(150), 
     FOREIGN KEY ([address id]) REFERENCES [address]([address id]) ON UPDATE 
     CASCADE ON DELETE CASCADE 
  ); 

CREATE INDEX [FK_T_Address] 
  ON [Transportation Vendor] ([address id]); 

CREATE TABLE [orderitem] 
  ( 
     [orderid]  INT, 
     [itemno]   INT, 
     [quantity] INT, 
     CONSTRAINT pk_oi PRIMARY KEY([orderid], [itemno]) 
  ); 

ALTER TABLE [customerreturnsorder] 
  ADD CONSTRAINT fk_oi_1 FOREIGN KEY ([orderid]) REFERENCES [Order].[orderid] ON 
  DELETE CASCADE ON UPDATE CASCADE; 

ALTER TABLE [customerreturnsorder] 
  ADD CONSTRAINT fk_oi_2 FOREIGN KEY ([itemno]) REFERENCES [Item].[itemno] ON 
  DELETE CASCADE ON UPDATE CASCADE; 

CREATE INDEX [PK_OI, FK_OI_1] 
  ON [OrderItem] ([orderid]); 

CREATE INDEX [PK_OI, FK_OI_2] 
  ON [OrderItem] ([itemno]); 

CREATE TABLE [order] 
  ( 
     [orderid]     INT PRIMARY KEY, 
     [orderdate]   DATE, 
     [ordertime]   TIME, 
     [orderstatus] VARCHAR(20), 
     [employeeid]  INT, 
     FOREIGN KEY ([employeeid]) REFERENCES [employee]([employeeid]) ON UPDATE 
     CASCADE ON DELETE CASCADE 
  ); 

CREATE INDEX [FK_O_Emp] 
  ON [Order] ([employeeid]); 

CREATE TABLE [inventory] 
  ( 
     [itemno]          INT, 
     [quantityinstock] INT, 
     [inventory costs] DECIMAL(20, 15), 
     FOREIGN KEY ([itemno]) REFERENCES [item]([itemno]) ON UPDATE CASCADE ON 
     DELETE CASCADE 
  ); 

CREATE INDEX [FK_I_ITEM] 
  ON [Inventory] ([itemno]); 

CREATE TABLE [customer] 
  ( 
     [customerid]      INT PRIMARY KEY, 
     [firstname]       VARCHAR(50), 
     [lastname]        VARCHAR(50), 
     [telephonenumber] INT, 
     [address id]      INT, 
     [emailid]         VARCHAR(100), 
     FOREIGN KEY ([address id]) REFERENCES [address]([address id]) ON UPDATE 
     CASCADE ON DELETE CASCADE 
  ); 

CREATE INDEX [FK_Cust_Add] 
  ON [Customer] ([address id]); 

CREATE TABLE [customerorder] 
  ( 
     [customerid]      INT, 
     [orderid]         INT, 
     [invoiceid]       INT, 
     [transactionid]   INT, 
     [shippinglabelno] VARCHAR(50), 
     CONSTRAINT pk_co PRIMARY KEY([customerid], [orderid], [invoiceid], 
     [transactionid], [shippinglabelno]) 
  ); 

go 

ALTER TABLE [customerorder] 
  ADD CONSTRAINT fk_co_1 FOREIGN KEY ([customerid]) REFERENCES 
  [Customer].[customerid] ON DELETE CASCADE ON UPDATE CASCADE; 

ALTER TABLE [customerorder] 
  ADD CONSTRAINT fk_co_2 FOREIGN KEY ([orderid]) REFERENCES [Order].[orderid] ON 
  DELETE CASCADE ON UPDATE CASCADE; 

ALTER TABLE [customerorder] 
  ADD CONSTRAINT fk_co_3 FOREIGN KEY ([invoiceid]) REFERENCES 
  [Invoice].[invoiceid] ON DELETE CASCADE ON UPDATE CASCADE; 

ALTER TABLE [customerorder] 
  ADD CONSTRAINT fk_co_4 FOREIGN KEY ([transactionid]) REFERENCES 
  [Transaction].[transactionid] ON DELETE CASCADE ON UPDATE CASCADE; 

ALTER TABLE [customerorder] 
  ADD CONSTRAINT fk_co_5 FOREIGN KEY ([shippinglabelno]) REFERENCES 
  [Shipping].[shippinglabelno] ON DELETE CASCADE ON UPDATE CASCADE; 

go 

CREATE INDEX [PK_CO, FK_CO_1] 
  ON [CustomerOrder] ([customerid]); 

CREATE INDEX [PK_CO, FK_CO_2] 
  ON [CustomerOrder] ([orderid]); 

CREATE INDEX [PK_CO, FK_CO_3] 
  ON [CustomerOrder] ([invoiceid]); 

CREATE INDEX [PK_CO, FK_CO_4] 
  ON [CustomerOrder] ([transactionid]); 

CREATE INDEX [PK_CO, FK_CO_5] 
  ON [CustomerOrder] ([shippinglabelno]); 

CREATE TABLE [distributor] 
  ( 
     [distributorid]   INT PRIMARY KEY, 
     [distributorname] VARCHAR(50), 
     [telephonenumber] INT, 
     [address id]      INT, 
     [emailid]         VARCHAR(100), 
     FOREIGN KEY ([address id]) REFERENCES [address]([address id]) ON UPDATE 
     CASCADE ON DELETE CASCADE 
  ); 

CREATE INDEX [FK_D_Add] 
  ON [Distributor] ([address id]); 

CREATE TABLE [shipping] 
  ( 
     [shippinglabelno] VARCHAR(50) PRIMARY KEY, 
     [origin]          VARCHAR(50), 
     [destination]     VARCHAR(30), 
     [shippingstatus]  VARCHAR(18), 
     [shippingcost]    DECIMAL(20, 15), 
     [vendorid]        INT, 
     FOREIGN KEY ([vendorid]) REFERENCES [transportation vendor]([vendorid]) ON 
     UPDATE CASCADE ON DELETE CASCADE 
  ); 

CREATE INDEX [FK_Vendor] 
  ON [Shipping] ([vendorid]); 

CREATE TABLE [itemdistributor] 
  ( 
     [itemno]        VARCHAR(50), 
     [distributorid] INT, 
     CONSTRAINT pk_id PRIMARY KEY([itemno], [distributorid]) 
  ); 

ALTER TABLE [itemdistributor] 
  ADD CONSTRAINT fk_id_1 FOREIGN KEY ([itemno]) REFERENCES [Item].[itemno] ON 
  DELETE CASCADE ON UPDATE CASCADE; 

ALTER TABLE [customerreturnsorder] 
  ADD CONSTRAINT fk_id_2 FOREIGN KEY ([distributorid]) REFERENCES 
  [Distributor].[distributorid] ON DELETE CASCADE ON UPDATE CASCADE; 

CREATE INDEX [PK_ID, FK_ID_1] 
  ON [ItemDistributor] ([itemno]); 

CREATE INDEX [PK_ID, FK_ID_2] 
  ON [ItemDistributor] ([distributorid]); 
