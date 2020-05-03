IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AccountServiceChannel_s]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[AccountServiceChannel_s] AS' 
END

GO
-- ================================================================================  
-- Author:  janeth.valbuena         
-- Modified date: 23-12-2019           
-- Description: Se consulta la tabla por AccountServiceChannel.
-- Jira: ETEL-3878
-- ================================================================================      
-- Author:  janeth.valbuena/Yulieth Ospina      
-- Modified date: 22-01-2020           
-- Description: Se realiza inner join con las tablas config.account y config.ServiceChannel
--              Se agrega parametro @AccountId y se modifica WHERE
-- Jira: ETEL-3878
-- ================================================================================  
          
ALTER PROCEDURE [Config].[AccountServiceChannel_s]            
        @ASCActiveFlag BIT = NULL,
		@AccountId int = NULL
		          
AS
BEGIN

SET NOCOUNT ON;   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;          
          
	SELECT
		asch.ASCId,
		asch.AccountId,
		a.AccountName,
		asch.ServiceChannelId, 
		sc.SCName,
		asch.ASCOnlineReports,
		asch.ASCCreated, 
		asch.ASCModifiedDate,
		asch.ASCModifiedByUserId, 
		asch.ASCActiveFlag, 
		asch.ASCTimeForSurvey,		
		U.username
	FROM Config.AccountServiceChannel asch 		
	inner join Config.ServiceChannel sc on sc.ServiceChannelId = asch.ServiceChannelId
	inner join Config.Account a on a.AccountId = asch.AccountId
	inner join [Security].[User] u on u.userid = asch.ASCModifiedByUserId
	WHERE (asch.ASCActiveFlag = @ASCActiveFlag OR @ASCActiveFlag IS NULL)
	and (asch.AccountId = @AccountId)
END

