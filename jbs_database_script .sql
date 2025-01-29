--JOBSCRAPER

--DIM TABLES

CREATE TABLE dbo.DimLocations(
    LocationID INT PRIMARY KEY IDENTITY(1,1), -- Auto genereted identifier
    City NVARCHAR(200),
    Country NVARCHAR(200) NOT NULL
);

CREATE TABLE dbo.DimCompanies(
    CompanyID INT PRIMARY KEY IDENTITY(1,1),
    CompanyName NVARCHAR(200) NOT NULL, --Always required (high-level information)
    Industry NVARCHAR(300), --optional
    CompanySize NVARCHAR(100)
);

CREATE TABLE dbo.DimJobTitles (
    JobTitleID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    JobTitleName NVARCHAR(255) NOT NULL 
);

CREATE TABLE dbo.DimSkills (
    SkillID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    SkillName NVARCHAR(255)
);


CREATE TABLE dbo.DimTechnologies (
    TechnologyID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    TechnologyName NVARCHAR(255)
);


CREATE TABLE dbo.DimJobMode (
    JobModeID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    JobMode NVARCHAR(50)
);

CREATE TABLE dbo.DimEducationLevels (
    EducationLevelID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    EducationLevel NVARCHAR(255)
);


CREATE TABLE dbo.DimContractTypes (
    ContractTypeID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    ContractType NVARCHAR(100)
);

CREATE TABLE dbo.DimWorkHours (
    WorkHourID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    WorkHourType NVARCHAR(100)
);

CREATE TABLE dbo.DimIndustries(
    IndustryID INT PRIMARY KEY IDENTITY(1,1),
    IndustryName NVARCHAR(200)
);


CREATE TABLE dbo.DimResponsibilities (
    ResponsibilityID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    Responsibility NVARCHAR(500) NOT NULL -- Description of the responsibility
);


CREATE TABLE dbo.DimBuzzwords (
    BuzzwordID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    Buzzword NVARCHAR(255) NOT NULL -- The buzzword or concept
);


CREATE TABLE dbo.DimLanguages (
    LanguageID INT PRIMARY KEY IDENTITY(1,1),
    Language NVARCHAR(100) NOT NULL
);


--SOURCE TABLE 

CREATE TABLE dbo.JobOffers (
    JobOfferID INT PRIMARY KEY IDENTITY(1,1),
    JobTitleID INT, --FK to DimJobTitles
    LocationID INT, --FK to DimCompanies
    CompanyID INT,
    JobModeID INT,  -- FK to DimJobMode
    Salary NVARCHAR(100), --salary range optional
    PostedDate DATE, --optional
    ExpirationDate DATE, --optional
    EducationLevelID INT, --optional
    ExperienceYears NVARCHAR(100), --optional
    IndustryID INT NOT NULL, --required
    CompanySize NVARCHAR(100), --optional
    ApplicationsNr INT, --optional
    WorkHourID INT, --optional
    ContractTypeID INT,--optional
    JobDescription NVARCHAR(MAX) NOT NULL, --required
    JobLink NVARCHAR(700) NOT NULL UNIQUE,          -- Link to the job posting (mandatory), is unique to avoid duplicates
    DateScraped DATETIME DEFAULT GETDATE() NOT NULL, -- Timestamp for when the job was scraped
    LastUpdated DATETIME DEFAULT GETDATE(), -- Timestamp for when the job was last updated
    JobStatus NVARCHAR(50) DEFAULT 'Active', -- Status of the job (Active or Removed)

    CONSTRAINT FK_JobOffers_JobTitleID FOREIGN KEY (JobTitleID) REFERENCES dbo.DimJobTitles(JobTitleID),
    CONSTRAINT FK_JobOffers_LocationID FOREIGN KEY (LocationID) REFERENCES dbo.DimLocations(LocationID),
    CONSTRAINT FK_JobOffers_CompanyID FOREIGN KEY (CompanyID) REFERENCES dbo.DimCompanies(CompanyID),
    CONSTRAINT FK_JobOffers_JobModeID FOREIGN KEY (JobModeID) REFERENCES dbo.DimJobMode(JobModeID),
    CONSTRAINT FK_JobOffers_EducationLevelID FOREIGN KEY (EducationLevelID) REFERENCES dbo.DimEducationLevels(EducationLevelID),
    CONSTRAINT FK_JobOffers_IndustryID FOREIGN KEY (IndustryID) REFERENCES dbo.DimIndustries(IndustryID),
    CONSTRAINT FK_JobOffers_WorkHourID FOREIGN KEY (WorkHourID) REFERENCES dbo.DimWorkHours(WorkHourID),
    CONSTRAINT FK_JobOffers_ContractTypeID FOREIGN KEY (ContractTypeID) REFERENCES dbo.DimContractTypes(ContractTypeID),
    -- Check Constraint for JobStatus
    CONSTRAINT CK_JobOffers_JobStatus CHECK (JobStatus IN ('Active', 'Removed'))
);


