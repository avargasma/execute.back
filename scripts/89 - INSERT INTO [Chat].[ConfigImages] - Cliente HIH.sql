
DECLARE @configId int; 
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
SET @configId = null; ----------------ATENCION!: MODIFICAR POR EL ID DE LA SALA CORRESPONDIENTE----------------



INSERT INTO [Chat].[ConfigImages]
           ([CConfigId]
           ,[CImageId]
           ,[CConfigImagesInternalCode]
           ,[CConfigImagesActiveFlag]
           ,[CImageDescription])
     VALUES
           (@configId
           ,18
           ,1
           ,1
           ,'Favicon hih')

INSERT INTO [Chat].[ConfigImages]
           ([CConfigId]
           ,[CImageId]
           ,[CConfigImagesInternalCode]
           ,[CConfigImagesActiveFlag]
           ,[CImageDescription])
     VALUES
           (@configId
           ,19
           ,1
           ,1
           ,'Burbuja chat hih')

INSERT INTO [Chat].[ConfigImages]
           ([CConfigId]
           ,[CImageId]
           ,[CConfigImagesInternalCode]
           ,[CConfigImagesActiveFlag]
           ,[CImageDescription])
     VALUES
           (@configId
           ,20
           ,1
           ,1
           ,'Logo notificaciones hih')


