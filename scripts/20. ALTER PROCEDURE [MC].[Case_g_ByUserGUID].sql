/****** Object:  StoredProcedure [MC].[Case_g_ByUserGUID]    Script Date: 09/03/2020 9:32:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MC].[Case_g_ByUserGUID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [MC].[Case_g_ByUserGUID] AS' 
END
GO
    
                
-- =================================================================================                    
-- Author:  nsruiz                    
-- Modified date: 25/08/2014                    
-- Description: Obtiene los casos no bloqueados asignados a un usuario                     
-- Jira: EPN-1960                    
-- ================================================================================                    
-- Author:  yantrossero                    
-- Modified date: 24/06/2016                  
-- Description: Se agrega el campo ElementTypeId                  
-- Jira:                    
-- ================================================================================                    
-- Author:  yantrossero                    
-- Modified date: 26/07/2016                  
-- Description: Se modifica la forma de devolver las fechas. Se devuelven los                  
--    segundos transcurridos desde su última modificación y su creación.                  
--    Además se agrega el campo UCUserName, el campo UCDAux4.                  
-- Jira:                    
-- ================================================================================                    
-- Author:  mflosalinas                    
-- Modified date: 27/08/2016                  
-- Description: Se restructura sp, se realiza dinamismo, se quita if repitiendo consulta y se remplaza por una sola consulta                   
-- con  IF @State = 1 --abiertos                  
 -- SET @sFiltroCaseType = ' AND C.CaseClosureDate IS NULL  '                  
 --IF @State = 0 --cerrados                  
 -- SET @sFiltroCaseType = ' AND C.CaseClosureDate IS NOT NULL  '                  
-- Se agrega para que me muestre la cantidad de notificaciones que tiene un caso.                  
-- Jira:  EVOLUTION-1128                  
-- ================================================================================                    
-- Author:  ggasparini                    
-- Modified date: 18/01/2017                  
-- Description: Se agrega el campo A.AttentionQueueEnableNotificationsPanel                  
-- Jira:  EOE-444                  
-- ================================================================================                    
-- Author:  yantrossero / ggasparini                    
-- Modified date: 19/01/2017                  
-- Description: Se agregaron los campos AccountDetailId, UserChannelId, UCPublicationTo y SCOnline                  
-- Jira:  EOE-450                  
-- ================================================================================                    
-- ================================================================================                    
-- Author:  Brenda Pereyra                     
-- Modified date: 05/05/2017                  
-- Description: Se agregaron los campos AccountId para que sea utilizado en el método NotifyConversationStated                   
-- de la aplicacion Apichat                  
-- Jira:                    
-- ================================================================================                    
-- Author:  yantrossero                     
-- Modified date: 05/05/2017                  
-- Description: Se agregaron el campo SCInternalCode                  
-- Jira: EPIQUAM-1118                  
-- ================================================================================                  
-- Author:  fsoler                     
-- Modified date: 05/05/2017                  
-- Description: Se agregaron el campo UCDAux3                  
-- Jira: EOE-2574                 
-- ================================================================================                  
-- Author:  apizarro                     
-- Modified date: 05/04/2018                  
-- Description: Por errores de facebook la imagen devuelve NULL                  
-- Jira: EP3C-752                 
-- ================================================================================       
-- Author:  fsoler                     
-- Modified date: 18/04/2018              
-- Description: Se agregaron el campo AttentionQueueImage                  
-- Jira: EMIN-286                 
-- ================================================================================                 
-- Author:  mflosalinas                     
-- Modified date: 11/05/2018              
-- Description: Se agrega si el último comentario del caso es del cliente (1) o del asesor (0)                 
-- Jira: ETEL-694               
-- ================================================================================               
-- Author:  yantrossero                     
-- Modified date: 17/09/2018             
-- Description: Se obtiene el ElementGUID del primer comentario de cada caso.                
-- Jira: EP3C-2601              
-- ================================================================================               
-- Author:  nsruiz                     
-- Modified date: 23/10/2018             
-- Description: Se agrega la columna AlertColorsCode, que indica por cada caso un alerta de acuerdo al            
--              tiempo que pasó desde el último contacto del cliente, sin respuesta del REP            
-- Jira: EENT-361              
-- ================================================================================             
-- Author: mflosalinas                   
-- Modified date: 17/12/2018             
-- Description: Se modifica sp ya que tiraba time out en Bancolombia, se quita ElementTypeOutput y se agrega en otra consulta.          
-- Y se agrega SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  en la segunda consulta          
-- Jira: EPBC-316             
-- ================================================================================               
-- Author: mflosalinas                   
-- Modified date: 18/01/2019             
-- Description: Se agrega el campo ClassificationDetailId           
-- Jira: EDIN-540             
-- ================================================================================          
-- Author:  mflosalinas                     
-- Modified date: 28/01/2019                  
-- Description: Se comenta la linea  /* UCD.UCDAux4 AS ProfileImage,  */   ya que esta duplicado          
-- Jira: EPMP-652               
-- ================================================================================               
-- Author: dawverson.mejia                   
-- Modified date: 26/02/2019             
-- Description: se agrega validacion para evitar mostrar imagenes con extension .gif          
-- Jira: EENT-579             
-- ================================================================================            
-- Author: mflosalinas                 
-- Modified date: 07/03/2019             
-- Description: se agregan los campos PersonFirstName y PersonLastName          
-- Jira:  EP3C-4434          
-- ================================================================================            
-- Author: Luchini Diego        
-- Modified date: 12/03/2019        
-- Description: Se agrega left join a la tabla MC.CaseSchedule campo CSExpirationDate. (Casos agendados para una fecha y hora)        
-- Jira:  EPBC-479        
-- ================================================================================              
-- Author: Arlington      
-- Modified date: 11/04/2019        
-- Description: Se agrega la columna StateShowCase      
-- Jira:  EPBC-336       
-- ================================================================================       
-- Author: mflosalinas      
-- Modified date: 14/06/2019        
-- Description: Se agrega la columna AutomaticOpenCases        
-- Jira:  EDIN-211      
-- ================================================================================       
-- Author: nsruuiz      
-- Modified date: 03/10/2019        
-- Description: Se agrega la columna CaseTypeName  y CaseTypeInternalCode      
-- Jira:  EP3C-5434      
-- ================================================================================       
-- Author: mflosalinas      
-- Modified date: 08/10/2019        
-- Description: se excluyen los comentarios entrantes automáticos, para que no se tengan en cuenta para el muñeco rojo y verde.      
-- Jira:  ETEC-1134      
-- ================================================================================       
-- Author: janeth.valbuena      
-- Modified date: 05-11-2019      
-- Description: se agrega la condicion AlertColorsActiveFlag = 1 en la consulta de las alertas de colores para tomar en cuenta      
--              solo las alertas que se encuentren vigentes.      
-- Jira:  EP3C-5363      
-- ================================================================================       
-- Author: nsruuiz      
-- Modified date: 06/11/2019        
-- Description: Se agrega top(1) al SELECT de "UPDATE #TMP_ULT_ULT_COMMENT SET AlertColorsCode = (SELECT...."      
--              ya que cuando hay mas de una alerta para el mismo rango ésta sentencia da error.      
--              Esto es para resolver mas rapido la falta de esta validacion en el ABM de Alertas, se crea otro pedido      
--              para desarrolarla      
-- Jira:  EP3C-5641      
-- ================================================================================       
-- Author: mflosalinas      
-- Modified date: 19/11/2019        
-- Description: Se agrega consulta para saber si un caso de chat fue generado desde un dispositivo movil.      
-- Jira: ETEL-3742      
-- ================================================================================       
-- Author: dawverson.mejia      
-- Modified date: 02/12/2019        
-- Description: Visualización de nombre del cliente en bandeja de casos del gestor - Whatsapp.      
-- Jira: EONC-426      
-- ================================================================================       
-- Author: yantrossero   
-- Modified date: 26/02/2020
-- Description: Se agrega el campo G.[GroupAccountName]
-- Jira: [ETEC-1327]
-- ================================================================================ 
      
