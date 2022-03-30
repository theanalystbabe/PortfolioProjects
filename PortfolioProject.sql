SELECT * 
FROM PortfolioProject.DBO.[Covid Deaths]
where continent is not null
ORDER BY 2,3

SELECT * 
FROM PortfolioProject.DBO.CovidVaccines
ORDER BY 2,3

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject.DBO.[Covid Deaths]
ORDER BY 1,2

-- looking at total cases vs total deaths
-- shows the likelihood of dying if you contract covid in your country

SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
FROM PortfolioProject.DBO.[Covid Deaths]
where location like '%Nigeria%'
AND continent is not null
 
 -- Looking at the total cases vs Population
 -- SHOWS what percentage got covid

 SELECT location, date, total_cases, Population, (total_cases/Population)*100 as CasesPercentage
 FROM PortfolioProject..[Covid Deaths]
 where location like '%Nigeria%'
ORDER BY 1,2

-- Looking at Countries with highest infection rate compared to population

 SELECT location, population, MAX(total_cases) AS HighestInfectiousCount, MAX(total_cases/Population)*100 as PercentofPopInfected
 FROM PortfolioProject..[Covid Deaths]
 --where location like '%Niger%'
 GROUP BY location, POPULATION
 ORDER BY PercentofPopInfected

 --Showing Countries with highest Death Count Per population
 
 SELECT location, MAX(cast(total_deaths as int)) AS DeathCount, MAX(total_deaths/Population)*100 as PercentofPopdead
 FROM PortfolioProject..[Covid Deaths]
-- Where location like '%Niger%'
  WHERE continent is not null
 GROUP BY location
 ORDER BY DeathCount desc

 -- Lets break things down by Continent
  -- Showing the continent with the highest deathcount

  SELECT continent, MAX(cast(total_deaths as int)) AS DeathCount, MAX(total_deaths/Population)*100 as PercentofPopdead
 FROM PortfolioProject..[Covid Deaths]
-- Where location like '%Niger%'
  WHERE continent is not null
 GROUP BY continent
 ORDER BY DeathCount desc

  SELECT location, MAX(cast(total_deaths as int)) AS DeathCount, MAX(total_deaths/Population)*100 as PercentofPopdead
 FROM PortfolioProject..[Covid Deaths]
-- Where location like '%Niger%'
  WHERE continent is null
 GROUP BY location
 ORDER BY DeathCount desc

 -- GLOBAL NUMBERS

  SELECT location, date, total_cases, Population, (total_cases/Population)*100 as CasesPercentage
	FROM PortfolioProject..[Covid Deaths]
	 --where location like '%Nigeria%'
	 Where continent is not null
	 Group By date
	ORDER BY 1,2

	SELECT Sum(new_cases) as TotalNewCases, Sum(cast(new_deaths as int)) as TotalNewdeaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercent
FROM PortfolioProject..[Covid Deaths]
where continent is not null
--GROUP BY date
ORDER BY 1,2 



--JOIN THE TWO TABLES COVID DEATHS AND VACCINATION TO FIND TOTAL POULATION VS VACCINATION
select * 
From PortfolioProject..[Covid Deaths] DEA
Join PortfolioProject..[CovidVaccines] VAC
ON DEA.LOCATION = VAC.LOCATION
AND DEA.date = VAC.date

SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
FROM PortfolioProject..[Covid Deaths] DEA
JOIN PortfolioProject..CovidVaccines VAC
	ON DEA.location = VAC.location
	AND DEA.date = VAC.date
where dea.continent is not null
Order by 2,5 DESC


--TOTAL POULATION VS VACCINATION
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations,
SUM(CONVERT(numeric,VAC.new_vaccinations)) OVER(Partition by DEA.Location Order by DEA.location, DEA.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..[Covid Deaths] DEA
JOIN PortfolioProject..CovidVaccines VAC
	ON DEA.location = VAC.location
	AND DEA.date = VAC.date
where DEA.continent is not null
Order by 2,3 

Create View PercentPopVaccinated
as
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations,
SUM(CONVERT(numeric,VAC.new_vaccinations)) OVER(Partition by DEA.Location Order by DEA.location, DEA.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..[Covid Deaths] DEA
JOIN PortfolioProject..CovidVaccines VAC
	ON DEA.location = VAC.location
	AND DEA.date = VAC.date
where DEA.continent is not null
--Order by 2,3 

select * 
From PercentPopVaccinated

