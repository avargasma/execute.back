/****** Object:  StoredProcedure [Config].[AttentionQueue_i]    Script Date: 09/03/2020 8:48:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AttentionQueue_i]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Config].[AttentionQueue_i]
GO
/****** Object:  StoredProcedure [Config].[AttentionQueue_i]    Script Date: 09/03/2020 8:48:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AttentionQueue_i]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[AttentionQueue_i] AS' 
END
GO

-- =============================================
-- Author:	ggasparini	
-- Create date: 18/02/2014
-- Description:	Se registra una nueva cola
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
-- Author:		david.atehortua	- apivatto
-- Modified date: 01/06/2018
-- Description:	Se agrega el parametro @image segun correccion de ytrossero en pre
-- para el ticket EMIN-291
-- Tambien se tuvo que crear la tabla [AttentionQueueType]
-- Este cambio se realiza para poder iniciar con el desarrollo de colas combinadas utilizando
-- la rama de desarrollo 1.4.8
-- Jira: [EP3C-956] - [EP3C-1257]
-- ================================================================================
-- Author:			david.atehortua	- apivatto
-- Modified date:	01/06/2018
-- Description:		Se agregan los valores @PriorityId y @AttentionQueueAssignCases se setean con valores por defecto de manera temporal
--					Este cambio se realiza para poder continuar con el desarrollo de colas combinadas
-- Jira:			[EP3C-956] - [EP3C-1257]
-- ================================================================================
-- Author:			apivatto
-- Modified date:	22/06/2018
-- Description:		Se agrega select para obtener el PriorityId con internalCode = 2
-- Jira:			[EMNE-9]
-- ================================================================================
-- Author:			david.atehortua
-- Modified date:	30/06/2018
-- Description:		El parametro @PriorityId no se envia desde el codigo, por lo tanto se modifica a null como valor por defecto
-- Jira:			[EMNE-9] - [EP3C-956] - [EP3C-1257]
-- ================================================================================
-- Author:			juan.sanchez
-- Modified date:	06/03/2020
-- Description:		Se agrega transaction al SP e inserción a la tabla Config.AttentionQueueLog
-- Jira:			[EP3C-5908]
-- ================================================================================

ALTER PROCEDURE [Config].[AttentionQueue_i]

@AttentionQueueId INT OUTPUT,
@GroupAccountId int, 
@AttentionQueueName VARCHAR(MAX), 
@PAttentionQueueType int,
@AttentionQueueExecutionOrder int, 
@AttentionQueueStart DATETIME, 
@AttentionQueueEnd DATETIME = NULL,
@AttentionQueueActiveFlag bit, 
@UserId int,
@ClassificationId int = NULL,
@AttentionQueueSelectClassification bit,
@AttentionQueueEnablesScaling bit,
@Image varbinary(max) = NULL,
@PriorityId int = NULL
--@AttentionQueueAssignCases


AS
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRANSACTION

DECLARE @AttentionQueueAssignCases bit

IF (@PriorityId = 0 or @PriorityId IS NULL)
BEGIN
	SET @PriorityId = (SELECT PriorityId FROM Config.Priority WHERE PriorityInternalCode = 2)
END

SET @AttentionQueueAssignCases = 1

IF @AttentionQueueEnd IS NOT NULL
	SET @AttentionQueueEnd = dbo.UltimaHoraDia(@AttentionQueueEnd)

INSERT INTO Config.AttentionQueue
(GroupAccountId, 
AttentionQueueName, 
PAttentionQueueType,
AttentionQueueExecutionOrder, 
AttentionQueueStart, 
AttentionQueueEnd,
AttentionQueueCreated, 
AttentionQueueActiveFlag, 
UserId,
AttentionQueueModifiedDate,
ClassificationId,
AttentionQueueSelectClassification,
AttentionQueueEnablesScaling,
AttentionQueueImage,
PriorityId,
AttentionQueueAssignCases)
VALUES (@GroupAccountId,
@AttentionQueueName,
@PAttentionQueueType,
@AttentionQueueExecutionOrder, 
@AttentionQueueStart, 
@AttentionQueueEnd, 
GETDATE(),
@AttentionQueueActiveFlag, 
@UserId,
GETDATE(),
@ClassificationId,
@AttentionQueueSelectClassification,
@AttentionQueueEnablesScaling,
@Image,
@PriorityId,
@AttentionQueueAssignCases)

Set @AttentionQueueId = SCOPE_IDENTITY()  

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
	   aq.AttentionQueueEnableQuickResponse, aq.AttentionQueueTypeId, aq.AttentionQueueAssignCases, aq.AttentionQueueImage, aq.PriorityId, 1
FROM config.AttentionQueue aq
WHERE aq.AttentionQueueId=@AttentionQueueId

COMMIT TRANSACTION

           
END

GO
