/****** Object:  StoredProcedure [MC].[AccountOutputChannelTypeDetail_s_ByParams]    Script Date: 21/11/2019 12:13:15 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[AccountOutputChannelTypeDetail_s_ByParams]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[AccountOutputChannelTypeDetail_s_ByParams] AS' 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	mflosalinas
-- Create date: 09/02/2018
-- Description:	Busca los tipos de extensión configuradas por grupo de cuenta y elemento
-- Jira: ETEL-235
-- =============================================
-- Author: yantrossero    
-- Create date: 28/11/2019    
-- Description: en la cláusula WHERE se agrega el filtro "AND aoctd.[AOCTDetailActiveFlag] = 1"
-- Jira: [EPBC-744]    
-- =============================================   
-- Author:	mflosalinas
-- Create date: 29/11/2019
-- Description:	Se agrega el parámetro @AccountOutputChannelTypeId y si tiene valor se busca por ese valor.
-- Jira: EPAC-448
-- =============================================

ALTER PROCEDURE [MC].[AccountOutputChannelTypeDetail_s_ByParams]

@GroupAccountId INT = NULL,    
@ElementTypeId INT = NULL,
@AccountOutputChannelTypeId INT = NULL 

AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQL NVARCHAR(MAX),
	@PARMDEFINITION NVARCHAR(MAX),
	@AccountOutputChannelTypeActiveFlag BIT,
	@AOCTDetailActiveFlag BIT


	SET @AccountOutputChannelTypeActiveFlag = 1
	SET @AOCTDetailActiveFlag = 1

	SET @PARMDEFINITION = N' @PGroupAccountId INT,    
	@PElementTypeId INT,
	@PAccountOutputChannelTypeId INT,
	@PAccountOutputChannelTypeActiveFlag BIT,
	@PAOCTDetailActiveFlag BIT'

SET @SQL = N'
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT
	aoct.ElementTypeId,
	aoct.ElementTypeOutputId,
	ff.FileFormatExtension,
	aoctd.FileSize,
	ff.MediaTypeId,
	etmc.MediaCategory
	FROM [Config].[AccountOutputChannelType] aoct
	INNER JOIN [Config].[AccountOutputChannelTypeDetail] aoctd on aoctd.AccountOutputChannelTypeId = aoct.AccountOutputChannelTypeId 
	LEFT JOIN [Config].[FileFormat] ff ON ff.FileFormatId = aoctd.FileFormatId
	LEFT JOIN [Config].[ElementTypeMediaCategory] etmc on etmc.ElementTypeId = aoct.ElementTypeOutputId and etmc.ElementTypeMediaCategoryId = aoctd.ElementTypeMediaCategoryId
	WHERE aoct.AccountOutputChannelTypeActiveFlag = @PAccountOutputChannelTypeActiveFlag
	AND aoctd.[AOCTDetailActiveFlag] = @PAOCTDetailActiveFlag'
	

IF (@AccountOutputChannelTypeId IS NOT NULL)
BEGIN

	SET @SQL = @SQL + '	AND aoctd.AccountOutputChannelTypeId = @PAccountOutputChannelTypeId'

END

	SET @SQL = @SQL + '	AND aoct.GroupAccountId = @PGroupAccountId
	AND aoct.ElementTypeId = @PElementTypeId'

 EXECUTE SP_EXECUTESQL              
 @SQL,              
 @PARMDEFINITION, 
 @PGroupAccountId = @GroupAccountId,
 @PElementTypeId = @ElementTypeId,
 @PAccountOutputChannelTypeActiveFlag = @AccountOutputChannelTypeActiveFlag,
 @PAccountOutputChannelTypeId = @AccountOutputChannelTypeId,
 @PAOCTDetailActiveFlag = @AOCTDetailActiveFlag	



END
