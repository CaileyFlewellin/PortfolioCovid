/*

Queries for my Tableau Project

*/


-- 1.

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths
, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioCovid..CovidData
Where continent is not null
and continent not like '%income%'
Order by 1,2

--Just a double check my calculations against "World"
--Both the queries produce extremly similar results


--Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths
--, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
--From PortfolioCovid..CovidData
---Where continent is not null
---and continent not like '%income%'
--Where location = 'World'
--Order by 1,2


-- 2.

-- European Union is the same thing as Europe

Select location, Sum(cast(new_deaths as int)) as TotalDeathCount
From PortfolioCovid..CovidData
Where continent is null
and location not in ('World', 'European Union', 'International')
and location not like '%income%'
Group by location
Order by TotalDeathCount desc


-- 3. 

Select location, population, Max(total_cases) as HighestInfectionCount
, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioCovid..CovidData
Group by Location, Population Order by PercentPopulationInfected desc


--4

Select Location, Population, date, Max(total_cases) as HighestInfectionCount
, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioCovid..CovidData
Group by Location, Population, date
Order by PercentPopulationInfected desc
