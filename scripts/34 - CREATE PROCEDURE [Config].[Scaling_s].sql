/****** Object:  StoredProcedure [Config].[Scaling_s]    Script Date: 27/02/2020 8:58:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[Scaling_s]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Config].[Scaling_s]
GO
/****** Object:  StoredProcedure [Config].[Scaling_s]    Script Date: 27/02/2020 8:58:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[Scaling_s]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[Scaling_s] AS' 
END
GO
 
-- =============================================  
-- Author:  juan.sanchez.l  
-- Create date: 27/02/2020   
-- Description: Obtiene los datos de la tabla Config.Scaling filtrados por el campo AttentionQueueScalingId
-- JIRA: EP3C-5908 
-- =============================================  

ALTER PROCEDURE [Config].[Scaling_s]   
 @AttentionQueueScalingId int = NULL
 
AS  
BEGIN  

SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

DECLARE
@pAttentionQueueScalingId int = @AttentionQueueScalingId
   
SELECT ScalingId FROM [Config].[Scaling] WHERE AttentionQueueScalingId = @pAttentionQueueScalingId;
 
END  
GO
