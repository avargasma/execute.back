IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[CaseCommentAll_s_ByCaseId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Chat].[CaseCommentAll_s_ByCaseId] AS' 
END
GO
-- ================================================================================ 
-- Author: Arlington
-- Create date: 22/10/2018
-- Description: Consulta todos los comentarios del caso por id del caso
-- Jira: [ETEL-3048]-[ETEL-3049]
-- ================================================================================ 
-- Author:  Arlington
-- Modified date: 18/09/2019 
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
-- Modified date: 29/04/2020
-- Description: Se modifica la consulta de UCName
-- Jira: [1702]-[ETRY-1706]
-- ================================================================================ 

ALTER PROCEDURE [Chat].[CaseCommentAll_s_ByCaseId]    
    
@CaseId AS INT    
AS     
    
BEGIN    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
SELECT 
	cc.CaseCommentId
	,cc.CaseCommentText
	, cc.UserChannelId
	,ISNULL(NULLIF(co.CConfigUserName, ''), uc.UCName) as UCName
	,ISNULL(NULLIF(co.CConfigUserName, ''), uc.UCUserName) as UCUserName
	,uca.ClientId
	,uc.ServiceChannelId
	,uc.UCPublicationTo
	,cc.AccountDetailId
	,cc.CaseCommentCreated
	,cc.CaseCommentModifiedByUserId
	,cc.ElementId
	,cc.ElementTypeId
	,cc.CaseCommentPublicationTo
	,et.PChannelType
	,et.ElementTypePublic
	,et.ElementTypeOutput
	,et.ServiceChannelId
	,dcc.[DCCSubject]
	,sc.SCName, u.UserName
	,p.PublicationDate
	,sc.SCInternalCode
	,cc.ProcessDetailsId
	,dcc.DCCPermlinkRoot
	,uc2.UCName AS UsuarioMarca
	,pe.PersonFirstName
	,pe.PersonLastName
	,cc.CaseCommentAutomatic
	,cc.CaseCommentGUID
	,cc.ActionTypeCode
FROM mc.CaseComment cc  
INNER JOIN mc.[Case] c ON c.CaseId = cc.CaseId
INNER JOIN mc.UserChannel uc ON uc.UserChannelId = cc.UserChannelId 
INNER JOIN Config.AccountDetail cad ON cad.AccountDetailId = cc.AccountDetailId 
INNER JOIN mc.UserChannelAccount uca ON uca.UserChannelId = uc.UserChannelId AND uca.AccountId = cad.AccountId
INNER JOIN mc.ElementType et ON cc.ElementTypeId = et.ElementTypeId  
INNER JOIN config.ServiceChannel sc ON sc.ServiceChannelId=et.ServiceChannelId  
INNER JOIN [Chat].[Config] co ON co.CConfigGuid = cad.AccountDetailUnique
LEFT JOIN [Chat].[V_ActionTypeCommentNoShow] VCC ON CC.ActionTypeCode = VCC.ActionTypeCode
LEFT JOIN MC.UserChannel uc2 ON cad.OwnerId = uc2.UserChannelId 
Left JOIN [Security].[User] u ON c.UserAssignedId=u.userid 
Left JOIN [Security].[Person] pe ON pe.PersonId=u.PersonId  
LEFT JOIN mc.DetailCaseComment dcc ON dcc.CaseCommentId=cc.CaseCommentId  
LEFT JOIN mc.Publication p ON p.CaseCommentGUID = cc.CaseCommentGUID
WHERE cc.CaseId = @CaseId AND VCC.ActionTypeCode IS NULL
ORDER BY cc.CaseCommentCreated DESC
  
END