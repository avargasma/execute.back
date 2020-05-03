/****** Object:  StoredProcedure [Config].[CasesClientAttributes_SearchByClientId]    Script Date: 29/04/2020 15:00:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[CasesClientAttributes_SearchByClientId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[CasesClientAttributes_SearchByClientId] AS' 
END
GO
----------------------------------------------------------------------------------------------
---- Author     : yantrossero
---- Date       : 13/01/2020   
---- Description: Busca los atributos de un cliente y sus valores
---- JIRA       : EENT-1719  
---------------------------------------------------------------------------------------------- 
ALTER PROCEDURE [Config].[CasesClientAttributes_SearchByClientId]
	@ClientId INT
AS
BEGIN
	
	SET NOCOUNT ON;                
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  

	DECLARE @vClientId INT
	SET @vClientId = @ClientId

    SELECT	ca.ClientAttributeId, 
			ca.ClientAttributeName,	   
			ca.ClientAttributeOrder,
			cav.ClientAttributeValueId, 
			cav.[Value],
			@vClientId AS 'ClientId'
	FROM [Config].[ClientAttribute] ca
	INNER JOIN [MC].[ClientAttributeValue] cav ON cav.ClientAttributeId = ca.ClientAttributeId
	LEFT JOIN [MC].[ClientAttributeItemValue] caiv ON caiv.ClientAttributeId = ca.ClientAttributeId
	WHERE cav.[ClientId] = @vClientId
END
GO
