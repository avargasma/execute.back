


--[AttentionQueueByCharQuantityCreated]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[DF_AttentionQueueByCharQuantity_AttentionQueueByCharQuantityCreated]') AND type = 'D')
BEGIN

	ALTER TABLE [Config].[AttentionQueueByCharQuantity]
	ADD  CONSTRAINT [DF_AttentionQueueByCharQuantity_AttentionQueueByCharQuantityCreated]  
	DEFAULT (GETDATE()) FOR [AttentionQueueByCharQuantityCreated]

END


--[AttentionQueueByCharQuantityModifiedDate]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[DF_AttentionQueueByCharQuantity_AttentionQueueByCharQuantityModifiedDate]') AND type = 'D')
BEGIN

	ALTER TABLE [Config].[AttentionQueueByCharQuantity]
	ADD  CONSTRAINT [DF_AttentionQueueByCharQuantity_AttentionQueueByCharQuantityModifiedDate]  
	DEFAULT (GETDATE()) FOR [AttentionQueueByCharQuantityModifiedDate]

END


--[AttentionQueueByCharQuantityActiveFlag]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[DF_AttentionQueueByCharQuantity_AttentionQueueByCharQuantityActiveFlag]') AND type = 'D')
BEGIN

	ALTER TABLE [Config].[AttentionQueueByCharQuantity]
	ADD  CONSTRAINT [DF_AttentionQueueByCharQuantity_AttentionQueueByCharQuantityActiveFlag]  
	DEFAULT ((1)) FOR [AttentionQueueByCharQuantityActiveFlag]

END
