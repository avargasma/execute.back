/****** Object:  StoredProcedure [MC].[Account_s_AccountList]    Script Date: 05/02/2020 15:18:56 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[Account_s_AccountList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[Account_s_AccountList] AS' 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	mflosalinas
-- Create date: 05/07/2019
-- Description:	obtiene información para la asignación de acuerdo a la cuenta.
-- Jira: EMIN-2532
-- =============================================

ALTER PROCEDURE [MC].[Account_s_AccountList] 

	@AccountList INT

AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @P1AccountList INT
	SET @P1AccountList = @AccountList

	--DECLARE @PAccountList TABLE(AccountId int)    
	--INSERT INTO @PAccountList
	--EXEC [Config].[convertStringToTable] @P1AccountList

	SELECT a.AccountId,a.AccountName, act.AssigmentCaseTypeInternalCode,act.AssigmentCaseTypeName
	FROM Config.Account a
	INNER JOIN [Config].[AssigmentCaseType] act ON act.AssigmentCaseTypeId = a.AssigmentCaseTypeId
	WHERE a.AccountId = @P1AccountList
	--ORDER BY a.AccountId

END
