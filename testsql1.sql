IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_NotasEstudiantesMateria_G]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_NotasEstudiantesMateria_G] AS' 
END
GO
-- =============================================
-- Author:		Arlington
-- Create date: 04-11-2018
-- Description:	Trae las notas de los estudiantes de determinado curso en determinado año y de determinada materia
-- =============================================
-- Author:		Arlington
-- Create date: 16-06-2019
-- Description:	Se agrega logica para manejar las ausencias
-- =============================================
-- Author:		Arlington
-- Create date: 19-06-2019
-- Description:	Se quita join con la tabla adinasistencias
-- =============================================
-- Author:		Arlington
-- Create date: 19-06-2019
-- Description:	test
-- =============================================
ALTER PROCEDURE [dbo].[SP_NotasEstudiantesMateria_G]

	@pIdAñoLectivo INT,
	@pIdCurso INT,
	@pIdMateria INT,
	@pIdMaestro BIGINT		

AS
BEGIN
	
	DECLARE 
	@IdAñoLectivo INT = @pIdAñoLectivo, 
	@IdCurso INT = @pIdCurso,
	@IdMaestro INT = @pIdMaestro,
	@IdMateria BIGINT = @pIdMateria

	SET NOCOUNT ON;

		SELECT MC.Sec AS SecMatCurso, ET.IdTercero, CONCAT(ET.Papellido,' ',ET.Sapellido,' ',ET.Pnombre,' ',ET.Snombre) AS NombreComp 
		, MR.Sec AS IdMateria, MR.NomMateria, MT.Sec AS IdMatricula, P1, 
		(SELECT CantInasistencias 
		FROM ADInasistencia 
		WHERE IdEstudiante = ET.IdTercero 
		AND IdCurso = @IdCurso
		AND IdMateria = @IdMateria
		AND IdPeriodo = 1) AS IAP1, P2, (SELECT CantInasistencias 
		FROM ADInasistencia 
		WHERE IdEstudiante = ET.IdTercero 
		AND IdCurso = @IdCurso
		AND IdMateria = @IdMateria
		AND IdPeriodo = 2) IAP2, P3, (SELECT CantInasistencias 
		FROM ADInasistencia 
		WHERE IdEstudiante = ET.IdTercero
		AND IdCurso = @IdCurso
		AND IdMateria = @IdMateria
		AND IdPeriodo = 3)IAP3, P4, (SELECT CantInasistencias 
		FROM ADInasistencia 
		WHERE IdEstudiante = ET.IdTercero 
		AND IdCurso = @IdCurso
		AND IdMateria = @IdMateria
		AND IdPeriodo = 4)IAP4,  ((P1 + P2 + P3 + P4) / 4) AS Prom   
		FROM ADTerceros ET 
		INNER JOIN ADMatriculas MT ON ET.IdTercero = MT.IdEstudiante AND MT.IdAñoLectivo = @IdAñoLectivo
		INNER JOIN ADCursos CS ON MT.IdCurso = CS.Sec
		INNER JOIN ADMateriasCursos MC ON CS.Sec = MC.IdCurso
		INNER JOIN ADMaterias MR ON MC.IdMateria = MR.Sec
		LEFT JOIN ADNotas NT ON MC.Sec = NT.SecMatCurso AND NT.IdEstudiante = ET.IdTercero AND NT.IdMatricula = MT.Sec
		WHERE CS.Sec = @IdCurso AND MR.Sec = @IdMateria AND MC.IdMaestro = @IdMaestro AND MT.Cancelada = 0 ORDER BY NombreComp
END