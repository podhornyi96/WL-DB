SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProductListGet]
	@SearchType INT, -- By Id = 1, By Params = 2 (with paging)
	@Title varchar(50) = NULL,
	@EventListId INT = NULL,
	@OwnerId varchar(100) = NULL,
	@StoreId bigint = NULL,
	@Skip INT = NULL,
	@Top INT = NULL,
	@IDs dbo.ListLong READONLY
AS
BEGIN
	
	create table #ids ( 
		ID bigint NOT NULL,
		TotalRows INT NOT NULL
	);

	IF(@SearchType = 1)
		INSERT INTO #ids
			SELECT ID, 0 FROM dbo.ProductList
			WHERE Id IN (SELECT ID FROM @IDs);

	IF(@SearchType = 2)
	BEGIN
		WITH EventListCTE AS(
			SELECT	pl.ID,
					pl.OwnerId,
					pl.StoreId,
					pl.EventListId,
					pl.Title,
					pl.Created,
					pl.Updated
			FROM ProductList pl
			WHERE (pl.Title LIKE '%' + @Title + '%' OR @Title IS NULL)
			AND pl.OwnerId = @OwnerId
			AND pl.StoreId = @StoreId
			AND (
				pl.EventListId = @EventListId OR pl.EventListId IS NULL
			)
		)

		INSERT INTO #ids
		SELECT	Id,
				tCountPeriods.CountPeriods AS TotalRows
		FROM EventListCTE
		CROSS JOIN (
			SELECT COUNT(*) AS CountPeriods 
			FROM EventListCTE
		) AS tCountPeriods
		ORDER BY ID
		OFFSET @Skip ROWS
		FETCH NEXT  @Top ROWS ONLY
	END

	SELECT	pl.ID,
			pl.OwnerId,
			pl.StoreId,
			pl.EventListId,
			pl.Title,
			pl.Created,
			pl.Updated
	FROM	dbo.ProductList pl
	WHERE	pl.Id IN (SELECT Id FROM #ids)
	ORDER BY pl.Created ASC

	SELECT	pl.ProductListId as ProdListId,
			pl.ProductListId,
			pl.ProductId,
			pl.VariantId
	FROM	dbo.Product pl
	WHERE	pl.ProductListId IN (SELECT Id FROM #ids);

	SELECT TOP 1 TotalRows FROM #ids;

	IF OBJECT_ID('tempdb..#ids') IS NOT NULL
		DROP TABLE #ids

END
GO
