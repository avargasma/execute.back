IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[PreAttendantAnswer_g_ByCPreAttendantQuestionId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Chat].[PreAttendantAnswer_g_ByCPreAttendantQuestionId] AS' 
END
GO

-- =============================================
-- Author:	psosa	
-- Create date: 12/02/2020
-- Description:	busca las preguntas opcionales configuradas para el pre-atendedor por el id de la pregunta
-- Jira: 
-- =============================================
-- Author:	Arlington	
-- Create date: 17/04/2020
-- Description:	Se agrega el order by CPreAttendantAnswerOrden
-- Jira: [EP3C-6027] - [EP3C-6176]
-- =============================================
ALTER PROCEDURE [Chat].[PreAttendantAnswer_g_ByCPreAttendantQuestionId]
@CPreAttendantQuestionId int
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

SELECT * FROM [Chat].[PreAttendantAnswer]
WHERE [CPreAttendantQuestionId] = @CPreAttendantQuestionId
ORDER BY CPreAttendantAnswerOrden

END

