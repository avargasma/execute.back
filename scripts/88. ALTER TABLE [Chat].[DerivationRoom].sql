IF NOT EXISTS(SELECT * FROM sys.columns 
          WHERE Name = N'DerivationRoomRedirectionChat'
          AND Object_ID = Object_ID(N'[Chat].[DerivationRoom]'))
BEGIN

ALTER TABLE [Chat].[DerivationRoom] ADD DerivationRoomRedirectionChat nvarchar(256) NULL

END