/****** Object:  StoredProcedure [Config].[Case_s_ByFilters]    Script Date: 13/03/2020 14:17:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[Case_s_ByFilters]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Config].[Case_s_ByFilters] AS' 
END
GO
          
----------------------------------------------------------------------------------------------              
---- Author     : i29554837 Sabrina Sotomayor              
---- Date       : 2016-07-15              
---- Description: Recupera los casos segun los filtros seleccionados y enviados como parametros              
---- JIRA       : [EVOLUTION-997]              
----------------------------------------------------------------------------------------------             
---- Author     : i29554837 Sabrina Sotomayor              
---- Date       : 2016-11-18              
---- Description: Se agrega LEFT con la tabla estatizada con el arbol de clasificaciones              
---- JIRA       : [EVOLUTION-1922]              
----------------------------------------------------------------------------------------------             
---- Author     : i29554837 Sabrina Sotomayor              
---- Date       : 2016-12-14              
---- Description: Se modifica la logica con la que recupera los casos segun los filtros seleccionados y enviados como parametros              
----              para poder trabajar con los casos sin tipo de estado, en forma mas eficiente               
---- JIRA       : [EVOLUTION-2069]              
----------------------------------------------------------------------------------------------             
---- Author     : i29554837 Sabrina Sotomayor              
---- Date       : 2016-12-27              
---- Description: Se agregan los parametros @GruposVigentes y @ColasVigentes              
---- JIRA       : [EOE-221]              
----------------------------------------------------------------------------------------------            
---- Author     : i29554837 Sabrina Sotomayor              
---- Date       : 2017-02-06              
---- Description: Se agrega el parametro @SendingUser               
---- JIRA       : [EOE-648]              
----------------------------------------------------------------------------------------------              
---- Author     : i29554837 Sabrina Sotomayor              
---- Date       : 2017-03-02              
---- Description: Se agrega INNER con la nueva tabla UserChannelAccount                
---- JIRA       : [EOE-854]              
----------------------------------------------------------------------------------------------              
---- Author     : pnunez               
----   : Se analizan los cambios con Marcelo M, Sabrina y Pablo G.              
----   : Buscar Cambios con --Cambio 28/3/2017              
---- Date       : 2017-03-28              
---- Description: Se hacen ajustes por demora de ejecucion                
---- JIRA       :               
----------------------------------------------------------------------------------------------              
---- Author     : i29554837 Sabrina Sotomayor               
---- Date       : 2017-04-19              
---- Description: Se agregan la busqueda por texto en comentarios y la busqueda de tag en casos,               
-----             comentarios y conversaciones. Se agrega el campo [SCInternalCode].               
-----             Se comenta @GruposVigentes y @ColasVigentes               
---- JIRA       : EEC-75              
----------------------------------------------------------------------------------------------         
---- Author     : i29554837 Sabrina Sotomayor           
---- Date       : 2017-05-02          
---- Description: Se agrega la busqueda por Estados y se elimina la busqueda por Tipos de Estados.          
----              Se agrega la devolucion de la columna DCCPermlinkRoot (link raiz del primer comentario).          
---- JIRA       : EOE-1434          
----------------------------------------------------------------------------------------------         
---- Author     : i29554837 Sabrina Sotomayor           
---- Date       : 2017-05-03          
---- Description: Se agrega la busqueda por arboles de clasificacion.          
---- JIRA       : EOE-1436          
----------------------------------------------------------------------------------------------              
---- Author     : i29554837 Sabrina Sotomayor               
---- Date       : 2017-06-05              
---- Description: Se agrega control de los parametros @SendingUser y @CommentText. Si vienen '' se setean en NULL.             
---- JIRA       : EOE-1657              
----------------------------------------------------------------------------------------------          
---- Author     : i29554837 Sabrina Sotomayor               
---- Date       : 2017-06-27              
---- Description: Se agrega la columna ElementTypeId del primer comentario             
---- JIRA       : EOE-1876              
----------------------------------------------------------------------------------------------            
---- Author     : i29554837 Sabrina Sotomayor               
---- Date       : 2017-06-28              
---- Description: Se agregan los parametros @ClientAttributeId y @ClientAttributeValue para realizar la busqueda por ANI de cliente          
---- JIRA       : EOE-2096             
----------------------------------------------------------------------------------------------            
---- Author     : i29554837 Sabrina Sotomayor               
---- Date       : 2017-07-10              
---- Description: Se comenta el campo StateActiveFlag para poder visualizar los casos con estados no vigentes          
---- JIRA       : EOE-2166             
----------------------------------------------------------------------------------------------             
---- Author     : i29554837 Sabrina Sotomayor               
---- Date       : 2017-08-16              
---- Description: Se agrega la cantidad de veces que se escalo un caso          
---- JIRA       : EOE-1625             
----------------------------------------------------------------------------------------------             
---- Author     : i30423669 Pablo Guidici          
---- Date       : 2017-09-04              
---- Description: Se agregan dos columnas, la fecha de cierre del caso y el usuario que lo cerro          
---- JIRA       : EOE-2313           
----------------------------------------------------------------------------------------------             
---- Author     : i29554837 Sabrina Sotomayor          
---- Date       : 2017-10-13              
---- Description: Se agregan dos parametros @DateTypeM y @DateTypeF, para el filtro por fecha de cierre          
---- JIRA       : EOE-3579           
----------------------------------------------------------------------------------------------             
---- Author     : Pnunez          
---- Date       : 2018-01-26          
---- Description: Se hacen los siguientes cambios por lentitud reportada en Peru           
--   La lentitud inicial venia dada por la tabla que se carga en @Cd que tiene 102.000 registros           
--     modifica la Tabla @case, se usa #Tmpcase           
--     Se deja de usar la Tabla @CD, se usa directamente la Tabla Original          
---- JIRA       :           
----------------------------------------------------------------------------------------------          
---- Author     : Hernan Freschi          
---- Date       : 2018-03-19          
---- Description: Se cambian todos los campos VARCHAR a NVARCHAR y se amplia todo a NVARCHAR(MAX)          
---- JIRA       : EPBC-49          
----------------------------------------------------------------------------------------------          
---- Author     : nsruiz          
---- Date       : 2018-04-16          
---- Description: Se agrega columna Followers          
---- JIRA       : EMIN-279          
----------------------------------------------------------------------------------------------          
---- Author     : pnunez          
---- Date       : 2018-04-30          
---- Description: Se reemplaza Nombre de usuario por Nombre y apellido de la Persona           
---- JIRA       : EP3C-1098          
----------------------------------------------------------------------------------------------          
---- Author     : wilmar.duque          
---- Date       : 2018-05-16          
---- Description: Se agrega la opcion de traer toda la información del cliente al administrador de casos          
---- JIRA       : EDIN-100          
----------------------------------------------------------------------------------------------          
---- Author     : wilmar.duque          
---- Date       : 2018-05-17          
---- Description: Se agrega columna del comentario post de la marca para facebook y twitter          
---- JIRA       : EENT-165          
----------------------------------------------------------------------------------------------          
---- Author     : wilmar.duque          
---- Date       : 2018-05-21          
---- Description: Se filtra por Account en la tabla #Tmpcase          
---- JIRA       : EDIN-100          
----------------------------------------------------------------------------------------------          
---- Author     : nsruiz          
---- Date       : 2018-08-08          
---- Description: Se corrige error que se producia al filtrar por un atributo de cliente          
---- JIRA       : EP3C-2247          
----------------------------------------------------------------------------------------------          
---- Author     : nsruiz-mmoyano          
---- Date       : 2018-08-30          
---- Description: Se modifica para reducir la demora ya que está dando TimeOut         
---- JIRA       : ETEL-1161          
----------------------------------------------------------------------------------------------         
---- Author     : Luchini Diego      
---- Date       : 2018-10-08      
---- Description: Se agrega el client id para poder mostrar el historial de cambios sobre el mismo.      
---- JIRA       : EMIN-868       
----------------------------------------------------------------------------------------------         
---- Author     : Arlington      
---- Date       : 2018-10-23      
---- Description: Se modifica para traer los tags por caso en una sola linea separados por /      
---- JIRA       : EDIN-295      
----------------------------------------------------------------------------------------------     
---- Author     : apizarro-manuelveliz-arlington    
---- Date       : 2019-01-23      
---- Description: Se modifica para reducir la demora ya que está dando TimeOut     
---- JIRA       : EDIN-295      
----------------------------------------------------------------------------------------------     
---- Author     : apizarro-NicolasMasgoret    
---- Date       : 2019-01-29     
---- Description: Se añade distinct a la consulta @select por casos duplicados en busqueda por texto     
---- JIRA       : EENT-586     
----------------------------------------------------------------------------------------------     
---- Author     : Arlington    
---- Date       : 2019-01-29     
---- Description: Se añade el campo UCPublicationTo    
---- JIRA       : EMIN-970      
----------------------------------------------------------------------------------------------     
---- Author     : apizarro    
---- Date       : 2019-01-30     
---- Description: Se añade la función de filtrar por comentario del cliente y/o representante    
---- JIRA       : EMIN-1014    
----------------------------------------------------------------------------------------------     
---- Author     : Arlington    
---- Date       : 2019-01-30     
---- Description: Se añade el campo AccountDetailSurveyId    
---- JIRA       : EMIN-970    
----------------------------------------------------------------------------------------------     
---- Author     : janeth.valbuena   
---- Date       : 29-05-2019    
---- Description: Se añade el campo DCCTextEmailBody para traer el primer comentario para casos de email  
---- JIRA       : EDIN-721    
----------------------------------------------------------------------------------------------     
---- Author     : janeth.valbuena   
---- Date       : 12-07-2019    
---- Description: Se comenta la condicion Where de la [MC].[DetailCaseComment] para consultar los datos  
---- JIRA       : EENT-1150    
----------------------------------------------------------------------------------------------     
---- Author     : mflosalinas  
---- Date       : 30-07-2019    
---- Description: Se quita left(CaseCommentText , 200) y left (DCC.DCCTextEmailBody, 200), dejando solamente CaseCommentText,   
---- DCC.DCCTextEmailBody de la tabla temporal #CaseCommentPrimer  
---- JIRA       : EDIN-802   
----------------------------------------------------------------------------------------------    
---- Author     : TReyna - G2 - NSRuiz  
---- Date       : 22-08-2019    
---- Description: Se agrega left(CaseCommentText , 32766) y left (DCC.DCCTextEmailBody, 32766) para que no arroje error al exportar a excel  
----    desde el admin de casos, ya que excel permite hasta 32,767 caracteres por celda   
---- JIRA       : EDIN-984   
----------------------------------------------------------------------------------------------   
---- Author     : Arlington/Marcelo Moyano/Dayan  
---- Date       : 06-09-2019    
---- Description: Se realizan mejoras de performarce, se crea la #TmpCase0 que contiene solo los CaseId  
----     luego hace JOIN con la MC.Case para traer info adicional, la #GGroupAccount y la #AAccountDetail cambia el tipo  
----              de dato de una de las propiedades, pasa de nvarchar(max) a int.  
---- JIRA       : ETEL-2574  
----------------------------------------------------------------------------------------------   
---- Author     : mmoyano  
---- Date       : 02-10-2019    
---- Description: BUG detectado   
----     CREATE TABLE #TmpCase...CaseClosureUserId DATETIME..pasado a INT  
---- JIRA       : ETEL-3325  
----------------------------------------------------------------------------------------------   
---- Author     : mflosalinas  
---- Date       : 23-09-2019    
---- Description: Se agrega fecha de agendamiento, se integró el 7 de octubre por que estaba desactualizado en analisis  
---- JIRA       : EPBC-984  
----------------------------------------------------------------------------------------------   
---- Author     : nsruiz  
---- Date       : 07-10-2019    
---- Description: Se agrega parámetro @CaseType y la columna CaseTypeId a los resultados  
---- JIRA       : EP3C-5441  
----------------------------------------------------------------------------------------------   
---- Author     : i24120394, Mayorga Andrea  
---- Date       : 26/11/2019    
---- Description: Se agrega la columna CreationDateLog a los resultados  
---- JIRA       : EMIN-1730  
----------------------------------------------------------------------------------------------   
---- Author     : yantrossero
---- Date       : 13/01/2020   
---- Description: Se quita la parte que busca los atributos del cliente (@SearchClient)
---- JIRA       : EENT-1719  
---------------------------------------------------------------------------------------------- 

ALTER PROCEDURE [Config].[Case_s_ByFilters]            
(      
 @AccountType INT ,                  
 @Account INT ,                  
 @GroupAccount NVARCHAR(MAX) = NULL,                  
 @AccountDetail NVARCHAR(MAX) = NULL,                  
 @PlaceId NVARCHAR(MAX) = NULL,                  
 @Queue NVARCHAR(MAX)= NULL,                  
 @DateTypeC BIT,                  
 @DateTypeM BIT,              
 @DateTypeF BIT,              
 @StartDate DATETIME,                  
 @EndDate DATETIME,                      
 @Users NVARCHAR(max)= NULL,                  
 @CasesUnassigned BIT,                  
 @CasesAssigned BIT,                  
 @SendingUser NVARCHAR(MAX) = NULL,                   
 @CommentText NVARCHAR(MAX)=NULL,                  
 @TagList NVARCHAR(MAX)=NULL,                   
 @CaseTag BIT= NULL,                  
 @CommentTag BIT= NULL,                   
 @ConversationTag BIT= NULL,              
 @StateId NVARCHAR(max)=NULL,              
 @StateGroupAccountId NVARCHAR(max)=NULL,              
 @ClassificationDetailId NVARCHAR(max)=NULL,              
 @ClientAttributeId INT= NULL,               
 @ClientAttributeValue NVARCHAR(MAX)= NULL,                
 --@SearchClient BIT = NULL,       
 @TextRep bit = NULL,    
 @TextCli bit = NULL,  
 @CaseType NVARCHAR(MAX) = NULL    
)        
 --with recompile    
  
 AS  
BEGIN             
          
SET NOCOUNT ON;                
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;              
                
  
                
DECLARE                 
        @SQL NVARCHAR(MAX),                
        @SELECT NVARCHAR(MAX),                
        @FROM NVARCHAR(MAX),                
        @WHERE NVARCHAR(MAX),                
        @ORDERBY NVARCHAR(MAX),                
        @PARMDEFINITION NVARCHAR(MAX),                
        @FROM1 NVARCHAR(MAX),                
        @WHERE1 NVARCHAR(MAX),          
        @SELECT_FINAL  NVARCHAR(MAX),          
        @SELECT_PRIMER_ULTIMO  NVARCHAR(MAX)            
                    
         
   /*                 
  IF OBJECT_ID('tempdb..#tmpInter2') IS NOT NULL        
                  drop table #tmpInter2        
         
CREATE TABLE #tmpInter2(        
      [StateName] [nvarchar](max) NULL,        
      [StateId] [int] NULL,        
      [CaseId] [int] NOT NULL,        
      [TTL] [int] NOT NULL,        
      [StateTypeId] [int] NULL,        
      [StateTypeDescrip] [nvarchar](max) NULL,        
      [GroupAccountName] [varchar](200) NOT NULL,        
      [AttentionQueueId] [int] NULL,        
      [AttentionQueueName] [nvarchar](max) NULL,        
      [UserId] [int] NULL,        
      [UserName] [nvarchar](101) NULL,        
      [UserPlaceId] [int] NULL,        
      [UserPlaceName] [varchar](250) NULL,        
      [UserActiveFlag] [bit] NULL,        
      [CaseCreated] [datetime] NOT NULL,        
      [CaseModifiedDate] [datetime] NOT NULL,        
      [ServiceChannelId] [int] NOT NULL,        
      [SCName] [varchar](250) NOT NULL,        
      [SCInternalCode] [int] NOT NULL,        
      [UCUserName] [varchar](max) NULL,        
      [GroupAccountId] [int] NOT NULL,        
      [AccountId] [int] NOT NULL,        
      [AccountTypeId] [int] NOT NULL,        
      [ClassificationDetailId] [int] NULL,        
      [E0] [nvarchar](max) NULL,        
      [E1] [nvarchar](max) NULL,        
      [E2] [nvarchar](max) NULL,        
      [E3] [nvarchar](max) NULL,        
      [E4] [nvarchar](max) NULL,        
      [E5] [nvarchar](max) NULL,        
      [E6] [nvarchar](max) NULL,        
      [E7] [nvarchar](max) NULL,        
      [E8] [nvarchar](max) NULL,        
      [E9] [nvarchar](max) NULL,        
      [CantidadEscalamiento] [int] NOT NULL,        
      [FechaCierre] [datetime] NULL,        
      [UsuarioCierre] [nvarchar](50) NULL,        
      [Followers] [int] NOT NULL,        
      [ClientLastName] [nvarchar](max) NULL,        
      [ClientFirstName] [nvarchar](max) NULL,        
      [ClientObservation] [nvarchar](max) NULL,        
      [ClientId] [int] NULL,        
      [TagsCase] [nvarchar](max) NULL,        
      [CommentRootPostMarca] [varchar](max) NULL,        
      [ClientInformation] [varchar](max) NULL,  
   )  */       
           
              
