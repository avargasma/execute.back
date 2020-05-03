IF NOT EXISTS(SELECT object_id FROM sys.columns 
          WHERE Name = N'ASCActiveFlag'
          AND Object_ID = Object_ID(N'[Config].[AccountServiceChannel]'))

BEGIN
	ALTER TABLE [Config].[AccountServiceChannel]
	ADD ASCActiveFlag bit NULL 
END
GO

UPDATE [Config].[AccountServiceChannel]
SET ASCActiveFlag = 1
GO

ALTER TABLE [Config].[AccountServiceChannel]
ALTER COLUMN ASCActiveFlag bit NOT NULL
GO