-- UPDATE LOGIC FOR JOB STATUS

-- Mark jobs as 'Removed' when the description is missing or invalid
UPDATE dbo.JobOffers
SET JobStatus = 'Removed'
WHERE JobDescription IS NULL OR JobDescription = 'Page not found';


-- OPTIONAL: AUTOMATIC UPDATES USING A TRIGGER

-- Create a trigger to automatically update JobStatus based on conditions
CREATE TRIGGER trg_UpdateJobStatus
ON dbo.JobOffers
AFTER UPDATE
AS
BEGIN
    -- Mark job as 'Removed' if the JobDescription is empty or invalid
    UPDATE dbo.JobOffers
    SET JobStatus = 'Removed'
    WHERE JobDescription IS NULL OR JobDescription = 'Page not found';
END;


-- Correct DetectLanguage Function
CREATE FUNCTION dbo.DetectLanguage (@JobDescription NVARCHAR(MAX))
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Language NVARCHAR(100);

    IF @JobDescription IS NULL OR LTRIM(RTRIM(@JobDescription)) = ''
        SET @Language = 'Unknown';
    ELSE IF @JobDescription LIKE '%you%' OR @JobDescription LIKE '%we%'
        SET @Language = 'English';
    ELSE IF @JobDescription LIKE '%pracę%' OR @JobDescription LIKE '%praca%'
        SET @Language = 'Polish';
    ELSE IF @JobDescription LIKE '%wir%' OR @JobDescription LIKE '%du%'
        SET @Language = 'German';
    ELSE
        SET @Language = 'Unknown';

    RETURN @Language;
END;

ALTER TABLE dbo.JobOffers
ADD DetectedLanguage NVARCHAR(100); --added language column



-- Correct trg_DetectLanguage Trigger
CREATE TRIGGER trg_DetectLanguage
ON dbo.JobOffers
AFTER INSERT
AS
BEGIN
    UPDATE dbo.JobOffers
    SET DetectedLanguage = dbo.DetectLanguage(inserted.JobDescription)
    FROM dbo.JobOffers
    INNER JOIN inserted ON dbo.JobOffers.JobOfferID = inserted.JobOfferID;
END;


--BRIDGE TABLE
CREATE TABLE dbo.JobOfferSkills (
    JobOfferSkillID INT PRIMARY KEY IDENTITY(1,1),
    JobOfferID INT NOT NULL,
    SkillID INT NOT NULL,
    CONSTRAINT FK_JobOfferSkills_JobOfferID FOREIGN KEY (JobOfferID) REFERENCES dbo.JobOffers(JobOfferID),
    CONSTRAINT FK_JobOfferSkills_SkillID FOREIGN KEY (SkillID) REFERENCES dbo.DimSkills(SkillID),
    CONSTRAINT UQ_JobOfferSkills UNIQUE (JobOfferID, SkillID) -- Prevent duplicates
);


CREATE TABLE dbo.JobOfferTechnologies (
    JobOfferTechID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    JobOfferID INT NOT NULL, -- FK to JobOffers
    TechnologyID INT NOT NULL, -- FK to DimTechnologies
    CONSTRAINT FK_JobOfferTechnologies_JobOfferID FOREIGN KEY (JobOfferID) REFERENCES dbo.JobOffers(JobOfferID),
    CONSTRAINT FK_JobOfferTechnologies_TechnologyID FOREIGN KEY (TechnologyID) REFERENCES dbo.DimTechnologies(TechnologyID),
    CONSTRAINT UQ_JobOfferTechnologies UNIQUE (JobOfferID, TechnologyID) --Prevent duplicates
);


