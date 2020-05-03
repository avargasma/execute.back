IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[GroupAccountDetail_s_ByGroupAccountId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[GroupAccountDetail_s_ByGroupAccountId] AS' 
END

GO
  
-- ============================================================================================      
-- Author: ggasparini       
-- Create date: 27/05/2014      
-- Description: Se obtiene las cuentas asociadas a un grupo      
-- Jira:  EPN-1530      
-- ============================================================================================      
-- Author: ggasparini       
-- Create date: 20/08/2014      
-- Description: Se agrega el filtro de detalle de cuentas activa      
-- Jira:  EPN-1901      
-- ============================================================================================  
-- Author: nsruiz        
-- Create date: 30/03/2016      
-- Description: Se agrega a IF (@GADActiveFlag IS NULL) en los resultados de la consulta  
--              las columnas ServiceChannelAccountId, SCInternalCodeAccount y GADActiveFlag  
-- Jira:  EVOLUTION-505     
-- ============================================================================================   
-- Author: nsruiz        
-- Create date: 22/08/2016      
-- Description: se agregan las columnas gad.GADStartDate y gad.GADEndDate   
--              Se elimina parámetro @GADActiveFlag   
-- Jira:  EVOLUTION-1299   
-- ============================================================================================  
-- Author:   abarrios  
-- Create date: 27/11/2017  
-- Description: se agregan columnas AccountDetailOutput y AccountDetailInput  
-- JIRA:  EOE-4092  
-- ============================================================================================  
-- Author:   janeth.valbuena  
-- Create date: 04-02-2020  
-- Description: Se realiza join con las tablas MC.CaseType y MC.CaseTypeAccountDetail para mostrar las cuentas
--              configuradas con casos salientes.  
-- Jira:  EP3C-5342 
-- ============================================================================================  
-- Author:   janeth.valbuena  
-- Create date: 10-02-2020  
-- Description: se agrega la condicion ctad.CTADActiveFlag = 1  en el left join con la tabla MC.CaseTypeAccountDetail
-- Jira:  EP3C-5342 
-- ============================================================================================  
 
      
ALTER PROCEDURE [Config].[GroupAccountDetail_s_ByGroupAccountId]       
      
@GroupAccountId INT  
--,      
--@GADActiveFlag BIT=NULL      
      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED       
      
--IF (@GADActiveFlag IS NULL)      
BEGIN      
 SELECT ad.AccountDetailId, ad.AccountDetailUnique, ad.AccountDetailDescrip,      
     ad.AccountDetailActiveFlag, sc.ServiceChannelId AS ServiceChannelAccountId, sc.SCName, sc.SCInternalCode AS SCInternalCodeAccount,  
     gad.GADActiveFlag, gad.GADId, gad.GADStartDate, gad.GADEndDate, ad.AccountDetailOutput, ad.AccountDetailInput, ctad.CaseTypeId,
	 ct.CaseTypeName, ctad.CTADActiveFlag  
 FROM Config.GroupAccountDetail gad      
 INNER JOIN Config.AccountDetail ad ON ad.AccountDetailId = gad.AccountDetailId      
 INNER JOIN Config.ServiceChannel sc ON AD.ServiceChannelId=SC.ServiceChannelId   
 LEFT JOIN MC.CaseTypeAccountDetail ctad ON ctad.AccountDetailId = AD.AccountDetailId  and ctad.CTADActiveFlag = 1 -- EP3C-5342 
 LEFT JOIN MC.CaseType ct ON ct.CaseTypeId = ctad.CaseTypeId -- EP3C-5342 
 WHERE (gad.GroupAccountId=@GroupAccountId)
END      
--ELSE      
--BEGIN      
-- SELECT ad.AccountDetailId, ad.AccountDetailUnique, ad.AccountDetailDescrip,      
-- ad.AccountDetailActiveFlag, sc.ServiceChannelId AS ServiceChannelAccountId,sc.SCName, sc.SCInternalCode AS SCInternalCodeAccount,  
-- gad.GADActiveFlag, gad.GADId, gad.GADStartDate, gad.GADEndDate       
-- FROM Config.GroupAccountDetail gad      
-- INNER JOIN Config.AccountDetail ad ON ad.AccountDetailId = gad.AccountDetailId AND gad.GADDefaultOutput=1     
-- INNER JOIN Config.ServiceChannel sc ON AD.ServiceChannelId=SC.ServiceChannelId      
-- INNER JOIN config.GroupAccount ga ON ga.GroupAccountId = gad.GroupAccountId  
-- WHERE gad.GroupAccountId=@GroupAccountId      
         
--END     