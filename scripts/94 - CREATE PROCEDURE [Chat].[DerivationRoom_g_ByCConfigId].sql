IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[DerivationRoom_g_ByCConfigId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Chat].[DerivationRoom_g_ByCConfigId] AS' 
END
GO

-- =================================================================================          
-- Author:  psosa         
-- Modified date: 23/03/2020          
-- Description: Obtiene las urls disponibles para la derivacion de carga de los chats         
-- Jira:           
-- ================================================================================          

ALTER PROCEDURE [Chat].[DerivationRoom_g_ByCConfigId]          
          
@CConfigId AS INT          
AS           
          
BEGIN          
   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
          
select 
       cd.DerivationRoomRedirectionChat,
       cd.DerivationRoomId,
       cd.DerivationRoomGUID, 
       cd.DerivationRoomChatServer from Chat.Config cc
inner join Chat.DerivationRoom cd on cd.CConfigId = cc.CConfigId
where cc.CConfigId = @CConfigId and 
      cd.DerivationRoomActiveFlag = 1 and 
	  cc.CConfigActiveFlag = 1

	union

select 
       '' as DerivationRoomRedirectionChat,
       null as DerivationRoomId,
       cc.CConfigGuid as DerivationRoomGUID, 
       '' as DerivationRoomChatServer from Chat.Config cc
inner join Config.Account ca on ca.AccountId = cc.AccountId
where cc.CConfigId = @CConfigId and 
      ca.AccountActiveFlag = 1 and 
	  cc.CConfigActiveFlag = 1     
               
END  