SET @PARMDEFINITION  = N' @PAccountType INT,                
        @PAccount INT,            
        @PGroupAccount NVARCHAR(MAX),                
        @PAccountDetail NVARCHAR(MAX),                
        @PStartDate DATETIME,                
        @PEndDate DATETIME,             
        @PPlaceId NVARCHAR(MAX),                
        @PQueue NVARCHAR(MAX),                
        @PUsers NVARCHAR(MAX),                 
        @PSendingUser NVARCHAR(MAX),                 
        @PCommentText NVARCHAR(MAX),                
        @PTagList NVARCHAR(MAX),             
        @PStateId NVARCHAR(max),            
        @PStateGroupAccountId NVARCHAR(max),            
        @PClassificationDetailId NVARCHAR(max) ,            
        @PClientAttributeId INT,            
        @PClientAttributeValue NVARCHAR(MAX),  
  @PCaseType NVARCHAR(MAX) '                
         
declare @ParamStartDate datetime        
declare @ParamEndDate datetime        
         
SET @ParamStartDate = (dateadd(day, datediff(day, '2000-01-01', @StartDate), '2000-01-01'))          
         
SET @ParamEndDate = dateadd(ms,-3,dateadd(day,+1,@EndDate))                
        
---------------------------CAMBIOS 30/05/2017-------------            
SET @SendingUser=RTRIM(LTRIM(@SendingUser))           
            
