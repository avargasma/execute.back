IF NOT EXISTS(SELECT * FROM sys.columns 
          WHERE Name = N'ReplyToCaseCommentId'
          AND Object_ID = Object_ID(N'[MC].[CaseComment]'))
BEGIN
ALTER TABLE MC.CaseComment ADD ReplyToCaseCommentId INT NULL

ALTER TABLE MC.CaseComment ADD CONSTRAINT
	FK_CaseComment_ReplyToCaseCommentId FOREIGN KEY
	(
	ReplyToCaseCommentId
	) REFERENCES MC.CaseComment
	(
	CaseCommentId
	)
END