CREATE TABLE dbo.JobOfferResponsibilities (
    JobOfferResponsibilityID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    JobOfferID INT NOT NULL, -- FK to JobOffers
    ResponsibilityID INT NOT NULL, -- FK to DimResponsibilities
    CONSTRAINT FK_JobOfferResponsibilities_JobOfferID FOREIGN KEY (JobOfferID) REFERENCES dbo.JobOffers(JobOfferID),
    CONSTRAINT FK_JobOfferResponsibilities_ResponsibilityID FOREIGN KEY (ResponsibilityID) REFERENCES dbo.DimResponsibilities(ResponsibilityID),
    CONSTRAINT UQ_JobOfferResponsibilities UNIQUE (JobOfferID, ResponsibilityID)
);


CREATE TABLE dbo.JobOfferBuzzwords (
    JobOfferBuzzwordID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    JobOfferID INT NOT NULL, -- FK to JobOffers
    BuzzwordID INT NOT NULL, -- FK to DimBuzzwords
    CONSTRAINT FK_JobOfferBuzzwords_JobOfferID FOREIGN KEY (JobOfferID) REFERENCES dbo.JobOffers(JobOfferID),
    CONSTRAINT FK_JobOfferBuzzwords_BuzzwordID FOREIGN KEY (BuzzwordID) REFERENCES dbo.DimBuzzwords(BuzzwordID),
    CONSTRAINT UQ_JobOfferBuzzwords UNIQUE (JobOfferID, BuzzwordID)
);


