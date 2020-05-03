IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[ConfigPreAttendant_u_ActiveFlag]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Chat].[ConfigPreAttendant_u_ActiveFlag] AS' 
END
GO

-- =============================================
-- Author:	Arlington	
-- Create date: 20/04/2020
-- Description:	Actualiza el estado activo e inactivo de la pregunta configurada en la sala
-- Jira: [EP3C-6027] - [EP3C-6176]
-- =============================================
ALTER PROCEDURE [Chat].[ConfigPreAttendant_u_ActiveFlag]
@pCConfigPreAttendantActiveFlag INT,
@pCConfigPreAttendantId INT

AS
BEGIN

DECLARE
@CConfigPreAttendantActiveFlag INT = @pCConfigPreAttendantActiveFlag,
@CConfigPreAttendantId INT = @pCConfigPreAttendantId

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

UPDATE [Chat].[ConfigPreAttendant]
   SET [CConfigPreAttendantActiveFlag] = @CConfigPreAttendantActiveFlag
 WHERE CConfigPreAttendantId = @CConfigPreAttendantId

END

