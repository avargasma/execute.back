IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[CaseComment_s_ByCUserGUID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Chat].[CaseComment_s_ByCUserGUID] AS' 
END
GO

-- ================================================================================    
-- Author: mflosalinas    
-- Modified date: 26/06/2018 
-- Description: se buscan los casos por usuarios y se obtienen los comentarios de todos los casos encontrados
-- Jira: EP3C-1738  
-- ================================================================================ 
-- Author: yantrossero    
-- Modified date: 04/10/2018
-- Description: Se permite filtrar por comentario y se dinamiza la consulta
-- Jira: EPRE-1055
-- ================================================================================ 
-- Author:  psosa     
-- Modified date: 30/10/2018 
-- Description: para poder verificar si el comentario es automatico o no se agrega la columna CaseCommentAutomatic
-- Jira: 
-- ================================================================================ 
-- Author:  yantrossero     
-- Modified date: 05/11/2018 
-- Description: Si el campo UCName es vacío o null, muestra el UCUserName
-- Jira: EPRE-1136
-- ================================================================================ 
-- Author:  Arlington
-- Modified date: 11/09/2019 
-- Description: Se agrega el campo ActionTypeCode
-- Jira: ETEC-722 - ETEC-869
-- ================================================================================
-- Author:  Arlington
-- Modified date: 19/09/2019 
-- Description: Se agrega JOIN con [Chat].[V_ActionTypeCommentNoShow] para no mostrar los mensajes 
--				con determinado ActionTypeCode
-- Jira: ETEC-722 - ETEC-869
-- ================================================================================ 
-- Author:  Arlington
-- Modified date: 27/11/2019 
-- Description: Mejora de Performance
-- Jira: EP3C-5387 - EP3C-5696
-- ================================================================================ 
-- Author:  Arlington
-- Modified date: 29/04/2020
-- Description: Se modifica la consulta de UCName
-- Jira: [1702]-[ETRY-1706]
-- ================================================================================ 

ALTER PROCEDURE [Chat].[CaseComment_s_ByCUserGUID]
    
@CUserGUID uniqueidentifier,
@CConfigGUID uniqueidentifier,
@CPattern varchar(max) = NULL

AS     

    
BEGIN    
    
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

Declare @Sql nvarchar(max)
Declare @Params nvarchar(2000)



Set @Sql = '
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

Declare @AccountId int
set @AccountId = (Select AccountId from [Config].[AccountDetail] where AccountDetailUnique = @CConfigGUID)

declare @UserChannelId int 
set @UserChannelId = (select uc.UserChannelId from mc.UserChannel uc
					  inner join mc.UserChannelAccount uca on uca.UserChannelId = uc.UserChannelId
					  where SourceUserId = cast(@CUserGUID as varchar(250)) and uca.AccountId = @AccountId)

;WITH
MCCase (CaseId, UserAssignedId) AS 
(
	SELECT C.CaseId, C.UserAssignedId FROM MC.[Case] C
	INNER JOIN Config.AccountDetail  AD ON AD.AccountDetailId = C.AccountDetailId
	WHERE UserChannelId = @UserChannelId AND ad.AccountId = @AccountId
),
MCCaseComment AS 
(
	SELECT
	 CC.Caseid
	,CC.CaseCommentId
	,CC.CaseCommentText
	,CC.UserChannelId
	,CC.AccountDetailId
	,CC.CaseCommentCreated
	,CC.CaseCommentModifiedByUserId
	,CC.ElementId
	,CC.ElementTypeId
	,CC.CaseCommentPublicationTo
	,CC.CaseCommentGUID
	,CC.ActionTypeCode
	,CC.ProcessDetailsId
	,CC.CaseCommentAutomatic
	FROM MC.CaseComment CC
	INNER JOIN MCCase C ON C.CaseId = CC.CaseId'

IF @CPattern IS NOT NULL AND RTRIM(LTRIM(@CPattern)) <> ''
BEGIN
	Set @Sql = @Sql + ' WHERE CC.CaseCommentText LIKE  ''%' + @CPattern + '%'' '
END

Set @Sql = @Sql + ')'

Set @Sql = @Sql + '
SELECT 
	CC.Caseid
	,CC.CaseCommentId
	,CC.CaseCommentText
	,CC.UserChannelId
	,ISNULL(NULLIF(co.CConfigUserName, ''''), uc.UCName) as UCName
	,ISNULL(NULLIF(CO.CConfigUserName,''''),UC.UCUserName) as UCUserName
	,UCA.ClientId
	,UC.ServiceChannelId
	,UC.UCPublicationTo
	,CC.AccountDetailId
	,CC.CaseCommentCreated
	,CC.CaseCommentModifiedByUserId
	,CC.ElementId, CC.ElementTypeId
	,CC.CaseCommentPublicationTo
	,ET.PChannelType
	,ET.ElementTypePublic
	,ET.ElementTypeOutput
	,ET.ServiceChannelId
	,DCC.DCCSubject
	,SC.SCName
	,u.UserName
	,p.PublicationDate
	,sc.SCInternalCode
	,CC.ProcessDetailsId
	,DCC.DCCPermlinkRoot
	,UC2.UCName AS UsuarioMarca
	,pe.PersonFirstName
	,pe.PersonLastName
	,cc.CaseCommentAutomatic
	,cc.CaseCommentGUID
	,cc.ActionTypeCode
FROM MCCaseComment cc
	INNER JOIN MCCase c ON c.CaseId = cc.CaseId
	INNER JOIN mc.UserChannel uc ON uc.UserChannelId = cc.UserChannelId  
	INNER JOIN mc.ElementType et ON cc.ElementTypeId = et.ElementTypeId  
	INNER JOIN config.ServiceChannel sc ON sc.ServiceChannelId=et.ServiceChannelId  
	INNER JOIN Config.AccountDetail cad ON cad.AccountDetailId = cc.AccountDetailId
	INNER JOIN mc.UserChannelAccount uca ON uca.UserChannelId = uc.UserChannelId AND cad.AccountId = uca.AccountId
	INNER JOIN [Chat].[Config] co ON co.CConfigGuid = cad.AccountDetailUnique
	LEFT JOIN [Chat].[V_ActionTypeCommentNoShow] VCC ON CC.ActionTypeCode = VCC.ActionTypeCode
	LEFT JOIN MC.UserChannel uc2 ON cad.OwnerId = uc2.UserChannelId 
	Left JOIN [Security].[User] u ON c.UserAssignedId=u.userid 
	Left JOIN [Security].[Person] pe ON pe.PersonId=u.PersonId  
	LEFT JOIN mc.DetailCaseComment dcc ON dcc.CaseCommentId=cc.CaseCommentId  
	LEFT JOIN mc.Publication p ON p.CaseCommentGUID = cc.CaseCommentGUID 
WHERE VCC.ActionTypeCode IS NULL 
ORDER BY cc.CaseCommentCreated DESC'

Set @Params = N'@CUserGUID uniqueidentifier, @CConfigGUID uniqueidentifier'

exec sp_executesql @Sql, @Params, @CUserGUID = @CUserGUID, @CConfigGUID = @CConfigGUID

END
