SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[StoreModify] 
	@Id bigint = NULL,
	@Nonce varchar(100),
	@Host varchar(100),
	@Code varchar(100) = NULL,
	@AccessToken varchar(100) = NULL,
	@Options bigint
AS
BEGIN
	
	DECLARE @Ids table( Id bigint); 

	MERGE dbo.Store target
	USING (SELECT @ID as ID) source
	ON target.Id = source.Id
	WHEN MATCHED THEN
		UPDATE SET
			target.Nonce = @Nonce,
			target.Host = @Host,
			target.Code = @Code,
			target.AccessToken = @AccessToken,
			target.Options = @Options,
			target.Updated = GETUTCDATE()
	WHEN NOT MATCHED THEN
		INSERT (
			Nonce,
			Host,
			Code,
			AccessToken,
			Options,
			Created,
			Updated
		)
		VALUES (
			@Nonce,
			@Host,
			@Code,
			@AccessToken,
			@Options,
			GETUTCDATE(),
			GETUTCDATE()
		)
	OUTPUT INSERTED.Id
	INTO @Ids;

	SELECT TOP 1 Id FROM @Ids;

END
GO
