-- ====================================================================
--  InfluishDB.sql
--  Unified Database & Schema Creation Script for Influish (.NET Web Forms)
--  Comprehensive 14-Table Architecture covering:
--    1. Core / Authentication (Admin, Influencer, Advertiser)
--    2. Advertiser Module (Brand Profile, Campaigns, Deliverables)
--    3. Influencer Module (Creator Profile, Social Accounts, Applications, Submissions)
--    4. Financial & Trust (Payments/Escrow, Reviews & Ratings)
--    5. Admin & Moderation (Reports/Support, Audit Logs, Categories)
-- ====================================================================

USE master;
GO

-- ─────────────────────────────────────────────────────────────────────
-- STEP 1: Cleanly recreate the database
-- ─────────────────────────────────────────────────────────────────────
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'InfluishDB')
BEGIN
    ALTER DATABASE InfluishDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE InfluishDB;
END
GO

CREATE DATABASE InfluishDB;
GO

USE InfluishDB;
GO

-- ====================================================================
-- PART 1: CORE & AUTHENTICATION TABLES
-- ====================================================================

-- --------------------------------------------------------------------
-- TABLE 1: Users
-- Role    : Shared / All Roles
-- Purpose : Master authentication and user directory.
-- Used by : Signup.aspx, Login.aspx, Admin/ManageUsers.aspx, Site.Master
-- --------------------------------------------------------------------
CREATE TABLE Users
(
    UserID       INT           IDENTITY(1,1) PRIMARY KEY,
    FullName     NVARCHAR(150) NOT NULL,
    Email        NVARCHAR(150) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NULL,
    Role         NVARCHAR(30)  NOT NULL,                  -- 'Influencer', 'Advertiser', 'Admin'
    Phone        NVARCHAR(50)  NULL,
    Status       NVARCHAR(30)  NOT NULL DEFAULT 'Active', -- 'Active', 'Inactive', 'Pending', 'Suspended'
    ProfilePic   NVARCHAR(300) NULL,
    JoinedDate   DATE          NOT NULL DEFAULT GETDATE()
);
GO

-- --------------------------------------------------------------------
-- TABLE 2: Categories
-- Role    : Admin Managed / Shared Master Data
-- Purpose : Master lookup for niches across campaigns and creators.
-- Used by : CreateCampaign.aspx, Campaigns.aspx, ProfileSetup.aspx
-- --------------------------------------------------------------------
CREATE TABLE Categories
(
    CategoryID   INT           IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    Icon         NVARCHAR(50)  NULL,                      -- e.g. 'fa-laptop', 'fa-shirt', 'fa-spa'
    Description  NVARCHAR(255) NULL,
    IsActive     BIT           NOT NULL DEFAULT 1,
    DisplayOrder INT           NOT NULL DEFAULT 0
);
GO

-- --------------------------------------------------------------------
-- TABLE 3: Notifications
-- Role    : Shared / All Roles
-- Purpose : In-app real-time notifications for creators, brands, and admins.
-- Used by : Advertiser/Notifications.aspx, Notifications.aspx, Site.Master
-- --------------------------------------------------------------------
CREATE TABLE Notifications
(
    NotificationID INT           IDENTITY(1,1) PRIMARY KEY,
    UserID         INT           NULL CONSTRAINT FK_Notifications_Users FOREIGN KEY REFERENCES Users(UserID) ON DELETE SET NULL,
    Message        NVARCHAR(MAX) NOT NULL,
    RelatedType    NVARCHAR(50)  NULL,                       -- 'Acceptance', 'Applicant', 'CampaignLive', 'Billing', 'Submission', 'Review', 'System'
    RelatedID      INT           NULL,
    IsRead         BIT           NOT NULL DEFAULT 0,
    CreatedAt      DATETIME      NOT NULL DEFAULT GETDATE()
);
GO


-- ====================================================================
-- PART 2: ADVERTISER SIDE TABLES
-- ====================================================================

