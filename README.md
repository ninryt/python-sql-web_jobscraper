# 🐍📊 (Web-Scraper): SQL Database Schema and Python Automation

A SQL and Python-powered system for job scraping, database management, and market analysis

This repository contains SQL and Python scripts for a comprehensive Job Scraping and Analysis Database Schema. It is designed to facilitate job market analysis by storing scraped job offers and their metadata in a structured, scalable, and normalized manner. The integration of Python ensures seamless automation of scraping, processing, and data management.

---
![Copy of Drive project](https://github.com/user-attachments/assets/5e54bcd0-22c1-4558-9763-ea1e8411528d)

---

This project also serves as an example for beginners who have never worked with SQL database design, database architecture, or Python automation. During the initial phases of designing the architecture and creating the first database scripts, I was accompanied by a former colleague who was new to these concepts.

It became an excellent learning opportunity for her to explore SQL, database management, and writing her first SQL scripts. Guiding her step-by-step through the process of designing the database architecture, explaining the relationships between tables, and creating the scripts allowed me to deepen my own knowledge. Her questions and feedback helped refine the project and provided valuable insights into teaching and collaboration.

I was able to mentor while simultaneously strengthening my skills in explaining complex topics, answering her questions, and leading her through the entire project. This project is therefore not only a functional system for job scraping and analysis but also a practical example for anyone new to database design and Python automation.

![scrapper4](https://github.com/user-attachments/assets/98dac9a1-0580-4097-b847-f18ca2b517ac)

![scrapper5](https://github.com/user-attachments/assets/09a18a73-fafd-4706-8c43-261ba21ca4ff)

## 🔸 Tools used:
- SQL Server on Azure: For hosting and managing the job scraping database.
-  Azure Data Studio: For query development, database management, and data exploration.
- Visual Studio Code (VS Code): For developing Python scripts with an enhanced coding experience and extensions.
- Python: For automating job data scraping, processing, and database interaction.
- Lucidchart: For designing the database schema and visualizing entity relationships.
- Excel: For exporting and sharing analyzed job data.

## 🔸 As part of this project, the following skills were applied:

1️⃣ Database Design and Data Modeling:
- Designed a normalized relational database schema optimized for storing and analyzing job-related data.
- Defined clear relationships between tables using primary keys, foreign keys, and unique constraints.

2️⃣ Data Automation and Wrangling:
- Developed Python scripts in Visual Studio Code to automate the scraping of job postings from platforms like LinkedIn and Indeed.
- Wrote SQL queries to clean, transform, and prepare data for analysis.
- Automated workflows for regular updates and data integrity checks.

3️⃣ Data Analysis and Reporting:
- Analyzed job market trends, such as in-demand skills, industries, and salary ranges.
- Used SQL and Python to extract meaningful insights from the data.

4️⃣ Mentoring and Knowledge Sharing.

## 🔸 Project Architecture:
Below, you can view the Lucidchart diagram showcasing the database architecture designed for this project. It includes all the key components, such as dimension tables, fact tables, and bridge tables, with clear relationships defined by primary keys, foreign keys, and unique constraints. This visual representation provides a comprehensive understanding of how the database is structured to support efficient storage and analysis of job-related data.

🔴 [CHECK THE DATABASE ARCHITECTURE DESIGN PROCESS: ER Diagram](https://example.com/lucidchart-diagram)

![scrapper3](https://github.com/user-attachments/assets/cf7d8f76-e835-4057-ad9f-8f8c3179f04f)



## 🔸 Guidance and Practical Learning
As part of the project, I had the opportunity to guide a former colleague who was new to SQL and database design. During our collaboration:

1. Practical Explanation: I used the Lucidchart diagram to explain the dependencies and relationships between the tables in real-time. For example, I showed how the FactJobScraper table connects to dimensions like DimCompanies and DimJobTitles, making the concept of fact and dimension tables more tangible.

2. Hands-On Practice: I encouraged my colleague to actively participate by asking questions and proposing changes to the architecture. Her queries about normalization, constraints, and table design helped refine the schema and provided a deeper learning experience.

3. Step-by-Step Walkthrough: I demonstrated how to translate the diagram into SQL scripts. Starting with table creation, we discussed constraints like CHECK, UNIQUE, and foreign key relationships, ensuring she understood both the purpose and implementation.
4. Iterative Learning: As the project progressed, I provided feedback on her SQL queries and scripts, helping her refine her skills while addressing real-world scenarios.

### A Collaborative and Interactive Approach
This collaborative approach significantly accelerated her understanding of SQL and database architecture. By combining the Lucidchart visualization with practical script-writing exercises, the project served as both a learning opportunity and a productive collaboration.

### Accessing the Architecture and Notes
The Lucidchart document includes:

- A detailed database schema diagram.
- My annotations explaining the relationships between tables.
- Her feedback on the project, along with my responses.
- This document can be a helpful resource for anyone learning SQL or database design for the first time. It provides not only the architecture but also a real-world example of how to approach building and understanding a database from scratch.

## 🔸 Features of SQL Database
1. SQL Database Schema
- Dimension Tables: Store metadata such as locations, companies, job titles, skills, technologies, industries, and more.
- Source Table: The JobOffers table acts as the central repository for job details, including job descriptions, salaries, job links, and statuses.
- Bridge Tables: Enable many-to-many relationships, connecting job offers with related skills, technologies, responsibilities, and buzzwords.
- Fact Table: FactJobScraper aggregates job data for analytics and reporting.

2. Advanced SQL Features
- Triggers: Automate updates to job statuses and detect the language of job descriptions.
- Custom Functions: Dynamically classify job descriptions based on language and assign job categories.
- Validation and Constraints: Maintain data integrity by enforcing rules on numeric values and relationships.
- Indexes: Optimize query performance for frequent operations.

3. Optional Extensions
- Application Tracking: Track job applications with statuses like "Pending," "Submitted," or "Accepted."
- Job Categories: Dynamically categorize jobs based on titles and keywords for easier filtering and analysis.

### Sample SQL Script 
```sql
CREATE TABLE dbo.DimBuzzwords (
    BuzzwordID INT PRIMARY KEY IDENTITY(1,1), -- Auto-generated identifier
    Buzzword NVARCHAR(255) NOT NULL -- The buzzword or concept
);


CREATE TABLE dbo.DimLanguages (
    LanguageID INT PRIMARY KEY IDENTITY(1,1),
    Language NVARCHAR(100) NOT NULL
);
```
### Sample SQL Script 
```sql
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
```
## 🔸 Testing SQL Database
### Seed Data Example
To populate the database with initial data for testing, you can use the following SQL scripts. These scripts insert sample data into the dimension and source tables to simulate a real-world scenario.
```sql
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
```
## 🔸 Python Integration 
Python played a crucial role in automating the data scraping and processing workflows for this project. Using tools like Selenium and BeautifulSoup, the script dynamically interacted with job platforms such as LinkedIn to extract detailed job postings, even from JavaScript-rendered pages. Python handled everything from parsing job titles, descriptions, locations, and company names to detecting the language of the job description using a custom keyword-based detection algorithm. Once scraped, the data was processed, cleaned, and inserted into the SQL database via libraries like pyodbc. Additionally, Python scripts were used to extract relevant insights from the database, export data to Excel for further use, and automate workflows to ensure the system remained up-to-date with new job postings. This seamless integration of Python ensured efficient data collection, preparation, and usability for further analysis.

### Sample PYTHON Script 
```python
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup
import time

# Set up Selenium WebDriver with the correct path to ChromeDriver
service = Service("/usr/local/bin/chromedriver")  # Replace with your correct path
driver = webdriver.Chrome(service=service)

# Target URL
url = "https://www.linkedin.com/jobs/view/4093031873"  # Replace with the LinkedIn job link
driver.get(url)

# Wait for JavaScript content to load
time.sleep(5)  # Adjust based on your network speed
```
## 🔸 Future Development and Authentication with LinkedIn
Currently, the data is scraped from LinkedIn without logging into an account. This raised concerns about whether Python could reliably scrape additional job postings and handle pagination or advanced search features. The next phase of the project involves further testing and implementing authentication with LinkedIn to access more job data available to logged-in users. This will require modifying the existing codebase to handle the logged-in version of LinkedIn, ensuring the scraper can navigate and extract data from authenticated sessions.

The next steps of the project will focus on addressing these challenges and expanding the scraper's functionality for enhanced reliability and data coverage. Stay tuned for updates as the project evolves!

![scrapper2](https://github.com/user-attachments/assets/afcdb332-cd8e-4d5c-bda2-a4deb6a79d14)

## 🔸 Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss your ideas.

## 🔸 LICENSE
This project is licensed under the MIT License. See the LICENSE file for more details.

## 🔸 How to Use
1. Clone the repository.
2. Open the SQL script [Jobscraper Script](./jbs_database_script.sql) in your preferred SQL environment, such as:
- Azure Data Studio
- SQL Server Management Studio (SSMS)
3. Execute the scripts to:
- Create the database schema: Set up all tables, constraints, and relationships.
- Populate the tables with sample data (you can use: [Jobscraper Seed Data Example](./jbs_seed_data.sql))
4. Analyze the data:
- Use the provided SQL queries (above: "Sample Query 2") or write your own to:
- Retrieve insights (e.g., travel expenses by month).
- Perform advanced analysis for reporting purposes.
5. Connect to SQL using Python [Establish Connection SQL-PY](./establish_connection_sql.py)
6. Run the Python automation script [Jobscraper Automation Script](./jbs_automation_script.py)

Clone this repository:
   ```bash
   git clone https://github.com/ninryt/python-sql-web_jobscraper.git
 ```

---
## 👤 Author
👤 N.B. Ryttel
📧 [Email me](zerobughero@gmail.com)
🔗 [Github](https://github.com/ninryt)



