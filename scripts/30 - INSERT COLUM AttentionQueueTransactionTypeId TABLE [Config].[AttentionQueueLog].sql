IF NOT EXISTS(SELECT * FROM sys.columns 
WHERE Name = N'AttentionQueueTransactionTypeId'
AND Object_ID = Object_ID(N'[Config].[AttentionQueueLog]'))
BEGIN
ALTER TABLE [Config].[AttentionQueueLog]
ADD AttentionQueueTransactionTypeId INT NULL 
END
GO

IF  EXISTS (SELECT *  FROM sys.foreign_keys where name = 'FK_AttentionQueueLog_TransactionType')
BEGIN
ALTER TABLE [Config].[AttentionQueueLog]
DROP CONSTRAINT FK_AttentionQueueLog_TransactionType;
END
GO

ALTER TABLE [Config].[AttentionQueueLog] 
ADD CONSTRAINT FK_AttentionQueueLog_TransactionType 
FOREIGN KEY (AttentionQueueTransactionTypeId) REFERENCES [Config].[TransactionType](TransactionTypeId);
GO

