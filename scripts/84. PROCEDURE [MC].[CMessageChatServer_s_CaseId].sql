IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[CMessageChatServer_s_CaseId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[CMessageChatServer_s_CaseId] AS' 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: mflosalinas
-- Create date: 19-03-2020
-- Description:	Se obtiene la url del servidor de chat
-- Jira: emin-3267
-- =============================================

ALTER PROCEDURE [MC].[CMessageChatServer_s_CaseId]

	@CaseId INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @p1CaseId INT
	SET @p1CaseId = @CaseId

    -- Insert statements for procedure here
	SELECT m.CMessageChatServer
	FROM Chat.[Message] m
	WHERE m.CaseIdCreation = @p1CaseId 

END
GO