--FACT JobScraper TABLE 
--removed 'NOT NULL', to proritize flexibility, to allow for storing as many records as possible, even with partial data"""
CREATE TABLE dbo.FactJobScraper (
    FactScraperID INT PRIMARY KEY IDENTITY(1,1),
    JobOfferID INT,
    LocationID INT,
    CompanyID INT,
    JobTitleID INT,
    JobModeID INT,
    EducationLevelID INT,
    ContractTypeID INT,
    WorkHourID INT,
    IndustryID INT,
    LanguageID INT, -- New foreign key to DimLanguages
    Salary DECIMAL(18,2),
    PostedDate DATE,
    ExpirationDate DATE,
    Applications INT,
    ScrapeDate DATETIME DEFAULT GETDATE() NOT NULL,
    CONSTRAINT FK_FactJobScraper_JobOfferID FOREIGN KEY (JobOfferID) REFERENCES dbo.JobOffers(JobOfferID),
    CONSTRAINT FK_FactJobScraper_LocationID FOREIGN KEY (LocationID) REFERENCES dbo.DimLocations(LocationID),
    CONSTRAINT FK_FactJobScraper_CompanyID FOREIGN KEY (CompanyID) REFERENCES dbo.DimCompanies(CompanyID),
    CONSTRAINT FK_FactJobScraper_JobTitleID FOREIGN KEY (JobTitleID) REFERENCES dbo.DimJobTitles(JobTitleID),
    CONSTRAINT FK_FactJobScraper_JobModeID FOREIGN KEY (JobModeID) REFERENCES dbo.DimJobMode(JobModeID),
    CONSTRAINT FK_FactJobScraper_EducationLevelID FOREIGN KEY (EducationLevelID) REFERENCES dbo.DimEducationLevels(EducationLevelID),
    CONSTRAINT FK_FactJobScraper_ContractTypeID FOREIGN KEY (ContractTypeID) REFERENCES dbo.DimContractTypes(ContractTypeID),
    CONSTRAINT FK_FactJobScraper_WorkHourID FOREIGN KEY (WorkHourID) REFERENCES dbo.DimWorkHours(WorkHourID),
    CONSTRAINT FK_FactJobScraper_IndustryID FOREIGN KEY (IndustryID) REFERENCES dbo.DimIndustries(IndustryID),
    CONSTRAINT FK_FactJobScraper_LanguageID FOREIGN KEY (LanguageID) REFERENCES dbo.DimLanguages(LanguageID)
);

--ALTER TABLES 

-- 1. Set default value for DetectedLanguage
ALTER TABLE dbo.JobOffers
ADD CONSTRAINT DF_JobOffers_DetectedLanguage DEFAULT 'Unknown' FOR DetectedLanguage;


-- 2. Set the column to NOT NULL
UPDATE dbo.JobOffers
SET DetectedLanguage = 'Unknown'
WHERE DetectedLanguage IS NULL; -- Wypełnia NULL-e wartością domyślną

ALTER TABLE dbo.JobOffers
ALTER COLUMN DetectedLanguage NVARCHAR(100) NOT NULL;


-- 3. Add validation constraints for numeric columns in FactJobScraper
ALTER TABLE dbo.FactJobScraper
ADD CONSTRAINT CK_FactJobScraper_Salary CHECK (Salary >= 0);


-- ALTER TABLE dbo.FactJobScraper
-- ADD CONSTRAINT CK_FactJobScraper_Applications CHECK (Applications >= 0);



-- 4. Add indexes for frequently queried columns
-- CREATE INDEX IX_JobOffers_JobTitleID ON dbo.JobOffers (JobTitleID);
-- CREATE INDEX IX_JobOffers_LocationID ON dbo.JobOffers (LocationID);
-- CREATE INDEX IX_JobOffers_CompanyID ON dbo.JobOffers (CompanyID);
-- CREATE INDEX IX_JobOffers_IndustryID ON dbo.JobOffers (IndustryID);
-- CREATE INDEX IX_FactJobScraper_ScrapeDate ON dbo.FactJobScraper (ScrapeDate);


-- EVENT TABLES
-- Application tracking TABLE

-- CREATE TABLE dbo.AppliedJobs (
--     ApplicationID INT PRIMARY KEY IDENTITY(1,1), -- Unique identifier for the application
--     JobOfferID INT NOT NULL, -- FK to JobOffers
--     JobLink NVARCHAR(MAX) NOT NULL, -- Link of the job offer
--     ApplicationDate DATETIME DEFAULT GETDATE() NOT NULL, -- When the application was sent
--     Status NVARCHAR(50) DEFAULT 'Pending', -- Status of the application
--     Notes NVARCHAR(MAX), -- Optional notes about the application
--     CONSTRAINT FK_AppliedJobs_JobOfferID FOREIGN KEY (JobOfferID) REFERENCES dbo.JobOffers(JobOfferID),
--     CONSTRAINT CK_AppliedJobs_Status CHECK (Status IN ('Pending', 'Submitted', 'Rejected', 'Accepted')),
--     CONSTRAINT UQ_AppliedJobs_JobOfferID UNIQUE (JobOfferID) -- Ensure one application per job offer
-- );

--Job categories TABLE
-- CREATE TABLE dbo.JobCategories (
--     JobCategoryID INT PRIMARY KEY IDENTITY(1,1), -- Unique identifier
--     CategoryName NVARCHAR(100) NOT NULL, -- Name of the category (e.g., "Data Analyst")
--     Keywords NVARCHAR(MAX) NOT NULL -- Keywords associated with this category
-- );

-- ALTER TABLE dbo.JobOffers
-- ADD JobCategoryID INT NULL; -- FK to JobCategories

-- ALTER TABLE dbo.JobOffers
-- ADD CONSTRAINT FK_JobOffers_JobCategoryID FOREIGN KEY (JobCategoryID) REFERENCES dbo.JobCategories(JobCategoryID);

--Adding function
-- CREATE FUNCTION dbo.GetJobCategoryID (@JobTitle NVARCHAR(255))
-- RETURNS INT
-- AS
-- BEGIN
--     DECLARE @CategoryID INT;

--     SELECT TOP 1 @CategoryID = JobCategoryID
--     FROM dbo.JobCategories
--     WHERE CHARINDEX(Keywords, @JobTitle) > 0;

--     RETURN @CategoryID;
-- END;

--Creating trigger
-- CREATE TRIGGER trg_AssignJobCategory
-- ON dbo.JobOffers
-- AFTER INSERT
-- AS
-- BEGIN
--     UPDATE jo
--     SET JobCategoryID = dbo.GetJobCategoryID(jo.JobDescription)
--     FROM dbo.JobOffers jo
--     INNER JOIN inserted i ON jo.JobOfferID = i.JobOfferID;
-- END;


