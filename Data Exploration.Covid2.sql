/*

-- Data Exploration
-- Cailey Flewellin
-- 1/31/2022

*/

Select *
From [Portfolio Project]..CovidData
Where continent is not null
Order by 3, 4

-----------------------------------------------------------------------------------

-- Selecting the data that I am going to be using


Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidData
Where continent is not null
Order by 1,2

--Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidData
Where location like '%states%'
And continent is not null
Order by 1,2

-- Total Cases vs Population
-- Shows what percentage of the population got Covid

Select location, date,population, total_cases, (total_cases/population)*100 as CasePercentage
From [Portfolio Project]..CovidData
Where location like '%states%'
And continent is not null
Order by 1,2

-- Countries with Highest Infection Rate Compared to Population

Select location,population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as CasePercentage
From [Portfolio Project]..CovidData
Where continent is not null
Group by Location, Population
Order by CasePercentage desc

--Showcases Countries with Highest Death Count Per Population


Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidData
Where continent is not null
Group by Location
Order by TotalDeathCount desc

-----------------------------------------------------------------------------------------------------------------

--Breaking this down by continent

--Showcases Highest Death Count Per Continent

Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidData
Where continent is null
And location not like '%income%'
Group by location
Order by TotalDeathCount desc


--Global Numbers

Select Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths,
	Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidData
Where continent is not null
Order by 1,2

-----------------------------------------------------------------------------------------------------------------
--Vaccination Information


--Total Population vs Vaccinations

Select continent, location, date, population, new_vaccinations
From [Portfolio Project]..CovidData
Where continent is not null
Order by 2,3

--New Vaccinations Per Day (Creating a Rolling Count)

Select continent, location, date, population, new_vaccinations,
SUM(cast(new_vaccinations as bigint)) OVER (Partition by Location Order by date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidData
Where continent is not null
Order by 2,3

-- Use CTE(Common Expression Table)

With PopvsVac (Continent, Location, Date, Population,New_vaccinations, RollingPeopleVaccinated)
as
(
Select continent, location, date, population, new_vaccinations,
SUM(cast(new_vaccinations as bigint)) OVER (Partition by Location Order by date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidData
Where continent is not null

)

Select *,(RollingPeopleVaccinated/Population)*100 as RollingVaccinationPercentage
From PopvsVac

--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
)

Insert Into #PercentPopulationVaccinated
Select continent, location, date, population, new_vaccinations,
SUM(cast(new_vaccinations as bigint)) OVER (Partition by Location Order by date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidData
Where continent is not null

Select *,(RollingPeopleVaccinated/Population)*100 as RollingVaccinationPercentage
From #PercentPopulationVaccinated


-- Create a View

Create View PercentPopulationVaccinated as
Select continent, location, date, population, new_vaccinations,
SUM(cast(new_vaccinations as bigint)) OVER (Partition by Location Order by date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidData
Where continent is not null
