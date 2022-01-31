/*

--Data Exploration

*/

Select *
From PortfolioProject..CovidData
where continent not like '%income%'
And continent is not null 

---------------------------------------------------------------------------------------------------------------------------------

-- Looking at Total Cases vs Total Death
-- Death Percentage by Country 

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidData
Where location like '%states%'
Order by 1,2


-----------------------------------------------------------------------------------------------------------------------


--Total Cases vs Population
-- Showcases what percentage of population has contracted Covid


Select Location, date, total_cases, Population, (total_cases/population)*100 as CasePercentage 
From PortfolioProject..CovidData
Where continent not like '%income%'
and continent is not null
Order by 1,2


----------------------------------------------------------------------------------------------------------------------------------------

--Looking at Countries with Highest infection rate compared to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidData
Where continent not like '%income%'
And continent is not null
Group by Location, Population
Order by PercentPopulationInfected desc


---------------------------------------------------------------------------------------------------------------------------------------------


--Showing highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidData
Where continent not like '%income%'
and continent is not null
Group by Location
Order by TotalDeathCount desc


------------------------------------------------------------------------------------------------------------------------


--Showing Death Count by Continent


Select Continent, Max(Cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidData
Where continent not like '%income%'
and continent is not null
Group by continent
Order by TotalDeathCount desc


-----------------------------------------------------------------------------------------------------------------------------------------------


--Global Numbers


Select Sum(new_cases) as Total_Cases, Sum(cast(new_deaths as int)) as Total_Deaths, (Sum(cast(new_deaths as int))/Sum(New_cases))*100 as DeathPercentage
From PortfolioProject..CovidData
Where continent not like '%income%'
and continent is not null
Order by 1,2

---------------------------------------------------------------------------------------------------------------------------------------------------------


-- Looking at Total Population vs Vaccinations

Select continent, location, date, population, new_vaccinations
From PortfolioProject..CovidData
Where continent not like '%income%'
and continent is not null
Order by 2,3

----------------------------------------------------------------------------------------------------------------------------------

--New Vaccinations per day

Select continent, location, date, population, new_vaccinations
, Sum(cast(new_vaccinations as bigint)) OVER (Partition by Location Order by date) as RollingPeopleVaccinated
From PortfolioProject..CovidData
Where continent not like '%income%'
and continent is not null
Order by 2,3

---------------------------------------------------------------------------------------------------


--Use CTE (Common Table Expressions)

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
As
(
Select continent, location, date, population, new_vaccinations
, Sum(cast(new_vaccinations as bigint)) OVER (Partition by Location Order by date) as RollingPeopleVaccinated
From PortfolioProject..CovidData
Where continent not like '%income%'
and continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

---------------------------------------------------------------------------------------------------------------


--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric 
)

Insert into #PercentPopulationVaccinated
Select continent, location, date, population, new_vaccinations
, Sum(cast(new_vaccinations as bigint)) OVER (Partition by Location Order by date) as RollingPeopleVaccinated
From PortfolioProject..CovidData
Where continent not like '%income%'
and continent is not null
Order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-----------------------------------------------------------------------------------------------------------------------------------

--Creating View

Create View PercentPeopleVaccinated as
Select continent, location, date, population, new_vaccinations
, Sum(cast(new_vaccinations as bigint)) OVER (Partition by Location Order by date) as RollingPeopleVaccinated
From PortfolioProject..CovidData
Where continent not like '%income%'
and continent is not null

