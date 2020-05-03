SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Config].[AccountServiceChannelLog]') AND type in (N'U'))
BEGIN

CREATE TABLE [Config].[AccountServiceChannelLog](
    [ASCLogId] [int] IDENTITY(1,1) NOT NULL,
	[ASCId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[ServiceChannelId] [int] NOT NULL,
	[ASCOnlineReports] [int] NOT NULL,
	[ASCActiveFlag] [bit] NOT NULL,
	[ASCCreated] [datetime] NOT NULL,
	[ASCModifiedDate] [datetime] NOT NULL,
	[ASCModifiedByUserId] [int] NOT NULL,
	[ASCTimeForSurvey] [int] NULL,
	[ASCTransactionTypeId] [int] NOT NULL,
 CONSTRAINT [PK_AccountServiceChannelLog] PRIMARY KEY CLUSTERED 
(
	[ASCLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

ALTER TABLE [Config].[AccountServiceChannelLog]  WITH CHECK ADD FOREIGN KEY([ASCTransactionTypeId])
REFERENCES [Config].[TransactionType] ([TransactionTypeId])
GO


