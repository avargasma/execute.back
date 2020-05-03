
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================
-- Author:  psosa  
-- Modified date: 02/01/2018
-- Description: Creamos el sp para realizar el insert del mail
-- Jira: 
-- ===============================================================
-- Author:  psosa  
-- Modified date: 02/04/2020
-- Description: Se agrega select para buscar el ProcessDetailsId
-- Jira: 
-- ===============================================================

ALTER PROCEDURE [Chat].[EmailMessage_i]  

@EmailId INT OUTPUT,
@EmailGuid UNIQUEIDENTIFIER,
@EmailBody VARCHAR (max),
@EmailDeliveredTo varchar(256),
@FromAddressId INT,
@EmailSubject varchar(256),
@MailConfigId INT,
@AccountDetailUnique UNIQUEIDENTIFIER

AS 
BEGIN

DECLARE @NewId UNIQUEIDENTIFIER
DECLARE @Getdate DATETIME

DECLARE @ProcessDetailsId Int
SET @ProcessDetailsId = (SELECT TOP (1) ProcessDetailsId FROM [Email].[Message] order by 1 desc)


SET @NewId = Newid()
SET @Getdate = Getdate()


INSERT INTO [Email].[Message]
           (EmailGuid
           ,EmailGuidOrigen
           ,EmailDeliveredTo
           ,EmailDeliveryDate
           ,EmailMessageId
           ,FromAddressId
           ,EmailBody
           ,EmailBodyHTML
           ,EmailSubject
           ,MailConfigId
           ,EmailTray
           ,AccountDetailUnique
           ,EmailDeliveryDateOriginal
           ,EmailCreated
           ,ProcessDetailsId)
     VALUES
           (@NewId
           ,@NewId
           ,@EmailDeliveredTo
           ,@Getdate 
           ,@NewId
           ,@FromAddressId
           ,@EmailBody
		   ,null
		   ,@EmailSubject
		   ,@MailConfigId
		   ,0
		   ,@AccountDetailUnique
		   ,@Getdate
		   ,@Getdate
		   ,@ProcessDetailsId)
    
Set @EmailId = SCOPE_IDENTITY()    
           
END


