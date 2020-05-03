IF  EXISTS(SELECT * FROM sys.columns WHERE Name = N'FCRetriesQuantityMax' AND Object_ID = Object_ID(N'[Facebook].[Config]')) 
	
BEGIN  
	return
end 

ALTER TABLE [Facebook].[Config] ADD  CONSTRAINT [DF__Config__FCRetrie__5E5695F7]  DEFAULT ((5)) FOR [FCRetriesQuantityMax]

