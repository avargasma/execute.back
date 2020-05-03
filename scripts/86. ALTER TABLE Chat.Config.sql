IF NOT EXISTS(SELECT * FROM sys.columns 
          WHERE Name = N'NumberOfUsersOnline'
          AND Object_ID = Object_ID(N'[Chat].Config'))
BEGIN

ALTER TABLE Chat.Config ADD NumberOfUsersOnline INT NULL

END