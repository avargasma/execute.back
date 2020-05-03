
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AttentionQueueByCharQuantity_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[AttentionQueueByCharQuantity_u] AS' 
END
GO

-- =============================================
-- Author:	apizarro
-- Create date: 11-05-2018
-- Description:	Se modifica un registro de en la tabla
-- [Config].[AttentionQueueByCharQuantity]
-- Jira:  EPAC-217
-- =============================================

ALTER PROCEDURE [Config].[AttentionQueueByCharQuantity_u]

 @AttentionQueueId int
,@AttentionQueueByCharQuantityMAX int
,@AttentionQueueByCharQuantityMIN int
,@AttentionQueueByCharQuantityModifiedByUser int
,@AttentionQueueByCharQuantityActiveFlag bit

AS
BEGIN

UPDATE [Config].[AttentionQueueByCharQuantity]
   SET
       [AttentionQueueByCharQuantityMAX] = @AttentionQueueByCharQuantityMAX 
      ,[AttentionQueueByCharQuantityMIN] = @AttentionQueueByCharQuantityMIN 
      ,[AttentionQueueByCharQuantityModifiedDate] = GETDATE() 
      ,[AttentionQueueByCharQuantityModifiedByUser] = @AttentionQueueByCharQuantityModifiedByUser 
      ,[AttentionQueueByCharQuantityActiveFlag] = @AttentionQueueByCharQuantityActiveFlag 
 WHERE AttentionQueueId = @AttentionQueueId

END


GO
