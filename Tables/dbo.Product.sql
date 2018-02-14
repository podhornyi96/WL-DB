CREATE TABLE [dbo].[Product]
(
[ProductListId] [bigint] NOT NULL,
[ProductId] [bigint] NOT NULL,
[VariantId] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_ProductList] FOREIGN KEY ([ProductListId]) REFERENCES [dbo].[ProductList] ([Id]) ON DELETE CASCADE
GO
