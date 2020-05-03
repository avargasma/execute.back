IF NOT EXISTS(SELECT * FROM sys.columns 
          WHERE Name = N'AccountPersonDefaultSettings'
          AND Object_ID = Object_ID(N'[Security].AccountPerson'))
BEGIN
ALTER TABLE [Security].AccountPerson ADD
	AccountPersonDefaultSettings bit NOT NULL CONSTRAINT DF_AccountPerson_AccountPersonDefaultSettings DEFAULT (0)
END