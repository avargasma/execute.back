IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Login].[User_g_ByUserGUID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Login].[User_g_ByUserGUID] AS' 
END
GO
/****** Object:  StoredProcedure [Login].[User_g_ByUserGUID]    Script Date: 03/03/2020 11:32:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================    
-- Author:  nsruiz    
-- Created date: 17/10/2016    
-- Description: Obtiene los datos de un usuario buscando por GUID     
-- Jira:     
-- =================================================================================    
-- Author:  fsoler  
-- Created date: 18/11/2016    
-- Description: Se agrega la columna UserName,PersonId  
-- Jira:     
-- ================================================================================    
-- Author:  lsalvo  
-- Created date: 27/07/2018    
-- Description: Se agrega la columna AllowAutomatedTagView  
-- Jira:     
-- ================================================================================    
-- Author:  Luchini Diego
-- Created date: 21/08/2018    
-- Description: Se agrega la columna PersonAutomaticOpenCases (y join a la tabla person).
-- Jira:     EDIN-889
-- ================================================================================  
-- Author:	mflosalinas
-- Created date: 21/02/2020
-- Description:	Se agregan los campos PersonNewQuantity, PersonPendingQuantity
-- Jira: EMIN-4238
-- ================================================================================  

ALTER PROCEDURE [Login].[User_g_ByUserGUID]    
    
@UserGUID AS UNIQUEIDENTIFIER    
AS     
    
BEGIN    

declare @pUserGUID AS UNIQUEIDENTIFIER    
set @pUserGUID =@UserGUID
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
set nocount on;
    
SELECT   
UserId,  
UserName,  
su.PersonId ,  
AllowAutomatedTagView,
p.PersonAutomaticOpenCases,
p.PersonNewQuantity,
p.PersonPendingQuantity
FROM [Security].[User] SU    
join [Security].Person p on su.PersonId= p.PersonId
WHERE SU.UserGUID =  @pUserGUID

--AND SU.UserActiveFlag = 1    
    
END 