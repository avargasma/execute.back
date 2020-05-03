IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[Config_g_ByAccountId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Chat].[Config_g_ByAccountId] AS' 
END
GO
-- =================================================================================
-- Author:		ggasparini
-- Modified date: 24/08/2016
-- Description:	Obtiene la salas de chat por unidad de negocio
-- Jira: EVOLUTION-1327
-- ================================================================================
-- Author:	mflosalinas
-- Modified date: 07/12/2017
-- Description:	Se agrega el campo c.CConfigUserName
-- Jira: EOE-4306
-- ================================================================================
-- Author:	i31105160
-- Modified date: 27/12/2017
-- Description:	Se agrega el campo c.CConfigSendMailAfterHours
-- Jira: EOE-4552
-- ================================================================================
-- Author:	psosa
-- Modified date: 26/06/2018
-- Description:	Se agrega el campo c.CConfigActivateHistory
-- Jira: 
-- ================================================================================
-- Author:	yantrossero
-- Modified date: 10/12/2018
-- Description:	Se agrega el campo c.CCNoAgentsFormEnable
-- Jira: [PRDL-817][PRDL-828]
-- ================================================================================
-- Author:	psosa
-- Modified date: 02/01/2019
-- Description:	Se agrega el campo c.CCGenerateRandomData
-- Jira: [ETEL-1560][ETEL-1782]
-- ================================================================================
-- Author:	Arlington
-- Modified date: 15/08/2019
-- Description:	Se agrega el campo c.CCConversationSending, c.CCPositionRequestSendConversation 
--				para controlar el popup del envio del chat por correo
-- Jira: [ETEL-3049]-[ETEL-3048]
-- ================================================================================
-- Author:	Arlington
-- Modified date: 07/11/2019
-- Description:	Se agrega el campo c.CCSendMessageWaiting, c.CCTimeSendMessageWaiting y c.CCCantSendMessageWaiting
--				para controlar el envio del mensaje al cliente mientras espera a ser atendido
-- Jira: [EMIN-3241]-[EMIN-3351]
-- ================================================================================
-- Author:	psosa
-- Modified date: 28/11/2019
-- Description:	Se agrega el campo CCPreAttendantHistoryTime para controlar el tiempo en minutos que se muestra el
			--  historial de la conversación.
-- Jira: 
-- ================================================================================
-- Author:	psosa
-- Modified date: 28/11/2019
-- Description:	Se agrega el campo CCActiveAudioNote para controlar si se activa o no el envio de nota de audio
-- Jira: 
-- ================================================================================
-- Author:	Arlington
-- Modified date: 19/03/2020
-- Description:	Se agrega el campo CCShowConversationInSurvey para determinar si se muestra o no
-- el boton para ver la conversacion del caso una vez este en la vista de encuesta
-- Jira: [ETEC-1311]
-- ================================================================================
-- Author:	Arlington
-- Modified date: 20/03/2020
-- Description:	Se agrega el campo CCNameClientSala para configurar el look and feel de cencosus
-- de acuerdo al cliente configurado en la sala, se pinta un look diferente, ejempo "jumbo" o "disco"
-- Jira: [ECEN-44]
-- ================================================================================
-- Author:	psosa
-- Modified date: 03/04/2020
-- Description:	Se agrega el campo CCReactivateChat si es solicitado y esta abierto el caso se podra volver a conectar
-- al chat el usuario.
-- Jira: 
-- ================================================================================
ALTER PROCEDURE [Chat].[Config_g_ByAccountId] 

@Accountid int

AS 

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT c.CConfigName, 
c.CConfigDefault, 
c.CConfigId, 
c.CConfigTimeOut, 
c.CConfigGuid , 
c.CConfigWaitingLonger,  
c.CConfigLinkDataClient, 
c.CConfigUserName,
c.CConfigSendMailAfterHours, 
c.CConfigNameImage, 
c.CConfigActivateHistory,
c.CCNoAgentsFormEnable,
c.CCGenerateRandomData,
c.CCConversationSending, 
c.CCPositionRequestSendConversation,
c.CCSendMessageWaiting,
c.CCTimeSendMessageWaiting,
c.CCCantSendMessageWaiting,
c.CCPreAttendantActive,
c.CCPreAttendantHistoryTime,
c.CCActiveAudioNote,
c.CCShowConversationInSurvey,
c.CCNameClientSala,
c.CCReactivateChat
FROM chat.Config c
WHERE c.AccountId=@Accountid 
AND c.CConfigActiveFlag=1


END
