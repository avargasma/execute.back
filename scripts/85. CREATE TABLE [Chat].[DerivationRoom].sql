
/****** Object:  Table [Chat].[DerivationRoom]    Script Date: 20/03/2020 10:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[DerivationRoom]') AND type in (N'U'))
BEGIN
CREATE TABLE [Chat].[DerivationRoom](
	[DerivationRoomId] [int] IDENTITY(1,1) NOT NULL,
	[CConfigId] [int] NOT NULL,
	[DerivationRoomGUID] [uniqueidentifier] NOT NULL,
	[DerivationRoomChatServer] [nvarchar](256) NOT NULL,
	[DerivationRoomCreatedDate] [datetime] NOT NULL,
	[DerivationRoomActiveFlag] [bit] NOT NULL,
	[DerivationRoomModifedDate] [datetime] NULL,
	[DerivationRoomModifiedByUserId] [int] NOT NULL,
	[DerivationRoomOrden] [int] NOT NULL,
 CONSTRAINT [PK_DerivationRoom] PRIMARY KEY CLUSTERED 
(
	[DerivationRoomId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[DF_DerivationRoom_DerivationRoomGUID]') AND type = 'D')
BEGIN
ALTER TABLE [Chat].[DerivationRoom] ADD  CONSTRAINT [DF_DerivationRoom_DerivationRoomGUID]  DEFAULT (newid()) FOR [DerivationRoomGUID]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[DF_DerivationRoom_DerivationRoomCreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [Chat].[DerivationRoom] ADD  CONSTRAINT [DF_DerivationRoom_DerivationRoomCreatedDate]  DEFAULT (getdate()) FOR [DerivationRoomCreatedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Chat].[DF_DerivationRoom_DerivationRoomActiveFlag]') AND type = 'D')
BEGIN
ALTER TABLE [Chat].[DerivationRoom] ADD  CONSTRAINT [DF_DerivationRoom_DerivationRoomActiveFlag]  DEFAULT ((1)) FOR [DerivationRoomActiveFlag]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Chat].[FK_DerivationRoom_Config]') AND parent_object_id = OBJECT_ID(N'[Chat].[DerivationRoom]'))
ALTER TABLE [Chat].[DerivationRoom]  WITH CHECK ADD  CONSTRAINT [FK_DerivationRoom_Config] FOREIGN KEY([CConfigId])
REFERENCES [Chat].[Config] ([CConfigId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Chat].[FK_DerivationRoom_Config]') AND parent_object_id = OBJECT_ID(N'[Chat].[DerivationRoom]'))
ALTER TABLE [Chat].[DerivationRoom] CHECK CONSTRAINT [FK_DerivationRoom_Config]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Chat].[FK_DerivationRoom_User]') AND parent_object_id = OBJECT_ID(N'[Chat].[DerivationRoom]'))
ALTER TABLE [Chat].[DerivationRoom]  WITH CHECK ADD  CONSTRAINT [FK_DerivationRoom_User] FOREIGN KEY([DerivationRoomModifiedByUserId])
REFERENCES [Security].[User] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Chat].[FK_DerivationRoom_User]') AND parent_object_id = OBJECT_ID(N'[Chat].[DerivationRoom]'))
ALTER TABLE [Chat].[DerivationRoom] CHECK CONSTRAINT [FK_DerivationRoom_User]
GO
