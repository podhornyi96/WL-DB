SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProductListDelete]
	@IDs dbo.ListLong READONLY
AS
BEGIN
	
	DELETE FROM dbo.ProductList
	WHERE Id IN (SELECT Id FROM @IDs)

END
GO
