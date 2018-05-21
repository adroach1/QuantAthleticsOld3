﻿/*
Deployment script for AdminSite.Database.Sql.QaDbContext

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "AdminSite.Database.Sql.QaDbContext"
:setvar DefaultFilePrefix "AdminSite.Database.Sql.QaDbContext"
:setvar DefaultDataPath "C:\Users\adroa_000\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"
:setvar DefaultLogPath "C:\Users\adroa_000\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO

IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Dropping [dbo].[FK_dbo.AthleteAccounts_dbo.Users_UserId]...';


GO
ALTER TABLE [dbo].[AthleteAccounts] DROP CONSTRAINT [FK_dbo.AthleteAccounts_dbo.Users_UserId];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Starting rebuilding table [dbo].[Users]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Users] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [Username]      NVARCHAR (150) NULL,
    [PasswordHash]  NVARCHAR (150) NULL,
    [EmailAddress]  NVARCHAR (500) NULL,
    [FirstName]     NVARCHAR (150) NULL,
    [LastName]      NVARCHAR (150) NULL,
    [LastModified]  DATETIME       NULL,
    [TempSessionId] NVARCHAR (500) NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo.Users1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Users])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Users] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Users] ([Id], [Username], [EmailAddress], [FirstName], [LastName], [LastModified], [TempSessionId])
        SELECT   [Id],
                 [Username],
                 [EmailAddress],
                 [FirstName],
                 [LastName],
                 [LastModified],
                 [TempSessionId]
        FROM     [dbo].[Users]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Users] OFF;
    END

DROP TABLE [dbo].[Users];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Users]', N'Users';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo.Users1]', N'PK_dbo.Users', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[FK_dbo.AthleteAccounts_dbo.Users_UserId]...';


GO
ALTER TABLE [dbo].[AthleteAccounts] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.AthleteAccounts_dbo.Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[AthleteAccounts] WITH CHECK CHECK CONSTRAINT [FK_dbo.AthleteAccounts_dbo.Users_UserId];


GO
PRINT N'Update complete.';


GO