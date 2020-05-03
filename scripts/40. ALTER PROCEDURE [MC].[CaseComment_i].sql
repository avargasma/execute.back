/****** Object:  StoredProcedure [MC].[CaseComment_i]    Script Date: 03/12/2019 15:32:39 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[CaseComment_i]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[CaseComment_i] AS' 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================    
-- Author: nsruiz     
-- Create date: 16/01/2014    
-- Description: Insertar un comentario de un caso    
-- Jira:  EPN-761    
-- =============================================    
-- =============================================    
-- Author: nsruiz     
-- Create date: 27/02/2014    
-- Description: Se agregan los parametros @ElementId, @ElementTypeId    
--              Se elimina el parametro @PChannelType    
-- Jira:  EPN-1160    
-- =============================================    
-- Author: nsruiz     
-- Create date: 10/03/2014    
-- Description: Se elimina el parametro @SourceCaseCommentId    
-- Jira:  EPN-1186    
-- =============================================    
-- Author:  ggasparini    
-- Modified date: 13/08/2014   
-- Description: Se agrega la insercion del campo UCPublicationTo  
-- Jira: EPN-1889  
-- ===============================================================  
-- Author:  ggasparini    
-- Modified date: 21/08/2014   
-- Description: Se agrega la insercion del campo CaseCommentModifiedByUserId  
-- Jira: EPN-1901  
-- ===============================================================  
-- Author:  yantrossero    
-- Modified date: 24/02/2016  
-- Description: Al parámetro @CaseConfigurationId ahora es opcional  
-- Jira: EVOLUTION-378  
-- ===============================================================  
-- Author:  yantrossero    
-- Modified date: 24/02/2016  
-- Description: Al parámetro @CaseConfigurationId ahora es opcional  
-- Jira: EVOLUTION-378  
-- =============================================================== 
-- Author:  fsoler    
-- Modified date: 16/03/2016  
-- Description: Se garegan los parámetros CreationDate,CreatedRowOrigen,CreationDateOriginal  
-- Jira: EVOLUTION-514  
-- ===============================================================   
-- Author: mflosalinas
-- Modified date: 15/09/2016  
-- Description: Se agrega el parámetro de salida @CaseCommentGUID
-- Jira: 
-- ===============================================================  
-- Author: mflosalinas
-- Modified date: 23/02/2018  
-- Description: Se agrega el parámetro @StateValidationId
-- Jira: EMIN-39
-- ===============================================================  
-- Author: lsalvo
-- Modified date: 09/03/2018
-- Description: Se agrega el parametro @AttentionQueueId
-- =============================================================== 
-- Author: Gustavo Ramirez
-- Modified date: 28/01/2019
-- Description: Se modifica el sp para que no utilice las fechas
-- enviada por parametros. Se cambia a fecha de BD (GETDATE)
-- Jira: EMIN-39
-- ===============================================================  
-- Author:	mflosalinas
-- Create date: 31/01/2019
-- Description:	Se agrega condición de que si la cola que se pasa por parámetro es NULL, busque la cola del caso.
-- Jira: EPMP-726
-- =============================================
-- Author:	Gustavo Ramirez
-- Create date: 15/03/2019
-- Description:	Se modifica el parametro @CaseCommentText a NVarchar
-- Jira: EP3C-4523
-- ===============================================================
-- Author: mflosalinas
-- Create date: 03/12/2019
-- Description:	Se agrega el parámetro @ReplyToCaseCommentId
-- Jira: EPAC-448
-- ===============================================================
    
ALTER PROCEDURE [MC].[CaseComment_i]    
    
@CaseCommentId INT OUTPUT,    
@CaseId INT,     
@CaseCommentText NVARCHAR(MAX),     
@UserChannelId INT,     
@AccountDetailId INT,     
@CaseConfigurationId INT = NULL,     
@ProcessDetailsId INT = NULL,    
@ElementId INT = NULL,    
@ElementTypeId INT,  
@CaseCommentPublicationTo VARCHAR(256) = NULL,  
@CaseCommentModifiedByUserId int =NULL,
@CreationDate DATETIME,
@CreatedRowOrigen DATETIME,
@CreationDateOriginal DATETIME,
@CaseCommentGUID uniqueidentifier output,
@StateValidationId int = NULL,
@AttentionQueueId int = NULL,
@ReplyToCaseCommentId int = NULL
    
AS    
BEGIN  

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
    
SET @CaseCommentGUID = newid()
    
DECLARE @pFecha DATETIME
SET @pFecha = GETDATE()
    
IF (@AttentionQueueId IS NULL)
	BEGIN
		SET @AttentionQueueId = (SELECT c.AttentionQueueId FROM mc.[Case] c
									WHERE c.CaseId = @CaseId)
	END  
    
INSERT INTO MC.CaseComment    
 (CaseId,    
 CaseCommentText,    
 UserChannelId,    
 AccountDetailId,    
 CaseConfigurationId,    
 ProcessDetailsId,    
 ElementId,    
 ElementTypeId,  
 CaseCommentPublicationTo,  
 CaseCommentModifiedByUserId,
 CreationDateLog,
 CreatedRowOrigenLog,
 CreationDateOriginalLog,
 CaseCommentGUID,
 StateValidationId,
 AttentionQueueId,
 ReplyToCaseCommentId
 )    
VALUES    
 (@CaseId,    
 @CaseCommentText,    
 @UserChannelId,    
 @AccountDetailId,    
 @CaseConfigurationId,    
 @ProcessDetailsId,    
 @ElementId,    
 @ElementTypeId,  
 @CaseCommentPublicationTo,  
 @CaseCommentModifiedByUserId,
 
 --EMIN-1417: Se cambian las fechas para que tome la fecha de BD y no la de codigo que se reciben por parametro
 /*
 @CreationDate,
 @CreatedRowOrigen,
 @CreationDateOriginal,
 */
 
 @pFecha, --> CreationDate
 @pFecha, --> @CreatedRowOrigen,
 @pFecha, --> @CreationDateOriginal,
 
 
 @CaseCommentGUID,
 @StateValidationId,
 @AttentionQueueId,
 @ReplyToCaseCommentId)    
                  
    
Set @CaseCommentId = SCOPE_IDENTITY()      
    
END