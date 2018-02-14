CREATE TABLE [dbo].[ProductList]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[OwnerId] [varchar] (100) COLLATE Ukrainian_CI_AS NOT NULL,
[StoreId] [bigint] NULL,
[EventListId] [bigint] NULL,
[Title] [varchar] (50) COLLATE Ukrainian_CI_AS NOT NULL,
[Created] [datetime2] (0) NOT NULL,
[Updated] [datetime2] (0) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProductList] ADD CONSTRAINT [PK_ProductList] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProductList] ADD CONSTRAINT [FK_ProductList_EventList] FOREIGN KEY ([EventListId]) REFERENCES [dbo].[EventList] ([Id]) ON DELETE SET NULL
GO
ALTER TABLE [dbo].[ProductList] ADD CONSTRAINT [FK_ProductList_Store] FOREIGN KEY ([StoreId]) REFERENCES [dbo].[Store] ([Id])
GO
