IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[User_g_ByUserGUID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[User_g_ByUserGUID] AS' 
END
GO
/****** Object:  StoredProcedure [MC].[User_g_ByUserGUID]    Script Date: 03/03/2020 14:45:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================
-- Author:		nsruiz
-- Created date: 03/07/2014
-- Description:	Obtiene los datos de un usuario buscando por GUID
-- Jira: EPN-1716
-- ================================================================================
-- Author:	mflosalinas
-- Created date: 03/03/2020
-- Description:	Se agregan los campo p.PersonNewQuantity, p.PersonPendingQuantity
-- Jira: EMIN-4293
-- ================================================================================

ALTER PROCEDURE [MC].[User_g_ByUserGUID]

@UserGUID AS UNIQUEIDENTIFIER
AS 

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @pUserGUID AS UNIQUEIDENTIFIER    
set @pUserGUID =@UserGUID
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
set nocount on;
    
SELECT   
UserId,  
UserName,  
su.PersonId,  
AllowAutomatedTagView,
p.PersonAutomaticOpenCases,
p.PersonNewQuantity,
p.PersonPendingQuantity
FROM [Security].[User] SU    
join [Security].Person p on su.PersonId= p.PersonId
WHERE SU.UserGUID =  @pUserGUID
AND SU.UserActiveFlag = 1 

END

