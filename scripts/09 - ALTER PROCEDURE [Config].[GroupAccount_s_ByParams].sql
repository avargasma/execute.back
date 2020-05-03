IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[GroupAccount_s_ByParams]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[GroupAccount_s_ByParams] AS' 
END

GO

-- ============================================================================================      
-- Author: nsruiz       
-- Create date: 15/04/2014      
-- Description: Obtiene grupos y sus cuentas      
-- Jira:  EPN-1330      
-- ============================================================================================      
-- Author: ggasparini       
-- Create date: 30/05/2014       
-- Description: Se agrega la obtencion del campo ClasificationId      
-- Jira:  EPN-1530      
-- ============================================================================================      
-- Author:  ggasparini     
-- Modified date: 25/06/2014    
-- Description: Se agrega el filtro por cuenta (@AccountId).  
-- Por el momento el parametro @userID no se usa, pero se deja indicado para luego   
-- buscar los tipos de cuentas a los cuales tiene permiso el usuario loggeado.    
-- Jira: EPN-1704    
-- ================================================================================    
-- Author:  nsruiz      
-- Modified date: 16/09/2014    
-- Description: Se ponen = NULL a los parámetros que pueden venir en nulo  
-- Jira: EPN-2008    
-- ================================================================================  
-- Author:  nsruiz      
-- Modified date: 05/05/2016  
-- Description: Se agrega a los resultados el campo GroupAccountTimeConversation  
-- Jira: EVOLUTION-671    
-- ================================================================================   
-- Author: nsruiz     
-- Create date: 18/08/2016  
-- Description: Se agrega a la consulta las columnas GAD.GADStartDate y GAD.GADEndDate, y se  
--              cambia el nombre del parametro @GADActiveFlag y @GroupAccountActiveFlag  
--              por @CuentasVigentes y @GruposVigentes ya que la vigencia  
--              se va determinar por las fechas desde y hasta   
--              Se modifica condicion de Grupo Vigente: que su periodo comprenda la fecha actual  
--              Se separan los SELECT para cada combinacion de @CuentasVigentes y @GruposVigentes  
-- Jira:  EVOLUTION-1299  
-- ============================================================================================    
-- Author: nsruiz     
-- Create date: 15/09/2016  
-- Description: Se modifica el filtro por @AccountId, aplicando a la tabla GroupAccount en vez de AccountDetail  
-- Jira:  EVOLUTION-1450  
-- ============================================================================================  
-- Author: i33389229 Mariano Cordoba  
-- Modified date: 18/01/2016  
-- Description: Se convierte el Sp a cadena.  
-- Jira: EOE-416  
-- ================================================================================
-- Author: abarrios  
-- Modified date: 21/11/2017  
-- Description: Se agrega al select los campos AccountDetailInput y AccountDetailOutput  
-- Jira: EOE-4092  
-- ================================================================================
-- Author: david.atehortua  
-- Modified date: 25/01/2019  
-- Description: Se agrega al select el campo SCInternalCode
-- Jira: ETEL-1577 
-- ================================================================================
-- Author: Dahyan Puerta 
-- Create date: 01/08/2019
-- Description: Se agrega el campo GA.AllowUserToCreateTags
-- Jira:  [EDIN-23]
-- ================================================================================
-- Author:Janeth Valbuena
-- Create date: 22-01-2020
-- Description: Se agrega el campo GA.GroupAccountEnableButtonXGestor
-- Jira:  EMIN-3872
-- ================================================================================

ALTER PROCEDURE [Config].[GroupAccount_s_ByParams]
      
@GroupAccountName NVARCHAR(MAX) = NULL,      
@AccountDetailDescrip VARCHAR(200) = NULL,      
--@GroupAccountActiveFlag BIT = NULL,       
@GruposVigentes bit = NULL,  
--@GADActiveFlag BIT = NULL,  
@CuentasVigentes BIT = NULL,  
@AccountId INT,  
@UserId INT = NULL  
      
     
AS   
BEGIN

