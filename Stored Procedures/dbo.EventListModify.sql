SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EventListModify]
	@Id bigint = NULL,
	@OwnerId varchar(100),
	@StoreId bigint = NULL,
	@Title varchar(50),
	@Description varchar(500),
	@Date datetime2(0) = NULL,
	@ProuctLists dbo.ProductListTVP READONLY
AS
BEGIN
	
	DECLARE @Ids table( Id BIGINT NOT NULL); 

	MERGE dbo.EventList target
	USING (SELECT @ID as ID) source
	ON target.Id = source.Id
	WHEN MATCHED THEN
		UPDATE SET
			target.OwnerId = @OwnerId,
			target.StoreId = @StoreId,
			target.Title = @Title,
			target.[Description] = @Description,
			target.[Date] = @Date,
			target.Updated = GETUTCDATE()
	WHEN NOT MATCHED THEN
		INSERT (
			OwnerId,
			StoreId,
			Title,
			[Description],
			[Date],
			Created,
			Updated
		)
		VALUES (
			@OwnerId,
			@StoreId,
			@Title,
			@Description,
			@Date,
			GETUTCDATE(),
			GETUTCDATE()
		)
	OUTPUT INSERTED.Id
	INTO @Ids;

	DECLARE @EventListId bigint = (SELECT TOP 1 Id FROM @Ids);

	MERGE dbo.ProductList target
	USING @ProuctLists source
	ON target.Id = source.Id
	WHEN MATCHED THEN
		UPDATE SET
			target.OwnerId = @OwnerId,
			target.StoreId = @StoreId,
			target.EventListId = @EventListId,
			target.Title = source.Title,
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
			source.Title,
			GETUTCDATE(),
			GETUTCDATE()
		)
	WHEN NOT MATCHED BY SOURCE AND target.EventListId = @EventListId THEN
		 UPDATE SET
			target.EventListId = NULL;


	SELECT @EventListId;

END
GO
