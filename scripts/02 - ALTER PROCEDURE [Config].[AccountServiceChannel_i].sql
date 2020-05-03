IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AccountServiceChannel_i]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[AccountServiceChannel_i] AS' 
END

GO

-- ================================================================================
-- Author : janeth.Valbuena
-- Create date: 19-12-2019
-- Description: Inserta un registro en la tabla AccountServiceChannel
-- JIRA : ETEL-3878
-- ================================================================================

ALTER PROCEDURE [Config].[AccountServiceChannel_i]
@ASCId int out,
@AccountId int,
@ServiceChannelId int,
@ASCOnlineReports int,
@ASCActiveFlag bit,
@ASCTimeForSurvey int = null,
@ASCModifiedByUserId int

AS

DECLARE @pASCId int
DECLARE @pAccountId int
DECLARE @pServiceChannelId int
DECLARE @pASCOnlineReports int
DECLARE @pASCActiveFlag bit
DECLARE @pASCTimeForSurvey int
DECLARE @pASCModifiedByUserId int

SET @pAccountId = @AccountId
SET @pServiceChannelId = @ServiceChannelId
SET @pASCOnlineReports = @ASCOnlineReports
SET @pASCModifiedByUserId = @ASCModifiedByUserId
SET @pASCTimeForSurvey = @ASCTimeForSurvey
SET @pASCActiveFlag = @ASCActiveFlag

BEGIN
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRANSACTION

INSERT INTO AccountServiceChannel
(
[AccountId],
[ServiceChannelId],
[ASCOnlineReports],
[ASCActiveFlag],
[ASCTimeForSurvey],
[ASCCreated],
[ASCModifiedDate],
[ASCModifiedByUserId]
)
VALUES
(
@pAccountId,
@pServiceChannelId,
@pASCOnlineReports,
@pASCActiveFlag,
@pASCTimeForSurvey,
GETDATE (),
GETDATE (),
@pASCModifiedByUserId
)

SET @ASCId = SCOPE_IDENTITY()
SET @pASCId = @ASCId


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
VALUES
(
@pASCId,
@pAccountId,
@pServiceChannelId,
@pASCOnlineReports,
@pASCActiveFlag,
@pASCTimeForSurvey,
GETDATE (),
GETDATE (),
@pASCModifiedByUserId,
1
)
COMMIT TRANSACTION

END