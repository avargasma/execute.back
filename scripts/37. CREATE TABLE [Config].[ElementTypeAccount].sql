/****** Object:  Table [Config].[ElementTypeAccount]    Script Date: 10/12/2019 9:25:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[ElementTypeAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [Config].[ElementTypeAccount](
	[ElementTypeAccountId] [int] IDENTITY(1,1) NOT NULL,
	[ElementTypeId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[ReplyToComments] [bit] NOT NULL,
	[ElementTypeAccountActiveFlag] [bit] NOT NULL,
	[ElementTypeAccountCreatedRow] [datetime] NOT NULL,
	[ElementTypeAccountModifiedByUserId] [int] NOT NULL,
	[ElementTypeAccountModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ElementTypeAccount] PRIMARY KEY CLUSTERED 
(
	[ElementTypeAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[DF_ElementTypeAccount_ReplyToComments]') AND type = 'D')
BEGIN
ALTER TABLE [Config].[ElementTypeAccount] ADD  CONSTRAINT [DF_ElementTypeAccount_ReplyToComments]  DEFAULT ((0)) FOR [ReplyToComments]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[DF_ElementTypeAccount_ElementTypeAccountActiveFlag]') AND type = 'D')
BEGIN
ALTER TABLE [Config].[ElementTypeAccount] ADD  CONSTRAINT [DF_ElementTypeAccount_ElementTypeAccountActiveFlag]  DEFAULT ((1)) FOR [ElementTypeAccountActiveFlag]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[DF_ElementTypeAccount_ElementTypeAccountCreatedRow]') AND type = 'D')
BEGIN
ALTER TABLE [Config].[ElementTypeAccount] ADD  CONSTRAINT [DF_ElementTypeAccount_ElementTypeAccountCreatedRow]  DEFAULT (getdate()) FOR [ElementTypeAccountCreatedRow]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[DF_ElementTypeAccount_ElementTypeAccountModifiedDate]') AND type = 'D')
BEGIN
ALTER TABLE [Config].[ElementTypeAccount] ADD  CONSTRAINT [DF_ElementTypeAccount_ElementTypeAccountModifiedDate]  DEFAULT (getdate()) FOR [ElementTypeAccountModifiedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Config].[FK_ElementTypeAccount_Account]') AND parent_object_id = OBJECT_ID(N'[Config].[ElementTypeAccount]'))
ALTER TABLE [Config].[ElementTypeAccount]  WITH CHECK ADD  CONSTRAINT [FK_ElementTypeAccount_Account] FOREIGN KEY([AccountId])
REFERENCES [Config].[Account] ([AccountId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Config].[FK_ElementTypeAccount_Account]') AND parent_object_id = OBJECT_ID(N'[Config].[ElementTypeAccount]'))
ALTER TABLE [Config].[ElementTypeAccount] CHECK CONSTRAINT [FK_ElementTypeAccount_Account]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Config].[FK_ElementTypeAccount_ElementType]') AND parent_object_id = OBJECT_ID(N'[Config].[ElementTypeAccount]'))
ALTER TABLE [Config].[ElementTypeAccount]  WITH CHECK ADD  CONSTRAINT [FK_ElementTypeAccount_ElementType] FOREIGN KEY([ElementTypeId])
REFERENCES [MC].[ElementType] ([ElementTypeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Config].[FK_ElementTypeAccount_ElementType]') AND parent_object_id = OBJECT_ID(N'[Config].[ElementTypeAccount]'))
ALTER TABLE [Config].[ElementTypeAccount] CHECK CONSTRAINT [FK_ElementTypeAccount_ElementType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Config].[FK_ElementTypeAccount_User]') AND parent_object_id = OBJECT_ID(N'[Config].[ElementTypeAccount]'))
ALTER TABLE [Config].[ElementTypeAccount]  WITH CHECK ADD  CONSTRAINT [FK_ElementTypeAccount_User] FOREIGN KEY([ElementTypeAccountModifiedByUserId])
REFERENCES [Security].[User] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Config].[FK_ElementTypeAccount_User]') AND parent_object_id = OBJECT_ID(N'[Config].[ElementTypeAccount]'))
ALTER TABLE [Config].[ElementTypeAccount] CHECK CONSTRAINT [FK_ElementTypeAccount_User]
GO
