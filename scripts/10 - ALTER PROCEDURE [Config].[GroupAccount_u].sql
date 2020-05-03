IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[GroupAccount_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[GroupAccount_u] AS' 
END

GO

-- =================================================================================  
-- Author:   nsruiz  
-- Create date: 24/04/2014  
-- Description: actualiza los datos de un grupo  
-- JIRA:  EPN-1330  
-- ================================================================================  
-- Author:   ggasparini	  
-- Create date: 30/05/2014  
-- Description: se agrega el campo classificationid
-- JIRA:  EPN-1530  
-- ================================================================================  
-- Author:   nsruiz	  
-- Create date: 05/05/2016
-- Description: Se agrega el campo GroupAccountTimeConversation
-- JIRA:  EVOLUTION-671   
-- ================================================================================ 
-- Author:	  nsruiz
-- Create date: 19/09/2016
-- Description:	se agrega la grabacion en la tabla de log del campo AccountId
-- JIRA:  EVOLUTION-14501
-- ================================================================================
-- Author: nsruiz   
-- Create date: 19/10/2016
-- Description: Se modifica para que se registre la fecha de fin con los milisegundos = 
--              maximo valor de SQL
-- Jira:  EVOLUTION-1679
-- ================================================================================
-- Author: damramirez   
-- Create date: 19/11/2018
-- Description: Se agrega el campo QuickResponseGroupId
-- Jira:  ETEL-1347
-- ================================================================================
-- Author: Arlington   
-- Create date: 08/02/2018
-- Description: Se quitan los parametros 
--				@GroupAccountMergeComments bit,   
--				@GroupAccountMergeCommentsDifferentParents bit, 
--				@GroupAccountMergeCommentsToOwner bit,   
--				@GroupAccountMergePrivateComments bit,   
--				@GroupAccountFindLastOpenCase bit,   
-- Jira: [ETEL-1752]-[ETEL-1987]
-- ================================================================================
-- Author: Dahyan Puerta 
-- Create date: 01/08/2019
-- Description: Se agrega el campo AllowUserToCreateTags
-- Jira:  [EDIN-23]
-- ================================================================================
-- Author:Janeth Valbuena
-- Create date: 22-01-2020
-- Description: Se agrega el campo GA.GroupAccountEnableButtonXGestor
-- Jira:  EMIN-3872
-- ================================================================================
  
ALTER PROCEDURE [Config].[GroupAccount_u]
  
    @AccountGroupUnique uniqueidentifier,  
    @GroupAccountName nvarchar(200),   
    @GroupAccountStartDate datetime,   
    @GroupAccountEndDate datetime = NULL,
    @GroupAccountOpenCaseSearchTime int,   
    @GroupAccountConvertMessageToCase bit,   
    @GroupAccountReOpenCase bit,   
    @GroupAccountClosedCaseSearchTime int,   
    @GroupAccountReleaseCase bit,   
    @GroupAccountCreateOwnerUniqueCase bit,   
    @GroupAccountModifiedByUserId int,   
    @GroupAccountFindLastClosedCase bit,   
    @GroupAccountReleaseCaseTime int,   
    @StateGroupId INT,
    @ClassificationId INT=NULL,
    @GroupAccountTimeConversation int,  
    @QuickResponseGroupId INT=NULL,
	@AllowUserToCreateTags bit,
	@GroupAccountEnableButtonXGestor bit
    
AS  
BEGIN  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

IF @GroupAccountEndDate IS NOT NULL
	SET @GroupAccountEndDate = dbo.UltimaHoraDia(@GroupAccountEndDate)
  
INSERT INTO  Config.GroupAccountLog  
 (GroupAccountId, GroupAccountName, GroupAccountStartDate, GroupAccountEndDate,   
 GroupAccountCreated, GroupAccountActiveFlag, GroupAccountMergeComments, GroupAccountMergeCommentsDifferentParents,   
 GroupAccountMergeCommentsToOwner, GroupAccountMergePrivateComments, GroupAccountOpenCaseSearchTime,   
 GroupAccountConvertMessageToCase, GroupAccountReOpenCase, GroupAccountClosedCaseSearchTime,   
 GroupAccountReleaseCase, GroupAccountCreateOwnerUniqueCase, GroupAccountModifiedByUserId,   
 GroupAccountModifiedDate, AccountGroupUnique, GroupAccountFindLastOpenCase,   
 GroupAccountFindLastClosedCase, GroupAccountReleaseCaseTime, StateGroupId,ClassificationId, GroupAccountTimeConversation, AccountId, QuickResponseGroupId,
 AllowUserToCreateTags, GroupAccountEnableButtonXGestor)  
SELECT GA.GroupAccountId, GA.GroupAccountName, GA.GroupAccountStartDate,   
GA.GroupAccountEndDate, GA.GroupAccountCreated, GA.GroupAccountActiveFlag, GA.GroupAccountMergeComments,   
GA.GroupAccountMergeCommentsDifferentParents, GA.GroupAccountMergeCommentsToOwner,   
GA.GroupAccountMergePrivateComments, GA.GroupAccountOpenCaseSearchTime, GA.GroupAccountConvertMessageToCase,   
GA.GroupAccountReOpenCase, GA.GroupAccountClosedCaseSearchTime, GA.GroupAccountReleaseCase,   
GA.GroupAccountCreateOwnerUniqueCase, GA.GroupAccountModifiedByUserId, GA.GroupAccountModifiedDate,   
GA.AccountGroupUnique, GA.GroupAccountFindLastOpenCase, GA.GroupAccountFindLastClosedCase,   
GA.GroupAccountReleaseCaseTime, GA.StateGroupId, GA.ClassificationId, GA.GroupAccountTimeConversation, GA.AccountId, GA.QuickResponseGroupId,
GA.AllowUserToCreateTags, GA.GroupAccountEnableButtonXGestor
FROM  Config.GroupAccount GA  
WHERE GA.AccountGroupUnique = @AccountGroupUnique  
  
  
UPDATE Config.GroupAccount  
SET GroupAccountName = @GroupAccountName,   
    GroupAccountStartDate = @GroupAccountStartDate,   
    GroupAccountEndDate = @GroupAccountEndDate,  
    GroupAccountOpenCaseSearchTime = @GroupAccountOpenCaseSearchTime,   
    GroupAccountConvertMessageToCase = @GroupAccountConvertMessageToCase,   
    GroupAccountReOpenCase = @GroupAccountReOpenCase,   
    GroupAccountClosedCaseSearchTime = @GroupAccountClosedCaseSearchTime,   
    GroupAccountReleaseCase = @GroupAccountReleaseCase,   
    GroupAccountCreateOwnerUniqueCase = @GroupAccountCreateOwnerUniqueCase,   
    GroupAccountModifiedByUserId = @GroupAccountModifiedByUserId,   
    GroupAccountFindLastClosedCase = @GroupAccountFindLastClosedCase,   
    GroupAccountReleaseCaseTime = @GroupAccountReleaseCaseTime,   
    StateGroupId = @StateGroupId,  
    GroupAccountModifiedDate = getdate(),
    ClassificationId = @ClassificationId,
    GroupAccountTimeConversation = @GroupAccountTimeConversation,
	QuickResponseGroupId = @QuickResponseGroupId,
	AllowUserToCreateTags = @AllowUserToCreateTags,
	GroupAccountEnableButtonXGestor = @GroupAccountEnableButtonXGestor
WHERE AccountGroupUnique = @AccountGroupUnique  
  
END  