IF @SendingUser = ''           
  SET @SendingUser= NULL            
            
SET @CommentText=RTRIM(LTRIM(@CommentText))        
            
IF @CommentText = ''         
  SET @CommentText= NULL            
----------------------------------------------------              
         
SET @SQL= 'SET NOCOUNT ON;                
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;                
                
                 
  CREATE TABLE #State         
  (        
      StateId INT        
      ,StateName NVARCHAR(MAX)        
      ,StateTypeId INT        
  )        
                      
  INSERT INTO #State                
  SELECT S.StateId,                
   S.StateName,                
   S.StateTypeId                 
  FROM [Config].[State] S         
  INNER JOIN Config.StateGroup SG ON S.StateGroupId = SG.StateGroupId        
  WHERE SG.AccountTypeId = @PAccountType --filtro por empresa                  
          
  INSERT INTO #STATE  (StateId,StateName,StateTypeId)         
 SELECT  0,NULL,0              
        
 CREATE TABLE #TStateType        
    (        
            StateTypeId INT        
            ,StateTypeDescrip NVARCHAR(MAX)        
    )         
                     
  INSERT INTO #TStateType                  
  SELECT ST.StateTypeId,                  
   ST.StateTypeDescrip                   
  FROM [Config].[StateType] ST                  
              
  INSERT INTO #TStateType        
  SELECT 0, NULL        
        
        
  '             
             
 IF @GroupAccount IS NOT NULL           
 BEGIN            
 SET @SQL= @SQL + '         
            Declare @x XML         
            CREATE TABLE #GGroupAccount (valor int)             
                  
                    
            Select @x = cast(''<A>''+ replace(@PGroupAccount,'','',''</A><A>'')+ ''</A>'' as xml)        
            INSERT INTO #GGroupAccount          
            Select t.value(''.'', ''int'') as inVal        
            from @x.nodes(''/A'') as x(t)        
                    
            /**EXEC [Config].[convertStringToTable] @PGroupAccount     **/        
      '             
 END      
   
      
         
 SET @SQL= @SQL+ '     
  
  
SELECT  
C.CaseId  
into #TmpCase0  
      FROM [MC].[Case] C        
        INNER JOIN [Config].[GroupAccount] GA   
   ON GA.GroupAccountId=C.GroupAccountId            
  INNER JOIN [Config].[AccountDetail] AD   
   ON AD.AccountDetailId= C.AccountDetailId                      
  INNER JOIN [Config].[Account] AC   
   ON AC.AccountId=AD.AccountId                      
  INNER JOIN [Config].[AccountType] AT   
   ON AT.AccountTypeId= AC.AccountTypeId                      
WHERE GA.AccountId = @PAccount    
        AND (C.CaseCreated BETWEEN @PStartDate AND @PEndDate)   
  AND AT.AccountTypeId=@PAccountType   
  AND AC.AccountId=@PAccount     
