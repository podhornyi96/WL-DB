SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[StoreGet]
	@SearchType INT,
	@Host varchar(100) = NULL,
	@IDs dbo.ListLong READONLY
AS
BEGIN
	
	create table #ids ( ID bigint NOT NULL );

	IF(@SearchType = 1)
		INSERT INTO #ids
			SELECT ID FROM dbo.Store
			WHERE Id IN (SELECT ID FROM @IDs);

	IF(@SearchType = 2)
		INSERT INTO #ids
			SELECT s.ID FROM dbo.Store s
			WHERE s.Host = @Host;

	SELECT	Id,
			Nonce,
			Host,
			Code,
			AccessToken,
			Options,
			Created,
			Updated
	FROM dbo.Store
	WHERE Id IN (SELECT ID FROM #ids)

	IF OBJECT_ID('tempdb..#ids') IS NOT NULL
    DROP TABLE #ids

END
GO
