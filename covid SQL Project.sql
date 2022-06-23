Select *
FROM dbo.CovidDeaths
order by 3,4

--Select *
--FROM dbo.CovidDeaths
--order by 3,4

-- Select Data that we are going to be using
-- shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.CovidDeaths
WHERE location like '%states%'
order by 1,2

-- looking at total cases vs population
Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM dbo.CovidDeaths
-- WHERE location like '%states%'
order by 1,2

-- Looking at countries with highest infection rate compared to populatinon
Select Location,Population,MAX(total_cases)as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
From dbo.CovidDeaths
--Where location like'%states%'
Group by Location,Population
order by PercentPopulationInfected desc

-- show countries with the highest Death count per population
Select Location,MAX(cast(Total_deaths as int))as TotalDeathCount
From dbo.CovidDeaths
--Where location like'%states%'
WHERE continent is not null
Group by Location
order by TotalDeathCount desc

-- let's break things down by continent

Select continent,MAX(cast(Total_deaths as int))as TotalDeathCount
From dbo.CovidDeaths
--Where location like'%states%'
WHERE continent is not null
Group by continent
order by TotalDeathCount desc

-- showing the continents with the highest death count
Select continent,MAX(cast(Total_deaths as int))as TotalDeathCount
From dbo.CovidDeaths
--Where location like'%states%'
WHERE continent is not null
Group by continent
order by TotalDeathCount desc

-- global numbers part 1 
Select date, sum(new_cases) as total_cases, Sum(cast(new_deaths as int)), sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage -- population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM dbo.CovidDeaths
-- WHERE location like '%states%'
where continent is not null
Group by date
order by 1,2

-- see total global numbers
Select sum(new_cases) as total_cases, Sum(cast(new_deaths as int)), sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage -- population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM dbo.CovidDeaths
-- WHERE location like '%states%'
where continent is not null
--Group by date
order by 1,2

-- looking at totaala population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
	order by 2,3

	-- USE CTE
With PopsvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
	--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopsvsVac

-- Temp table

DROP Table if exists #PercentPopulationVaccinated
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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Create view to store data for visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select* 
FROM PercentPopulationVaccinated
