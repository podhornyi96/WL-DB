SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EventListGet]
	@SearchType INT, -- By Id = 1, By Params = 2 (with paging)
	@Title varchar(50) = NULL,
	@Skip INT = NULL,
	@Top INT = NULL,
	@OwnerId varchar(100) = NULL,
	@StoreId BIGINT = NULL,
	@IDs dbo.ListLong READONLY
AS
BEGIN
	
	create table #ids ( 
		ID bigint NOT NULL,
		TotalRows INT NULL
	);

	IF(@SearchType = 1)
		INSERT INTO #ids
			SELECT ID, 0 FROM dbo.EventList
			WHERE Id IN (SELECT ID FROM @IDs);

	IF(@SearchType = 2)
	BEGIN
		WITH EventListCTE AS(
			SELECT	el.ID,
					el.OwnerId,
					el.StoreId,
					el.Title,
					el.[Description],
					el.[Date],
					el.Created,
					el.Updated
			FROM EventList el
			WHERE el.Title LIKE '%' + @Title + '%' OR @Title IS NULL
			AND el.OwnerId = @OwnerId
			AND el.StoreId = @StoreId
		)

		INSERT INTO #ids
		SELECT	Id,
				tCountPeriods.CountPeriods AS TotalRows
		FROM EventListCTE
		CROSS JOIN (
			SELECT COUNT(*) AS CountPeriods 
			FROM EventListCTE
		) AS tCountPeriods
		ORDER BY EventListCTE.Created DESC
		OFFSET @Skip ROWS
		FETCH NEXT  @Top ROWS ONLY
	END

	SELECT	el.ID,
			el.OwnerId,
			el.StoreId,
			el.Title,
			el.[Description],
			el.[Date],
			el.Created,
			el.Updated
	FROM	dbo.EventList el
	WHERE	el.Id IN (SELECT Id FROM #ids)
	ORDER BY el.Created DESC

	SELECT	pl.EventListId as EventId,
			pl.Id,
			pl.OwnerId,
			pl.StoreId,
			pl.EventListId,
			pl.Title,
			pl.Created,
			pl.Updated
	FROM	dbo.ProductList pl
	WHERE	pl.EventListId IN (SELECT Id FROM #ids);

	SELECT TOP 1 TotalRows FROM #ids;

	IF OBJECT_ID('tempdb..#ids') IS NOT NULL
		DROP TABLE #ids

END
GO
