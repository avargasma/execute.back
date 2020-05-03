IF NOT EXISTS(SELECT * FROM sys.columns 
          WHERE Name = N'EnableReplyToComment'
          AND Object_ID = Object_ID(N'[MC].[ElementType]'))
BEGIN
ALTER TABLE MC.ElementType ADD EnableReplyToComment BIT NOT NULL
	CONSTRAINT DF_ElementType_EnableReplyToComment DEFAULT (0)
END