--and UserAssignedId IS NULL  
  
  
     
      CREATE TABLE #TmpCase        
      (        
            CaseId INT        
            ,StateId INT        
            --,ClientId INT        
            --,ClientLastName NVARCHAR(MAX)        
            --,ClientFirstName NVARCHAR(MAX)        
            --,ClientObservation NVARCHAR(MAX)        
            ,CaseCreated DATETIME        
            ,CaseModifiedDate DATETIME        
            ,GroupAccountId INT        
            ,FechaCierre DATETIME        
            ,ClassificationDetailId INT        
            ,AccountDetailId INT         
            ,UserChannelId INT        
            ,ElementTypeId INT         
            ,UserAssignedId INT        
            ,AttentionQueueId INT        
            ,CaseClosureUserId INT        
            ,RootPostId INT        
            ,TagsCase NVARCHAR(MAX)        
            ,ConversationId INT        
            ,AccountId INT  
   ,CaseTypeId int        
      )      
      INSERT INTO #TmpCase        
      (        
            CaseId         
            ,StateId         
            --,ClientId         
            --,ClientLastName        
            --,ClientFirstName         
            --,ClientObservation         
            ,CaseCreated        
            ,CaseModifiedDate        
            ,GroupAccountId        
            ,FechaCierre         
            ,ClassificationDetailId         
            ,AccountDetailId         
            ,UserChannelId         
            ,ElementTypeId         
            ,UserAssignedId         
            ,AttentionQueueId         
            ,CaseClosureUserId         
            ,RootPostId         
            ,TagsCase         
            ,ConversationId        
            ,AccountId      
   ,CaseTypeId    
      )        
      SELECT         
             C.CaseId        
            ,ISNULL(C.StateId,0) as StateId        
            --,CL.ClientId        
         --,CL.ClientLastName        
            --,CL.ClientFirstName        
            --,CL.ClientObservation        
            ,C.CaseCreated        
            ,C.CaseModifiedDate        
            ,C.GroupAccountId        
            ,C.CaseClosureDate as FechaCierre        
            ,C.ClassificationDetailId        
            ,C.AccountDetailId        
            ,C.UserChannelId        
            ,C.ElementTypeId        
            ,C.UserAssignedId        
            ,C.AttentionQueueId        
            ,C.CaseClosureUserId        
            ,C.RootPostId        
            ,'''' AS TagsCase        
            ,C.ConversationId        
            ,GA.AccountId   
   ,C.CaseTypeId         
      FROM [MC].[Case] C  
      inner join #TmpCase0 a  
      on c.CaseId = a.CaseId    
            INNER JOIN [Config].[GroupAccount] GA ON GA.GroupAccountId=C.GroupAccountId        
            --INNER JOIN [MC].UserChannelAccount UCA ON UCA.UserChannelId=C.UserChannelId AND GA.AccountId = UCA.AccountId            
             --LEFT JOIN [MC].[Client] CL ON CL.ClientId = UCA.ClientId        
      '        
         
      IF @GroupAccount IS NOT NULL            
      BEGIN            
            SET @SQL = @SQL + ' INNER JOIN #GGroupAccount GAC ON GAC.valor=C.GroupAccountId                                              '            
      END             
         
     ----------------------------------------BUSQUEDA POR TEXTO-----------------------------------------    
  IF @CommentText IS NOT NULL        
  BEGIN         
   SET @SQL = @SQL + ' INNER JOIN [MC].[CaseComment] CC     
         ON C.CaseId = CC.CaseId     
         AND CC.CaseCommentText  LIKE ''%''+@PCommentText+''%''    
        INNER JOIN MC.ElementType et ON cc.ElementTypeId = et.ElementTypeId    
         '         
    
   IF @TextRep = 1 AND @TextCli = 0    
    SET @SQL = @SQL + ' AND et.ElementTypeOutput = 1'    
   ELSE    
   BEGIN    
    IF @TextRep = 0 AND @TextCli = 1    
     SET @SQL = @SQL + ' AND et.ElementTypeOutput = 0'    
    ELSE    
     SET @SQL = @SQL    
   END     
                
  END    
     ----------------------------------------------------------------------------------------------------                     
         
      SET @SQL= @SQL + ' WHERE GA.AccountId = @PAccount '        
         
      IF @DateTypeC = 1 AND @DateTypeM = 0 AND @DateTypeF = 0            
            SET @SQL = @SQL + ' AND (C.CaseCreated BETWEEN @PStartDate AND @PEndDate) ' ----FILTRA POR FECHA DE CREACI�N               
      ELSE            
       BEGIN            
        IF @DateTypeC = 0  AND @DateTypeM = 1 AND @DateTypeF = 0            
         SET @SQL = @SQL + ' AND (C.CaseModifiedDate BETWEEN @PStartDate AND @PEndDate) ' ----FILTRA POR FECHA DE MODIFICACI�N            
        ELSE            
         SET @SQL = @SQL + ' AND (C.CaseClosureDate BETWEEN @PStartDate AND @PEndDate) '  ----FILTRA POR FECHA DE CIERRE            
       END         
         
      --Cambio 23/10/2018 Se agregar la consulta de los tags por CaseId y se hace Join con la consulta principal           
      SET @SQL= @SQL+ '               
              
            CREATE NONCLUSTERED INDEX index_tmpCase ON #TmpCase (CaseId); --indice sobre la tmpcase temporal        
                  
              SELECT TC.CaseId, tag.TagName        
              INTO #TagsCase        
                  FROM config.Tag tag                    
                  INNER JOIN [MC].[CaseTag] CT ON tag.TagId = CT.TagId        
                  INNER JOIN #TmpCase TC ON TC.[CaseId] = CT.[CaseId] --** SOLO LOS TAGS DE CASOS FILTRADOS        
                    
              SELECT TC1.[CaseId]        
            ,TagsCase = STUFF((        
                          SELECT TG.TagName + '' / ''        
                          FROM #TagsCase TG        
                          WHERE tc1.[CaseId] = TG.[CaseId]        
                          FOR XML PATH('''')), 1, 0, '''')        
            INTO #TagsByCase     
            FROM  #TmpCase tc1        
            INNER JOIN [MC].[CaseTag] CT1 ON tc1.[CaseId] = CT1.[CaseId]        
                    
            DROP TABLE #TagsCase        
            '          
         
      SET @SQL= @SQL+ '        
            UPDATE C        
            SET C.TagsCase = TC.TagsCase        
            FROM #TmpCase C        
                  INNER JOIN #TagsByCase TC ON C.CaseId = TC.CaseId -- UPDATE SOBRE LA TMPCASE CON LOS TAGS QUE ENCONTRO        
      '        
           
      SET @SQL= @SQL+ '        
      SELECT CAT.CaseId, COUNT(CAT.CaseId) CantidadEscalamiento  ----CUENTA LAS VECES QUE SE ESCAL� UN CASO            
            INTO #CaseAction            
      FROM MC.CaseActionType CAT        
            INNER JOIN #TmpCase TC ON CAT.CaseId = TC.CaseId         
            WHERE ActionTypeCode= ''A000032''        
      GROUP BY CAT.CaseId        
      '        
         
      ----------------B�squeda por tag en casos, comentarios y conversaciones-                 
IF @TagList IS NOT NULL          
      BEGIN        
         
      IF (@CaseTag =0 AND @CommentTag=0 AND @ConversationTag=0)        
        BEGIN        
         SET @CaseTag=1        
         SET @CommentTag=1        
         SET @ConversationTag=1        
      END        
         
        DECLARE @WHERETAG NVARCHAR(MAX) = ' WHERE T.TagActiveFlag = 1 '        
        SET @SQL= @SQL+ '                
              CREATE TABLE #TTagList (valor nvarchar(MAX))        
              INSERT INTO #TTagList        
              EXEC [Config].[convertStringToTable] @PTagList                   
              --INSERT INTO #TTagList (valor) VALUES (1)        
                      
                
               CREATE TABLE #TagTotalF (tagid INT, tagname nvarchar(MAX), caseid int)               
               CREATE TABLE #TagTotal (tagid INT, tagname nvarchar(MAX), caseid int)                
               INSERT INTO #TagTotal                
               SELECT tagid,TagName, null         
               FROM Config.Tag t         
                        inner join #TTagList tt ON t.TagName COLLATE Modern_Spanish_CI_AI LIKE ''%''+tt.valor+''%'' COLLATE Modern_Spanish_CI_AI        
         '        
         
         IF(@GroupAccount IS NOT NULL)        
                  SET @SQL= @SQL + @WHERETAG + ' AND t.GroupAccountId IN (SELECT valor FROM #GGroupAccount)' --** FILTRO POR GRUPO DE CUENTAS        
         ELSE        
         BEGIN        
                  SET @WHERETAG = @WHERETAG + ' AND A.AccountId = @PAccount' -- ** FILTRO POR UNIDAD DE NEGOCIO        
                 SET @SQL= @SQL + ' INNER JOIN Config.GroupAccount A ON t.GroupAccountId = A.GroupAccountId ' + @WHERETAG                         
         END        
         
         
        IF @CaseTag =1                
        BEGIN                
         SET @SQL= @SQL+ '         
              INSERT INTO #TagTotalF -- ** SE CREA ESTA TABLA PORQUE SE DUCPLICABAN LOS REGISTROS EN EL JOIN        
              SELECT tt.tagid, tt.tagname, ct.CaseId         
              from #TagTotal tt         
              INNER JOIN MC.CaseTag ct ON tt.tagid=ct.TagId        
              INNER JOIN #TmpCase TC ON ct.CaseId = TC.CaseId --** JOIN CON LOS CASOS YA FILTRADOS        
        '        
        END              
                
        IF @CommentTag =1                
        BEGIN                
            SET @SQL= @SQL+ '                
            INSERT INTO #TagTotalF              
            SELECT tt.tagid, tt.tagname, cc.CaseId  
            from MC.CaseCommentTag cct         
            INNER JOIN #TagTotal tt ON tt.tagid=cct.TagId                
            INNER JOIN MC.CaseComment cc on cct.CaseCommentId=cc.CaseCommentId        
            INNER JOIN #TmpCase TC ON cc.CaseId = TC.CaseId--** JOIN CON LOS CASOS YA FILTRADOS        
            '         
        END              
                
        IF @ConversationTag =1                
        BEGIN                
            SET @SQL= @SQL+ '                  
            INSERT INTO #TagTotalF         
            SELECT tt.tagid, tt.tagname, C.caseid         
            from MC.ConversationTag ct         
            INNER JOIN #TagTotal tt ON tt.tagid=ct.TagId                
            INNER JOIN #TmpCase C ON C.ConversationId = ct.ConversationId--** JOIN CON LOS CASOS YA FILTRADOS        
            '         
        END              
                
        SET @SQL= @SQL+ '         
             CREATE TABLE #TagFinal (CaseId INT)            
             INSERT INTO #TagFinal            
             SELECT CaseId from #TagTotalF tt WHERE CaseId IS NOT NULL        
              '        
END        
           
IF @TagList IS NOT NULL                
BEGIN                
 SET @SQL= @SQL+ '                                     
                             DELETE FROM #TmpCase WHERE CaseId NOT IN(SELECT CaseId FROM #TagFinal) --**QUITA LOS CASE QUE NO ESTAN EN EL FILTRO DE TAGS        
                 '        
END          
         
           
 SET @SELECT=  '         
 SELECT    
 DISTINCT --CAMBIO 29-01-2019        
 S.[StateName]         
 ,S.[StateId]         
 ,Tmp.CaseId         
 ,GA.[GroupAccountReleaseCaseTime] AS TTL            
 ,ST1.StateTypeId        
 ,ST1.[StateTypeDescrip]        
 ,GA.GroupAccountName        
 ,A.[AttentionQueueId]        
 ,A.[AttentionQueueName]            
 ,U.[UserId]        
 ,(PersonFirstName + space(1)' + ' +PersonLastName)  as UserName            
 ,UP.[UserPlaceId]         
 ,UP.[UserPlaceName]        
 ,U.[UserActiveFlag]        
 ,Tmp.[CaseCreated]        
 ,Tmp.[CaseModifiedDate]            
 ,SC.[ServiceChannelId]        
 ,SC.[SCName]        
 ,SC.[SCInternalCode]          
 ,UC.[UCUserName]    
 ,UC.UCPublicationTo       
 ,Tmp.[GroupAccountId]        
 ,AC.[AccountId]    
 ,AD.AccountDetailSurveyId       
 ,AT.[AccountTypeId]        
 ,D.ClassificationDetailId        
 ,D.E0,D.E1,D.E2,D.E3,D.E4,D.E5,D.E6,D.E7,D.E8,D.E9        
 ,ISNULL(CAT.CantidadEscalamiento,0) CantidadEscalamiento         
 ,tmp.FechaCierre            
 ,U2.[UserName] as UsuarioCierre        
 ,ISNULL(UCD.UCDAux3,0) as Followers        
 ,cs.CSExpirationDate  
 ,Tmp.ClientLastName        
 ,Tmp.ClientFirstName        
 ,Tmp.ClientObservation        
 ,Tmp.ClientId        
 ,Tmp.TagsCase,         
 CASE            
 WHEN SC.[SCInternalCode] = 3 THEN FP.FPostMessage            
 WHEN SC.[SCInternalCode] = 2 THEN TWT.TPostMessage            
 END AS CommentRootPostMarca,   
 Tmp.CaseTypeId            
     '                
                 
SET @FROM= ' FROM #TmpCaseFinal Tmp             
LEFT JOIN [Config].[ClassificationDetail_PivotStatesTrees] D ON tmp.ClassificationDetailId=D.ClassificationDetailId                      
INNER JOIN [Config].[GroupAccount] GA ON GA.GroupAccountId=Tmp.GroupAccountId                      
INNER JOIN [Config].[AccountDetail] AD ON AD.AccountDetailId= Tmp.AccountDetailId                      
INNER JOIN [Config].[Account] AC ON AC.AccountId=AD.AccountId                      
INNER JOIN [Config].[AccountType] AT ON AT.AccountTypeId= AC.AccountTypeId                      
INNER JOIN [MC].UserChannel UC ON UC.UserChannelId =Tmp.UserChannelId                      
INNER JOIN [MC].[ElementType] ET ON ET.ElementTypeId = Tmp.ElementTypeId                  
INNER JOIN [Config].ServiceChannel SC ON SC.ServiceChannelId=UC.ServiceChannelId              
                
LEFT JOIN [Security].[User] U ON Tmp.UserAssignedId=U.UserId                     
LEFT JOIN [Security].[Person] P ON P.PersonId= U.PersonId                     
LEFT JOIN [Security].[UserPlace] UP ON UP.UserPlaceId=P.UserPlaceId                     
LEFT JOIN #State S ON Tmp.StateId = S.StateId                      
LEFT JOIN #TStateType ST1 ON ST1.StateTypeId = S.StateTypeId                     
LEFT JOIN [Config].[AttentionQueue] A ON A.AttentionQueueId=Tmp.AttentionQueueId          --Cambio 16/05/2018 Se mueve este JOIN al inicio de la creacion de la temporal para tener siempre el ClientId                  
LEFT JOIN #CaseAction CAT ON Tmp.CaseId=CAT.CaseId                     
LEFT JOIN [MC].[UserChannelDetail] UCD ON UCD.UserChannelId = Tmp.UserChannelId          --Cambio 28/3/2017 Se cambia la Tabla CaseComment por una tabla con solamente el primer Comentario de cada caso             
          
LEFT JOIN [Security].[User] U2 ON Tmp.CaseClosureUserId = U2.UserId          --Cambio 17/05/2018 Se obtiene el comentario raiz para Fb y Tw publicos                 
LEFT JOIN [Facebook].[Post] FP ON FP.FPostId = Tmp.RootPostId                 
LEFT JOIN [Twitter].[Post] TWT ON TWT.TPostID = Tmp.RootPostId    
  
LEFT JOIN [MC].[CaseSchedule] cs on cs.CSCaseId=tmp.CaseId         --Cambio 23/092019 se obtiene fecha de agendamiento  
    '                   
               
SET @SQL = @SQL +         
'             
      --SELECCIONA LOS DATOS DEL CLIENTE HACIENDO JOIN CON LOS CASOS YA FILTRADOS Y LO INSERTE EN #TmpCaseFinal        
      SELECT         
           TC.CaseId        
            ,TC.StateId        
            ,TC.CaseCreated        
            ,TC.CaseModifiedDate        
            ,TC.GroupAccountId        
            ,TC.FechaCierre        
            ,TC.ClassificationDetailId        
            ,TC.AccountDetailId        
            ,TC.UserChannelId        
            ,TC.ElementTypeId        
            ,TC.UserAssignedId        
            ,TC.AttentionQueueId        
            ,TC.CaseClosureUserId        
            ,TC.RootPostId        
            ,TC.TagsCase        
            ,TC.ConversationId        
            ,TC.AccountId        
            ,CL.ClientId        
            ,CL.ClientLastName        
            ,CL.ClientFirstName        
            ,CL.ClientObservation  
   ,TC.CaseTypeId          
      INTO #TmpCaseFinal        
      FROM #TmpCase TC        
      INNER JOIN [MC].UserChannelAccount UCA ON UCA.UserChannelId = TC.UserChannelId AND TC.AccountId = UCA.AccountId            
      LEFT JOIN [MC].[Client] CL ON CL.ClientId = UCA.ClientId        
            
      CREATE NONCLUSTERED INDEX index_TmpCaseFinal ON #TmpCaseFinal (CaseId);      
            
'        
         
--IF @SearchClient IS NOT NULL             
-- BEGIN            
--  SET @SQL= @SQL + '       
              
--  SELECT CAV.ClientId, CAV.Value, CA.ClientAttributeName            
--  INTO #TmpClientes            
--  FROM MC.Client CC            
--  INNER JOIN [MC].[ClientAttributeValue] CAV ON CC.ClientId = CAV.ClientId            
--  INNER JOIN [Config].ClientAttribute CA ON CA.ClientAttributeId = CAV.ClientAttributeId        
--  INNER JOIN #TmpCaseFinal TC ON  CC.ClientId = TC.ClientId --** HACE JOIN CON LOS CASOS YA FILTRADOS PARA TRAER LA INFO ADICIONAL DEL CLIENTE        
--  WHERE CC.AccountTypeId = @PAccountType        
--  --ORDER BY CAV.ClientId ASC            
            
--  CREATE TABLE #TpmInfo              
--  (              
--   ClientId   INT,              
--   ClientInfo   NVARCHAR(4000)              
--  );              
         
--  INSERT INTO #TpmInfo(ClientId,ClientInfo)            
--  SELECT ClientId, Value = STUFF((SELECT DISTINCT '', '' + b.ClientAttributeName + '', '' + Value            
--       FROM #TmpClientes b             
--       WHERE b.ClientId = a.ClientId             
--      FOR XML PATH('''')), 1, 2, '''')            
--  FROM #TmpClientes a            
--  GROUP BY ClientId            
              
--  ALTER TABLE #TmpCaseFinal ADD ClientInformation VARCHAR(MAX)        
            
--  UPDATE #TmpCaseFinal            
--  SET ClientInformation = TI.ClientInfo            
--  FROM #TpmInfo TI            
--  WHERE #TmpCaseFinal.ClientId = TI.ClientId        
--  '            
            
--  SET @SELECT=  @SELECT + ',Tmp.ClientInformation'            
                         
-- END            
             
SET @WHERE=' WHERE 1=1 '                
                
--Cambio 28/3/2017 Se quita condicion en el Where                 
SET @WHERE=  @WHERE + '  AND AT.AccountTypeId=@PAccountType AND AC.AccountId=@PAccount  '                
            
 -----------------------            
IF @ClassificationDetailId IS NOT NULL            
 BEGIN            
  SET @SQL= @SQL + ' CREATE TABLE #CClassificationDetailId (valor nvarchar(MAX))             
      INSERT INTO #CClassificationDetailId            
      EXEC [Config].[convertStringToTable] @PClassificationDetailId             
                   '            
  SET @FROM= @FROM + ' INNER JOIN  #CClassificationDetailId CCD ON CCD.valor=tmp.ClassificationDetailId             
                     '            
 END            
------------------------------            
                      
------------POR CADA PAR�METRO NO NULL, SE CREA UNA TABLA Y SE HACE INNER JOIN CON EL FROM-----------------------                
IF @AccountDetail IS NOT NULL         
 BEGIN                
 SET @SQL= @SQL + ' CREATE TABLE #AAccountDetail (valor int)                 
        INSERT INTO #AAccountDetail                
        EXEC [Config].[convertStringToTable] @PAccountDetail '              
    SET @FROM = @FROM + ' INNER JOIN  #AAccountDetail ADE ON ADE.valor=tmp.AccountDetailId '                
 END                
               
IF @SendingUser IS NOT NULL                 
  BEGIN                
 SET @WHERE= @WHERE + ' AND UC.[UCUserName] LIKE ''%'' + @PSendingUser + ''%'' '                
  END                
                
IF @Queue IS NOT NULL                
 BEGIN                
    SET @SQL= @SQL + ' CREATE TABLE #QQueue (valor nvarchar(MAX))                 
        INSERT INTO #QQueue                
        EXEC [Config].[convertStringToTable] @PQueue '                 
    SET @FROM = @FROM + ' INNER JOIN  #QQueue QU ON QU.valor=tmp.AttentionQueueId '                
 END                
             
IF @CaseType IS NOT NULL                
 BEGIN                
    SET @SQL= @SQL + ' CREATE TABLE #CCaseType (valor nvarchar(MAX))                 
        INSERT INTO #CCaseType                
        EXEC [Config].[convertStringToTable] @PCaseType '                 
    SET @FROM = @FROM + ' INNER JOIN  #CCaseType CT ON CT.valor=tmp.CaseTypeId '                
 END   
  
 IF @StateId IS NOT NULL AND @StateGroupAccountId IS NOT NULL            
  BEGIN         
    CREATE TABLE  #SSState (StateId INT)             
    INSERT INTO #SSState (StateId)           
          
    EXEC [Config].[convertStringToTable] @StateId              
    DECLARE @SinEstado INT = NULL            
    SELECT @SINESTADO =  StateId FROM #SSState WHERE StateId =0            
               
    SET @SQL= @SQL + ' CREATE TABLE  #SState (id INT IDENTITY(1,1) , StateId nvarchar(MAX))             
           INSERT INTO #SState (StateId)            
           EXEC [Config].[convertStringToTable] @PStateId            
                      
           CREATE TABLE  #SStateGroupAccountId (id INT IDENTITY(1,1) , StateGroupAccountId nvarchar(MAX))             
           INSERT INTO #SStateGroupAccountId (StateGroupAccountId)            
           EXEC [Config].[convertStringToTable] @PStateGroupAccountId            
                      
           CREATE TABLE #SFiltro (StateId  INT , StateGroupAccountId INT )             
       INSERT INTO #SFiltro            
           SELECT StateId,StateGroupAccountId            
           FROM #SState  s INNER JOIN #SStateGroupAccountId sg ON s.id=sg.id            
         '            
    IF @SinEstado IS NULL            
  SET @FROM = @FROM + ' INNER JOIN #SFiltro SF ON SF.StateId=S.StateId AND SF.StateGroupAccountId= GA.GroupAccountId '            
 ELSE            
  SET @FROM = @FROM + ' INNER JOIN #SFiltro SF ON SF.StateId=S.StateId '                  
            
  DROP TABLE #SSState            
 END            
            
IF @ClientAttributeId IS NOT NULL AND @ClientAttributeValue IS NOT NULL ---SE AGREGA LA BUSQUEDA POR ANI            
 BEGIN             
   SET @FROM = @FROM + ' INNER JOIN MC.ClientAttributeValue CAV ON CAV.ClientId=Tmp.ClientId '            
   SET @WHERE=@WHERE + ' AND CAV.ClientAttributeId=@PClientAttributeId AND CAV.Value=@PClientAttributeValue '            
 END            
             
 --SET @FROM1= @FROM ---EN FROM1 SE GUARDA EL FROM ANTES DEL INNER CON @PLACEID PARA OBTENER LOS CASOS SIN USUARIOS ASIGNADOS                
 --SET @WHERE1 = @WHERE + ' AND tmp.UserAssignedId IS NULL '                 
      
/*             
IF @PlaceId IS NOT NULL                 
 BEGIN                
    SET @SQL= @SQL + '         
               CREATE TABLE #PlaceId (valor nvarchar(MAX))               
               INSERT INTO #PlaceId        
           EXEC [Config].[convertStringToTable] @PPlaceId '                
 SET @FROM = @FROM + ' INNER JOIN  #PlaceId PI ON PI.valor= UP.UserPlaceId  '                
 END                
*/       
               
IF @Users IS NOT NULL                 
 BEGIN                
    SET @SQL= @SQL + ' CREATE TABLE #UUsers (valor nvarchar(MAX))                 
              INSERT INTO #UUsers                
              EXEC [Config].[convertStringToTable] @PUsers '                
 SET @FROM = @FROM + ' INNER JOIN  #UUsers US ON US.valor=tmp.UserAssignedId '                 
 END                    
----------------------------------------------------------------------------------------------------------           
          
SET @SELECT_PRIMER_ULTIMO = '        
  
SELECT CC.CaseCommentId, CC.CaseCommentText, CC.ElementTypeId, CC.CaseId, ET.ElementTypeOutput, CC.CreationDateLog  
INTO #CaseComment        
FROM MC.CaseComment CC        
INNER JOIN [MC].[ElementType] ET ON ET.[ElementTypeId] = CC.[ElementTypeId]        
INNER JOIN #tmpInter TC ON CC.CaseId = TC.CaseId --** JOIN CON LOS CASOS YA FILTRADOS, SE CREA LA #CaseComment SOLO CON LOS CASOS CARGADOS        
  
--        
SELECT CC.CaseCommentId, dcc.DCCPermlinkRoot, dcc.DCCTextEmailBody  
INTO #DetailCaseComment        
FROM [MC].[DetailCaseComment] dcc        
INNER JOIN #CaseComment cc ON dcc.CaseCommentId = cc.CaseCommentId --** SE CREA LA #DetailCaseComment SOLO CON LOS DATOS DE LA #CaseComment        
--WHERE dcc.DCCPermlinkRoot IS NULL        
--        
     
--SE TRABAJA CON LA #DetailCaseComment Y LA #CaseComment YA FILTRADA CONTRA LA #tmpInter(CASOS TAMBIEN FILTRADOS)        
CREATE TABLE #CaseCommentPrimer (CaseCommentId INT, CaseId INT, CaseCommentText NVARCHAR(MAX), DCCPermlinkRoot NVARCHAR(MAX), ElementTypeId INT, DCCTextEmailBody NVARCHAR(MAX), CreationDateLog datetime)              
INSERT INTO #CaseCommentPrimer               
SELECT CC.CaseCommentId,CaseID , left(CaseCommentText,32766) as CaseCommentText, DCC.DCCPermlinkRoot, CC.ElementTypeId, left(DCC.DCCTextEmailBody, 32766) as DCCTextEmailBody, Cc.CreationDateLog  
FROM #CaseComment Cc               
LEFT JOIN #DetailCaseComment DCC ON DCC.CaseCommentId=CC.CaseCommentId     
INNER JOIN (SELECT MIN(CaseCommentId) CaseCommentId                  
   FROM #CaseComment Cc                  
   WHERE cc.CaseId IN (Select CaseId From #tmpInter )                  
GROUP BY CaseId )           
AS MinCaseComment ON MinCaseComment.CaseCommentId = cc.CaseCommentId           
         
CREATE TABLE #CaseCommentB (CaseId INT,ElementTypeId INT,[ElementTypeOutput] INT )                      INSERT INTO #CaseCommentB                
SELECT CAC.CaseId, CAC.ElementTypeId, CAC.ElementTypeOutput                 
FROM #CaseComment CAC                            
INNER JOIN #tmpInter ca on ca.CaseId = cac.CaseId                 
WHERE CAC.CaseCommentId =(SELECT MAX(CAC1.CaseCommentId)           
         FROM #CaseComment CAC1           
         WHERE CAC1.CaseId = CAC.CaseId                     
         GROUP BY CAC1.CaseId) --** CAMBIAMOS UN ORDER BY POR UN MAX CON GROUP BY        
'        
          
               
SET @ORDERBY = ' ORDER BY i.Caseid option (recompile)'                
          
--IF @SearchClient IS NOT NULL             
--BEGIN                
-- SET @SELECT_FINAL = ' SELECT i.StateName ,i.[StateId] ,           
-- i.CaseId,           
-- i.TTL,           
-- ccb.[ElementTypeOutput],            
-- i.StateTypeId,i.[StateTypeDescrip],i.GroupAccountName,i.[AttentionQueueId],i.[AttentionQueueName]                      
-- ,i.[UserId],                            
-- i.UserName,                       
-- i.[UserPlaceId] ,i.[UserPlaceName],i.[UserActiveFlag]           
-- ,i.[CaseCreated],i.[CaseModifiedDate]                      
-- ,i.[ServiceChannelId],i.[SCName],i.[SCInternalCode]           
-- ,ccp.ElementTypeId,ccp.DCCPermlinkRoot,ccp.CaseCommentText, ccp.DCCTextEmailBody                      
-- ,i.[UCUserName]    
-- ,i.UCPublicationTo      
-- ,i.[GroupAccountId],           
-- i.[AccountId]    
-- ,i.AccountDetailSurveyId    
-- ,i.[AccountTypeId],           
-- i.ClassificationDetailId,i.E0,i.E1,i.E2,i.E3,i.E4,i.E5,i.E6,i.E7,i.E8,i.E9,                      
-- CantidadEscalamiento ,            
-- i.FechaCierre,            
-- i.UsuarioCierre, i.Followers,i.CSExpirationDate, i.ClientLastName,                       
-- i.ClientFirstName, i.ClientObservation,                      
-- i.CommentRootPostMarca,           
-- i.ClientInformation ,i.ClientId, i.TagsCase, i.CaseTypeId,  
-- ccp.CreationDateLog         
-- FROM #tmpInter i            
-- INNER JOIN #CaseCommentPrimer ccp ON ccp.CaseId = i.CaseId           
-- INNER JOIN #CaseCommentB ccb ON ccb.CaseId = i.CaseId'          
--END              
--ELSE          
--BEGIN          
 SET @SELECT_FINAL = ' SELECT i.StateName ,i.[StateId] ,           
 i.CaseId,           
 i.TTL,           
 ccb.[ElementTypeOutput],            
 i.StateTypeId,i.[StateTypeDescrip],i.GroupAccountName,i.[AttentionQueueId],i.[AttentionQueueName]                      
 ,i.[UserId],                            
 i.UserName,                       
 i.[UserPlaceId] ,i.[UserPlaceName],i.[UserActiveFlag]           
 ,i.[CaseCreated],i.[CaseModifiedDate]                      
 ,i.[ServiceChannelId],i.[SCName],i.[SCInternalCode]           
 ,ccp.ElementTypeId,ccp.DCCPermlinkRoot,ccp.CaseCommentText, ccp.DCCTextEmailBody                        
 ,i.[UCUserName]    
 ,i.UCPublicationTo     
 ,i.[GroupAccountId],           
 i.[AccountId]    
 ,i.AccountDetailSurveyId                
 ,i.[AccountTypeId],           
 i.ClassificationDetailId,i.E0,i.E1,i.E2,i.E3,i.E4,i.E5,i.E6,i.E7,i.E8,i.E9,                      
 CantidadEscalamiento ,            
 i.FechaCierre,            
 i.UsuarioCierre, i.Followers,i.CSExpirationDate, i.ClientLastName,                       
 i.ClientFirstName, i.ClientObservation,                      
 i.CommentRootPostMarca, i.ClientId, i.TagsCase, i.CaseTypeId,  
 ccp.CreationDateLog  
 FROM #tmpInter i            
 INNER JOIN #CaseCommentPrimer ccp ON ccp.CaseId = i.CaseId           
 INNER JOIN #CaseCommentB ccb ON ccb.CaseId = i.CaseId'          
--END             
        
        
--Se elimina el UNION y se modifican la condición del where para tomar UserAssignedId NULL o NOT NULL segun corresponda 22/01/2019        
                
IF @CasesAssigned = 1 AND @CasesUnassigned = 0          
BEGIN      
      
 IF @PlaceId IS NOT NULL                 
 BEGIN                
  SET @SQL= @SQL +       
  '         
   CREATE TABLE #PlaceId (valor nvarchar(MAX))               
   INSERT INTO #PlaceId        
   EXEC [Config].[convertStringToTable] @PPlaceId       
  '                
  SET @FROM = @FROM + ' INNER JOIN  #PlaceId PI ON PI.valor= UP.UserPlaceId  '                
 END      
       
   SET @WHERE= @WHERE + ' AND tmp.UserAssignedId IS NOT NULL '        
   SET @SQL = @SQL + '' + @SELECT  + ' into #TmpInter ' + @FROM + @WHERE + @SELECT_PRIMER_ULTIMO + @SELECT_FINAL + @ORDERBY ---OBTIENE LA SELECCION SOLO DE LOS CASOS ASIGNADOS  END        
END      
        
IF @CasesAssigned = 0 AND @CasesUnassigned = 1          
BEGIN      
   SET @WHERE= @WHERE + ' AND tmp.UserAssignedId IS NULL '        
   SET @SQL = @SQL + '' + @SELECT +  ' INTO #tmpInter ' + @FROM + @WHERE + @SELECT_PRIMER_ULTIMO + @SELECT_FINAL + @ORDERBY ---OBTIENE LA SELECCION SOLO DE LOS CASOS NO ASIGNADOS       
END      
      
IF (@CasesAssigned=1 AND @CasesUnassigned=1)   
      OR (@CasesAssigned=0 AND @CasesUnassigned=0)        
BEGIN      
      
 IF @PlaceId IS NOT NULL                 
 BEGIN                
 SET @SQL= @SQL +       
 '         
  CREATE TABLE #PlaceId (valor nvarchar(MAX))               
  INSERT INTO #PlaceId        
  EXEC [Config].[convertStringToTable] @PPlaceId       
 '                
 SET @FROM = @FROM + ' LEFT JOIN  #PlaceId PI ON PI.valor= UP.UserPlaceId  '                
 END      
      
  SET @SQL = @SQL + @SELECT + ' into #TmpInter ' + @FROM + @WHERE + @SELECT_PRIMER_ULTIMO +  @SELECT_FINAL + @ORDERBY ---OBTIENE CASOS ASIGNADOS Y NO ASIGNADOS      
         
END       
               
 EXECUTE SP_EXECUTESQL                
 @SQL,                
 @PARMDEFINITION,             
 @PAccountType=@AccountType,                
 @PAccount =@Account,                
 @PGroupAccount =@GroupAccount,                
 @PAccountDetail= @AccountDetail,                
 @PStartDate = @ParamStartDate,                 
 @PEndDate = @ParamEndDate,                
 @PQueue= @Queue,                
 @PUsers= @Users,                
 @PPlaceId= @PlaceId,                    
 @PSendingUser= @SendingUser,                
 @PCommentText=@CommentText,                
 @PTagList= @TagList,            
 @PStateId= @StateId,            
 @PStateGroupAccountId= @StateGroupAccountId,            
 @PClassificationDetailId=@ClassificationDetailId,            
 @PClientAttributeId=@ClientAttributeId,            
 @PClientAttributeValue =@ClientAttributeValue,  
 @PCaseType = @CaseType               
        
END
GO
