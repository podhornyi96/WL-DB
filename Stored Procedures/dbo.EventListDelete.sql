SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EventListDelete]
	@IDs dbo.ListLong READONLY
AS
BEGIN
	
	DELETE FROM dbo.EventList
	WHERE Id IN (SELECT Id FROM @IDs)

END
GO
