IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[CaseComment_s_LastCommentByConversationId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[CaseComment_s_LastCommentByConversationId] AS' 
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- =============================================  
-- Author: janeth.valbuena  
-- Create date: 04/03/2020  
-- Description: Se obtiene la fecha del  último comentario de un usuario por conversacion.  
-- Jira: EONC-601 
-- =============================================   
-- Author: janeth.valbuena  
-- Create date: 19/03/2020  
-- Description: se comenta el ingreso del parametro @ElementTypeOutput con su condicion
-- Jira: EONC-601 
-- =============================================   
  
ALTER PROCEDURE [MC].[CaseComment_s_LastCommentByConversationId]
(
	@ConversationId INT
	-- @ElementTypeOutput bit
)
AS
BEGIN

	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @PConversationId INT = @ConversationId
		--	@PElementTypeOutput bit = @ElementTypeOutput

	SELECT cc.UserChannelId,cc.AccountDetailId, MAX (cc.CaseCommentCreated) AS FechaUltimoComment, et.ElementTypeOutput
	FROM mc.CaseComment cc    
	INNER JOIN MC.[Case] c 
		ON c.CaseId = cc.CaseId  
	INNER JOIN mc.ElementType et 
		ON cc.ElementTypeId = et.ElementTypeId  
	WHERE c.ConversationId = @PConversationId
--	AND et.ElementTypeOutput = @PElementTypeOutput
	GROUP BY cc.UserChannelId, cc.AccountDetailId, et.ElementTypeOutput

END