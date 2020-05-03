/****** Object:  StoredProcedure [Config].[AttentionQueue_u]    Script Date: 09/03/2020 8:52:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AttentionQueue_u]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Config].[AttentionQueue_u]
GO
/****** Object:  StoredProcedure [Config].[AttentionQueue_u]    Script Date: 09/03/2020 8:52:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AttentionQueue_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[AttentionQueue_u] AS' 
END
GO

-- =============================================
-- Author:	ggasparini	
-- Create date: 18/02/2014
-- Description:	Se se actualiza una cola de atención
-- Jira:  EPN-1130
-- =============================================
-- Author:		nsruiz	
-- Modified date: 03/10/2016
-- Description:	Se agrega las nuevas columnas ClassificationId y AttentionQueueSelectClassification
-- Jira: EVOLUTION-1533
-- ================================================================================
-- Author: nsruiz   
-- Create date: 19/10/2016
-- Description: Se modifica para que se registre la fecha de fin con los milisegundos = 
--              maximo valor de SQL
-- Jira:  EVOLUTION-1679
-- ================================================================================
-- Author: nsruiz   
-- Create date: 23/06/2017
-- Description: Se agrega grabacion del campo AttentionQueueEnablesScaling
-- Jira:  EOE-2016
-- ================================================================================
-- Author yantrossero     
-- Create date 20042018 
-- Description Se agrega el campo AttentionQueueImage y parametro @Image (Cambio copiado de la bd preproducción atehortua.david)
-- Jira  EMIN-291  
-- ================================================================================  
-- ================================================================================
-- Author dcarmonac     
-- Create date 27/07/2018
-- Description Se agrega el campo PriorityId y parametro @PriorityId ademas de los campos PriorityId, AttentionQueueEnableNotificationsPanel, AttentionQueueEnableQuickResponse,
-- AttentionQueueTypeId, AttentionQueueAssignCases, AttentionQueueImage en la AttentionQueueLog
-- Jira  EMNE-97
-- ================================================================================  
-- Author:   juan.sanchez.l 
-- Modified date: 06-03-2020
-- Description: Se agrega la inserción a la columna AttentionQueueTransactionTypeId para reconocer el tipo de transacción realizado.
-- JIRA:  EP3C-5908
-- ================================================================================

ALTER PROCEDURE [Config].[AttentionQueue_u]

@AttentionQueueId INT,
@AttentionQueueName VARCHAR(MAX), 
@AttentionQueueExecutionOrder int, 
@AttentionQueueStart DATETIME, 
@AttentionQueueEnd DATETIME = NULL,
@AttentionQueueActiveFlag bit, 
@UserId int,
@ClassificationId int = NULL,
@AttentionQueueSelectClassification bit ,
@AttentionQueueEnablesScaling bit,
@Image varbinary(max) = NULL,
@PriorityId INT

AS
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF @AttentionQueueEnd IS NOT NULL
	SET @AttentionQueueEnd = dbo.UltimaHoraDia(@AttentionQueueEnd)

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
	   aq.AttentionQueueEnableQuickResponse, aq.AttentionQueueTypeId, aq.AttentionQueueAssignCases, aq.AttentionQueueImage, aq.PriorityId, 2
FROM config.AttentionQueue aq
WHERE aq.AttentionQueueId=@AttentionQueueId


UPDATE Config.AttentionQueue
SET AttentionQueueName = @AttentionQueueName,
AttentionQueueExecutionOrder = @AttentionQueueExecutionOrder,
AttentionQueueStart = @AttentionQueueStart,
AttentionQueueEnd = @AttentionQueueEnd,
AttentionQueueActiveFlag = @AttentionQueueActiveFlag,
UserId = @UserId,
AttentionQueueModifiedDate = GETDATE(),
ClassificationId = @ClassificationId,
AttentionQueueSelectClassification = @AttentionQueueSelectClassification,
AttentionQueueEnablesScaling = @AttentionQueueEnablesScaling,
AttentionQueueImage = @Image,
PriorityId = @PriorityId
WHERE AttentionQueueId=@AttentionQueueId
           
END

GO
