IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[PublicationErrors_s_PublicationErrorId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[PublicationErrors_s_PublicationErrorId] AS' 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	mflosalinas
-- Create date: 14/02/2020
-- Description:	Se buscan los datos de error de publicación apartir de un Identificador
-- Jira: EDIN-1511
-- =============================================

ALTER PROCEDURE [MC].[PublicationErrors_s_PublicationErrorId]

@PublicationErrorId INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT [PublicationErrorId]
		  ,[PublicationErrorName]
		  ,[PublicationErrorDescription]
		  ,[PChannelType]
		  ,[PEAlertedByService]
		  ,[PEAlertedBySQL]
		  ,[PECreatedDate]
		  ,[PEContinueToNextContact]
		  ,[PEServiceCycleCancel]
	 FROM [MC].[PublicationErrors]
	 WHERE [PublicationErrorId] = @PublicationErrorId

END
GO
