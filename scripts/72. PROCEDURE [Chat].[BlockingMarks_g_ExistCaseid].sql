IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[BlockingMarks_g_ExistCaseid]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Chat].[BlockingMarks_g_ExistCaseid] AS' 
END

GO

-- =============================================
-- Author:	alvaro.catano   
-- Create date: 24/01/2018
-- Description:	Busca marcas de bloqueo y retorna caso y estado, si el estado del caso es 1 
-- el usuario se encuentra bloqueado por representante.
-- Jira: [ETEC-144] [ETEC-360]
-- =============================================
-- Author:	alvaro.catano   
-- Create date: 18/02/2019
-- Description:	Se cambia @BD para que traiga el nombre de la base de datos
-- Jira: [ETEC-144] [ETEC-360]
-- =============================================
-- Author:	alvaro.catano   
-- Create date: 22/02/2019
-- Description:	Se añade @UserAssigned y @CurrentUser
-- se buscan tanto el representante asignado al caso como el usuario que tiene bloqueado el caso
-- Jira: [ETEC-144] [ETEC-399]
-- =============================================
-- Author:	Arlington   
-- Create date: 18/03/2020
-- Description:	Se modifica el orden de la variable @AttValue, se incluye en la consulta dinamica
-- Jira: [ECEN-44]-[ECEN-47]
-- =============================================
           
ALTER PROCEDURE [Chat].[BlockingMarks_g_ExistCaseid]
 (
	@TableName NVARCHAR(100) = NULL,
	@Attribute NVARCHAR(100) = NULL,
	@CaseId INT,
	@Managing INT OUTPUT,
	@UserAssigned NVARCHAR(100) OUTPUT,
	@CurrentUser NVARCHAR(100) OUTPUT
 )
AS
BEGIN
  DECLARE @SQL NVARCHAR(2000);
  DECLARE @BD NVARCHAR(200) = (SELECT DataBaseName FROM [Config].[DataBase] WHERE DataBaseInternalCode = 4);
 
  SET @BD = @BD + '.[dbo].[BlockingMarks]';

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  DECLARE @PARAM NVARCHAR(MAX) = '
  	@TableName NVARCHAR(100) = NULL,
	@Attribute NVARCHAR(100) = NULL,
	@CaseId INT,
	@Managing INT OUTPUT,
	@UserAssigned NVARCHAR(100) OUTPUT,
	@CurrentUser NVARCHAR(100) OUTPUT
  '

SET @SQL = 'DECLARE @AttValue NVARCHAR(100) = NULL;
		    SET @AttValue = CAST(@CaseId AS NVARCHAR);'

SET @SQL = @SQL + ('
		SELECT  @UserAssigned = u.UserName
		FROM [MC].[Case] c
		INNER JOIN [security].[user] u ON u.userid= c.UserAssignedId
		WHERE caseid = @AttValue');
  SET @SQL = @SQL + ('
	SELECT @Managing = COUNT(bm.AttValue)
	FROM '+ @BD +' bm 
	INNER JOIN [MC].[Case] mc ON bm.AttValue = CAST(mc.CaseId AS NVARCHAR)
	WHERE 
	( @TableName is null or TableName = ''' + @TableName +''')
	AND
	( @Attribute is null or Attribute = ''' + @Attribute +''')
	AND  AttValue = @AttValue');

	SET @SQL = @SQL + ('
	SELECT @CurrentUser = bm.UserName
	FROM '+ @BD +' bm 
	INNER JOIN [MC].[Case] mc ON bm.AttValue = CAST(mc.CaseId AS NVARCHAR)
	WHERE 
	( @TableName is null or TableName = ''' + @TableName +''')
	AND
	( @Attribute is null or Attribute = ''' + @Attribute +''')
	AND  AttValue = @AttValue');

 EXECUTE SP_EXECUTESQL      
		 @SQL,
		 @PARAM,
		 @TableName = @TableName,
		 @Attribute = @Attribute,
		 @CaseId = @CaseId,
		 @Managing = @Managing OUTPUT,
		 @UserAssigned = @UserAssigned OUTPUT,
		 @CurrentUser = @CurrentUser OUTPUT
		 
		 END

