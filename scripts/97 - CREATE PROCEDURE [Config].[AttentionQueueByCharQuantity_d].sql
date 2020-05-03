/****** Object:  StoredProcedure [Config].[AttentionQueueByCharQuantity_d]    Script Date: 20/02/2020 10:37:26 p. m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AttentionQueueByCharQuantity_d]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Config].[AttentionQueueByCharQuantity_d]
GO
/****** Object:  StoredProcedure [Config].[AttentionQueueByCharQuantity_d]    Script Date: 20/02/2020 10:37:26 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AttentionQueueByCharQuantity_d]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:	apizarro
-- Create date: 09-08-2019
-- Description:	Se elimina un registro de en la tabla
-- [Config].[AttentionQueueByCharQuantity]
-- Jira:  EPAC-217
-- =============================================
-- Author:	juan.sanchez.l
-- Create date: 17-04-2020
-- Description:	Se cambia el filtro del where el campo AttentionQueueId por AttentionQueueByCharQuantityId
-- [Config].[AttentionQueueByCharQuantity]
-- Jira:  EPAC-398
-- =============================================

CREATE PROCEDURE [Config].[AttentionQueueByCharQuantity_d]

 @AttentionQueueId int

AS
BEGIN

DELETE FROM [Config].[AttentionQueueByCharQuantity]
WHERE AttentionQueueByCharQuantityId = @AttentionQueueId

END

' 
END
GO
