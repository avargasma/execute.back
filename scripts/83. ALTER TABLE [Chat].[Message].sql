IF NOT EXISTS(SELECT * FROM sys.columns 
          WHERE Name = N'CMessageChatServer'
          AND Object_ID = Object_ID(N'[Chat].[Message]'))
BEGIN

ALTER TABLE [Chat].[Message] ADD CMessageChatServer nvarchar(256) NULL

END