-- --------------------------------------------------------------------
-- TABLE 4: Companies
-- Role    : Advertiser Side
-- Purpose : Brand profiles, business contact, industry, and bio.
-- Used by : Advertiser/CompanyProfile.aspx, Advertiser/Dashboard.aspx, Site.Master
-- --------------------------------------------------------------------
CREATE TABLE Companies
(
    CompanyID     INT            IDENTITY(1,1) PRIMARY KEY,
    UserID        INT            NULL CONSTRAINT FK_Companies_Users FOREIGN KEY REFERENCES Users(UserID) ON DELETE SET NULL,
    CompanyName   NVARCHAR(200)  NOT NULL,
    ContactPerson NVARCHAR(150)  NULL,
    Email         NVARCHAR(200)  NULL,
    Phone         NVARCHAR(50)   NULL,
    Industry      NVARCHAR(100)  NULL,
    Website       NVARCHAR(250)  NULL,
    Logo          NVARCHAR(300)  NULL,
    Description   NVARCHAR(MAX)  NULL,
    CreatedAt     DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

-- --------------------------------------------------------------------
-- TABLE 5: Campaigns
-- Role    : Advertiser Side
-- Purpose : Marketing campaign briefs, budgets, eligibility requirements.
-- Used by : CreateCampaign.aspx, MyCampaigns.aspx, ManageCampaigns.aspx, Campaigns.aspx
-- Note    : CampaignName is computed from Title to guarantee 100% compatibility
--           with Admin (SELECT CampaignName) and Advertiser (SELECT Title)
-- --------------------------------------------------------------------
CREATE TABLE Campaigns
(
    CampaignID   INT            IDENTITY(1,1) PRIMARY KEY,
    CompanyID    INT            NULL CONSTRAINT FK_Campaigns_Companies FOREIGN KEY REFERENCES Companies(CompanyID) ON DELETE SET NULL,
    Title        NVARCHAR(200)  NOT NULL,
    CampaignName AS Title,                                   -- Computed column for Admin queries compatibility
    Advertiser   NVARCHAR(150)  NOT NULL DEFAULT 'TechNova Solutions',
    Category     NVARCHAR(100)  NULL,
    Description  NVARCHAR(MAX)  NULL,
    Budget       DECIMAL(18,2)  NOT NULL DEFAULT 0,
    MinFollowers INT            NULL DEFAULT 0,
    MinAge       INT            NULL DEFAULT 18,
    MaxAge       INT            NULL DEFAULT 55,
    Applicants   INT            NOT NULL DEFAULT 0,
    Status       NVARCHAR(50)   NOT NULL DEFAULT 'Open',     -- 'Open', 'Active', 'Pending', 'Closed', 'Ended', 'Deactivated'
    StartDate    DATE           NULL,
    EndDate      DATE           NULL,
    CreatedDate  DATE           NOT NULL DEFAULT GETDATE()
);
GO

-- --------------------------------------------------------------------
-- TABLE 6: CampaignDeliverables
-- Role    : Advertiser Side
-- Purpose : Specific creative deliverables requested per campaign.
-- Used by : Advertiser/CampaignDetails.aspx, CampaignDetails.aspx
-- --------------------------------------------------------------------
CREATE TABLE CampaignDeliverables
(
    DeliverableID    INT            IDENTITY(1,1) PRIMARY KEY,
    CampaignID       INT            NOT NULL CONSTRAINT FK_CampaignDeliverables_Campaigns FOREIGN KEY REFERENCES Campaigns(CampaignID) ON DELETE CASCADE,
    Platform         NVARCHAR(50)   NOT NULL,                -- 'Instagram', 'YouTube', 'TikTok', 'X'
    DeliverableType  NVARCHAR(100)  NOT NULL,                -- 'Reel (60s)', 'Story with Link', 'Dedicated Video', 'Product Review'
    Quantity         INT            NOT NULL DEFAULT 1,
    Instructions     NVARCHAR(MAX)  NULL,
    DueDays          INT            NOT NULL DEFAULT 7
);
GO


-- ====================================================================
-- PART 3: INFLUENCER SIDE TABLES
-- ====================================================================

-- --------------------------------------------------------------------
-- TABLE 7: Influencers
-- Role    : Influencer Side
-- Purpose : Influencer public creator profile, total reach, bio, category.
-- Used by : Profile.aspx, ProfileSetup.aspx, Advertiser/InfluencerProfile.aspx
-- --------------------------------------------------------------------
CREATE TABLE Influencers
(
    InfluencerID   INT            IDENTITY(1,1) PRIMARY KEY,
    UserID         INT            NULL CONSTRAINT FK_Influencers_Users FOREIGN KEY REFERENCES Users(UserID) ON DELETE SET NULL,
    Name           NVARCHAR(200)  NOT NULL,
    Category       NVARCHAR(100)  NULL,
    FollowerCount  INT            NOT NULL DEFAULT 0,
    Bio            NVARCHAR(MAX)  NULL,
    SocialLinks    NVARCHAR(MAX)  NULL,
    Phone          NVARCHAR(50)   NULL,
    ProfilePicture NVARCHAR(300)  NULL,
    City           NVARCHAR(100)  NULL,
    Country        NVARCHAR(100)  NULL DEFAULT 'India',
    EngagementRate DECIMAL(5,2)   NULL DEFAULT 3.50,
    CreatedAt      DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

-- --------------------------------------------------------------------
-- TABLE 8: SocialAccounts
-- Role    : Influencer Side
-- Purpose : Individual connected social media channels per influencer.
-- Used by : Profile.aspx, ProfileSetup.aspx, InfluencerProfile.aspx
-- --------------------------------------------------------------------
CREATE TABLE SocialAccounts
(
    SocialAccountID INT            IDENTITY(1,1) PRIMARY KEY,
    InfluencerID    INT            NOT NULL CONSTRAINT FK_SocialAccounts_Influencers FOREIGN KEY REFERENCES Influencers(InfluencerID) ON DELETE CASCADE,
    Platform        NVARCHAR(50)   NOT NULL,                 -- 'Instagram', 'YouTube', 'TikTok', 'Twitter', 'LinkedIn'
    Handle          NVARCHAR(100)  NOT NULL,                 -- e.g. '@riddhi.creates'
    ProfileUrl      NVARCHAR(300)  NULL,
    Followers       INT            NOT NULL DEFAULT 0,
    EngagementRate  DECIMAL(5,2)   NULL DEFAULT 0.00,
    IsVerified      BIT            NOT NULL DEFAULT 0,
    ConnectedAt     DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

-- --------------------------------------------------------------------
-- TABLE 9: Applications
-- Role    : Influencer & Advertiser Side Bridge
-- Purpose : Influencer applications to brand campaigns.
-- Used by : Advertiser/CampaignDetails.aspx, Applications.aspx, Dashboard.aspx
-- --------------------------------------------------------------------
CREATE TABLE Applications
(
    ApplicationID INT            IDENTITY(1,1) PRIMARY KEY,
    CampaignID    INT            NOT NULL CONSTRAINT FK_Applications_Campaigns FOREIGN KEY REFERENCES Campaigns(CampaignID) ON DELETE CASCADE,
    InfluencerID  INT            NOT NULL CONSTRAINT FK_Applications_Influencers FOREIGN KEY REFERENCES Influencers(InfluencerID) ON DELETE CASCADE,
    CoverLetter   NVARCHAR(MAX)  NULL,
    ProposedRate  DECIMAL(18,2)  NULL,
    Status        NVARCHAR(50)   NOT NULL DEFAULT 'Pending',  -- 'Pending', 'Accepted', 'Rejected', 'Completed'
    AppliedAt     DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

-- --------------------------------------------------------------------
-- TABLE 10: Submissions
-- Role    : Influencer Side (Work Proof) & Advertiser (Review)
-- Purpose : Deliverable submission by creators for advertiser approval.
-- Used by : Applications.aspx, CampaignDetails.aspx, Advertiser/CampaignDetails.aspx
-- --------------------------------------------------------------------
CREATE TABLE Submissions
(
    SubmissionID       INT           IDENTITY(1,1) PRIMARY KEY,
    ApplicationID      INT           NOT NULL CONSTRAINT FK_Submissions_Applications FOREIGN KEY REFERENCES Applications(ApplicationID) ON DELETE CASCADE,
    DeliverableTitle   NVARCHAR(200) NOT NULL,
    LivePostUrl        NVARCHAR(500) NOT NULL,
    ScreenshotUrl      NVARCHAR(300) NULL,
    ViewsCount         INT           NOT NULL DEFAULT 0,
    LikesCount         INT           NOT NULL DEFAULT 0,
    CommentsCount      INT           NOT NULL DEFAULT 0,
    SubmissionNotes    NVARCHAR(MAX) NULL,
    Status             NVARCHAR(50)  NOT NULL DEFAULT 'Pending Review', -- 'Pending Review', 'Approved', 'Revision Requested'
    AdvertiserFeedback NVARCHAR(MAX) NULL,
    SubmittedAt        DATETIME      NOT NULL DEFAULT GETDATE(),
    ReviewedAt         DATETIME      NULL
);
GO


-- ====================================================================
-- PART 4: FINANCIAL & REPUTATION TABLES (BOTH SIDES)
-- ====================================================================

-- --------------------------------------------------------------------
-- TABLE 11: Payments
-- Role    : Advertiser (Payer), Influencer (Payee), Admin (Escrow Ledger)
-- Purpose : Financial transactions: brand escrow deposit, influencer payouts, commission.
-- Used by : Advertiser/Dashboard.aspx, Dashboard.aspx, Admin/Dashboard.aspx
-- --------------------------------------------------------------------
CREATE TABLE Payments
(
    PaymentID      INT            IDENTITY(1,1) PRIMARY KEY,
    TransactionRef NVARCHAR(100)  NOT NULL UNIQUE,
    CampaignID     INT            NULL CONSTRAINT FK_Payments_Campaigns FOREIGN KEY REFERENCES Campaigns(CampaignID) ON DELETE NO ACTION,
    ApplicationID  INT            NULL CONSTRAINT FK_Payments_Applications FOREIGN KEY REFERENCES Applications(ApplicationID) ON DELETE NO ACTION,
    PayerUserID    INT            NULL CONSTRAINT FK_Payments_Payer FOREIGN KEY REFERENCES Users(UserID) ON DELETE NO ACTION,
    PayeeUserID    INT            NULL CONSTRAINT FK_Payments_Payee FOREIGN KEY REFERENCES Users(UserID) ON DELETE NO ACTION,
    Amount         DECIMAL(18,2)  NOT NULL,
    PlatformFee    DECIMAL(18,2)  NOT NULL DEFAULT 0.00,
    NetAmount      DECIMAL(18,2)  NOT NULL,
    PaymentType    NVARCHAR(50)   NOT NULL,                  -- 'Escrow_Deposit', 'Influencer_Payout', 'Platform_Fee', 'Refund'
    PaymentMethod  NVARCHAR(50)   NOT NULL DEFAULT 'UPI',    -- 'UPI', 'Bank_Transfer', 'Credit_Card', 'Net_Banking'
    Status         NVARCHAR(50)   NOT NULL DEFAULT 'Completed', -- 'Pending', 'Completed', 'Failed', 'Refunded'
    CreatedAt      DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

-- --------------------------------------------------------------------
-- TABLE 12: Reviews
-- Role    : Shared (Two-way Feedback)
-- Purpose : Advertisers rate Creators and Creators rate Advertisers.
-- Used by : InfluencerProfile.aspx, CompanyProfile.aspx
-- --------------------------------------------------------------------
CREATE TABLE Reviews
(
    ReviewID            INT           IDENTITY(1,1) PRIMARY KEY,
    CampaignID          INT           NOT NULL CONSTRAINT FK_Reviews_Campaigns FOREIGN KEY REFERENCES Campaigns(CampaignID) ON DELETE CASCADE,
    ReviewerUserID      INT           NOT NULL CONSTRAINT FK_Reviews_Reviewer FOREIGN KEY REFERENCES Users(UserID) ON DELETE NO ACTION,
    TargetUserID        INT           NOT NULL CONSTRAINT FK_Reviews_Target FOREIGN KEY REFERENCES Users(UserID) ON DELETE NO ACTION,
    Rating              INT           NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    ReviewText          NVARCHAR(MAX) NULL,
    CommunicationRating INT           NULL CHECK (CommunicationRating >= 1 AND CommunicationRating <= 5),
    QualityRating       INT           NULL CHECK (QualityRating >= 1 AND QualityRating <= 5),
    TimelinessRating    INT           NULL CHECK (TimelinessRating >= 1 AND TimelinessRating <= 5),
    CreatedAt           DATETIME      NOT NULL DEFAULT GETDATE()
);
GO


-- ====================================================================
-- PART 5: ADMIN & MODERATION TABLES
-- ====================================================================

-- --------------------------------------------------------------------
-- TABLE 13: Reports
-- Role    : Admin Moderation & Support
-- Purpose : Support tickets, content reporting, disputes, user moderation.
-- Used by : Admin/ReportsSupport.aspx, ContactSupport.aspx, Contact.aspx
-- --------------------------------------------------------------------
CREATE TABLE Reports
(
    ReportID    INT           IDENTITY(1,1) PRIMARY KEY,
    ReportType  NVARCHAR(20)  NOT NULL DEFAULT 'Support',    -- 'Report' or 'Support'
    Subject     NVARCHAR(300) NOT NULL,
    Message     NVARCHAR(MAX) NULL,
    ReportedBy  NVARCHAR(150) NOT NULL,
    ReportDate  DATE          NOT NULL DEFAULT GETDATE(),
    Priority    NVARCHAR(20)  NOT NULL DEFAULT 'Medium',     -- 'High', 'Medium', 'Low'
    Status      NVARCHAR(20)  NOT NULL DEFAULT 'Pending',    -- 'Pending', 'In Review', 'Resolved', 'Dismissed'
    AdminNotes  NVARCHAR(MAX) NULL,
    ResolvedBy  INT           NULL CONSTRAINT FK_Reports_Admin FOREIGN KEY REFERENCES Users(UserID) ON DELETE SET NULL
);
GO

-- --------------------------------------------------------------------
-- TABLE 14: AdminLogs
-- Role    : Admin Audit Trail
-- Purpose : Comprehensive security and audit logging of admin actions.
-- Used by : Admin/Dashboard.aspx, Admin/ManageUsers.aspx
-- --------------------------------------------------------------------
CREATE TABLE AdminLogs
(
    LogID        INT           IDENTITY(1,1) PRIMARY KEY,
    AdminUserID  INT           NULL CONSTRAINT FK_AdminLogs_Users FOREIGN KEY REFERENCES Users(UserID) ON DELETE SET NULL,
    Action       NVARCHAR(100) NOT NULL,                     -- 'User Status Updated', 'Campaign Approved', 'Payout Released'
    TargetEntity NVARCHAR(50)  NOT NULL,                     -- 'Users', 'Campaigns', 'Reports', 'Payments'
    TargetID     INT           NULL,
    Details      NVARCHAR(MAX) NULL,
    IPAddress    NVARCHAR(50)  NULL DEFAULT '127.0.0.1',
    Timestamp    DATETIME      NOT NULL DEFAULT GETDATE()
);
GO

-- ====================================================================
-- INDEXES FOR MAXIMUM QUERY PERFORMANCE
-- ====================================================================
CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_Users_Role ON Users(Role);
CREATE INDEX IX_Companies_UserID ON Companies(UserID);
CREATE INDEX IX_Influencers_UserID ON Influencers(UserID);
CREATE INDEX IX_Campaigns_CompanyID ON Campaigns(CompanyID);
CREATE INDEX IX_Campaigns_Status ON Campaigns(Status);
CREATE INDEX IX_Applications_CampaignID ON Applications(CampaignID);
CREATE INDEX IX_Applications_InfluencerID ON Applications(InfluencerID);
CREATE INDEX IX_Notifications_UserID ON Notifications(UserID);
CREATE INDEX IX_Reports_Status ON Reports(Status);
CREATE INDEX IX_Payments_CampaignID ON Payments(CampaignID);
CREATE INDEX IX_Reviews_CampaignID ON Reviews(CampaignID);
GO


-- ====================================================================
-- SAMPLE SEED DATA (ALL 14 TABLES)
-- ====================================================================

-- 1. Users (Admin, Advertisers, Influencers)
INSERT INTO Users (FullName, Email, PasswordHash, Role, Phone, Status, JoinedDate) VALUES
('Riddhi Devaliya', 'riddhi.creates@example.com', 'Creator@123', 'Influencer', '+91 99984 59006', 'Active', DATEADD(DAY, -10, GETDATE())),
('TechNova Solutions', 'contact@technova.io', 'Brand@123', 'Advertiser', '+1 (555) 123-4567', 'Active', DATEADD(DAY, -25, GETDATE())),
('Aarav Sharma', 'aarav.vlogs@example.com', 'Creator@123', 'Influencer', '+91 98765 43210', 'Active', DATEADD(DAY, -15, GETDATE())),
('Aura Beauty Co.', 'partnerships@aurabeauty.in', 'Brand@123', 'Advertiser', '+91 98200 44556', 'Active', DATEADD(DAY, -30, GETDATE())),
('Priya Patel', 'priya.style@example.com', 'Creator@123', 'Influencer', '+91 97123 45678', 'Pending', DATEADD(DAY, -2, GETDATE())),
('Arvi Antala', 'arviantala18@gmail.com', 'Abc@1234', 'Admin', '+91 90000 00000', 'Active', DATEADD(DAY, -60, GETDATE())),
('StyleHub India', 'brand@stylehub.in', 'Brand@123', 'Advertiser', '+91 98111 22334', 'Active', DATEADD(DAY, -45, GETDATE()));

-- 2. Categories
INSERT INTO Categories (CategoryName, Icon, Description, DisplayOrder) VALUES
('Technology', 'fa-laptop-code', 'Smartphones, wearables, software, computing and consumer gadgets.', 1),
('Fashion & Apparel', 'fa-shirt', 'Clothing, footwear, sustainable fashion, street style and couture.', 2),
('Beauty & Skincare', 'fa-spa', 'Cosmetics, natural skincare, haircare, and personal grooming.', 3),
('Health & Fitness', 'fa-dumbbell', 'Gym workouts, yoga, wellness, supplements, and activewear.', 4),
('Food & Culinary', 'fa-utensils', 'Restaurants, recipes, organic cooking, beverages, and reviews.', 5),
('Travel & Adventure', 'fa-plane', 'Destinations, hotel stays, backpacking, and itinerary guides.', 6),
('Lifestyle & Decor', 'fa-couch', 'Home aesthetics, productivity routines, and modern living.', 7);

-- 3. Companies (Advertisers)
INSERT INTO Companies (UserID, CompanyName, ContactPerson, Email, Phone, Industry, Website, Description) VALUES
(2, 'TechNova Solutions', 'Sarah Jenkins', 'sarah.j@technova.com', '+1 (555) 123-4567', 'Technology', 'https://technova.com', 'TechNova Solutions is a leading enterprise hardware and consumer electronics creator known for cutting-edge wearables and flagship gear.'),
(4, 'Aura Beauty Co.', 'Neha Kapoor', 'partnerships@aurabeauty.in', '+91 98200 44556', 'Beauty & Skincare', 'https://aurabeauty.in', 'Premium organic skincare and luxury cosmetics formulated with natural botanicals for healthy everyday skin.'),
(7, 'StyleHub India', 'Vikram Malhotra', 'brand@stylehub.in', '+91 98111 22334', 'Fashion & Apparel', 'https://stylehub.in', 'Trendy, youth-centric streetwear and festive collections with pan-India delivery.');

-- 4. Influencers
INSERT INTO Influencers (UserID, Name, Category, FollowerCount, Bio, SocialLinks, Phone, City, EngagementRate) VALUES
(1, 'Riddhi Devaliya', 'Lifestyle, Tech', 25200, 'Tech enthusiast & lifestyle content creator sharing honest product reviews and aesthetic setups.', '@riddhi.creates', '+91 99984 59006', 'Ahmedabad', 4.85),
(3, 'Aarav Sharma', 'Technology', 45100, 'Unboxing the future of smart gadgets, mobile reviews, and daily tech life in 4K.', '@aarav.tech', '+91 98765 43210', 'Mumbai', 5.20),
(5, 'Priya Patel', 'Fashion & Apparel', 18500, 'Fashion stylist, sustainable apparel enthusiast and travel creator crafting vibrant lookbooks.', '@priya.style', '+91 97123 45678', 'Surat', 3.90);

-- 5. SocialAccounts (Influencer Social Channels)
INSERT INTO SocialAccounts (InfluencerID, Platform, Handle, ProfileUrl, Followers, EngagementRate, IsVerified) VALUES
(1, 'Instagram', '@riddhi.creates', 'https://instagram.com/riddhi.creates', 18200, 4.90, 1),
(1, 'YouTube', 'Riddhi Tech Vlogs', 'https://youtube.com/@riddhitech', 7000, 4.75, 0),
(2, 'Instagram', '@aarav.tech', 'https://instagram.com/aarav.tech', 32000, 5.10, 1),
(2, 'YouTube', 'Aarav Tech Lab', 'https://youtube.com/@aaravtechlab', 13100, 5.45, 1),
(3, 'Instagram', '@priya.style', 'https://instagram.com/priya.style', 14500, 3.80, 0),
(3, 'Pinterest', 'PriyaStyleInspo', 'https://pinterest.com/priyastyle', 4000, 4.20, 0);

-- 6. Campaigns (Created by Advertisers)
INSERT INTO Campaigns (CompanyID, Title, Advertiser, Category, Description, Budget, MinFollowers, MinAge, MaxAge, Applicants, Status, StartDate, EndDate, CreatedDate) VALUES
(1, 'Smart Tech Product Promotion', 'TechNova Solutions', 'Technology', 'We are launching our new flagship smart device and looking for tech-savvy creators to help us spread the word. This campaign involves creating unboxing and review content focusing on innovative features.', 45000.00, 10000, 18, 40, 14, 'Active', DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, 25, GETDATE()), DATEADD(DAY, -2, GETDATE())),
(2, 'Summer Glow Skincare Campaign', 'Aura Beauty Co.', 'Beauty & Skincare', 'Promote our all-natural summer glow routine. We are looking for creators with high engagement who love clean and cruelty-free skincare products.', 28000.00, 5000, 18, 35, 22, 'Active', DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, 20, GETDATE()), DATEADD(DAY, -5, GETDATE())),
(1, 'Wireless Gaming Headset Buzz', 'TechNova Solutions', 'Technology', 'Dedicated review video and social clips for our ultra-low latency wireless gaming headset.', 32000.00, 15000, 16, 30, 8, 'Open', DATEADD(DAY, -12, GETDATE()), DATEADD(DAY, 18, GETDATE()), DATEADD(DAY, -7, GETDATE())),
(3, 'Diwali Festive Wear Launch', 'StyleHub India', 'Fashion & Apparel', 'Exclusive influencer gift boxes, styling lookbooks, and festive unboxings for our Diwali capsule wardrobe.', 50000.00, 15000, 18, 45, 19, 'Open', DATEADD(DAY, -20, GETDATE()), DATEADD(DAY, 10, GETDATE()), DATEADD(DAY, -15, GETDATE())),
(2, 'Festive Glow Drop', 'Aura Beauty Co.', 'Beauty & Skincare', 'Limited edition luxury holiday skincare collection promotion.', 50000.00, 20000, 18, 45, 35, 'Closed', DATEADD(DAY, -40, GETDATE()), DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, -35, GETDATE()));

-- 7. CampaignDeliverables
INSERT INTO CampaignDeliverables (CampaignID, Platform, DeliverableType, Quantity, Instructions, DueDays) VALUES
(1, 'Instagram', 'Reel (60s)', 1, 'Highlight flagship build quality, battery test, and companion app.', 7),
(1, 'Instagram', 'Story with Link', 2, 'Share swipe-up discount code with unboxing behind-the-scenes.', 3),
(2, 'Instagram', 'Reel (60s)', 1, 'Morning skincare routine showcase featuring vitamin C serum.', 5),
(3, 'YouTube', 'Dedicated Video', 1, '10-minute gaming headset review with discord audio test.', 10),
(4, 'Instagram', 'Carousel Post', 1, '3 festive lookbook styling photos with collection tags.', 5);

-- 8. Applications (Influencers apply to Campaigns)
INSERT INTO Applications (CampaignID, InfluencerID, CoverLetter, ProposedRate, Status, AppliedAt) VALUES
(1, 1, 'Excited to review the flagship smart device! My audience is 85% tech-focused with high purchasing intent.', 12000.00, 'Accepted', DATEADD(DAY, -2, GETDATE())),
(1, 2, 'I create high-production 4K YouTube reviews and Reels. I would love to showcase the device build quality.', 18000.00, 'Pending', DATEADD(DAY, -1, GETDATE())),
(2, 3, 'My followers love skincare tips! This fits my channel aesthetic perfectly.', 9000.00, 'Accepted', DATEADD(DAY, -3, GETDATE())),
(1, 3, 'Would love to test this product during my daily vlog routine.', 10000.00, 'Rejected', DATEADD(DAY, -3, GETDATE())),
(4, 3, 'Festive ethnic wear is my primary niche. I have 3 creative concept lookbooks planned!', 15000.00, 'Accepted', DATEADD(DAY, -10, GETDATE())),
(3, 2, 'Can produce a benchmark gaming audio test against competitor headsets.', 14000.00, 'Pending', DATEADD(DAY, -4, GETDATE()));

-- Update applicant counts on campaigns dynamically
UPDATE c
SET c.Applicants = ISNULL(a.AppCount, 0)
FROM Campaigns c
LEFT JOIN (
    SELECT CampaignID, COUNT(*) AS AppCount
    FROM Applications
    GROUP BY CampaignID
) a ON c.CampaignID = a.CampaignID;

-- 9. Submissions (Influencer Work Proof)
INSERT INTO Submissions (ApplicationID, DeliverableTitle, LivePostUrl, ScreenshotUrl, ViewsCount, LikesCount, CommentsCount, SubmissionNotes, Status, AdvertiserFeedback, SubmittedAt, ReviewedAt) VALUES
(1, 'Flagship Smartwatch Deep Dive Reel', 'https://instagram.com/reel/C8xyz12345', 'https://influish.com/proofs/proof_1.jpg', 34500, 2890, 142, 'Included product link in bio and tagged @technovasolutions in caption.', 'Approved', 'Outstanding video clarity and great engagement!', DATEADD(DAY, -1, GETDATE()), GETDATE()),
(3, 'Morning Summer Glow Routine', 'https://instagram.com/reel/C8abc67890', 'https://influish.com/proofs/proof_2.jpg', 18200, 1430, 95, 'Emphasized cruelty-free ingredients and morning routine aesthetic.', 'Approved', 'Captures our brand tone perfectly.', DATEADD(DAY, -2, GETDATE()), DATEADD(DAY, -1, GETDATE())),
(5, 'Diwali Lookbook: 3 Outfits in 45 Seconds', 'https://instagram.com/reel/C8diwali11', 'https://influish.com/proofs/proof_3.jpg', 42100, 4120, 310, 'All 3 outfits tagged with direct shop links.', 'Approved', 'Viral reach! Splendid job Priya.', DATEADD(DAY, -6, GETDATE()), DATEADD(DAY, -5, GETDATE()));

-- 10. Payments (Escrow Deposits, Creator Payouts & Fees)
INSERT INTO Payments (TransactionRef, CampaignID, ApplicationID, PayerUserID, PayeeUserID, Amount, PlatformFee, NetAmount, PaymentType, PaymentMethod, Status, CreatedAt) VALUES
('TXN-2026-1001', 1, NULL, 2, NULL, 45000.00, 2250.00, 42750.00, 'Escrow_Deposit', 'Bank_Transfer', 'Completed', DATEADD(DAY, -3, GETDATE())),
('TXN-2026-1002', 1, 1, NULL, 1, 12000.00, 600.00, 11400.00, 'Influencer_Payout', 'UPI', 'Completed', DATEADD(HOUR, -6, GETDATE())),
('TXN-2026-1003', 2, NULL, 4, NULL, 28000.00, 1400.00, 26600.00, 'Escrow_Deposit', 'Credit_Card', 'Completed', DATEADD(DAY, -6, GETDATE())),
('TXN-2026-1004', 2, 3, NULL, 5, 9000.00, 450.00, 8550.00, 'Influencer_Payout', 'UPI', 'Completed', DATEADD(DAY, -1, GETDATE())),
('TXN-2026-1005', 4, 5, NULL, 5, 15000.00, 750.00, 14250.00, 'Influencer_Payout', 'Bank_Transfer', 'Completed', DATEADD(DAY, -4, GETDATE()));

-- 11. Reviews (Two-way Feedback)
INSERT INTO Reviews (CampaignID, ReviewerUserID, TargetUserID, Rating, ReviewText, CommunicationRating, QualityRating, TimelinessRating, CreatedAt) VALUES
(1, 2, 1, 5, 'Riddhi delivered exceptional quality content ahead of schedule! Crisp visuals, articulate review, and proactive communication.', 5, 5, 5, DATEADD(HOUR, -4, GETDATE())),
(1, 1, 2, 5, 'TechNova Solutions was wonderful to collaborate with. Prompt brief clarification and immediate escrow release.', 5, 5, 5, DATEADD(HOUR, -3, GETDATE())),
(2, 4, 5, 5, 'Priya was amazing to work with. Highly recommended for beauty and lifestyle campaigns.', 5, 5, 4, DATEADD(DAY, -1, GETDATE())),
(4, 7, 5, 5, 'Exceptional styling and very fast turnaround time for our festive launch.', 5, 5, 5, DATEADD(DAY, -3, GETDATE()));

-- 12. Notifications (All Users)
INSERT INTO Notifications (UserID, Message, RelatedType, RelatedID, IsRead, CreatedAt) VALUES
(1, 'TechNova Solutions accepted your application for the "Smart Tech Product Promotion" campaign.', 'Acceptance', 1, 0, DATEADD(HOUR, -2, GETDATE())),
(2, 'Riddhi Devaliya applied to your "Smart Tech Product Promotion" campaign.', 'Applicant', 1, 0, DATEADD(HOUR, -5, GETDATE())),
(2, 'Your campaign "Smart Tech Product Promotion" is now live and visible to influencers.', 'CampaignLive', 1, 1, DATEADD(DAY, -1, GETDATE())),
(1, 'Payment Received: ₹11,400 has been credited via UPI for campaign #1 completion.', 'Billing', 1, 0, DATEADD(HOUR, -6, GETDATE())),
(1, 'Influish platform update: New collaboration analytics are now active in your dashboard.', 'System', 0, 1, DATEADD(DAY, -4, GETDATE())),
(2, 'Riddhi Devaliya submitted proof for "Smart Tech Product Promotion". Click to review.', 'Submission', 1, 1, DATEADD(DAY, -1, GETDATE()));

-- 13. Reports (Support & Disputes for Admin)
INSERT INTO Reports (ReportType, Subject, Message, ReportedBy, ReportDate, Priority, Status, AdminNotes, ResolvedBy) VALUES
('Support', 'Payment Gateway Integration Question', 'Inquiry regarding automated payouts to influencer UPI IDs.', 'riddhi.creates@example.com', DATEADD(DAY, -1, GETDATE()), 'Medium', 'Pending', NULL, NULL),
('Report', 'Suspicious Fake Follower Account', 'Profile handle @spamcreator appears to be using automated bot followers.', 'sarah.j@technova.com', DATEADD(DAY, -3, GETDATE()), 'High', 'In Review', 'Checking creator engagement metrics and API followers audit.', 6),
('Support', 'Campaign Banner Upload Ratio', 'Assistance needed with optimal aspect ratio for campaign hero image.', 'partnerships@aurabeauty.in', DATEADD(DAY, -5, GETDATE()), 'Low', 'Resolved', 'Provided standard 16:9 1200x675px resolution guidelines.', 6);

-- 14. AdminLogs (Audit Trail)
INSERT INTO AdminLogs (AdminUserID, Action, TargetEntity, TargetID, Details, IPAddress, Timestamp) VALUES
(6, 'User Status Approved', 'Users', 1, 'Verified influencer profile for Riddhi Devaliya.', '127.0.0.1', DATEADD(DAY, -9, GETDATE())),
(6, 'Campaign Review & Publish', 'Campaigns', 1, 'Approved campaign "Smart Tech Product Promotion" for TechNova Solutions.', '127.0.0.1', DATEADD(DAY, -2, GETDATE())),
(6, 'Support Ticket Resolved', 'Reports', 3, 'Resolved banner ratio support query for Aura Beauty Co.', '127.0.0.1', DATEADD(DAY, -4, GETDATE())),
(6, 'Escrow Disbursement Audit', 'Payments', 2, 'Verified successful UPI payout disbursement of ₹11,400.', '127.0.0.1', DATEADD(HOUR, -5, GETDATE()));
GO

-- ====================================================================
-- VALIDATION SUMMARY QUERY
-- ====================================================================
PRINT '====================================================================';
PRINT 'SUCCESS: InfluishDB database created with all 14 comprehensive tables!';
PRINT '====================================================================';

SELECT 
    t.name AS TableName,
    p.rows AS TotalRows
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0,1)
ORDER BY t.name;
GO
