INSERT INTO dbo.DimLocations
VALUES
('Berlin', 'Germany'),
('Munich', 'Germany'),
('Hamburg', 'Germany'),
('Frankfurt am Main', 'Germany'),
('Stuttgart', 'Germany'),
('Düsseldorf', 'Germany'),
('Dresden', 'Germany'),
('Leipzig', 'Germany'),
('Nuremberg', 'Germany'),
('Bremen', 'Germany'),
('Hanover', 'Germany');


-- Seed data for DimLanguages
INSERT INTO dbo.DimLanguages (Language)
VALUES 
('English'),
('French'),
('German'),
('Polish'),
('Spanish'),
('Unknown');


-- Insert all job titles into DimJobTitles
INSERT INTO dbo.DimJobTitles (JobTitleName)
VALUES
('Accessibility Researcher'),
('Behavioral Researcher'),
('BI Analyst'),
('B2B Analyst'),
('B2C Analyst'),
('CRM Analyst'),
('CRM Consultant'),
('Customer Behavior Analyst'),
('Customer Data Analyst'),
('Customer Experience Analyst'),
('Customer Insights Analyst'),
('Customer Relationship Management Analyst'),
('Data & BI Analyst (m/w/d)'),
('Data Analyst'),
('Data Analyst CRM + Data Analyst E-Commerce (m/w/d)'),
('Data Engineer'),
('Data Scientist'),
('Data Visualization Specialist'),
('Strategic Analyst'),
('Technical CRM Manager');


-- Seed data for DimBuzzwords
INSERT INTO dbo.DimBuzzwords (Buzzword)
VALUES 
('A/B-Test'), --German
('Adhoc Datenanalysen durchführen'),
('Agile Entwicklung'),
('Agile Teams'),
('Agiles Umfeld'),
('Analysen und Reports aus unterschiedlichen Datenquellen erstellen'),
('B2B'),
('B2B- und B2C-Projekte'),
('B2C'),
('Breites Spektrum von Research-Methoden'),
('Conversion-Optimierung'),
('Datastudios'),
('Datenanalyse'),
('Datengetrieben'),
('Datengetriebene Entscheidungen'),
('Design Thinking'),
('Entwicklung von Wireframes und Prototypen basierend auf Research-Erkenntnissen'),
('Fließende Deutsch- und Englischkenntnisse'),
('Fließende Deutsch- und Englischkenntnisse in Wort und Schrift'),
('Fließende Deutsch- und sehr gute Englischkenntnisse'),
('Google Analytics'),
('Informationsarchitektur (IA)'),


('Data analysis'),
('Data studios'),
('Data Studio'),
('Data-driven'),
('Data-driven decisions'),
('Design thinking'),
('Fluent German and English skills, both spoken and written'),
('Fluent German and very good English skills'),
('Teamwork'),
('UX research processes'),
('Usability tests'),
('Visualization of data in dashboards');


--
INSERT INTO dbo.DimResponsibilities (Responsibility)
VALUES
('Ad hoc data analysis execution'),
('Adhoc Datenanalysen durchführen'),
('Agile development'),
('Agile environment'),
('Agile teams'),
('Agile Entwicklung'),
('Agiles Umfeld'),
('Analyses and reports from various data sources'),
('Analysen und Reports aus unterschiedlichen Datenquellen erstellen'),
('Behavior'),
('Behavioral research'),
('Breites Spektrum von Research-Methoden'),
('Broad range of research methods'),
('B2B and B2C projects'),
('Communication skills'),
('Conversion optimization'),
('Conversion-Optimierung'),
('Cross-functional Collaboration'),
('Cross-functional teams'),
('Customer experience (CX)'),
('Data analysis'),
('Defining Research Questions and Hypotheses'),
('Designing User Flows and Information Architecture'),
('Development of wireframes and prototypes based on research insights'),
('Dynamic Diagrams'),
('e.g., interviews, usability tests'),
('Establishing Research Guidelines and Documentation Standards'),
('Forecasting'),
('Identify trends'),
('Information architecture (IA)'),
('Interaction design'),
('KPI'),
('KPI-based reports'),
('Metrics'),
('Mobile'),
('Stakeholder Communication'),
('User Tracking'),
('UX Metrics'),
('UX research processes'),
('Usability tests'),
('Visualization of data in dashboards'),
('Web analytics packages'),
('Workshops');

--
INSERT INTO dbo.DimTechnologies (TechnologyName)
VALUES
('Apache Spark'),
('Asana'),
('Azure'),
('Confluence'),
('Crazy Egg'),
('CSS'),
('Data Studio'),
('Datastudio'),
('Dovetail'),
('Excel'),
('Figma'),
('Google Analytics'),
('Google Sheets'),
('Hotjar'),
('HTML'),
('HubSpot'),
('JIRA'),
('Lucidchart'),
('Lookback'),
('Looker'),
('Maze'),
('Microsoft Dynamics'),
('Microsoft Teams'),
('Mixpanel'),
('Miro'),
('Mural'),
('Notion'),
('Optimal Workshop'),
('Optimizely'),
('Power BI'),
('Python'),
('SEO'),
('Slack'),
('Sticktail'),
('SQL'),
('SurveyMonkey'),
('Tableau'),
('UsabilityHub'),
('Zeplin');

--
INSERT INTO dbo.DimJobMode (JobMode)
VALUES
('Vor Ort'),
('On-site'),
('Remote'),
('Hybrid');

--
INSERT INTO dbo.DimWorkHours (WorkHourType)
VALUES
('Vollzeit'),
('Teilzeit'),
('Schichtarbeit'),
('Flexible Arbeitszeiten'),
('Freiberufliche Arbeitszeiten'),
('Projektbezogene Arbeitszeiten'),
('Full-time'),
('Part-time'),
('Shift work'),
('Flexible hours'),
('Freelance hours'),
('Project-based hours');

