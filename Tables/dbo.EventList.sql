CREATE TABLE [dbo].[EventList]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[OwnerId] [varchar] (100) COLLATE Ukrainian_CI_AS NOT NULL,
[StoreId] [bigint] NULL,
[Title] [varchar] (50) COLLATE Ukrainian_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE Ukrainian_CI_AS NOT NULL,
[Created] [datetime2] (0) NOT NULL,
[Updated] [datetime2] (0) NOT NULL,
[Date] [datetime2] (0) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventList] ADD CONSTRAINT [PK_EventList] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventList] ADD CONSTRAINT [FK_EventList_Store] FOREIGN KEY ([StoreId]) REFERENCES [dbo].[Store] ([Id])
GO
