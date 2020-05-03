IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[PreAttendantQuestion_g_ByCConfigId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Chat].[PreAttendantQuestion_g_ByCConfigId] AS' 
END
GO
-- =============================================
-- Author:	psosa	
-- Create date: 15/10/2019
-- Description:	busca las preguntas configuradas para el pre-atendedor por sala sin filtro por desactivacion
-- Jira: 
-- =============================================
-- Author:	Arlington	
-- Create date: 20/04/2020
-- Description:	Se agrega el campo CConfigPreAttendantId
-- Jira: [EP3C-6027] - [EP3C-6176]
-- =============================================
ALTER PROCEDURE [Chat].[PreAttendantQuestion_g_ByCConfigId]
@CConfigId int
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

SELECT cpa.*,
cp.CConfigPreAttendantActiveFlag as ActiveFlag,
cp.CConfigPreAttendantId
FROM [Chat].[ConfigPreAttendant] cp
INNER JOIN [Chat].[PreAttendantQuestion] cpa ON cpa.[CPreAttendantQuestionId] = cp.[CPreAttendantQuestionId]
where cp.CConfigId = @CConfigId 

END

