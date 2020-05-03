IF NOT EXISTS (SELECT 1 FROM [MC].[ErrorResponse] WHERE [ErrorResponseInternalCode] = 285)
BEGIN
INSERT INTO [MC].[ErrorResponse]
           ([ErrorResponseDescrip]
           ,[ErrorResponseInternalCode]
           ,[ErrorResponseActiveFlag]
           ,[ErrorResponseCreated])
     VALUES
           ('El valor introducido en el campo {[campo_1]} debe ser 1 o 0.'
           ,285
           ,'True'
           ,GETDATE()
		   )
END