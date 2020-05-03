
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AttentionQueueByCharQuantity_s_ByAttentionQueueId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[AttentionQueueByCharQuantity_s_ByAttentionQueueId] AS' 
END
GO

-- ===========================================================  
-- Author: apizarro   
-- Create date: 06-08-2019
-- Description: Consulta de campos de la tabla AttentionQueueByCharQuantity
-- por id de cola
-- Jira: EPAC-217
-- ===========================================================
  
ALTER PROCEDURE [Config].[AttentionQueueByCharQuantity_s_ByAttentionQueueId] 
  
	@AttentionQueueId INT
  
AS  
BEGIN  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   

SELECT
 aqcq.AttentionQueueByCharQuantityId
,aqcq.AttentionQueueId
,aqcq.AttentionQueueByCharQuantityMAX
,aqcq.AttentionQueueByCharQuantityMIN
,aqcq.AttentionQueueByCharQuantityCreated
,aqcq.AttentionQueueByCharQuantityModifiedDate
,aqcq.AttentionQueueByCharQuantityModifiedByUser
,aqcq.AttentionQueueByCharQuantityActiveFlag
FROM Config.AttentionQueueByCharQuantity aqcq
WHERE 
	aqcq.AttentionQueueId = @AttentionQueueId
AND aqcq.AttentionQueueByCharQuantityActiveFlag = 1

END
GO
