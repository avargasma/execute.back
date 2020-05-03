IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[Case_g_CommentError]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[Case_g_CommentError] AS' 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	mflosalinas
-- Create date: 13/03/2020
-- Description:	Trae los comentarios que tienen error
-- JIRA: EDIN-1578
-- =============================================

ALTER PROCEDURE [MC].[Case_g_CommentError]
	@CaseId INT
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON;
	
	SELECT cc.CaseCommentId, p.[PRetriesQuantity], p.PublicationErrorId
	FROM [MC].[CaseComment] cc	
	INNER JOIN [MC].[Publication] p ON p.CaseCommentGUID = cc.CaseCommentGUID
	INNER JOIN [MC].[ElementType] et ON cc.ElementTypeId = et.ElementTypeId 
	WHERE cc.CaseId = @CaseId AND et.ElementTypeOutput = 1 AND p.PublicationDate IS NULL
END

