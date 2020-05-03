IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[GroupAccount_i]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[GroupAccount_i] AS' 
END

GO

--------------------------------------------------------------------------------------------  
-- Author     : nsruiz  
-- Create date: 22/04/2014  
-- Description: Inserta un registro en la  GroupAccount  
-- JIRA    : EPN-1330  
--------------------------------------------------------------------------------------------  
-- Author: ggasparini   
-- Create date: 30/05/2014	  
-- Description: Se agrega la insercion del campo ClasificationId  
-- Jira:  EPN-1530  
-- ============================================================================================  
-- Author:   nsruiz	  
-- Create date: 16/06/2014  
-- Description: se hace nuleable el parametro @ClassificationId
-- JIRA:  EPN-1669  
-- ================================================================================
-- Author:   nsruiz	  
-- Create date: 05/05/2016
-- Description: Se registra el nuevo campo GroupAccountTimeConversation
-- JIRA:  EVOLUTION-671   
-- ================================================================================  
-- Author:   nsruiz	  
-- Create date: 15/09/2016
-- Description: Se registra el nuevo campo AccountId
-- JIRA:  EVOLUTION-1450   
-- ================================================================================  
-- Author: nsruiz   
-- Create date: 19/10/2016
-- Description: Se modifica para que se registre la fecha de fin con los milisegundos = 
--              maximo valor de SQL
-- Jira:  EVOLUTION-1679
-- ================================================================================
-- Author: nsruiz   
-- Create date: 24/11/2017
-- Description: Se eliminan parametros @GroupAccountMergeComments, @GroupAccountMergeCommentsDifferentParents ,   
--              @GroupAccountMergeCommentsToOwner, @GroupAccountMergePrivateComments, @GroupAccountFindLastOpenCase
-- Jira:  EOE-4148
-- ================================================================================
-- Author: damramirez   
-- Create date: 19/11/2018
-- Description: Se agrega el campo QuickResponseGroupId
-- Jira:  ETEL-1347
-- ================================================================================
-- Author: Dahyan Puerta 
-- Create date: 01/08/2019
-- Description: Se agrega el campo GA.AllowUserToCreateTags
-- Jira:  [EDIN-23]
-- ================================================================================
-- Author:Janeth Valbuena
-- Create date: 22-01-2020
-- Description: Se agrega el campo GA.GroupAccountEnableButtonXGestor
-- Jira:  EMIN-3872
-- ================================================================================

ALTER PROCEDURE [Config].[GroupAccount_i]
(  
    @GroupAccountId INT OUT,  
    @AccountGroupUnique uniqueidentifier,  
    @GroupAccountName nvarchar(200),   
    @GroupAccountStartDate datetime,   
    @GroupAccountEndDate datetime = NULL,   
    --@GroupAccountMergeComments bit,   
    --@GroupAccountMergeCommentsDifferentParents bit,   
    --@GroupAccountMergeCommentsToOwner bit,   
    --@GroupAccountMergePrivateComments bit,   
    @GroupAccountOpenCaseSearchTime int,   
    @GroupAccountConvertMessageToCase bit,   
    @GroupAccountReOpenCase bit,   
    @GroupAccountClosedCaseSearchTime int,   
    @GroupAccountReleaseCase bit,   
    @GroupAccountCreateOwnerUniqueCase bit,   
    @GroupAccountModifiedByUserId int,   
    --@GroupAccountFindLastOpenCase bit,   
    @GroupAccountFindLastClosedCase bit,   
    @GroupAccountReleaseCaseTime int,   
    @StateGroupId int,  
    @GroupAccountActiveFlag BIT,
    @ClassificationId int  = null,
    @GroupAccountTimeConversation int,
    @AccountId int,
	@QuickResponseGroupId int  = null,
	@AllowUserToCreateTags bit,
	@GroupAccountEnableButtonXGestor bit 
)  
AS  
  
BEGIN  

IF @GroupAccountEndDate IS NOT NULL
	SET @GroupAccountEndDate = dbo.UltimaHoraDia(@GroupAccountEndDate)

 INSERT INTO [Config].[GroupAccount]  
  (AccountGroupUnique,  
   GroupAccountName,   
   GroupAccountStartDate,   
   GroupAccountEndDate,   
   GroupAccountMergeComments,   
   GroupAccountMergeCommentsDifferentParents,   
   GroupAccountMergeCommentsToOwner,   
   GroupAccountMergePrivateComments,   
   GroupAccountOpenCaseSearchTime,   
   GroupAccountConvertMessageToCase,   
   GroupAccountReOpenCase,   
   GroupAccountClosedCaseSearchTime,   
   GroupAccountReleaseCase,   
   GroupAccountCreateOwnerUniqueCase,   
   GroupAccountModifiedByUserId,   
   GroupAccountFindLastOpenCase,   
   GroupAccountFindLastClosedCase,   
   GroupAccountReleaseCaseTime,   
   StateGroupId,  
   GroupAccountActiveFlag,
   ClassificationId,
   GroupAccountTimeConversation,
   AccountId,
   QuickResponseGroupId,
   AllowUserToCreateTags,
   GroupAccountEnableButtonXGestor)  
     VALUES  
   (@AccountGroupUnique,  
   @GroupAccountName,   
   @GroupAccountStartDate,   
   @GroupAccountEndDate,   
   1, --@GroupAccountMergeComments,   
   1, --@GroupAccountMergeCommentsDifferentParents,   
   1, --@GroupAccountMergeCommentsToOwner,   
   1, --@GroupAccountMergePrivateComments,   
   @GroupAccountOpenCaseSearchTime,   
   @GroupAccountConvertMessageToCase,   
   @GroupAccountReOpenCase,   
   @GroupAccountClosedCaseSearchTime,   
   @GroupAccountReleaseCase,   
   @GroupAccountCreateOwnerUniqueCase,   
   @GroupAccountModifiedByUserId,   
   1, --@GroupAccountFindLastOpenCase,   
   @GroupAccountFindLastClosedCase,   
   @GroupAccountReleaseCaseTime,   
   @StateGroupId,  
   @GroupAccountActiveFlag,
   @ClassificationId,
   @GroupAccountTimeConversation,
   @AccountId,
   @QuickResponseGroupId,
   @AllowUserToCreateTags,
   @GroupAccountEnableButtonXGestor)  
  
  SET @GroupAccountId = SCOPE_IDENTITY()  
  
END 
