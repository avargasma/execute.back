IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[User_s_CaseComment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[User_s_CaseComment] AS' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	mflosalinas
-- Create date: 17/01/2019
-- Description:	Se obtiene información del comentario 
-- Jira: EPAC-448
-- =============================================

ALTER PROCEDURE [MC].[User_s_CaseComment] 

	@GroupAccountId INT,
	@CaseCommentId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @AccountId INT
	SET @AccountId = (SELECT AccountId FROM Config.GroupAccount WHERE GroupAccountId = @GroupAccountId)

	SELECT cc.CaseCommentId, cc.CaseId, cc.CaseCommentText, cc.UserChannelId, uc.UCUserName,ISNULL (uc.UCName,'''') as UCName, cc.AccountDetailId,ad.AccountDetailDescrip AS AccountDetailDescripOutput,  
	ad.AccountDetailUnique AS AccountDetailUniqueOutput, gado.[AccountDetailOutputId] as AccountDetailIdOutput, cc.ElementTypeId, ISNULL (dcc.DCCSubject, A.AccountEmailDefaultSubject) as [Subject],
	 a.AccountEmailBodyTemplate,a.AccountEmailBodyBinaryTemplate,	a.AccountEmailHeaderTemplate, a.AccountEmailHeaderBinaryTemplate, dcc.DCCPermlinkRoot, cc.CaseCommentPublicationTo, 
	ISNULL (uca.UCPublicationToAccount, uc.UCPublicationTo)  as UCPublicationTo
	FROM mc.CaseComment cc      
	INNER JOIN mc.UserChannel uc ON  uc.UserChannelId = cc.UserChannelId 
	INNER JOIN MC.UserChannelAccount uca on uca.UserChannelId = uc.UserChannelId  
	INNER JOIN [Config].[GroupAccountDetail] gad on gad.GroupAccountId= @GroupAccountId and gad.AccountDetailId = cc.AccountDetailId  
	INNER JOIN [Config].[GroupAccountDetailOutput] gado on gado.GADId = gad.GADId  
	INNER JOIN Config.AccountDetail ad on ad.AccountDetailId = gado.[AccountDetailOutputId]  
	INNER JOIN Config.Account a ON a.AccountId = ad.AccountId
	LEFT JOIN MC.DetailCaseComment dcc ON dcc.CaseCommentId = cc.CaseCommentId  
	WHERE cc.CaseCommentId = @CaseCommentId 
	AND uca.AccountId = @AccountId

END
GO
