IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[Message_i]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Chat].[Message_i] AS' 
END
GO

/****** Object:  StoredProcedure [Chat].[Message_i]    Script Date: 25/03/2020 9:27:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================
-- Author:		ggasparini
-- Modified date: 24/08/2016
-- Description:	se inserta un nuevo mensaje de  chat
-- Jira: EVOLUTION-1327
-- ================================================================================
-- Author:		psosa
-- Modified date: 01/02/2018
-- Description:	se agrega campo ReasonConsultationId para tener el motivo de la consulta
-- Jira: EPTEL-52
-- ================================================================================
-- Author:	mflosalinas
-- Modified date: 25/03/2020
-- Description:	se agrega la obtención de la url del chat server
-- Jira: EMIN-4444
-- ================================================================================

ALTER PROCEDURE [Chat].[Message_i] 
	@CMessageId int OUTPUT,
	@CMessage nvarchar(max),
    @CConfigId int,
    @CStatusInternalCode int,
    @CUserId int,
    @CMessageSocket nvarchar(max),
    @AccountDetailUnique uniqueidentifier,
    @ReasonConsultationId int = NULL,
	@DerivationRoomId int = NULL

AS 

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @CStatusId int
SELECT @CStatusId = s.CStatusId
FROM Chat.Status s 
WHERE s.CStatusInternalCode=@CStatusInternalCode

DECLARE @ChatServer NVARCHAR(256)

IF (@DerivationRoomId IS NULL)

	BEGIN 

	SET @ChatServer = (SELECT AccountChatServer 
					  FROM [Config].[Account] a 
					  INNER JOIN Chat.Config c ON c.AccountId = a.AccountId
					  WHERE c.CConfigGuid = @AccountDetailUnique)

	END

IF (@DerivationRoomId IS NOT NULL)

	BEGIN 

	SET @ChatServer = (SELECT DerivationRoomChatServer  
					   FROM  [Chat].[DerivationRoom] 
					   WHERE DerivationRoomId = @DerivationRoomId)

	END

INSERT INTO chat.Message
(
    CMessage,
    CMessageCreationDate,
    CConfigId,
    CStatusId,
    CUserId,
    CMessageSocket,
    AccountDetailUnique,
    ReasonConsultationId,
	CMessageChatServer
)
VALUES
(
    @CMessage,
    getdate(),
    @CConfigId,
    @CStatusId,
    @CUserId,
    @CMessageSocket,
    @AccountDetailUnique,
    @ReasonConsultationId,
	@ChatServer
)

Set @CMessageId = SCOPE_IDENTITY()

end
