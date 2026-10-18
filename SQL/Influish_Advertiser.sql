-- SQL script to create advertiser-related tables for Influish
-- Run in SQL Server Management Studio against your database (replace database name if needed)

CREATE TABLE Companies (
	CompanyID INT IDENTITY(1,1) PRIMARY KEY,
	CompanyName NVARCHAR(200) NOT NULL,
	Email NVARCHAR(200) NULL,
	Phone NVARCHAR(50) NULL,
	Industry NVARCHAR(100) NULL,
	Website NVARCHAR(200) NULL,
	Description NVARCHAR(MAX) NULL
);

CREATE TABLE Campaigns (
	CampaignID INT IDENTITY(1,1) PRIMARY KEY,
	Title NVARCHAR(200) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	Category NVARCHAR(100) NULL,
	Budget DECIMAL(18,2) NULL,
	MinFollowers INT NULL,
	MinAge INT NULL,
	MaxAge INT NULL,
	Status NVARCHAR(50) NULL,
	CompanyID INT NULL,
	CONSTRAINT FK_Campaigns_Companies FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

CREATE TABLE Influencers (
	InfluencerID INT IDENTITY(1,1) PRIMARY KEY,
	Name NVARCHAR(200) NOT NULL,
	Category NVARCHAR(100) NULL,
	FollowerCount INT NULL,
	Bio NVARCHAR(MAX) NULL,
	SocialLinks NVARCHAR(MAX) NULL
);

CREATE TABLE Applications (
	ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
	CampaignID INT NOT NULL,
	InfluencerID INT NOT NULL,
	CoverLetter NVARCHAR(MAX) NULL,
	Status NVARCHAR(50) DEFAULT 'Pending',
	AppliedAt DATETIME DEFAULT GETDATE(),
	CONSTRAINT FK_Applications_Campaigns FOREIGN KEY (CampaignID) REFERENCES Campaigns(CampaignID),
	CONSTRAINT FK_Applications_Influencers FOREIGN KEY (InfluencerID) REFERENCES Influencers(InfluencerID)
);

CREATE TABLE Notifications (
	NotificationID INT IDENTITY(1,1) PRIMARY KEY,
	Message NVARCHAR(MAX) NOT NULL,
	RelatedType NVARCHAR(50) NULL,
	RelatedID INT NULL,
	CreatedAt DATETIME DEFAULT GETDATE()
);

-- Example: add sample influencer (optional)
-- INSERT INTO Influencers(Name, Category, FollowerCount, Bio, SocialLinks) VALUES('Sample Influencer','Lifestyle',12000,'Bio here','https://instagram.com/sample');

-- Notes:
-- 1) Adjust types and sizes for your requirements.
-- 2) If you already have equivalent tables, do not run duplicate creation; instead reuse existing tables.

GO

-- Optional: create a sample company so the dashboard shows a name
INSERT INTO Companies(CompanyName, Email) VALUES('Demo Company', 'demo@example.com');
GO

-- Optional: add a sample campaign
INSERT INTO Campaigns(Title, Description, Category, Budget, MinFollowers, Status, CompanyID) VALUES('Launch Promo','Promote new product','Lifestyle',500.00,1000,'Active',1);
GO

-- End of script
