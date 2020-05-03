IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AttentionQueue_d]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[AttentionQueue_d] AS' 
END
GO

/****** Object:  StoredProcedure [Config].[AttentionQueue_d]    Script Date: 09/03/2020 8:53:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=============================================
-- Author:	nsruiz	
-- Create date: 29/02/2016
-- Description:	Se elimina una cola de atencion
-- Jira:  EVOLUTION-457
-- =============================================
-- Author:	nsruiz	
-- Create date: 16/11/2016
-- Description:	Se agrega la eliminacion previa de las prioridades
--              de la cola a eliminar
-- Jira:  EVOLUTION-1914
-- =============================================
-- Author: juan.sanchez.l
-- Create date: 25/02/2020
-- Description: Se agrega eliminación física a las tablas MC.CaseTypeAttentionQueue, MC.CaseTypeAttentionQueueLog, Config.Scaling y Config.StateScaling
--	Se agrega eliminación del detalle de cada tabla de cola simple.
--	Se agrega eliminación de la tabla Config.ProcessAttributeDetail
-- Jira: [EP3C-5908]
-- =============================================
-- Author: juan.sanchez.l
-- Create date: 09/03/2020
-- Description: Se agrega inserción de registro en la tabla AttentionQueueLog
-- Jira: [EP3C-5908]
-- =============================================

ALTER PROCEDURE [Config].[AttentionQueue_d]

@AttentionQueueid INT

AS
BEGIN

DECLARE @count INT;
DECLARE @ParamId INT;

BEGIN TRY  

BEGIN TRANsaction

SELECT AQAParamId INTO #TmpAttentionQueue FROM Config.AttentionQueueDetail AQD
INNER JOIN [Config].[AttentionQueueAssembly] AQA ON AQD.AQDAttentionQueueAssemblyId = AQA.AQAId
WHERE AQD.AQDAttentionQueueId = @AttentionQueueid

SELECT @count = COUNT(*) FROM #TmpAttentionQueue;

IF @count = 0
BEGIN
INSERT INTO #TmpAttentionQueue
SELECT PAttentionQueueType FROM Config.AttentionQueue WHERE AttentionQueueId = @AttentionQueueid
SELECT @count = COUNT(*) FROM #TmpAttentionQueue;
END

WHILE @count > 0
BEGIN
SET @ParamId = (SELECT TOP (1) AQAParamId AQAParamId FROM #TmpAttentionQueue)

IF @ParamId = 804 -- ByAccount
DELETE FROM [Config].[AttentionQueueByAccount] WHERE AttentionQueueId = @AttentionQueueid

IF @ParamId = 802 -- ByBlackList
DELETE FROM [Config].[AttentionQueueByBlackList] WHERE AttentionQueueId = @AttentionQueueid

IF @ParamId = 803 -- ByChannel
DELETE FROM [Config].[AttentionQueueByChannel] WHERE AttentionQueueId = @AttentionQueueid

IF @ParamId = 812 -- ByChannelType
DELETE FROM [Config].[AttentionQueueByChannelType] WHERE AttentionQueueId = @AttentionQueueid

IF @ParamId = 820 -- ByCharQuantity
DELETE FROM [Config].[AttentionQueueByCharQuantity] WHERE AttentionQueueId = @AttentionQueueid

IF @ParamId = 811 -- ByContent
DELETE FROM [Config].[AttentionQueueByContent] WHERE AttentionQueueId = @AttentionQueueid

IF @ParamId = 807 -- ByDayAndTime
DELETE FROM [Config].[AttentionQueueByDayAndTime] WHERE AttentionQueueId = @AttentionQueueid

IF @ParamId = 805 -- ByInfluence
DELETE FROM [Config].[AttentionQueueByInfluence] WHERE AttentionQueueId = @AttentionQueueid

IF @ParamId = 808 -- ByPreclassification & ByPreclassificationDetail
BEGIN
DELETE FROM [Config].[AttentionQueueByPreclassification] WHERE AttentionQueueId = @AttentionQueueid
DELETE FROM [Config].[AttentionQueueByPreclassificationDetail] WHERE AttentionQueueId = @AttentionQueueid
END

IF @ParamId = 806 -- ByProduct
DELETE FROM [Config].[AttentionQueueByProduct] WHERE AttentionQueueId = @AttentionQueueid

IF @ParamId = 801 -- ByWhiteList
DELETE FROM [Config].[AttentionQueueByWhiteList] WHERE AttentionQueueId = @AttentionQueueid

    DELETE TOP (1) FROM #TmpAttentionQueue
    SELECT @count = COUNT(*) FROM #TmpAttentionQueue;
END

DROP TABLE #TmpAttentionQueue;

DELETE FROM Config.ProcessAttributeDetail 
WHERE AttentionQueueId = @AttentionQueueid;

DELETE FROM [Config].[AttentionQueueDetail]
WHERE AQDAttentionQueueId = @AttentionQueueid;

DELETE  SS
FROM [Config].[StateScaling] SS
INNER JOIN [Config].[Scaling] S ON S.ScalingId = SS.ScalingId
WHERE S.AttentionQueueId = @AttentionQueueid;

DELETE FROM [Config].[Scaling] 
WHERE AttentionQueueId = @AttentionQueueid;

DELETE FROM MC.CaseTypeAttentionQueue 
WHERE AttentionQueueId = @AttentionQueueid

DELETE FROM MC.CaseTypeAttentionQueueLog 
WHERE AttentionQueueId = @AttentionQueueid

DELETE FROM config.AttentionQueuePriority
WHERE AttentionQueueId =  @AttentionQueueid

INSERT INTO Config.AttentionQueueLog
(AttentionQueueId, AttentionQueueLogName, PAttentionQueueLogType,
AttentionQueueLogExecutionOrder, AttentionQueueLogStart, AttentionQueueLogEnd,
AttentionQueueLogCreated, AttentionQueueLogActiveFlag, AttentionQueueLogUserId,
AttentionQueueLogModifiedDate, ClassificationId, AttentionQueueSelectClassification,
AttentionQueueEnablesScaling, AttentionQueueEnableNotificationsPanel, AttentionQueueEnableQuickResponse,
AttentionQueueTypeId, AttentionQueueAssignCases, AttentionQueueImage, PriorityId, AttentionQueueTransactionTypeId)
SELECT aq.AttentionQueueId, aq.AttentionQueueName, aq.PAttentionQueueType,
       aq.AttentionQueueExecutionOrder, aq.AttentionQueueStart,
       aq.AttentionQueueEnd, aq.AttentionQueueCreated, aq.AttentionQueueActiveFlag,
       aq.UserId, aq.AttentionQueueModifiedDate, aq.ClassificationId, 
       aq.AttentionQueueSelectClassification, aq.AttentionQueueEnablesScaling, aq.AttentionQueueEnableNotificationsPanel,
	   aq.AttentionQueueEnableQuickResponse, aq.AttentionQueueTypeId, aq.AttentionQueueAssignCases, aq.AttentionQueueImage, aq.PriorityId, 3
FROM config.AttentionQueue aq
WHERE aq.AttentionQueueId=@AttentionQueueId

DELETE FROM Config.AttentionQueue
WHERE AttentionQueueId = @AttentionQueueId

COMMIT TRANSACTION
END TRY 
BEGIN CATCH  
SELECT ERROR_NUMBER() AS ErrorNumber ,ERROR_MESSAGE() AS ErrorMessage;
IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION
END CATCH
          
END


GO
