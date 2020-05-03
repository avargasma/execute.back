IF NOT EXISTS(SELECT * FROM sys.columns 
          WHERE Name = N'PersonNewQuantity'
          AND Object_ID = Object_ID(N'[Security].Person'))
BEGIN

ALTER TABLE [Security].Person ADD PersonNewQuantity	INT NULL
END

IF NOT EXISTS(SELECT * FROM sys.columns 
          WHERE Name = N'PersonPendingQuantity'
          AND Object_ID = Object_ID(N'[Security].Person'))
BEGIN
ALTER TABLE [Security].Person ADD PersonPendingQuantity	INT NULL
END