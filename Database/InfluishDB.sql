-- ====================================================================
--  InfluishDB.sql
--  Influish Admin Panel — Database & Table Creation Script
--
--  HOW TO RUN THIS SCRIPT:
--  1. Open SQL Server Management Studio (SSMS)
--  2. Connect to your SQL Server instance
--  3. Click  File > Open > File...  and select this .sql file
--  4. Press F5 (or click Execute) to run
--
--  NOTE: Run this script ONCE. If you run it again, it will fail
--        because the database/tables already exist.
-- ====================================================================

-- ─────────────────────────────────────────────────────────────────────
--  STEP 1: Create the Database
-- ─────────────────────────────────────────────────────────────────────
CREATE DATABASE InfluishDB;
GO

-- ─────────────────────────────────────────────────────────────────────
--  STEP 2: Switch to the new database
-- ─────────────────────────────────────────────────────────────────────
USE InfluishDB;
GO

-- ====================================================================
--  TABLE 1 : Users
--  Purpose  : Stores all registered users on the platform.
--             Each user is either an Influencer or an Advertiser.
--  Used by  : Admin > Manage Users page
-- ====================================================================
CREATE TABLE Users
(
    UserID     INT           IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment ID
    FullName   NVARCHAR(100) NOT NULL,                   -- Full display name
    Email      NVARCHAR(150) NOT NULL UNIQUE,            -- Unique email address
    Role       NVARCHAR(20)  NOT NULL,                   -- 'Influencer' or 'Advertiser'
    Status     NVARCHAR(20)  NOT NULL DEFAULT 'Active',  -- 'Active' or 'Inactive'
    JoinedDate DATE          NOT NULL DEFAULT GETDATE()  -- Date of registration
);
GO

-- ====================================================================
--  TABLE 2 : Campaigns
--  Purpose  : Stores all marketing campaigns created by Advertisers.
--  Used by  : Admin > Manage Campaigns page
-- ====================================================================
CREATE TABLE Campaigns
(
    CampaignID   INT           IDENTITY(1,1) PRIMARY KEY, -- Auto-increment ID
    CampaignName NVARCHAR(200) NOT NULL,                  -- Name of the campaign
    Advertiser   NVARCHAR(150) NOT NULL,                  -- Advertiser company name
    Category     NVARCHAR(100) NULL,                      -- e.g. 'Fashion & Apparel'
    Budget       DECIMAL(12,2) NOT NULL DEFAULT 0,        -- Budget in rupees
    Applicants   INT           NOT NULL DEFAULT 0,        -- Number of applicants
    Status       NVARCHAR(20)  NOT NULL DEFAULT 'Pending',-- 'Active','Pending','Deactivated'
    CreatedDate  DATE          NOT NULL DEFAULT GETDATE() -- Date campaign was created
);
GO

-- ====================================================================
--  TABLE 3 : Reports
--  Purpose  : Stores user-submitted reports and support messages.
--  Used by  : Admin > Reports & Support page
-- ====================================================================
CREATE TABLE Reports
(
    ReportID   INT           IDENTITY(1,1) PRIMARY KEY, -- Auto-increment ID
    ReportType NVARCHAR(20)  NOT NULL,                  -- 'Report' or 'Support'
    Subject    NVARCHAR(300) NOT NULL,                  -- Subject / short description
    ReportedBy NVARCHAR(150) NOT NULL,                  -- Username who submitted
    ReportDate DATE          NOT NULL DEFAULT GETDATE(),-- Date submitted
    Priority   NVARCHAR(20)  NOT NULL DEFAULT 'Medium', -- 'High', 'Medium', or 'Low'
    Status     NVARCHAR(20)  NOT NULL DEFAULT 'Pending' -- 'Pending','In Review','Resolved'
);
GO


-- ====================================================================
--  HOW TO VERIFY TABLES WERE CREATED
--
--  After running this script in SSMS:
--  1. In SSMS Object Explorer, expand: Databases > InfluishDB > Tables
--  2. You should see: dbo.Users, dbo.Campaigns, dbo.Reports
--  3. Right-click any table > Select Top 1000 Rows to confirm structure
-- ====================================================================

-- ====================================================================
--  HOW TO CONNECT THIS DATABASE TO YOUR ASP.NET PROJECT
--
--  In Web.config, the connection string is already set to:
--    Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=InfluishDB
--
--  If you use SQL Server Express instead, change to:
--    Data Source=.\SQLEXPRESS;Initial Catalog=InfluishDB
-- ====================================================================
