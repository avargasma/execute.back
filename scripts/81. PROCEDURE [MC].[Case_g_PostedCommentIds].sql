IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[Case_g_PostedCommentIds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[Case_g_PostedCommentIds] AS' 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		yantrossero
-- Create date: 19/09/2016
-- Description:	Trae los CaseCommentsId de los comentarios salientes publicados
-- JIRA:		EVOLUTION-1391
-- =============================================
-- Author:	mflosalinas
-- Create date: 27/03/2020
-- Description:	Se agrega campo ReplyToCaseCommentId
-- JIRA:	EPAC-180
-- =============================================

ALTER PROCEDURE [MC].[Case_g_PostedCommentIds]
	@CaseId INT
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON;

	DECLARE @P1CaseId INT
	SET @P1CaseId = @CaseId
	
	SELECT cc.CaseCommentId,cc.ReplyToCaseCommentId, cc.CaseCommentGUID
	INTO #ComentariosCaso
	FROM [MC].[CaseComment] cc
	INNER JOIN MC.ElementType et ON et.ElementTypeId = cc.ElementTypeId AND et.ElementTypeOutput = 1
	WHERE cc.CaseId = @P1CaseId 
		
	SELECT coc.CaseCommentId, p.PublicationDate
	FROM #ComentariosCaso coc
	INNER JOIN [MC].[Publication] p ON p.CaseCommentGUID = coc.CaseCommentGUID
	WHERE p.PublicationDate IS NOT NULL

	SELECT coc.CaseCommentId, coc.ReplyToCaseCommentId
	FROM #ComentariosCaso coc

END

