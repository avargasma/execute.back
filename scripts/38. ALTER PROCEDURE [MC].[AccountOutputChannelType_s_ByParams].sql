/****** Object:  StoredProcedure [MC].[AccountOutputChannelType_s_ByParams]    Script Date: 21/11/2019 11:32:17 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[AccountOutputChannelType_s_ByParams]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[AccountOutputChannelType_s_ByParams] AS' 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================      
-- Author:  ggasparini       
-- Modified date: 20/08/2014     
-- Description: se buscan los canales de salida para una cuenta y un tipo de elemento en    
-- particular    
-- Jira: EPN-1901      
-- ================================================================================      
-- Author:  yantrossero       
-- Modified date: 17/02/2016     
-- Description: Se agrega el campo AccountOutputChannelTypeSimpleEditor, que dice si el
-- canal debe usar un editor de texto simple (Ej.: Facebook) o complejo (Ej.: Mail).
-- Jira: EVOLUTION-378      
-- ================================================================================  
-- Author:  mflosalinas       
-- Modified date: 19/02/2016     
-- Description: Se modifica el parámetro @AccountId por @GroupAccountId
-- Jira: EVOLUTION-462     
-- ================================================================================  
-- Author:  yantrossero       
-- Modified date: 19/02/2016     
-- Description: Se agrega el campo AccountOutputChannelTypePublishOnline, que dice si el
-- salir o no por publicador
-- Jira: EVOLUTION-378      
-- ================================================================================      
-- Author:  yantrossero       
-- Modified date: 19/02/2016     
-- Description: Se agrega el campo ProcessType de Config.ProcessAssembly
-- Jira: EVOLUTION-378      
-- ================================================================================    
-- Author:  yantrossero       
-- Modified date: 05/04/2016
-- Description: Se modifica el campo ElementTypeMaxLengthComment para ser tomado
--				de la tabla Config.ServiceChannel
-- Jira: 
-- ================================================================================ 
-- Author:  ggasparini       
-- Modified date: 21/10/2016
-- Description: Se agrega el campo SCOnline
-- Jira: EVOLUTION-1632
-- ================================================================================ 
-- Author: mflosalinas   
-- Modified date: 24/10/2017
-- Description: Se agrega que tenga en cuenta si el canal de salida esta activo 
-- Jira: EOE-3678
-- ================================================================================ 
-- Author: nsruiz     
-- Modified date: 28/01/2019
-- Description: Se agrega campo SCInternalCode
-- Jira: EP3C-3901
-- ================================================================================ 
-- Author: yantrossero     
-- Modified date: 11/02/2019
-- Description: Se agrega campo ElementTypeEnableEmojis
-- Jira: [EPAC-69][EPAC-168]
-- ================================================================================ 
-- Author: mflosalinas    
-- Modified date: 22/11/2019
-- Description: Se agrega el parámetro @CaseComment para obtener el canal de salida relacionado a un comentario en particular.
-- Jira: EPAC-448
-- ================================================================================ 

ALTER PROCEDURE [MC].[AccountOutputChannelType_s_ByParams]      
      
@GroupAccountId AS INT,    
@ElementTypeId AS INT,
@CaseComment BIT = NULL      

AS       
      
BEGIN      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      

DECLARE @SQL NVARCHAR(MAX),   
@PARMDEFINITION NVARCHAR(MAX),
@AccountOutputChannelTypeActiveFlag BIT

SET @AccountOutputChannelTypeActiveFlag = 1   

SET @PARMDEFINITION = N'@PGroupAccountId INT, 
@PElementTypeId INT,
@PAccountOutputChannelTypeActiveFlag BIT'
 
SET @SQL = N'
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT et2.ElementTypeId, 
	   et2.ElementTypeDescrip, 
	   et2.ServiceChannelId, 
	   et2.PChannelType,    
       et2.ElementTypePublic,
       CASE et2.ElementTypePublic WHEN 0 
	   THEN sc.SCMaxLengthCommentDM 
	   ELSE sc.SCMaxLengthComment END AS ElementTypeMaxLengthComment,	
       pa.AssemblyStrongName,
       aoct.AccountOutputChannelTypeSimpleEditor,
       aoct.AccountOutputChannelTypePublishOnline,
       sc.SCOnline,
       sc.SCInternalCode,
	   et2.ElementTypeEnableEmojis,
	   aoct.AccountOutputChannelTypeId    
FROM Config.AccountOutputChannelType aoct     
INNER JOIN mc.ElementType et2 ON aoct.ElementTypeOutputId=et2.ElementTypeId 
INNER JOIN MC.ElementType et1 ON aoct.ElementTypeId = et1.ElementTypeId  
INNER JOIN config.ProcessAssembly pa ON et2.ProcessType=pa.ProcessType 
INNER JOIN Config.ServiceChannel sc ON sc.ServiceChannelId = et2.ServiceChannelId 
WHERE aoct.GroupAccountId = @PGroupAccountId
AND aoct.ElementTypeId= @PElementTypeId  
and aoct.AccountOutputChannelTypeActiveFlag = @PAccountOutputChannelTypeActiveFlag'

IF @CaseComment = 1

	SET @SQL = @SQL + ' AND et2.ElementTypePublic = et1.ElementTypePublic
						AND et2.ServiceChannelId = et1.ServiceChannelId' 

 EXECUTE SP_EXECUTESQL              
 @SQL,              
 @PARMDEFINITION, 
 @PGroupAccountId = @GroupAccountId,
 @PElementTypeId = @ElementTypeId,
 @PAccountOutputChannelTypeActiveFlag = @AccountOutputChannelTypeActiveFlag
    
END    
    
    
    
    
