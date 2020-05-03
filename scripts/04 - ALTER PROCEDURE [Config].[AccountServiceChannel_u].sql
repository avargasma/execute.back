IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AccountServiceChannel_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[AccountServiceChannel_u] AS' 
END

GO

-- ================================================================================  
-- Author     : janeth.Valbuena 
-- Create date: 19-12-2019  
-- Description: Actualiza un registro en la tabla AccountServiceChannel
-- JIRA    : ETEL-3878
-- ================================================================================  

ALTER PROCEDURE [Config].[AccountServiceChannel_u]
		@ASCId int out,
		@AccountId int,
		@ServiceChannelId int, 
		@ASCOnlineReports int,
		@ASCTimeForSurvey int, 
		@ASCActiveFlag bit,
		@ASCModifiedByUserId int

AS

DECLARE @pASCId int
DECLARE	@pAccountId int
DECLARE	@pServiceChannelId int 
DECLARE @pASCOnlineReports int
DECLARE @pASCActiveFlag bit
DECLARE	@pASCTimeForSurvey int
DECLARE @pASCModifiedByUserId int

SET @pASCId = @ASCId
SET	@pAccountId = @AccountId
SET	@pServiceChannelId = @ServiceChannelId
SET @pASCOnlineReports = @ASCOnlineReports
SET @pASCModifiedByUserId = @ASCModifiedByUserId
SET @pASCTimeForSurvey = @ASCTimeForSurvey
SET @pASCActiveFlag = @ASCActiveFlag

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	BEGIN TRANSACTION

	INSERT INTO AccountServiceChannelLog
	(
		 [ASCId],
		 [AccountId],
		 [ServiceChannelId],
		 [ASCOnlineReports], 
		 [ASCActiveFlag],
		 [ASCTimeForSurvey],
		 [ASCCreated],
		 [ASCModifiedDate],
		 [ASCModifiedByUserId],
		 [ASCTransactionTypeId]
	)
	SELECT
	a.ASCId,
	a.AccountId,
	a.ServiceChannelId,
	a.ASCOnlineReports,
	a.ASCActiveFlag,
	a.ASCTimeForSurvey,
	a.ASCCreated,
	a.ASCModifiedDate,
	a.ASCModifiedByUserId,
	2
	FROM Config.AccountServiceChannel a
	where a.ASCId = @pASCId
    	
UPDATE AccountServiceChannel
	SET AccountId = @pAccountId,
		ServiceChannelId = @pServiceChannelId,
		ASCOnlineReports = @pASCOnlineReports, 
		ASCActiveFlag = @pASCActiveFlag,
		ASCTimeForSurvey = @pASCTimeForSurvey,
		ASCModifiedDate = GETDATE (),
		ASCModifiedByUserId = @pASCModifiedByUserId 
	WHERE ASCId = @pASCId

	COMMIT TRANSACTION

END