IF NOT EXISTS (SELECT 1 FROM [MC].[ErrorResponse] WHERE [ErrorResponseInternalCode] = 286)
BEGIN
INSERT INTO [MC].[ErrorResponse]
           ([ErrorResponseDescrip]
           ,[ErrorResponseInternalCode]
           ,[ErrorResponseActiveFlag]
           ,[ErrorResponseCreated])
     VALUES
           ('Usted esta intentado enviar un texto no valido para el envío de Plantillas. Por favor seleccione un Plantilla y complete los campos correspondientes para iniciar el contacto con el cliente nuevamente.'
           ,286
           ,'True'
           ,GETDATE()
		   )
END
GO