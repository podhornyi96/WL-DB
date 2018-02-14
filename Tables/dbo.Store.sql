CREATE TABLE [dbo].[Store]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[Nonce] [varchar] (100) COLLATE Ukrainian_CI_AS NOT NULL,
[Host] [varchar] (100) COLLATE Ukrainian_CI_AS NOT NULL,
[Code] [varchar] (500) COLLATE Ukrainian_CI_AS NULL,
[AccessToken] [varchar] (500) COLLATE Ukrainian_CI_AS NULL,
[Options] [bigint] NOT NULL,
[Created] [datetime2] (0) NOT NULL,
[Updated] [datetime2] (0) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Store] ADD CONSTRAINT [PK_Store] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
