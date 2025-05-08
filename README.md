# 🦠 COVID-19 Worldwide Data Analysis using SQL

This project explores global COVID-19 data to uncover trends in infection rates, mortality, and vaccination efforts using SQL. It focuses on analyzing detailed information about COVID-19 cases, deaths, population, and vaccination rates across different countries and continents. The goal is to derive valuable insights into the pandemic’s global spread, impact, and response efforts.

---

## 🗂️ Dataset Overview

The analysis leverages two key datasets:

- **`coviddeaths`**: This dataset contains daily records of COVID-19 cases, deaths, and population by country.
- **`covidvaccinations`**: This dataset includes vaccination data (new vaccinations) by country and date.

---

## 🔍 Key Analyses & Insights

The project explores various aspects of COVID-19's impact globally, with the following analyses:

### ✅ **Mortality Rate**
Calculates the percentage of deaths relative to total confirmed cases, offering insight into the severity of the virus in different regions.

### ✅ **Percentage of Population Infected**
Determines the percentage of a country’s population that has contracted COVID-19, helping to assess the spread of the virus in various regions.

### ✅ **Highest Infection Rate by Country**
Identifies the countries with the highest proportion of infected citizens in relation to their population size.

### ✅ **Highest Death Rate per Population**
Highlights countries where the largest percentage of the population has died due to COVID-19.

### ✅ **Country with the Highest Death Count**
Ranks countries by total deaths to show where the pandemic had the greatest absolute impact.

### ✅ **Continent with the Highest Death Count**
Aggregates death totals by continent, offering a broader view of the global impact.

### ✅ **Global Daily Cases and Deaths**
Presents total daily cases and deaths globally, and calculates the global mortality rate based on new cases.

### ✅ **Rolling Count of People Vaccinated**
Tracks the cumulative number of vaccinated individuals per country over time, and computes the percentage of the population that has received the vaccine.

---

## 🧠 SQL Techniques Used

The project uses various advanced SQL techniques to extract meaningful insights:

- **JOINs**: Combining data from different sources (e.g., case data and vaccination data).
- **Common Table Expressions (CTEs)**: Temporary result sets to structure and simplify complex queries.
- **Aggregate Functions**: Functions like `SUM()`, `MAX()`, and `ROUND()` to compute totals, maxima, and averages.
- **Window Functions**: Used to compute running totals, such as the rolling count of vaccinations over time.
- **Views**: Encapsulating common queries into reusable SQL views for easy reporting and analysis.

---

## 🧱 Views Created

The project defines several SQL views that simplify access to critical metrics:

- `mortalityrate`
- `PercentagePopulationInfected`
- `HighestInfectedCountry`
- `HighestDeathperPopulation`
- `hightestDeathCountLocation`
- `percentpopvac`
- `RollingCountofPeopleVaccinated`

These views allow for easier querying of COVID-19 trends and insights for further analysis or visualization.

---

## 📌 Purpose

This project provides insights into the impact of COVID-19 on a global scale, focusing on:

- Understanding the progression and severity of the virus.
- Identifying the regions most affected by the pandemic.
- Assessing the progress of vaccination campaigns.
- Providing data-driven recommendations to aid public health planning.

---

## 🛠️ How to Use

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Merlinantony1810/covidproject.git
