SELECT * 
FROM [Portofolio Project ]..CovidDeaths
where continent is not null
order by 3,4

--SELECT * 
--FROM [Portofolio Project ]..CovidVaccinations
--order by 3,4

--Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portofolio Project ]..CovidDeaths
where continent is not null 

order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [Portofolio Project ]..CovidDeaths
where location like '%greece%'
and continent is not null


order by 1,2


--Looking at Total Cases vs Population
--Shows what percentage of population got Covid

SELECT location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
FROM [Portofolio Project ]..CovidDeaths
where location like '%greece%'
order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population

SELECT location, population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentPopulationInfected
FROM [Portofolio Project ]..CovidDeaths
group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per population


SELECT location, max(cast(total_deaths as int)) as TotalDeathCount
FROM [Portofolio Project ]..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


--Showing the continents with the highest deaths count per population

SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount
FROM [Portofolio Project ]..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

-- Global Numbers

SELECT sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deats, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
FROM [Portofolio Project ]..CovidDeaths
--where location like '%greece%'--
where continent is not null
--group by date
order by 1,2


SELECT date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deats, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
FROM [Portofolio Project ]..CovidDeaths
--where location like '%greece%'--
where continent is not null
group by date
order by 1,2


-- Loking Total Population vs Vaccination Use CTE

With PopvsVac (continent, location, date, population, new_vacciantions, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from [Portofolio Project ]..CovidDeaths dea
join [Portofolio Project ]..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date 
where dea.continent is not null
--order by 2,3
)
select *
from PopvsVac

--Creat Views

create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from [Portofolio Project ]..CovidDeaths dea
join [Portofolio Project ]..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date 
where dea.continent is not null


select *
from PercentPopulationVaccinated

