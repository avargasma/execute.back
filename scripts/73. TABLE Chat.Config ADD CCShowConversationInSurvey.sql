GO
IF NOT EXISTS(SELECT object_id FROM sys.columns 
          WHERE Name = N'CCShowConversationInSurvey'
          AND Object_ID = Object_ID(N'[Chat].[Config]'))
BEGIN
	ALTER TABLE Chat.Config ADD CCShowConversationInSurvey BIT NOT NULL DEFAULT(0);
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bandera para determinar si se muestra o no el boton para ver conversación del cliente.' , @level0type=N'SCHEMA',@level0name=N'Chat', @level1type=N'TABLE',@level1name=N'Config', @level2type=N'COLUMN',@level2name=N'CCShowConversationInSurvey'
END
 
