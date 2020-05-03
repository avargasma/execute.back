GO
IF NOT EXISTS(SELECT object_id FROM sys.columns 
          WHERE Name = N'CCReactivateChat'
          AND Object_ID = Object_ID(N'[Chat].[Config]'))
BEGIN
	ALTER TABLE Chat.Config ADD CCReactivateChat BIT NOT NULL DEFAULT(0);
END