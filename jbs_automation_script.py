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

# Get the rendered HTML
html = driver.page_source

# Parse the HTML with BeautifulSoup
soup = BeautifulSoup(html, "html.parser")

# Extract job title
try:
    job_title = soup.find("h1", class_="top-card-layout__title").get_text(strip=True)
    print(f"Job Title: {job_title}")
except AttributeError:
    print("Job Title not found.")

# Extract location
location_element = soup.find("span", class_="topcard__flavor topcard__flavor--bullet")
if location_element:
    location = location_element.get_text(strip=True)
    print(f"Location: {location}")
else:
    print("Location not found.")

# Extract company name
try:
    company_name_element = soup.find("a", class_="topcard__org-name-link topcard__flavor--black-link")
    company_name = company_name_element.get_text(strip=True)
    print(f"Company Name: {company_name}")
except AttributeError:
    print("Company Name not found.")

# Extract job description
job_description = soup.find("div", class_="show-more-less-html__markup")
if job_description:
    job_description_text = job_description.get_text(strip=True)
    print(f"Job Description: {job_description_text}")
else:
    print("Job Description not found.")

# Extract posted time
try:
    posted_time_element = driver.find_element(By.CSS_SELECTOR, "span.posted-time-ago__text.topcard__flavor--metadata")
    posted_time = posted_time_element.text
    print(f"Posted time ago: {posted_time}")
except Exception as e:
    print(f"Could not find the posted time element: {e}")

# Extract number of applicants
try:
    num_applicants_element = driver.find_element(By.CSS_SELECTOR, ".num-applicants__caption.topcard__flavor--metadata.topcard__flavor--bullet")
    num_applicants = num_applicants_element.text
    print(f"Number of applicants: {num_applicants}")
except Exception as e:
    print(f"Could not find the number of applicants: {e}")

# Extract job poster's profile link
try:
    job_poster_element = driver.find_element(By.CSS_SELECTOR, "a.base-card__full-link")
    job_poster_url = job_poster_element.get_attribute("href")
    print(f"Job poster's profile URL: {job_poster_url}")
except Exception as e:
    print(f"Could not find the job poster's profile link: {e}")

# Extract work hours type
try:
    # Locate the span with a class that contains work hours information
    work_hours_element = soup.find_all("span", class_="description__job-criteria-text")
    if work_hours_element:
        work_hours = work_hours_element[1].text.strip()
        print(f"Work hours type: {work_hours}")
    else:
        print("Work hours type not found.")
except Exception as e:
    print(f"Could not extract work hours type: {e}")


# Extract job criteria
try:
    job_criteria_elements = soup.find_all("span", class_="description__job-criteria-text")
    if job_criteria_elements:
        job_criteria = [element.text.strip() for element in job_criteria_elements]
        # Assign each criterion based on expected order
        job_level = job_criteria[0] if len(job_criteria) > 0 else "Not specified"
        employment_type = job_criteria[1] if len(job_criteria) > 1 else "Not specified"
        job_function = job_criteria[2] if len(job_criteria) > 2 else "Not specified"
        industries = job_criteria[3] if len(job_criteria) > 3 else "Not specified"
        
        print(f"Job Level: {job_level}")
        print(f"Employment Type: {employment_type}")
        print(f"Job Function: {job_function}")
        print(f"Industries: {industries}")
    else:
        print("Job criteria not found.")
except Exception as e:
    print(f"Could not extract job criteria: {e}")

    # Extract job description
job_description = soup.find("div", class_="show-more-less-html__markup").get_text(strip=True)

# Detect language
detected_language = detect_language(job_description)  # Use one of the functions above
print(f"Detected Language: {detected_language}")


# Close the browser
driver.quit()
