IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[CaseComment_s_CaseCommentId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[CaseComment_s_CaseCommentId] AS' 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	mflosalinas
-- Create date: 13-03-2020
-- Description:	obtiene un comentario de un caso en particular
-- Jira: EPAC-488
-- =============================================

ALTER PROCEDURE [MC].[CaseComment_s_CaseCommentId]

 @CaseId INT,  
 @CaseCommentId INT 
 
AS
BEGIN

 Declare @PCaseId int , @PCaseCommentId int   
  
 Set @PCaseId = @CaseId  
 Set @PCaseCommentId = @CaseCommentId  

 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	SET NOCOUNT ON;

	SELECT cc.CaseCommentId, cc.CaseId, cc.CaseCommentText, cc.UserChannelId, cc.AccountDetailId, cc.CaseCommentGUID,
	cc.ElementTypeId,cc.ProcessDetailsId, cc.CaseCommentPublicationTo, cc.CaseCommentCreated,   
	c.ConversationId,c.GroupAccountId,cc.CreationDateLog, cc.CaseCommentModifiedByUserId 
	INTO #Comment
	FROM mc.CaseComment cc    
	INNER JOIN MC.[Case] c ON c.CaseId = cc.CaseId  
	WHERE cc.CaseId = @PCaseId
	and cc.CaseCommentId = @PCaseCommentId 


	SELECT cc.CaseCommentId, cc.CaseId, cc.CaseCommentText, cc.UserChannelId, uc.UCUserName,isnull(uc.UCName,'''') as UCName, cc.AccountDetailId,ad.AccountDetailDescrip AS AccountDetailDescripOutput,  
	ad.AccountDetailUnique AS AccountDetailUniqueOutput, gado.[AccountDetailOutputId] as AccountDetailIdOutput,  
	et.PChannelType, et.ElementTypePublic, et.ElementTypeOutput,cc.ElementTypeId, et.ServiceChannelId, dcc.DCCSubject, p.PublicationDate,  
	cc.ProcessDetailsId,dcc.DCCPermlinkRoot, cc.CaseCommentPublicationTo,sc.SCName, sc.SCInternalCode, cc.CaseCommentCreated,   
	cc.ConversationId,cc.GroupAccountId, DATEDIFF(ss, cc.CreationDateLog, GETDATE()) AS CreationTimeElapsed, cc.CaseCommentModifiedByUserId,dcc.DCCOnline,
	GETDATE() AS ServerDate,cc.CreationDateLog,
	u.[UserName]+' - '+ per.PersonLastName +' '+ per.PersonFirstName as Agent
	FROM #Comment cc
	INNER JOIN mc.ElementType et ON cc.ElementTypeId = et.ElementTypeId    
	INNER JOIN config.ServiceChannel sc ON sc.ServiceChannelId=et.ServiceChannelId   
	INNER JOIN mc.UserChannel uc ON  uc.UserChannelId = cc.UserChannelId   
	INNER JOIN [Config].[GroupAccountDetail] gad on gad.GroupAccountId= cc.GroupAccountId and gad.AccountDetailId = cc.AccountDetailId  
	INNER JOIN [Config].[GroupAccountDetailOutput] gado on gado.GADId = gad.GADId  
	INNER JOIN Config.AccountDetail ad on ad.AccountDetailId = gado.[AccountDetailOutputId]  
	LEFT JOIN MC.DetailCaseComment dcc ON dcc.CaseCommentId = cc.CaseCommentId  
	LEFT JOIN mc.Publication p ON p.CaseCommentGUID = cc.CaseCommentGUID  
	LEFT JOIN [Security].[User] u on u.UserId = cc.CaseCommentModifiedByUserId  
	LEFT JOIN [Security].[Person] per on per.PersonId = u.PersonId  
	ORDER BY cc.CaseCommentCreated DESC

	END
GO
