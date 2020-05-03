IF NOT EXISTS(SELECT * FROM sys.columns 
          WHERE Name = N'GroupAccountEnableButtonXGestor'
          AND Object_ID = Object_ID(N'Config.GroupAccountLog'))
BEGIN

ALTER TABLE Config.GroupAccountLog
ADD GroupAccountEnableButtonXGestor BIT NOT NULL DEFAULT (1)

END