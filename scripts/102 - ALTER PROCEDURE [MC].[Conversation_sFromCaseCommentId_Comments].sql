IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[Conversation_sFromCaseCommentId_Comments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[Conversation_sFromCaseCommentId_Comments] AS' 
END

GO

-- =============================================    
-- Author:  yantrossero    
-- Create date: 07/08/2016    
-- Description: Trae todos los comentarios de una conversación apartir de un CaseCommentId    
-- JIRA:  EVOLUTION-1391    
-- =============================================    
-- Author: mflosalinas    
-- Create date: 20/09/2016    
-- Description:  se quita el emparejamiento LEFT JOIN mc.CaseCommentPublication ccp ON ccp.CaseCommentId=cc.CaseCommentId      
-- LEFT JOIN mc.Publication p ON ccp.PublicationId=p.PublicationId    
-- y se agrega LEFT JOIN mc.Publication p ON p.CaseCommentGUID = cc.CaseCommentGUID    
-- JIRA: EVOLUTION-1470    
-- =============================================    
-- Author: mflosalinas    
-- Create date: 28/09/2016    
-- Description:  Se modifica en el calculo del valor CreationTimeElapsed, el campo CaseCommentCreated por CreationDateLog    
-- y se agregó el campo CreationDateLog en los select    
-- Jira:  EVOLUTION-1543    
-- =============================================    
-- Author: yantrossero    
-- Create date: 18/10/2016    
-- Description:  Se agrego el campo AccountDetailDescrip    
-- Jira:  EVOLUTION-1653    
-- =============================================    
-- Author: yantrossero    
-- Create date: 20/12/2016    
-- Description:  Se agrego el nombre del representante (campo u.UserName as Agent)    
-- Jira:      
-- =============================================    
-- Author: mflosalinas    
-- Create date: 18/01/2017    
-- Description:  Se agrega un nuevo campo DCCOnline el cual indica si el video esta activo    
-- Jira:      
-- =============================================    
-- Author: yantrossero      
-- Create date:06/04/2017     
-- Description:  Se filtra por CaseComment.ActiveFlag = 1, es decir, comentarios completos.    
-- Jira:    EVOLUTION-2327    
-- =============================================    
-- Author: mflosalinas     
-- Create date: 31/01/2018    
-- Description:  Se agrega el campo UCName    
-- Jira: ETEL-234    
-- =============================================  
-- Author: fsoler     
-- Create date: 24/05/2018    
-- Description: Se agrega el campo ElementId    
-- Jira: EMIN-367    
-- =============================================      
-- Author: pnunez  
-- Create date: 30/05/2018    
-- Description:  Se reasigna parametros a @PConversationId, @PCaseCommentId  
-- para evitar sql Parameter Sniffing  
-- =============================================     
-- Author: Gustavo Ramirez  
-- Create date: 15/03/2019  
-- Description: Se modifica [CaseCommentText] [varchar](max) NOT NULL a nvarchar  
-- Jira: EP3C-4523  
-- =============================================  
-- Author: mflosalinas  
-- Create date: 05/06/2019  
-- Description: Se modifica el guardado en una variable por una tabla  
-- Jira: EMIN-2328  
-- =============================================  
-- Author: mflosalinas  
-- Create date: 31/07/2019  
-- Description: Se agrega el nombre y apellido del rep  
-- JIRA: ETEC-470  
-- =============================================   
-- Author: mflosalinas/pnunez  
-- Create date: 28/10/2019  
-- Description: Se modfica para que si la primer consulta no devuelve nada, no siga ejecutando las demas consultas.  
-- JIRA: ETEL-3546  
-- =============================================   
-- Author: mflosalinas  
-- Create date: 12/12/2019  
-- Description: Se agrega el campo ReplyToComment, ReplyToCaseCommentId y AnsweredByCommentId  
-- JIRA: EPAC-451  
-- =============================================  
-- Author: mflosalinas  
-- Create date: 14/02/2020  
-- Description: Se agregan los campos p.[PRetriesQuantity], p.PublicationErrorId  
-- JIRA: EDIN-1511  
-- =============================================  
-- Author: janeth.valbuena  
-- Create date: 27-02-2020  
-- Description: Se agrega en la consulta final join MC.PublicationDetail para mostrar el campo PDCommentAux5  
-- JIRA: EONC-601  
-- =============================================   
-- Author: Luchini Diego
-- Create date: 27-04-2020  
-- Description: Se agrega order by CaseComment
-- =============================================   
    
ALTER PROCEDURE [MC].[Conversation_sFromCaseCommentId_Comments]    
  
 @ConversationId INT,    
 @CaseCommentId INT    
  
AS    
BEGIN    
  
 Declare @PConversationId int , @PCaseCommentId int     
    
 Set @PConversationId = @ConversationId    
 Set @PCaseCommentId = @CaseCommentId    
  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
 SET NOCOUNT ON;    
     
 DECLARE @Query NVARCHAR(MAX), @Params NVARCHAR(MAX)    
 DECLARE @CurrentDate DATETIME    
     
 SET @CurrentDate = GETDATE()    
     
 create table #sindatos  
(  
  [CaseCommentId] int ,   
 [CaseId] int,   
 [CaseCommentText] nvarchar(max),    
 [UserChannelId] int,   
 [AccountDetailId] int,   
 [AccountId] int,  
 [CaseCommentCreated] datetime,  
 CreationTimeElapsed datetime,    
 [CaseCommentModifiedByUserId] int,    
 [ElementTypeId] int,   
 PChannelType int,  
 [ElementId] int,    
 ElementTypePublic bit,   
 ElementTypeOutput bit,   
 ServiceChannelId int,  
 [DCCSubject] varchar(max),     
 SCName varchar(250),   
 PublicationDate datetime,   
 PRetriesQuantity int,  
 PublicationErrorId int,  
 SCInternalCode int,   
 ProcessDetailsId int,   
 DCCPermlinkRoot varchar(max),    
 DCCOnline bit,  
 IsTextHtml bit,   
 ConversationId int ,   
 GroupAccountId int,    
 ServerDate datetime,  
 CaseCommentPublicationTo varchar(256),   
 UCUserName nvarchar(max),   
 UCName nvarchar(max),    
 CreationDateLog datetime,    
 AccountDetailDescrip varchar(200),  
 Agent nvarchar(150),  
 ReplyToComments BIT,  
 ReplyToCaseCommentId INT,  
 AnsweredByCommentId INT,  
 PDCommentAux5 varchar (100) null  
)  
     
 CREATE TABLE #tb(    
 [CaseCommentId] [int] NOT NULL,    
 [CaseId] [int] NOT NULL,    
 [CaseCommentText] [nvarchar](max) NOT NULL,    
 [UserChannelId] [int] NOT NULL,    
 [AccountDetailId] [int] NOT NULL,  
 [AccountId] [int] NOT NULL,    
 [CaseCommentCreated] [datetime] NOT NULL,    
 [CaseCommentModifiedByUserId] [int] NULL,    
 [Agent] [nvarchar](150) NULL,    
 [CaseConfigurationId] [int] NULL,    
 [ProcessDetailsId] [int] NULL,    
 [ElementId] [int] NULL,    
 [ElementTypeId] [int] NOT NULL,    
 [CaseCommentPublicationTo] [varchar](256) NULL,    
 [CreationDateLog] [datetime] NULL,    
 [CreatedRowOrigenLog] [datetime] NULL,    
 [CreationDateOriginalLog] [datetime] NULL,    
 [CaseCommentGUID] [uniqueidentifier] NOT NULL,    
 [GroupAccountId] [int] NOT NULL,    
 ConversationId [int] NOT NULL,  
 ReplyToCaseCommentId [int] NULL)    
  
   
 IF NOT EXISTS( SELECT      
  cc.[CaseId]  
  FROM [MC].[CaseComment] cc    
  INNER JOIN [MC].[Case] c ON c.CaseId = cc.CaseId    
  WHERE c.ConversationId = @PConversationId    
  and cc.[CaseCommentId] > @PCaseCommentId )  
  
 begin   
  
   Select [CaseCommentId],   
   [CaseId],   
   [CaseCommentText],    
   [UserChannelId],   
   [AccountDetailId],  
   [AccountId],   
   [CaseCommentCreated],  
   CreationTimeElapsed,    
   [CaseCommentModifiedByUserId],    
   [ElementTypeId],   
   PChannelType,  
   [ElementId],    
   ElementTypePublic,   
   ElementTypeOutput,   
   ServiceChannelId,  
   [DCCSubject],    
   SCName,   
   PublicationDate,  
   PRetriesQuantity,  
   PublicationErrorId,   
   SCInternalCode,   
   ProcessDetailsId,   
   DCCPermlinkRoot,    
   DCCOnline,  
   IsTextHtml,   
   ConversationId,   
   GroupAccountId,    
   ServerDate,  
   CaseCommentPublicationTo,   
   UCUserName,   
   UCName,   
   CreationDateLog,    
   AccountDetailDescrip,  
   Agent,   
   ReplyToComments,  
   ReplyToCaseCommentId,  
   AnsweredByCommentId,  
   PDCommentAux5  
   from #sindatos  
  
   SELECT 0 AS [Continue]    
  
  end   
 else   
  begin   
   
   --Filtro los datos    
  SELECT      
  cc.[CaseCommentId] ,  
  cc.[CaseId],    
  cc.[CaseCommentText],    
  cc.[UserChannelId],    
  cc.[AccountDetailId],  
  ad.AccountId,    
  cc.[CaseCommentCreated],    
  cc.[CaseCommentModifiedByUserId],    
  cc.[CaseConfigurationId],    
  cc.[ProcessDetailsId],    
  cc.[ElementId],    
  cc.[ElementTypeId],    
  cc.[CaseCommentPublicationTo],    
  cc.[CreationDateLog],    
  cc.[CreatedRowOrigenLog],    
  cc.[CreationDateOriginalLog],    
  cc.[CaseCommentGUID],    
  c.GroupAccountId,     
  c.ConversationId,  
  cc.ReplyToCaseCommentId     
  into  #Casecomment  
  FROM [MC].[CaseComment] cc    
  INNER JOIN [MC].[Case] c ON c.CaseId = cc.CaseId    
  INNER JOIN Config.AccountDetail ad ON ad.AccountDetailId = c.AccountDetailId  
  WHERE c.ConversationId = @PConversationId    
  and cc.[CaseCommentId] > @PCaseCommentId    
  
 --Filtro los datos    
  INSERT INTO #tb    
  SELECT      
  tcc.[CaseCommentId],   
  tcc.[CaseId],    
  tcc.[CaseCommentText],    
  tcc.[UserChannelId],    
  tcc.[AccountDetailId],   
  tcc.AccountId,   
  tcc.[CaseCommentCreated],    
  tcc.[CaseCommentModifiedByUserId],    
  u.[UserName]+' - '+ p.PersonLastName +' '+ p.PersonFirstName as Agent,   
  tcc.[CaseConfigurationId],    
  tcc.[ProcessDetailsId],    
  tcc.[ElementId],    
  tcc.[ElementTypeId],    
  tcc.[CaseCommentPublicationTo],    
  tcc.[CreationDateLog],    
  tcc.[CreatedRowOrigenLog],    
  tcc.[CreationDateOriginalLog],    
  tcc.[CaseCommentGUID],    
  tcc.GroupAccountId,     
  tcc.ConversationId,   
  tcc.ReplyToCaseCommentId   
  FROM #Casecomment tcc  
  LEFT JOIN [Security].[User] u on u.UserId = tcc.CaseCommentModifiedByUserId    
  LEFT JOIN [Security].[Person] p on p.PersonId = u.PersonId   
    
  SELECT cc.ElementTypeId, eta.ReplyToComments, et.ElementTypePublic, et.ElementTypeOutput, et.ServiceChannelId, et.PChannelType  
  INTO #Element  
  FROM #tb cc    
  LEFT JOIN MC.ElementType et ON et.ElementTypeId = cc.ElementTypeId  
  LEFT JOIN Config.ElementTypeAccount eta ON et.ElementTypeId = eta.ElementTypeId and eta.AccountId = cc.AccountId  
  GROUP BY cc.ElementTypeId, eta.ReplyToComments, et.ElementTypePublic, et.ElementTypeOutput, et.ServiceChannelId, et.PChannelType  
        
  SELECT     
  cc.[CaseCommentId],   
  cc.[CaseId],   
  cc.[CaseCommentText],    
  cc.[UserChannelId],   
  cc.[AccountDetailId],   
  cc.[CaseCommentCreated],  
  DATEDIFF(ss, cc.[CreationDateLog], @CurrentDate) AS CreationTimeElapsed,    
  cc.[CaseCommentModifiedByUserId],    
  cc.[ElementTypeId],   
  e.PChannelType,  
  cc.[ElementId],    
  e.ElementTypePublic,   
  e.ElementTypeOutput,   
  e.ServiceChannelId,  
  dcc.[DCCSubject],    
  sc.SCName,   
  p.PublicationDate,  
  p.[PRetriesQuantity],  
  p.PublicationErrorId,    
  sc.SCInternalCode,   
  cc.ProcessDetailsId,   
  dcc.DCCPermlinkRoot,    
  dcc.DCCOnline,  
  sc.IsTextHtml,   
  cc.ConversationId,   
  cc.GroupAccountId,    
  @CurrentDate AS ServerDate,  
  cc.CaseCommentPublicationTo,   
  uc.UCUserName,   
  uc.UCName,   
  cc.CreationDateLog,    
  cad.AccountDetailDescrip,  
  cc.Agent,  
  cc.ReplyToCaseCommentId,  
  cc1.CaseCommentId as AnsweredByCommentId,  
  CASE  
  WHEN e.ElementTypeOutput = 1 THEN 0  
  WHEN e.ReplyToComments IS NULL THEN 0  
  ELSE e.ReplyToComments  
  END AS ReplyToComments,  
  pd.PDCommentAux5  
  FROM #tb cc   
  INNER JOIN MC.UserChannel uc On uc.UserChannelId = cc.UserChannelId    
  INNER JOIN #Element e ON e.ElementTypeId = cc.ElementTypeId  
  INNER JOIN config.ServiceChannel sc ON sc.ServiceChannelId=e.ServiceChannelId      
  INNER JOIN Config.AccountDetail cad ON cad.AccountDetailId = cc.AccountDetailId  
  LEFT JOIN [MC].CaseComment cc1 on cc1.ReplyToCaseCommentId = cc.CaseCommentId           
  LEFT JOIN mc.DetailCaseComment dcc ON dcc.CaseCommentId=cc.CaseCommentId      
  LEFT JOIN mc.Publication p ON p.CaseCommentGUID = cc.CaseCommentGUID  
  LEFT JOIN [MC].[PublicationDetail] pd ON pd.PublicationId = p.PublicationId  -- EONC-601     
  order by cc.[CaseCommentId]   
  --Me dice si quedan o no comentarios de traer    
  SELECT 0 AS [Continue]   
    
 end   
      
END 