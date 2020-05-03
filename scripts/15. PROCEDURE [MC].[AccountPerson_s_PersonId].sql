IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[AccountPerson_s_PersonId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[AccountPerson_s_PersonId] AS' 
END
GO
/****** Object:  StoredProcedure [Login].[AccountPerson_s_PersonId]    Script Date: 04/02/2020 12:23:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		yantrossero
-- Create date: 09/05/2017
-- Description:	Obtiene la unidades de negocio asociadas a una persona 
--				que no hayan vencido
-- JIRA:		EOE-1543
-- =============================================
-- Author:		mflosalinas
-- Create date: 19/06/2019
-- Description:	Se crea el sp [Login].[AccountPerson_s_PersonId] apartir del sp [MC].[AccountPerson_s_PersonId]
-- Se agrega sniffing.
-- JIRA:	EDIN-211
-- =============================================
-- Author:		mflosalinas
-- Create date: 04/02/2020
-- Description:	Se agrega el campo AccountPersonDefaultSettings
-- JIRA: EDIN-1467
-- =============================================

ALTER PROCEDURE [MC].[AccountPerson_s_PersonId]

	@PersonId INT

AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @P1PersonId INT
	SET @P1PersonId = @PersonId

	DECLARE @Fecha DATETIME
	SET @Fecha = GETDATE()
    
    SELECT ap.[AccountId], a.AccountName, ap.AccountPersonDefaultSettings 
	FROM [Security].[AccountPerson] ap
	INNER JOIN Config.Account a on a.AccountId = ap.AccountId
	WHERE ([AccountPersonEndDate] IS NULL OR [AccountPersonEndDate] >= @Fecha)
	AND AccountPersonStartDate <= @Fecha
	AND [PersonId] = @P1PersonId

END
