
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AttentionQueueByCharQuantity_i]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[AttentionQueueByCharQuantity_i] AS' 
END
GO

-- =============================================
-- Author:	apizarro
-- Create date: 09-08-2019
-- Description:	Se registra un registro de en la tabla
-- [Config].[AttentionQueueByCharQuantity]
-- Jira:  EPAC-217
-- =============================================

ALTER PROCEDURE [Config].[AttentionQueueByCharQuantity_i]

 @AttentionQueueId int
,@AttentionQueueByCharQuantityMAX int
,@AttentionQueueByCharQuantityMIN int
,@AttentionQueueByCharQuantityModifiedByUser int
,@AttentionQueueByCharQuantityActiveFlag bit

AS
BEGIN

INSERT INTO [Config].[AttentionQueueByCharQuantity]
(
	 [AttentionQueueId]
	,[AttentionQueueByCharQuantityMAX]
	,[AttentionQueueByCharQuantityMIN]
	,[AttentionQueueByCharQuantityModifiedByUser]
	,[AttentionQueueByCharQuantityActiveFlag]
)
VALUES
(
	 @AttentionQueueId
	,@AttentionQueueByCharQuantityMAX
	,@AttentionQueueByCharQuantityMIN
	,@AttentionQueueByCharQuantityModifiedByUser
	,@AttentionQueueByCharQuantityActiveFlag
)

END

GO
