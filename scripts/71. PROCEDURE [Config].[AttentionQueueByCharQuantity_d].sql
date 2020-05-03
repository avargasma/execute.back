
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AttentionQueueByCharQuantity_d]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[AttentionQueueByCharQuantity_d] AS' 
END
GO

-- =============================================
-- Author:	apizarro
-- Create date: 09-08-2019
-- Description:	Se elimina un registro de en la tabla
-- [Config].[AttentionQueueByCharQuantity]
-- Jira:  EPAC-217
-- =============================================

ALTER PROCEDURE [Config].[AttentionQueueByCharQuantity_d]

 @AttentionQueueId int

AS
BEGIN

DELETE FROM [Config].[AttentionQueueByCharQuantity]
WHERE AttentionQueueId = @AttentionQueueId

END

GO
