SELECT * FROM coviddeaths

-- selecting relevant column from the table
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM coviddeaths
ORDER BY 1,2

-- looking at total cases  vs total deaths
-- shows likelihood of dying if you contract covid in your country
SELECT location,date,total_cases,total_deaths,round((total_deaths/total_cases)*100,2) as death_percentage
FROM coviddeaths
where location like '%kingdom'
ORDER BY 1,2 

-- looking at total cases vs population
-- shows what percentage of population got covid
SELECT location,date,total_cases,population,(total_cases/population)*100 as infected_percent_population  
FROM coviddeaths
-- where location like '%kingdom'
ORDER BY 1,2 

-- looking at countries with highest infection rate compared to population 
SELECT location,population,max(total_cases) as Highest_infection_count,max((total_cases/population))*100 as infected_percent_population
FROM coviddeaths
GROUP BY location,population
ORDER BY infected_percent_population desc

-- Countries with the highest total COVID-19 death count
SELECT location, MAX(total_deaths) AS total_death_count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

-- Countries with the highest COVID-19 deaths per population percentage
SELECT 
    location, 
    population,
    MAX(total_deaths) AS total_death_count,
    MAX(total_deaths * 1.0 / population) * 100 AS death_percent_population
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY death_percent_population DESC;

-- Continents with the highest total COVID-19 death count
SELECT continent, MAX(total_deaths) AS total_death_count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- Global totals: cases, deaths, and death percentage
SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths, 
    ROUND(SUM(new_deaths) * 100.0 / NULLIF(SUM(new_cases), 0), 2) AS death_percentage
FROM coviddeaths
WHERE continent IS NOT NULL;

-- Daily vaccinations by country with cumulative totals
SELECT 
    cd.continent, 
    cd.location, 
    cd.date,
    cd.population, 
    cv.new_vaccinations,
    SUM(cv.new_vaccinations) OVER (
        PARTITION BY cd.location 
        ORDER BY cd.location, cd.date
    ) AS rolling_people_vaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
    ON cd.location = cv.location
    AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY cd.location, cd.date;

-- Vaccination percentage per country using CTE
WITH PopVsVac AS (
    SELECT 
        cd.continent, 
        cd.location, 
        cd.date,
        cd.population, 
        cv.new_vaccinations,
        SUM(cv.new_vaccinations) OVER (
            PARTITION BY cd.location 
            ORDER BY cd.location, cd.date
        ) AS rolling_people_vaccinated
    FROM coviddeaths cd
    JOIN covidvaccinations cv
        ON cd.location = cv.location
        AND cd.date = cv.date
    WHERE cd.continent IS NOT NULL
)
SELECT *, 
       ROUND((rolling_people_vaccinated * 1.0 / population) * 100, 2) AS percent_vaccinated
FROM PopVsVac;

-- create table
CREATE TABLE covid_project.percentpopulationvaccinated (
    continent VARCHAR(50),
    location VARCHAR(100),
    date DATE,
    population BIGINT,
    new_vaccinations INT,
    rollingpeoplevaccinated BIGINT,
    vaccination_percentage DECIMAL(5,2)
);
-- insert table
INSERT INTO percentpopulationvaccinated
SELECT *,
       ROUND((rollingpeoplevaccinated / population) * 100, 2) AS vaccination_percentage
FROM (
    SELECT 
        cd.continent, 
        cd.location, 
        cd.date,
        cd.population, 
        cv.new_vaccinations,
        SUM(cv.new_vaccinations) OVER (
            PARTITION BY cd.location 
            ORDER BY cd.location, cd.date
        ) AS rollingpeoplevaccinated
    FROM coviddeaths cd
    JOIN covidvaccinations cv
        ON cd.location = cv.location
        AND cd.date = cv.date
    -- WHERE cd.continent IS NOT NULL
) AS subquery
-- ORDER BY location, date;

-- create views
	
CREATE VIEW percentpopvac_v2 as
 SELECT 
        cd.continent, 
        cd.location, 
        cd.date,
        cd.population, 
        cv.new_vaccinations,
        SUM(cv.new_vaccinations) OVER (
            PARTITION BY cd.location 
            ORDER BY cd.location, cd.date
        ) AS rollingpeoplevaccinated
	FROM coviddeaths cd
    JOIN covidvaccinations cv
        ON cd.location = cv.location
        AND cd.date = cv.date
	WHERE cd.continent IS NOT NULL
    -- ORDER BY location, date;


--  Death Percentage View
CREATE VIEW DeathPercentageView AS 
SELECT 
    continent, location, date, 
    total_cases, total_deaths, 
    ROUND((total_deaths * 1.0 / total_cases) * 100, 2) AS death_percentage
FROM coviddeaths
WHERE continent IS NOT NULL;


--  Infection Rate View
CREATE VIEW InfectionRateView AS 
SELECT 
    continent, location, date, 
    total_cases, population, 
    ROUND((total_cases * 1.0 / population) * 100, 2) AS infected_percent_population 
FROM coviddeaths
WHERE continent IS NOT NULL;


-- Highest Infection Countries View
CREATE VIEW HighestInfectionCountriesView AS 
SELECT 
    continent, location, population, 
    MAX(total_cases) AS highest_infection_count, 
    ROUND(MAX(total_cases * 1.0 / population) * 100, 2) AS infected_percent_population
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent, location, population;


-- Vaccination Progress View
CREATE VIEW VaccinationProgressView AS
WITH PopVsVac AS (
    SELECT 
        cd.continent, cd.location, cd.date, 
        cd.population, 
        CAST(cv.new_vaccinations AS UNSIGNED) AS new_vaccinations,
        SUM(CAST(cv.new_vaccinations AS UNSIGNED)) OVER (
            PARTITION BY cd.location 
            ORDER BY cd.location, cd.date
        ) AS rolling_people_vaccinated
    FROM coviddeaths cd
    JOIN covidvaccinations cv 
        ON cd.location = cv.location 
        AND cd.date = cv.date
    WHERE cd.continent IS NOT NULL
)
SELECT *, 
    ROUND((rolling_people_vaccinated * 1.0 / population) * 100, 2) AS vaccination_percentage
FROM PopVsVac;


-- Global Summary View
CREATE VIEW GlobalSummaryView AS 
SELECT 
    date, 
    SUM(new_cases) AS total_new_cases, 
    SUM(new_deaths) AS total_new_deaths, 
    CASE 
        WHEN SUM(new_cases) > 0 THEN ROUND((SUM(new_deaths) * 1.0 / SUM(new_cases)) * 100, 2)
        ELSE NULL
    END AS global_death_rate
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;



 

