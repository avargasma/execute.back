IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[Conversation_s_Comments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[Conversation_s_Comments] AS' 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  yantrossero  
-- Create date: 08/08/2016  
-- Description: Obtiene un rango de comentarios de la conversación  
-- JIRA:  EVOLUTION-1210  
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
-- Description:  Se modifica en el calculo del valor CreationTimeElapsed, el campo CaseCommentCreated por CreationDateLog,  
-- y se agregó el campo CreationDateLog en los select  
-- Jira:  EVOLUTION-1543  
-- =============================================  
-- Author: yantrossero  
-- Create date: 18/10/2016  
-- Description:  Se agrego el campo AccountDetailDescrip  
-- Jira:  EVOLUTION-1653  
-- =============================================  
-- Author: yantrossero  
-- Create date:20/12/2016  
-- Description:  Se agrego el nombre del representante (campo u.UserName as Agent)  
-- Jira:    
-- =============================================  
-- Author: mflosalinas  
-- Create date:18/01/2017  
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
-- Description: Se agrega el campo UCName  
-- Jira: ETEL-234  
-- =============================================   
-- Author: fsoler   
-- Create date: 24/05/2018  
-- Description: Se agrega el campo ElementId  
-- Jira: EMIN-367  
-- =============================================   
-- Author: fsoler   
-- Create date: 24/05/2018  
-- Description: Se agrega el campo ElementId  
-- Jira: EMIN-367  
-- =============================================   
-- Author:	Gustavo Ramirez
-- Create date: 15/03/2019
-- Description:	Se modifica [CaseCommentText] [varchar](max) NOT NULL a nvarchar
-- Jira: EP3C-4523
-- =============================================
-- Author:		mflosalinas
-- Create date: 03/06/2019
-- Description:	Se agrega sniffing, se modifican las variables dentro del dinamismo
-- Se modifica ya que se guardaba una consulta en una variable y se remplazo por una tabla
-- JIRA: EMIN-2298		
-- =============================================
-- Author:		Todos a las 18hs
-- Create date: 23/07/2019
-- Description:	Se agrega left al campo CaseCommentText ya que comentarios muy grandes da error al abrir caso
-- JIRA: 	ETEC-871
-- =============================================
-- Author:	mflosalinas
-- Create date: 31/07/2019
-- Description:	Se agrega el nombre y apellido del rep
-- JIRA: ETEC-470
-- =============================================
-- Author:		janeth.valbuena / Valentina Yucuma
-- Create date: 19/08/2019
-- Description:	se comenta la linea left(cc.[CaseCommentText],15000) as CaseCommentText y se agrega para que traiga 
--              el campo cc.[CaseCommentText] completo.
-- JIRA: 	EDIN-1019
-- =============================================
-- Author:	mflosalinas
-- Create date: 12/12/2019
-- Description:	Se agrega el campo ReplyToComment, ReplyToCaseCommentId y AnsweredByCommentId
-- JIRA: EPAC-451
-- =============================================
-- Author:	mflosalinas
-- Create date: 14/02/2020
-- Description:	Se agregan los campos p.[PRetriesQuantity], p.PublicationErrorId
-- JIRA: EDIN-1511
-- =============================================
-- Author:	janeth.valbuena
-- Create date: 27-02-2020
-- Description:	Se agrega en la consulta final join MC.PublicationDetail para mostrar el campo PDCommentAux5
-- JIRA: EONC-601
-- ============================================= 
  
ALTER PROCEDURE [MC].[Conversation_s_Comments]  
 @ConversationId INT,  
 @Row INT = NULL,  
 @Ascendent BIT,  
 @DaysRange INT = NULL  
AS  
BEGIN  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 SET NOCOUNT ON;  
   
 DECLARE @Top INT, @Count INT, @Offset INT  
 DECLARE @Continue BIT  
 DECLARE @Query NVARCHAR(MAX), @Params NVARCHAR(MAX)  
 DECLARE @CurrentDate DATETIME  
 DECLARE @Order NVARCHAR(5)  
 DECLARE @P1ConversationId INT  
 DECLARE @P1Row INT   
 DECLARE @P1Ascendent BIT 
 DECLARE @P1DaysRange INT 
 
 SET @P1ConversationId = @ConversationId 
 SET @P1Row = @Row    
 SET @P1Ascendent = @Ascendent
 SET @P1DaysRange = @DaysRange
   
 --Orden en el que se deben filtrar los bloques de registros  
 IF @P1Ascendent = 1 BEGIN  
  SET @Order = 'ASC'  
 END  
 ELSE  
 BEGIN  
  SET @Order = 'DESC'  
 END  
   
 SET @CurrentDate = GETDATE()  
   
 SET @Query = N' SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
    
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
  ReplyToCaseCommentId [int] NULL
  )  
      
  --Filtro los datos  
  INSERT INTO #tb  
  SELECT    
  cc.[CaseCommentId],  
  cc.[CaseId],  
 -- left(cc.[CaseCommentText],5000) as CaseCommentText, 
  cc.CaseCommentText,
  cc.[UserChannelId],  
  cc.[AccountDetailId], 
  ad.AccountId,
  cc.[CaseCommentCreated],  
  cc.[CaseCommentModifiedByUserId],  
  u.[UserName] + '' - '' + p.PersonLastName + '' '' + p.PersonFirstName as Agent, 
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
  FROM [MC].[CaseComment] cc  
  INNER JOIN [MC].[Case] c ON c.CaseId = cc.CaseId  
  INNER JOIN Config.AccountDetail ad ON ad.AccountDetailId = c.AccountDetailId
  LEFT JOIN [Security].[User] u on u.UserId = cc.CaseCommentModifiedByUserId    
  LEFT JOIN [Security].[Person] p on p.PersonId = u.PersonId  
  WHERE c.ConversationId = @PConversationId AND cc.ActiveFlag = 1'  
      
    --Obtengo el rango de comentarios  
    IF @P1DaysRange IS NULL  
    BEGIN  
      
  --Busco el top de comentarios a traer  
  SELECT @Top = CONVERT(INT, Value)   
  FROM [Config].[ApplicationSettings]  
  WHERE SettingId = 19  
    
  IF @P1Row = 0  
  BEGIN  
   SET @Offset = @P1Row + @Top   
  END  
  ELSE  
  BEGIN  
   SET @Offset = @P1Row + @Top - 1  
  END  
  
  SET @Query += '   
  --Obtengo el total de comentarios de la conversación  
  SELECT @PCount = COUNT(*)   
  FROM #tb  

  SELECT cc.ElementTypeId, eta.ReplyToComments, et.ElementTypePublic, et.ElementTypeOutput, et.ServiceChannelId, et.PChannelType
  INTO #Element
  FROM #tb cc  
  LEFT JOIN MC.ElementType et ON et.ElementTypeId = cc.ElementTypeId
  LEFT JOIN Config.ElementTypeAccount eta ON et.ElementTypeId = eta.ElementTypeId and eta.AccountId = cc.AccountId
  GROUP BY cc.ElementTypeId, eta.ReplyToComments, et.ElementTypePublic, et.ElementTypeOutput, et.ServiceChannelId, et.PChannelType

      
  SELECT   
  cc.[CaseCommentId], cc.[CaseId], cc.[CaseCommentText]  
  ,cc.[UserChannelId], cc.[AccountDetailId], cc.[CaseCommentCreated]  
  ,cc.CreationTimeElapsed  
  ,cc.[CaseCommentModifiedByUserId]  
  ,cc.[ElementTypeId], cc.PChannelType, cc.[ElementId],  
  cc.ElementTypePublic, cc.ElementTypeOutput, cc.ServiceChannelId, cc.[DCCSubject],  
  cc.SCName, cc.PublicationDate,cc.PRetriesQuantity,cc.PublicationErrorId,
  cc.SCInternalCode, cc.ProcessDetailsId, cc.DCCPermlinkRoot,cc.DCCOnline,  
  cc.IsTextHtml, cc.ConversationId, cc.GroupAccountId, @PCurrentDate AS ServerDate,   
  cc.CaseCommentPublicationTo, cc.UCUserName,cc.UCName, cc.CreationDateLog, cc.AccountDetailDescrip,
  cc.Agent,cc.ReplyToCaseCommentId, cc.AnsweredByCommentId,
  CASE
	WHEN cc.ElementTypeOutput = 1 THEN 0
	WHEN cc.ReplyToComments IS NULL THEN 0
	ELSE cc.ReplyToComments
  END AS ReplyToComments,
  cc.PDCommentAux5
  FROM(  
  SELECT ROW_NUMBER() OVER (ORDER BY cc.[CaseCommentId] ' + @Order + ') AS RowNum  
  ,cc.[CaseCommentId], cc.[CaseId], cc.[CaseCommentText]  
  ,cc.[UserChannelId], cc.[AccountDetailId], cc.[CaseCommentCreated]  
  ,DATEDIFF(ss, cc.[CreationDateLog], @PCurrentDate) AS CreationTimeElapsed  
  ,cc.[CaseCommentModifiedByUserId]  
  ,cc.[ElementTypeId], e.PChannelType, cc.[ElementId],  
  e.ElementTypePublic, e.ElementTypeOutput, e.ServiceChannelId,dcc.[DCCSubject],  
  sc.SCName, p.PublicationDate, p.[PRetriesQuantity],p.PublicationErrorId,
  sc.SCInternalCode, cc.ProcessDetailsId, dcc.DCCPermlinkRoot,dcc.DCCOnline,  
  sc.IsTextHtml, cc.ConversationId, cc.GroupAccountId, cc.CaseCommentPublicationTo,  
  uc.UCUserName,uc.UCName, cc.CreationDateLog, cad.AccountDetailDescrip, cc.Agent,
  e.ReplyToComments,cc.ReplyToCaseCommentId,cc1.CaseCommentId as AnsweredByCommentId, pd.PDCommentAux5 
  FROM #tb cc  
  INNER JOIN #Element e ON e.ElementTypeId = cc.ElementTypeId
  INNER JOIN MC.UserChannel uc On uc.UserChannelId = cc.UserChannelId  
  INNER JOIN config.ServiceChannel sc ON sc.ServiceChannelId=e.ServiceChannelId    
  INNER JOIN Config.AccountDetail cad ON cad.AccountDetailId = cc.AccountDetailId 
  LEFT JOIN [MC].CaseComment cc1 on cc1.ReplyToCaseCommentId = cc.CaseCommentId       
  LEFT JOIN mc.DetailCaseComment dcc ON dcc.CaseCommentId=cc.CaseCommentId   
  LEFT JOIN mc.Publication p ON p.CaseCommentGUID = cc.CaseCommentGUID
  LEFT JOIN mc.PublicationDetail pd ON pd.PublicationId = p.PublicationId) cc  -- EONC-601
  WHERE cc.RowNum BETWEEN  CAST(@PRow AS VARCHAR(5))  AND  CAST(@POffset AS VARCHAR(5))  
  ORDER BY cc.[CaseCommentId] ASC   
  --Me dice si quedan o no comentarios de traer  
  SELECT (Case WHEN @POffset >= @PCount THEN 0 ELSE 1 END) AS [Continue]  
    
  print @PCount  
  print @POffset  
  '  
         
  SET @Params = N'@PConversationId INT, @PCount INT, @POffset INT, @PCurrentDate DATETIME, @PRow INT'  
  
  EXEC sp_executesql @Query, @Params,   
         @PConversationId=@P1ConversationId, @PCount=@Count,   
         @POffset=@Offset, @PCurrentDate=@CurrentDate, @PRow = @P1Row
          
 END  
 ELSE  
 BEGIN    
  SET @Query += '   

  SELECT cc.ElementTypeId, eta.ReplyToComments, et.ElementTypePublic, et.ElementTypeOutput, et.ServiceChannelId, et.PChannelType
  INTO #Element
  FROM #tb cc  
  LEFT JOIN MC.ElementType et ON et.ElementTypeId = cc.ElementTypeId
  LEFT JOIN Config.ElementTypeAccount eta ON et.ElementTypeId = eta.ElementTypeId and eta.AccountId = cc.AccountId
  GROUP BY cc.ElementTypeId, eta.ReplyToComments, et.ElementTypePublic, et.ElementTypeOutput, et.ServiceChannelId, et.PChannelType

  SELECT   
  cc.[CaseCommentId], cc.[CaseId], cc.[CaseCommentText]  
  ,cc.[UserChannelId], cc.[AccountDetailId], cc.[CaseCommentCreated]  
  ,DATEDIFF(ss, cc.[CreationDateLog], @PCurrentDate) AS CreationTimeElapsed  
  ,cc.[CaseCommentModifiedByUserId]  
  ,cc.[ElementTypeId], e.PChannelType, cc.[ElementId],
  e.ElementTypePublic, e.ElementTypeOutput, e.ServiceChannelId,dcc.[DCCSubject],  
  sc.SCName, p.PublicationDate,p.[PRetriesQuantity], p.PublicationErrorId, sc.SCInternalCode, 
  cc.ProcessDetailsId, dcc.DCCPermlinkRoot, dcc.DCCOnline,sc.IsTextHtml, cc.ConversationId, cc.GroupAccountId,   
  @PCurrentDate AS ServerDate, cc.CaseCommentPublicationTo, uc.UCUserName, uc.UCName, cc.CreationDateLog,  
  cad.AccountDetailDescrip,cc.Agent, cc.ReplyToCaseCommentId, cc1.CaseCommentId as AnsweredByCommentId, 
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
  LEFT JOIN mc.PublicationDetail pd ON pd.PublicationId = p.PublicationId'  -- EONC-601          
    
  --Se fija si traer o no todos los comentarios de la conversación  
  IF @P1DaysRange > 0  
  BEGIN  
  SET @Query = @Query + ' WHERE DATEDIFF(dd, cc.[CreationDateLog], @PCurrentDate) <= @PDaysRange '  
  END  
       
  SET @Query = @Query + '--Me dice si quedan o no comentarios de traer  
  SELECT 0 AS [Continue]'    
        
  SET @Params = N'@PConversationId INT, @PCurrentDate DATETIME, @PDaysRange INT'  
       
  EXEC sp_executesql @Query, @Params,   
         @PConversationId=@P1ConversationId, @PCurrentDate=@CurrentDate,  
         @PDaysRange=@P1DaysRange  
 END    
END 