DECLARE @SqlStr NVARCHAR(MAX)
DECLARE @PRE NVARCHAR(MAX)
DECLARE @SQL NVARCHAR (max)  
DECLARE @PARAMDEFINITION NVARCHAR(500)    

	SET @PRE =    'SET NOCOUNT ON;
			       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;'

	SET @SQL = N'SELECT GA.GroupAccountId,       
	 GA.GroupAccountName,       
	 GA.GroupAccountStartDate,       
	 GA.GroupAccountEndDate,       
	 GA.GroupAccountActiveFlag,       
	 GA.GroupAccountMergeComments,       
	 GA.GroupAccountMergeCommentsDifferentParents,       
	 GA.GroupAccountMergeCommentsToOwner,       
	 GA.GroupAccountMergePrivateComments,       
	 GA.GroupAccountOpenCaseSearchTime,       
	 GA.GroupAccountConvertMessageToCase,       
	 GA.GroupAccountReOpenCase,       
	 GA.GroupAccountClosedCaseSearchTime,       
	 GA.GroupAccountReleaseCase,       
	 GA.GroupAccountCreateOwnerUniqueCase,       
	 GA.GroupAccountModifiedByUserId,       
	 GA.GroupAccountModifiedDate,       
	 AccountGroupUnique,       
	 GA.GroupAccountFindLastOpenCase,       
	 GA.GroupAccountFindLastClosedCase,       
	 GA.GroupAccountReleaseCaseTime,      
	 GA.StateGroupId,      
	 SG.StateGroupName,      
	 U.UserName as GroupUserName,      
	 GAD.GADId,       
	 GAD.GADActiveFlag,      
	 AD.AccountDetailId,       
	 AD.AccountDetailUnique,       
	 AD.AccountDetailDescrip,       
	 AD.AccountDetailActiveFlag,       
	 AD.ServiceChannelId,       
	 SC.SCName,
	 SC.SCInternalCode,    
	 GA.ClassificationId,    
	 c.ClassificationName,  
	 GA.GroupAccountClosedCaseSearchTime ,  
	 GA.GroupAccountTimeConversation,  
	 GAD.GADStartDate,  
	 GAD.GADEndDate,  
	 AD.AccountDetailInput,  
	 AD.AccountDetailOutput,
	 GA.AllowUserToCreateTags,
	 GA.GroupAccountEnableButtonXGestor
	 FROM  Config.GroupAccount GA      
	 INNER JOIN Config.GroupAccountDetail GAD ON GAD.GroupAccountId = GA.GroupAccountId      
	 INNER JOIN Config.AccountDetail AD ON AD.AccountDetailId = GAD.AccountDetailId      
	 INNER JOIN Config.ServiceChannel SC ON SC.ServiceChannelId = AD.ServiceChannelId      
	 INNER JOIN [Security].[User] U ON U.UserId = GA.GroupAccountModifiedByUserId      
	 LEFT JOIN Config.StateGroup SG ON SG.StateGroupId = GA.StateGroupId      
	 LEFT JOIN config.Classification c ON ga.ClassificationId=c.ClassificationId    
	 WHERE (GA.GroupAccountName like ''%'' + @GroupAccountName + ''%'' or @GroupAccountName is null) '  
  
  
IF @GruposVigentes = 1 AND @CuentasVigentes = 1  
 BEGIN  
  SET @SQL = @SQL + ' AND (AD.AccountDetailDescrip like ''%'' + @AccountDetailDescrip + ''%'' or @AccountDetailDescrip is null)      
       AND (GA.GroupAccountStartDate <= getdate() AND (GA.GroupAccountEndDate >= getdate() OR GA.GroupAccountEndDate IS NULL))   --grupo vigente   
       AND (GAD.GADStartDate <= getdate() AND (GAD.GADEndDate >= getdate() OR GAD.GADEndDate IS NULL)) --cuenta vigente  
       AND AD.AccountDetailActiveFlag = 1      
       AND GA.AccountId=@AccountId  
       ORDER BY GA.GroupAccountName '  
 END  
ELSE  
 BEGIN  
  IF @GruposVigentes IS NULL AND @CuentasVigentes IS NULL  
   BEGIN  
    SET @SQL = @SQL + '      
         AND (AD.AccountDetailDescrip like ''%'' + @AccountDetailDescrip + ''%'' or @AccountDetailDescrip is null)         
         AND AD.AccountDetailActiveFlag = 1      
         AND GA.AccountId=@AccountId  
         ORDER BY GA.GroupAccountName'  
   END  
  ELSE  
   BEGIN  
    IF @GruposVigentes = 1 AND @CuentasVigentes IS null  
     BEGIN  
      SET @SQL = @SQL + ' AND (AD.AccountDetailDescrip like ''%'' + @AccountDetailDescrip + ''%'' or @AccountDetailDescrip is null)      
           AND (GA.GroupAccountStartDate <= getdate() AND (GA.GroupAccountEndDate >= getdate() OR GA.GroupAccountEndDate IS NULL))   --grupo vigente   
           AND AD.AccountDetailActiveFlag = 1      
           AND GA.AccountId=@AccountId  
           ORDER BY GA.GroupAccountName  '  
     END  
    ELSE  
     BEGIN  
      IF @GruposVigentes IS NULL AND @CuentasVigentes = 1  
       BEGIN  
        SET @SQL = @SQL + ' AND (AD.AccountDetailDescrip like ''%'' + @AccountDetailDescrip + ''%'' or @AccountDetailDescrip is null)      
             AND (GAD.GADStartDate <= getdate() AND (GAD.GADEndDate >= getdate() OR GAD.GADEndDate IS NULL)) --cuenta vigente  
             AND AD.AccountDetailActiveFlag = 1      
             AND GA.AccountId=@AccountId  
             ORDER BY GA.GroupAccountName  '  
       END  
     END  
   END   
 END  
   
 PRINT @SQL  
 SET @SqlStr =  @PRE + @SQL

SET @PARAMDEFINITION  = N'@GroupAccountName NVARCHAR(MAX),      
      @AccountDetailDescrip VARCHAR(200),          
      @GruposVigentes bit,  
      @CuentasVigentes BIT,  
      @AccountId INT,  
      @UserId INT'  
  
  
EXECUTE sp_executesql   
@SqlStr,  
@PARAMDEFINITION,  
@GroupAccountName = @GroupAccountName,  
@AccountDetailDescrip = @AccountDetailDescrip,     
@GruposVigentes = @GruposVigentes,  
@CuentasVigentes = @CuentasVigentes,  
@AccountId = @AccountId,  
@UserId = @UserId  
  
  
END
