GO
IF NOT EXISTS(SELECT object_id FROM sys.columns 
          WHERE Name = N'CCNameClientSala'
          AND Object_ID = Object_ID(N'[Chat].[Config]'))
BEGIN
	ALTER TABLE Chat.Config ADD CCNameClientSala nvarchar(50) NULL;
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre clave del de la sala para hacer tareas particulares en el front del chat, como configuracion especial de css segun el valor configurado aqui, puede repetirse por sala.' , @level0type=N'SCHEMA',@level0name=N'Chat', @level1type=N'TABLE',@level1name=N'Config', @level2type=N'COLUMN',@level2name=N'CCNameClientSala'
END
 
