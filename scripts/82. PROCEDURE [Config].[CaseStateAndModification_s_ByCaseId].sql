/****** Object:  StoredProcedure [Config].[CaseStateAndModification_s_ByCaseId]    Script Date: 01/04/2020 12:07:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[CaseStateAndModification_s_ByCaseId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[CaseStateAndModification_s_ByCaseId] AS' 
END
GO
-- =============================================
-- Author:		yantrossero
-- Create date: 27/03/2020
-- Description:	EMIN-4422
-- =============================================
ALTER PROCEDURE [Config].[CaseStateAndModification_s_ByCaseId] 
	@CaseId INT
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 

    SELECT
	@CaseId AS CaseId,
	C.[CaseModifiedDate],
	ST.[StateTypeDescrip]
	FROM MC.[Case] C
	LEFT JOIN [Config].[State] S ON C.StateId= S.StateId
	LEFT JOIN [Config].[StateType] ST ON ST.StateTypeId = S.StateTypeId
	WHERE C.CaseId = @CaseId
END
GO
