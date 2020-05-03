/****** Object:  StoredProcedure [Config].[GetClientTemplate]    Script Date: 29/04/2020 16:46:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[GetClientTemplate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[GetClientTemplate] AS' 
END
GO
-- ================================================================================                  
-- Author:  yantrossero
-- Modified date: 16/01/2020
-- Description: Devuelve la plantilla de atributos configurada para esa empresa y
--				unidad de negocio.				
-- Jira: EENT-1719  
-- ================================================================================ 
ALTER PROCEDURE [Config].[GetClientTemplate]
	@AccountTypeId INT,
	@AccountId INT
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @vAccountTypeId INT, @vAccountId INT

	SET @vAccountTypeId = @AccountTypeId
	SET @vAccountId = @AccountId

    SELECT ca.ClientAttributeId,
		   ca.ClientAttributeName, 
		   ca.ClientAttributeOrder		
	FROM Config.ClientAttributeGroup cag            
	INNER JOIN config.ClientAttribute ca ON ca.ClientAttributeGroupId = cag.ClientAttributeGroupId       
	WHERE cag.AccountTypeId = @vAccountTypeId  AND ca.ClientAttributeActiveFlag = 1
	EXCEPT
	SELECT ca.ClientAttributeId,
		   ca.ClientAttributeName, 
	 	   ca.ClientAttributeOrder		
	FROM Config.ClientAttributeGroup cag            
	INNER JOIN config.ClientAttribute ca ON ca.ClientAttributeGroupId = cag.ClientAttributeGroupId       
	LEFT JOIN Config.ClientAccountAttribute caa ON caa.ClientAttributeId = ca.ClientAttributeId
	WHERE ca.ClientAttributeActiveFlag = 1 AND caa.ClientAccountAttributeActiveFlag = 0 and caa.AccountId = @vAccountId
	order by ClientAttributeOrder
END
GO
