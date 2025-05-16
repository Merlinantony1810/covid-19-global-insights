# 🦠 COVID-19 Worldwide Data Analysis using SQL

This project explores global COVID-19 data to uncover trends in infection rates, mortality, and vaccination efforts using SQL. 
---

## 🔍 Key Analyses & Insights
The project explores various aspects of COVID-19's impact globally, with the following analyses:  

## 🗂️ Dataset Overview
Our World in Data COVID-19 datasets can be found on https://ourworldindata.org/covid-deaths.
___

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
## License
All the material produced by Our World in Data, including interactive visualizations and code, are completely open access under the Creative Commons BY license


