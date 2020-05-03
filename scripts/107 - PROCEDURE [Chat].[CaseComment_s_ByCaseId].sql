IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[CaseComment_s_ByCaseId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Chat].[CaseComment_s_ByCaseId] AS' 
END
GO
-- ================================================================================    
-- Author:  ggasparini     
-- Modified date: 11/10/2016 
-- Description: se buscan los comentarios de un caso  
-- Jira: EVOLUTION-1327    
-- ================================================================================ 
-- Author:  mflosalinas     
-- Modified date: 06/03/2017 
-- Description: se modifica sp ya que el campo clientid se elimina de la tabla MC.UserChannel y se agrega
-- en la tabla MC.UserChannelAccount
-- Jira: EOE-883 
-- ================================================================================ 
-- Author:  mflosalinas     
-- Modified date: 07/12/2017 
-- Description: se modifica sp agregando inner join [Chat].[Config] para obtener el campo CConfigUserName
-- Jira: EOE-4306
-- ================================================================================ 
-- Author:  psosa     
-- Modified date: 30/10/2018 
-- Description: para poder verificar si el comentario es automatico o no se agrega la columna CaseCommentAutomatic
-- Jira: 
-- ================================================================================ 
-- Author: mflosalinas/psosa   
-- Modified date: 11/03/2019
-- Description: se agrega condición por unidad de negocio para que no se repitan los mensajes.
-- Jira: EENT-762
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
-- Modified date: 29/04/2020
-- Description: Se modifica la consulta de UCName
-- Jira: [1702]-[ETRY-1706]
-- ================================================================================ 

ALTER PROCEDURE [Chat].[CaseComment_s_ByCaseId]    
    
@CaseId AS INT    
AS     
    
BEGIN    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
SELECT TOP 10 
	cc.CaseCommentId
	,cc.CaseCommentText
	,cc.UserChannelId
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