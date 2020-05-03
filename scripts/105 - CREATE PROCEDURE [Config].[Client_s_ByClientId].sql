/****** Object:  StoredProcedure [Config].[Client_s_ByClientId]    Script Date: 17/04/2020 10:28:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[Client_s_ByClientId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[Client_s_ByClientId] AS' 
END
GO
           
-----------------------------------------------------------------------*/             
-- Author:  yantrossero  
-- Modified date: 17/04/2020
-- Description: Se buscan los datos del cliente por id. Se crea a partir del sp [MC].[Client_s_ByClientId] 
-- Jira: EENT-1302
-----------------------------------------------------------------------*/  
            
ALTER PROCEDURE [Config].[Client_s_ByClientId]            
(            
 @ClientId INT          
)            
AS             
BEGIN        
         
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED            
      
SELECT 
c.ClientId,
c.ClientFirstName, 
c.ClientLastName, 
c.ClientActiveFlag,
c.ClientModifiedDate, 
c.ClientModifiedByUserId,
c.AccountTypeId,
c.ClientObservation
FROM mc.Client c
WHERE clientid=@ClientId

END 
GO
