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

-- showing countries with highest death count 

SELECT location,max(total_deaths) as total_death_count
FROM coviddeaths
where continent is not null
GROUP BY location
ORDER BY total_death_count desc


-- showing countries with highest death count per population

SELECT location, population,
       MAX(total_deaths) AS total_death_count,
       MAX((total_deaths / population)) * 100 AS death_percent_population
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY death_percent_population DESC;

-- let's break things down by continent


-- showing continent with the highest death count per population
SELECT continent, max(total_deaths) AS total_death_count
FROM coviddeaths
WHERE continent is not null
GROUP BY continent
ORDER BY total_death_count desc

-- global numbers
  
 SELECT sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as death_percentage
 FROM coviddeaths
 WHERE continent is not null
 ORDER BY 1, 2
 

-- looking at total population vs vaccinations

SELECT 
    cd.continent, 
    cd.location, 
    cd.date,
    cd.population, 
    cv.new_vaccinations,
    SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location,cd.date) AS rollingpeoplevaccinated
FROM coviddeaths cd
 JOIN covidvaccinations cv
    on cd.location = cv.location
    and cd.date=cv.date
WHERE cd.continent IS NOT NULL
ORDER BY cd.location,cd.date

WITH PopvsVac(continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
SELECT 
    cd.continent, 
    cd.location, 
    cd.date,
    cd.population, 
    cv.new_vaccinations,
    SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location,cd.date) AS rollingpeoplevaccinated
FROM coviddeaths cd
 JOIN covidvaccinations cv
    on cd.location = cv.location
    and cd.date=cv.date
WHERE cd.continent IS NOT NULL
-- ORDER BY cd.location,cd.date
)
select *, round((rollingpeoplevaccinated/population)*100,2)
from PopvsVac


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

	

Create View death_percentage AS 
SELECT continent, location, date, total_cases, total_deaths, (total_deaths * 1.0 /total_cases) * 100 as death_percentage
FROM coviddeaths
WHERE Continent is not NULL

Create View infected_percent_population  AS 
SELECT continent, location, date, total_cases, population, (total_cases * 1.0 /population) * 100 as infected_percent_population 
FROM coviddeaths
WHERE Continent is not NULL

Create View HighestInfectedCountry AS 
SELECT continent, location, population, Max(total_cases) as highestInfectionCount, MAX((total_cases * 1.0/population)*100) as PercentPopulationInfected
FROM coviddeaths
WHERE Continent is not NULL
Group by continent, location, population

Create View HighestDeathperPopulation AS 
SELECT continent, location, population, MAX(total_deaths) as hightestDeathCount, MAX((total_deaths * 1.0/population)*100) as PercentPopulationDied
FROM coviddeaths
WHERE Continent is not NULL
Group by continent, location, population

Create View HightestDeathCountLocation AS 
SELECT continent, location, MAX(total_deaths) as HightestDeathCount
FROM coviddeaths
WHERE CONTINENT IS NOT NULL 
Group by continent, location

Create View HighestDeathCountContinent AS 
SELECT continent, MAX(total_deaths) as hightestDeathCount
FROM coviddeaths
WHERE CONTINENT IS NOT NULL 
Group by continent

Create View GlobalCasesPerDay AS 
SELECT date, SUM(new_cases) as total_newcases, sum(new_deaths) as total_newdeaths, 
    case
        WHEN SUM(new_cases) <> 0 THEN SUM(new_deaths)*1.0/SUM(new_cases)*100 
        ELSE NULL
    END AS death_rate
FROM coviddeaths
WHERE Continent is not NULL
GROUP BY DATE

CREATE VIEW RollingCountofPeopleVaccinated AS
WITH PopVsVac AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population,  
        CAST(vac.new_vaccinations AS UNSIGNED) AS new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (
            PARTITION BY dea.location 
            ORDER BY dea.location, dea.date
        ) AS RollingCountofPeopleVaccinated
    FROM coviddeaths dea
    JOIN covidvaccinations vac 
        ON dea.location = vac.location 
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, 
       (RollingCountofPeopleVaccinated * 1.0 / population) * 100 AS PercentageofVaccinatedPeople
FROM PopVsVac;



 

