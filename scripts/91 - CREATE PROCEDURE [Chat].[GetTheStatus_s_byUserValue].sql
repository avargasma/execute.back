
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ===================================================================
-- Author: psosa
-- Create date: 09/03/2020
-- Description:	Busca el estado de un caso por el valor principal
-- JIRA: 
-- ===================================================================


CREATE PROCEDURE [Chat].[GetTheStatus_s_byUserValue] 
	
	@CUserValue varchar(300)
	
AS
BEGIN

SET NOCOUNT ON;   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;   

SELECT TOP 1 max(cm.[CMessageCreationDate]) as CreationDate, 
       cst.StateTypeInternalCode, cm.CaseId FROM [Chat].[User] cu 
INNER JOIN [Chat].[Message] cm ON cm.CUserId = cu.CUserId
INNER JOIN [Chat].[Status] cs ON cs.CStatusId = cm.CStatusId
INNER JOIN [Config].[StateType] cst ON cst.StateTypeId = cs.StateTypeId
WHERE cu.CUserValue = @CUserValue
GROUP BY cst.StateTypeInternalCode, cm.CaseId
ORDER BY 1 DESC


END