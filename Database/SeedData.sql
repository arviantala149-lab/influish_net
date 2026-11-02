USE InfluishDB;
GO

INSERT INTO Users (FullName, Email, PasswordHash, Role, Status, JoinedDate) VALUES
('Riddhi Devaliya', 'riddhi.creates@example.com', 'Creator@123', 'Influencer', 'Active', DATEADD(DAY, -10, GETDATE())),
('TechNova Solutions', 'contact@technova.io', 'Brand@123', 'Advertiser', 'Active', DATEADD(DAY, -25, GETDATE())),
('Aarav Sharma', 'aarav.vlogs@example.com', 'Creator@123', 'Influencer', 'Active', DATEADD(DAY, -15, GETDATE())),
('Aura Beauty Co.', 'partnerships@aurabeauty.in', 'Brand@123', 'Advertiser', 'Active', DATEADD(DAY, -30, GETDATE())),
('Priya Patel', 'priya.style@example.com', 'Creator@123', 'Influencer', 'Pending', DATEADD(DAY, -2, GETDATE())),
('Arvi Antala', 'arviantala18@gmail.com', 'Abc@1234', 'Admin', 'Active', DATEADD(DAY, -60, GETDATE()));

INSERT INTO Companies (UserID, CompanyName, ContactPerson, Email, Phone, Industry, Website, Description) VALUES
(2, 'TechNova Solutions', 'Sarah Jenkins', 'sarah.j@technova.com', '+1 (555) 123-4567', 'Technology', 'https://technova.com', 'TechNova Solutions is a leading provider of enterprise software solutions, specializing in cloud infrastructure and consumer electronics.'),
(4, 'Aura Beauty Co.', 'Neha Kapoor', 'partnerships@aurabeauty.in', '+91 98200 44556', 'Fashion & Apparel', 'https://aurabeauty.in', 'Premium organic skincare and beauty cosmetics brand crafted for modern lifestyles.');

INSERT INTO Influencers (UserID, Name, Category, FollowerCount, Bio, SocialLinks, Phone) VALUES
(1, 'Riddhi Devaliya', 'Lifestyle, Tech', 25200, 'Tech enthusiast & lifestyle content creator sharing honest product reviews and aesthetic setups.', '@riddhi.creates', '+91 99984 59006'),
(3, 'Aarav Sharma', 'Tech & Gadgets', 45100, 'Unboxing the future of smart gadgets, mobile reviews, and daily tech life.', '@aarav.tech', '+91 98765 43210'),
(5, 'Priya Patel', 'Fashion & Lifestyle', 18500, 'Fashion stylist, sustainable apparel enthusiast and travel creator.', '@priya.style', '+91 97123 45678');

INSERT INTO Campaigns (CompanyID, Title, Advertiser, Category, Description, Budget, MinFollowers, MinAge, MaxAge, Applicants, Status, CreatedDate) VALUES
(1, 'Smart Tech Product Promotion', 'TechNova Solutions', 'Technology', 'We are launching our new flagship smart device and looking for tech-savvy creators to help us spread the word. This campaign involves creating unboxing and review content focusing on the innovative features.', 45000.00, 10000, 18, 40, 14, 'Active', DATEADD(DAY, -2, GETDATE())),
(2, 'Summer Glow Skincare Campaign', 'Aura Beauty Co.', 'Fashion & Apparel', 'Promote our all-natural summer glow routine. We are looking for creators with high engagement who love clean and cruelty-free skincare products.', 28000.00, 5000, 18, 35, 22, 'Active', DATEADD(DAY, -5, GETDATE())),
(1, 'Wireless Gaming Headset Buzz', 'TechNova Solutions', 'Technology', 'Dedicated review video and social clips for our ultra-low latency wireless gaming headset.', 32000.00, 15000, 16, 30, 8, 'Open', DATEADD(DAY, -7, GETDATE())),
(2, 'Festive Glow Drop', 'Aura Beauty Co.', 'Fashion & Apparel', 'Exclusive influencer gift boxes and Diwali festival unboxings.', 50000.00, 20000, 18, 45, 35, 'Closed', DATEADD(DAY, -20, GETDATE()));

INSERT INTO Applications (CampaignID, InfluencerID, CoverLetter, Status, AppliedAt) VALUES
(1, 1, 'Excited to review the flagship smart device! My audience is 85% tech-focused with high purchasing intent.', 'Accepted', DATEADD(DAY, -2, GETDATE())),
(1, 2, 'I create high-production 4K YouTube reviews and Reels. I would love to showcase the device build quality.', 'Pending', DATEADD(DAY, -1, GETDATE())),
(2, 3, 'My followers love skincare tips! This fits my channel aesthetic perfectly.', 'Accepted', DATEADD(DAY, -3, GETDATE())),
(1, 3, 'Would love to test this product during my daily vlog routine.', 'Rejected', DATEADD(DAY, -3, GETDATE()));

UPDATE c
SET c.Applicants = ISNULL(a.AppCount, 0)
FROM Campaigns c
LEFT JOIN (
    SELECT CampaignID, COUNT(*) AS AppCount
    FROM Applications
    GROUP BY CampaignID
) a ON c.CampaignID = a.CampaignID;

INSERT INTO Notifications (UserID, Message, RelatedType, RelatedID, IsRead, CreatedAt) VALUES
(1, 'TechNova Solutions accepted your application for the "Smart Tech Product Promotion" campaign.', 'Acceptance', 1, 0, DATEADD(HOUR, -2, GETDATE())),
(2, 'Riddhi Devaliya applied to your "Smart Tech Product Promotion" campaign.', 'Applicant', 1, 0, DATEADD(HOUR, -5, GETDATE())),
(2, 'Your campaign "Smart Tech Product Promotion" is now live and visible to influencers.', 'CampaignLive', 1, 0, DATEADD(DAY, -1, GETDATE())),
(1, 'Influish platform update: New collaboration analytics are now active in your dashboard.', 'System', 0, 1, DATEADD(DAY, -4, GETDATE()));

INSERT INTO Reports (ReportType, Subject, Message, ReportedBy, ReportDate, Priority, Status) VALUES
('Support', 'Payment Gateway Integration Question', 'Inquiry regarding automated payouts to influencer UPI IDs.', 'riddhi.creates@example.com', DATEADD(DAY, -1, GETDATE()), 'Medium', 'Pending'),
('Report', 'Suspicious Fake Follower Account', 'Profile handle @spamcreator appears to be using automated bot followers.', 'sarah.j@technova.com', DATEADD(DAY, -3, GETDATE()), 'High', 'In Review'),
('Support', 'Campaign Banner Upload Ratio', 'Assistance needed with optimal aspect ratio for campaign hero image.', 'partnerships@aurabeauty.in', DATEADD(DAY, -5, GETDATE()), 'Low', 'Resolved');
GO
