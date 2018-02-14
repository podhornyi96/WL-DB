SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProductListModify]
	@Id bigint = NULL,
	@OwnerId varchar(100),
	@StoreId bigint,
	@EventListId bigint = NULL,
	@Title varchar(50),
	@Products dbo.ProductTvp READONLY
AS
BEGIN
	
	DECLARE @Ids table( Id bigint); 

	MERGE dbo.ProductList target
	USING (SELECT @ID as ID) source
	ON target.Id = source.Id
	WHEN MATCHED THEN
		UPDATE SET
			target.OwnerId = @OwnerId,
			target.StoreId = @StoreId,
			target.EventListId = @EventListId,
			target.Title = @Title,
			target.Updated = GETUTCDATE()
	WHEN NOT MATCHED THEN
		INSERT (
			OwnerId,
			StoreId,
			EventListId,
			Title,
			Created,
			Updated
		)
		VALUES (
			@OwnerId,
			@StoreId,
			@EventListId,
			@Title,
			GETUTCDATE(),
			GETUTCDATE()
		)
	OUTPUT INSERTED.Id
	INTO @Ids;

	DECLARE @ProductListId bigint = (SELECT TOP 1 Id FROM @Ids);

	MERGE dbo.Product as Target
	USING (
		SELECT	p.ProductId,
				p.[VariantId],
				@ProductListId as ProductListID
		FROM @Products p
	) as source ([ShopifyProductId], VariantId, ProductListID)
	ON (target.ProductListID = source.ProductListID) AND (target.ProductId = source.[ShopifyProductId])
	WHEN NOT MATCHED THEN
		INSERT (
			[ProductListID],
			ProductId,
			VariantId
		)
		VALUES (
			source.[ProductListID],
			source.[ShopifyProductId],
			source.VariantId
		)
	WHEN NOT MATCHED BY source AND target.ProductListID = @ProductListId
		THEN DELETE;

	SELECT @ProductListId; 

END
GO
