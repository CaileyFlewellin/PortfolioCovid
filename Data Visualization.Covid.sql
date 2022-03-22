/*

Queries for my Tableau Visualization
Cailey Flewellin
2/1/2022


*/


-- 1. Global Numbers

-- Used for a Word Chart

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths
, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidData
Where continent is not null
Order by 1,2



-- 2. Total Death Count by Continent

-- Used for Bar Chart

-- European Union is the same thing as Europe

Select location, Sum(cast(new_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidData
Where continent is null
and location not in ('World', 'European Union', 'International')
and location not like '%income%'
Group by location
Order by TotalDeathCount desc


-- 3. Percent Population Infected by Country

-- Used for Map Chart

Select location, population, Max(total_cases) as HighestInfectionCount
, Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project]..CovidData
Group by Location, Population Order by PercentPopulationInfected desc


--4 Percent Population Infected by Country and Date

-- Used to Forecast and Line Graph

Select Location, Population, date, Max(total_cases) as HighestInfectionCount
, Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project]..CovidData
Group by Location, Population, date
Order by PercentPopulationInfected desc