ALTER PROCEDURE [MC].[Case_g_ByUserGUID]      
                  
@UserGUID AS UNIQUEIDENTIFIER,                    
@State AS BIT                    
                     
AS                     
                    
BEGIN        
      
 SET NOCOUNT ON;      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED       
                 
 DECLARE @CurrentDate DATETIME                  
                   
 DECLARE @sFiltroCaseType varchar(300)                  
 DECLARE @sql nvarchar(max)             
 DECLARE @Sql2 nvarchar(max)            
 DECLARE @PARMDEFINITION nvarchar(MAX)         
 DECLARE @P1UserGUID UNIQUEIDENTIFIER      
       
 SET @P1UserGUID =  @UserGUID             
                    
 IF @State = 1 --abiertos                  
  SET @sFiltroCaseType = ' AND C.CaseClosureDate IS NULL  '                  
 IF @State = 0 --cerrados                  
  SET @sFiltroCaseType = ' AND C.CaseClosureDate IS NOT NULL  '                  
            
      
SET @PARMDEFINITION = N'@PCurrentDate DATETIME,                  
      @PUserGUID UNIQUEIDENTIFIER'                  
                   
SET @CurrentDate = GETDATE()                  
                  
SET @sql = N'                  
                  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                  
                
 SELECT C.CaseId,                  
  C.CaseModifiedDate,                  
  C.CaseCreated,                  
  C.GroupAccountId,                  
  C.ElementTypeId,                  
  C.UserAssignedId,                  
  C.AttentionQueueId,                  
  C.UserChannelId,                  
  C.StateId,      
  C.ClassificationDetailId,                
  C.AccountDetailId,                  
  SC.SCOnline,                  
  AD.AccountId,                  
  SC.SCInternalCode,       
  CT.[CaseTypeName],       
  CT.CaseTypeInternalCode                   
 INTO #CasosAsignadosUsuario                  
 FROM  MC.[Case] C                     
 INNER JOIN [Security].[User] U ON U.UserId = C.UserAssignedId                   
 INNER JOIN MC.ElementType ET ON ET.ElementTypeId = C.ElementTypeId                  
 INNER JOIN Config.ServiceChannel SC ON SC.ServiceChannelId = ET.ServiceChannelId                  
 INNER JOIN Config.AccountDetail AD ON AD.AccountDetailId = C.AccountDetailId                  
 INNER JOIN MC.CaseType CT ON CT.[CaseTypeId] = C.CaseTypeId       
 WHERE U.UserGUID =  @PUserGUID '                  
 + @sFiltroCaseType + '              
             
 -- Se agrega el color a mostrar en el ícono Antigüedad              
 -- CARGO TABLA CON LA CANT DE MINUTOS QUE PASO DESDE EL ULTIMO COMENTARIO                                
  CREATE TABLE #TMP_ULT_ULT_COMMENT1             
  (CaseId INT,            
  CaseCommentId INT,            
  AccountDetailId INT,            
  AccountId INT,            
  AccountTypeId INT,            
  ServiceChannelId INT,            
  Antig INT,            
  ElementTypeId INT,          
 -- ElementTypeOutput BIT,            
  AlertColorsCode NVARCHAR(20))            
             
  INSERT INTO #TMP_ULT_ULT_COMMENT1             
  SELECT DISTINCT t.CaseId, cc.CaseCommentId, t.AccountDetailId, a.AccountId, a.AccountTypeId, ad.ServiceChannelId,             
  DATEDIFF(ss, cc.CaseCommentCreated, GETDATE()) / 60  as Antig,           
  cc.ElementTypeId,          
  --et.ElementTypeOutput,           
  NULL AS AlertColorsCode                
  FROM #CasosAsignadosUsuario t             
  INNER JOIN MC.CaseComment cc ON cc.CaseId = t.CaseId             
  INNER JOIN mc.ElementType et ON et.ElementTypeId = cc.ElementTypeId             
  INNER JOIN Config.AccountDetail ad ON ad.AccountDetailId = t.AccountDetailId             
  INNER JOIN Config.Account a ON a.AccountId = ad.AccountId             
  WHERE cc.CaseCommentId = (SELECT max(cc2.CaseCommentId) FROM mc.CaseComment cc2               
         WHERE cc2.CaseId = t.CaseId)             
                 
           
  Select cc.CaseId,          
  cc.CaseCommentId,          
  cc.AccountDetailId,          
  cc.AccountId,          
  cc.AccountTypeId,          
  cc.ServiceChannelId,          
  cc.Antig,          
  cc.AlertColorsCode,          
  et.ElementTypeOutput          
  into #TMP_ULT_ULT_COMMENT          
  from  #TMP_ULT_ULT_COMMENT1  cc                
  INNER JOIN mc.ElementType et ON et.ElementTypeId = cc.ElementTypeId             
          
                     
  --elimino los casos donde su ultimo comentario es del rep                     
  DELETE FROM #TMP_ULT_ULT_COMMENT              
  WHERE ElementTypeOutput = 1 '            
              
  SET @SQL2 = '              
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED           
              
  --COMPLETO EL COLOR DE ACUERDO A LA ANTIGUEDAD: 1ero por CUENTA              
  UPDATE #TMP_ULT_ULT_COMMENT              
  SET AlertColorsCode = (SELECT top(1) c.ColorCode FROM Config.AlertColors ac              
                       INNER JOIN Config.AlertColorsType act ON act.AlertColorsTypeId = ac.AlertColorsTypeId             
                       INNER JOIN Config.Colors c ON c.ColorId = ac.ColorId               
                       WHERE act.AlertColorsTypeInternalCode = 1        
        AND ac.AlertColorsActiveFlag = 1       
                       AND ac.AccountDetailId = #TMP_ULT_ULT_COMMENT.AccountDetailId             
        AND #TMP_ULT_ULT_COMMENT.Antig >= CONVERT(int, ac.AlertColorsValueMin)             
        AND (#TMP_ULT_ULT_COMMENT.Antig < CONVERT(int, ac.AlertColorsValueMax) OR ac.AlertColorsValueMax IS NULL ))             
            
  --COMPLETO EL COLOR DE ACUERDO A LA ANTIGUEDAD: 2DO por CANAL                    
  UPDATE #TMP_ULT_ULT_COMMENT              
  SET AlertColorsCode = (SELECT top(1) c.ColorCode FROM Config.AlertColors ac             
                       INNER JOIN Config.AlertColorsType act ON act.AlertColorsTypeId = ac.AlertColorsTypeId             
                       INNER JOIN Config.Colors c ON c.ColorId = ac.ColorId              
                       WHERE act.AlertColorsTypeInternalCode = 1           
        AND ac.AlertColorsActiveFlag = 1       
                       AND ac.ServiceChannelId = #TMP_ULT_ULT_COMMENT.ServiceChannelId             
        AND #TMP_ULT_ULT_COMMENT.Antig >= CONVERT(int, ac.AlertColorsValueMin)             
        AND (#TMP_ULT_ULT_COMMENT.Antig < CONVERT(int, ac.AlertColorsValueMax) OR ac.AlertColorsValueMax IS NULL ))             
  WHERE AlertColorsCode IS NULL             
            
  --COMPLETO EL COLOR DE ACUERDO A LA ANTIGUEDAD: 3ERO por U.N.                    
  UPDATE #TMP_ULT_ULT_COMMENT              
  SET AlertColorsCode = (SELECT top(1) c.ColorCode FROM Config.AlertColors ac             
                       INNER JOIN Config.AlertColorsType act ON act.AlertColorsTypeId = ac.AlertColorsTypeId             
                       INNER JOIN Config.Colors c ON c.ColorId = ac.ColorId              
                       WHERE act.AlertColorsTypeInternalCode = 1      
        AND ac.AlertColorsActiveFlag = 1       
                       AND ac.AccountId = #TMP_ULT_ULT_COMMENT.AccountId             
        AND #TMP_ULT_ULT_COMMENT.Antig >= CONVERT(int, ac.AlertColorsValueMin)             
        AND (#TMP_ULT_ULT_COMMENT.Antig < CONVERT(int, ac.AlertColorsValueMax) OR ac.AlertColorsValueMax IS NULL ))             
  WHERE AlertColorsCode IS NULL              
            
  --COMPLETO EL COLOR DE ACUERDO A LA ANTIGUEDAD: 4TO por EMPRESA                    
  UPDATE #TMP_ULT_ULT_COMMENT              
  SET AlertColorsCode = (SELECT top(1) c.ColorCode FROM Config.AlertColors ac             
                       INNER JOIN Config.AlertColorsType act ON act.AlertColorsTypeId = ac.AlertColorsTypeId             
                       INNER JOIN Config.Colors c ON c.ColorId = ac.ColorId              
                       WHERE act.AlertColorsTypeInternalCode = 1      
        AND ac.AlertColorsActiveFlag = 1                  
                       AND ac.AccountTypeId = #TMP_ULT_ULT_COMMENT.AccountTypeId             
        AND #TMP_ULT_ULT_COMMENT.Antig >= CONVERT(int, ac.AlertColorsValueMin)             
        AND (#TMP_ULT_ULT_COMMENT.Antig < CONVERT(int, ac.AlertColorsValueMax) OR ac.AlertColorsValueMax IS NULL ))              
  WHERE AlertColorsCode IS NULL                 
                         
  SELECT n.CaseId, COUNT (*) AS Notificacion                  
  INTO #Notificaciones                  
  FROM MC.[Notification] n                  
  WHERE EXISTS (SELECT T.CaseID FROM #CasosAsignadosUsuario t WHERE T.CaseId = N.CaseId)                  
  AND n.NotificationModifiedByUserId IS NULL                  
  AND n.NotificationModifiedDate IS NULL                  
  GROUP BY n.CaseId                  
        
  -- se obtiene el max y min comentario excluyendo los comentarios entrantes automáticos            
  SELECT c.CaseId, Max(cc.CaseCommentId) AS CaseCommentId, Min(cc.CaseCommentId) AS FirstCommentId             
  INTO #ComentarioTemporal              
  FROM #CasosAsignadosUsuario c              
  INNER JOIN MC.CaseComment cc on cc.CaseId = c.CaseId         
  AND NOT EXISTS (SELECT CaseCommentId FROM mc.CaseComment cc1        
      INNER JOIN mc.ElementType et2 ON et2.ElementTypeId = cc1.ElementTypeId      
      WHERE cc1.CaseCommentId = cc.CaseCommentId       
      AND cc1.CaseCommentAutomatic = 1 AND et2.ElementTypeOutput = 0)                 
  GROUP BY c.CaseId              
            
  SELECT cc.ElementGUID as FirstCommentElementGUID, c.CaseId, c.CaseCommentId            
  INTO #Comentario            
  FROM MC.CaseComment cc            
  INNER JOIN #ComentarioTemporal c on cc.CaseId = c.CaseId              
  WHERE cc.CaseCommentId = FirstCommentId            
                           
-- Se obtiene para saber si un caso de chat fue peticionado desde un dispositivo mobile o no      
  SELECT cau.CaseId, md.MessageDeviceIsMobile      
  INTO #ChatIsMobile      
  FROM #CasosAsignadosUsuario cau      
  INNER JOIN [Chat].[Message] m ON m.CaseId = cau.CaseId      
  INNER JOIN [Chat].[MessageDevice] md ON md.CMessageId = m.CMessageId      
        
                        
 SELECT C.CaseId,                 
 case    
 when et.ElementTypeOutput = 1 and (cim.MessageDeviceIsMobile IS NULL OR cim.MessageDeviceIsMobile= 0) then ''0''              
 when et.ElementTypeOutput = 0 and (cim.MessageDeviceIsMobile IS NULL OR cim.MessageDeviceIsMobile= 0) then ''1''           
 when et.ElementTypeOutput = 1 and cim.MessageDeviceIsMobile= 1 then ''2''      
 when et.ElementTypeOutput = 0 and cim.MessageDeviceIsMobile= 1 then ''3''      
 end AS ''Cliente'',                
  DATEDIFF(ss, C.CaseModifiedDate, @PCurrentDate) AS CaseModifiedDate,                  
  DATEDIFF(ss, C.CaseCreated, @PCurrentDate) AS CaseCreated,                  
  S.StateName,          
  C.AttentionQueueId,                  
  A.AttentionQueueName,              
  A.AttentionQueueImage,        
  A.AutomaticOpenCases,                
  S.StateId,           
  ISNULL(S.StateShowCase,1) AS StateShowCase,  /* Si es nulo  muestra el caso */       
  C.ClassificationDetailId,               
  C.GroupAccountId,         
  G.[GroupAccountName],
  C.ElementTypeId,           
  C.UserAssignedId,          
  p.PersonFirstName,          
  p.PersonLastName,                
  UC.UCUserName,                  
/*  UCD.UCDAux4 AS ProfileImage,   */             
 case                
 when C.SCInternalCode = 3 then NULL                
 when C.SCInternalCode <> 3 then CASE WHEN CHARINDEX(''.gif'',UCD.UCDAux1) > 0 THEN NULL ELSE UCD.UCDAux4 END               
  END as ProfileImage,                  
  UCD.UCDAux3 AS Followers,                  
  t2.Notificacion,                  
  A.AttentionQueueEnableNotificationsPanel,                  
  C.AccountDetailId,                  
  C.UserChannelId,                  
  C.SCOnline,                  
  AD.AccountId,                  
  UC.UCPublicationTo,                  
  C.SCInternalCode,            
  co.FirstCommentElementGUID,            
  TUU.AlertColorsCode,            
  TUU.Antig    ,        
  cs.CSExpirationDate,       
  C.[CaseTypeName],       
  C.CaseTypeInternalCode,        
  CL.[ClientFirstName] ClientFirstName,      
  CL.[ClientLastName]   ClientLastName          
  FROM  #CasosAsignadosUsuario C                
  INNER JOIN #Comentario co on co.CaseId = c.CaseId              
  INNER JOIN MC.CaseComment cc on cc.CaseCommentId = co.CaseCommentId         
  INNER JOIN MC.ElementType et on et.ElementTypeId = cc.ElementTypeId              
  INNER JOIN [Security].[User] U ON U.UserId = C.UserAssignedId           
  INNER JOIN [Security].[Person] P on p.PersonId = u.PersonId               
  INNER JOIN Config.AttentionQueue A ON A.AttentionQueueId = C.AttentionQueueId                  
  INNER JOIN Config.GroupAccount G ON G.GroupAccountId = C.GroupAccountId                    
  INNER JOIN MC.UserChannel UC ON UC.UserChannelId = C.UserChannelId                   
  INNER JOIN Config.AccountDetail AD ON AD.AccountDetailId = C.AccountDetailId                   
  LEFT JOIN Config.[State] S ON S.StateId = C.StateId                    
  LEFT JOIN MC.UserChannelDetail UCD ON UCD.UserChannelId = C.UserChannelId                   
  LEFT JOIN #Notificaciones t2 ON t2.CaseId = c.CaseId                      
  LEFT JOIN #TMP_ULT_ULT_COMMENT TUU ON TUU.CaseId = c.CaseId            
  left join MC.CaseSchedule cs on cs.CSCaseId=c.CaseId       
  LEFT JOIN #ChatIsMobile cim on cim.CaseId = c.CaseId         
  INNER JOIN [MC].[UserChannelAccount] UCA ON C.[UserChannelId] = UCA.[UserChannelId] AND C.AccountId = UCA.AccountId      
  LEFT JOIN [MC].[Client] CL ON UCA.[ClientId] = CL.[ClientId]       
  ORDER BY C.CaseModifiedDate DESC                  
                       
  DROP TABLE #CasosAsignadosUsuario                  
  DROP TABLE #Notificaciones              
  DROP TABLE #ComentarioTemporal             
  DROP TABLE #Comentario             
  DROP TABLE #TMP_ULT_ULT_COMMENT '                  
              
  SELECT @sql  =  @sql + @sql2                
                    
   EXEC sp_executesql @sql  ,                  
   @PARMDEFINITION,                  
   @PCurrentDate = @CurrentDate,                  
  @PUserGUID = @P1UserGUID                  
                     
 END 
GO
