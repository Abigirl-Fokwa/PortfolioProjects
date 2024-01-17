SELECT *
FROM PORTFOLIOPROJECT1..[ CovidDeaths]
order by 3,4

--SELECT *
--FROM PORTFOLIOPROJECT1..['CovidVacinnations']
--Order by 3,4

SELECT location, total_cases, new_cases, total_cases, population
FROM PORTFOLIOPROJECT1..[ CovidDeaths]
order by 1,2

--- Looking at Total cases Vs Total Deaths
--- shows the likelihood of dying if you contract Covid in your country 
SELECT location, date, total_cases, total_deaths, (Cast (total_deaths as decimal))/ (cast(total_cases as decimal))*100 as DeathPercentage
FROM PORTFOLIOPROJECT1..[ CovidDeaths]
WHERE location like '%cameroon%'
order by DeathPercentage desc

--- looking at the total cases Vs the Population
--- shows what Percentage of population got covid 
SELECT location, date, population, total_cases,  (Cast (total_cases as decimal))/ (cast(population as decimal))*100 as PercentagePopulationInfected
FROM PORTFOLIOPROJECT1..[ CovidDeaths]
WHERE location like '%cameroon%'
order by 1,2

--- looking at Countries with Highest Infection rate compared to population 

SELECT location, population, MAX (total_cases) as HighestInfectionCount, MAX( (Cast (total_cases as decimal))/  (cast(population as decimal)))*100 as PercentagePopulationInfected
FROM PORTFOLIOPROJECT1..[ CovidDeaths]
WHERE continent is not null
GROUP By location, population
order by PercentagePopulationInfected desc

--- looking at the countries with the highest Deathcount per Population
SELECT location, MAX(cast (total_deaths as int)) as TotalDeathCount
FROM PORTFOLIOPROJECT1..[ CovidDeaths]
WHERE continent is not null
GROUP By location 
order by TotalDeathCount desc

--- Showing continents with the highest Deathcounts per population 
SELECT continent, MAX(cast (total_deaths as int)) as TotalDeathCount
FROM PORTFOLIOPROJECT1..[ CovidDeaths]
WHERE continent is not null
GROUP By continent
order by TotalDeathCount desc

--- Global Numbers
SELECT date, SUM(new_cases) as totalcases, SUM(cast(new_deaths as int))as totalDeaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PORTFOLIOPROJECT1..[ CovidDeaths]
--WHERE location like '%cameroon%'
WHERE continent is not null
group by date
order by 1,2

--- Looking at Total Population Vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, (vac.new_vaccinations)
,SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PORTFOLIOPROJECT1..[ CovidDeaths] dea
Join PORTFOLIOPROJECT1..['CovidVacinnations'] vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
ORDER By 2,3


--using CTE
;WITH PopsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, ( vac.new_vaccinations)
,SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PORTFOLIOPROJECT1..[ CovidDeaths] dea
Join PORTFOLIOPROJECT1..['CovidVacinnations'] vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--ORDER By 2,3
)
select *, (RollingPeopleVaccinated/population)*100
From PopsVac

--USING TEMP TABLES 
DROP TABLE IF EXISTS #PercentPopulationVaccinated1 
CREATE TABLE #PercentPopulationVaccinated1 
(
continent nVarchar(255),
location nVarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)


INSERT INTO #PercentPopulationVaccinated1
SELECT dea.continent, dea.location, dea.date, dea.population, ( vac.new_vaccinations)
,SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PORTFOLIOPROJECT1..[ CovidDeaths] dea
Join PORTFOLIOPROJECT1..['CovidVacinnations'] vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--ORDER By 2,3

select *, (RollingPeopleVaccinated/population)*100 
From #PercentPopulationVaccinated1 


--creating view to store data for later visualization
GO
create view PercentPopulationVaccinated1 as 
SELECT dea.continent, dea.location, dea.date, dea.population, ( vac.new_vaccinations)
,SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PORTFOLIOPROJECT1..[ CovidDeaths] dea
Join PORTFOLIOPROJECT1..['CovidVacinnations'] vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--ORDER By 2,3




 




 


