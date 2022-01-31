SELECT * 
FROM "portfolio project".dbo.death$
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM "portfolio project".dbo.death$
ORDER BY 1,2

-- total cases v total deaths PER COUNTRY PER DAY 

SELECT location, date, total_cases, total_deaths, round((total_deaths/total_Cases)*100,2) as death_percentage
FROM "portfolio project".dbo.death$
ORDER BY 1,2

-- total cases v total deaths by country ?? 

SELECT location, sum(cast(new_cases as bigint)) as total_cases, sum(cast(new_deaths as bigint)) as total_deaths, 
SUM(cast(new_deaths as bigint))/sum(cast(new_cases as bigint))*100 as death_percentage 
FROM "portfolio project".dbo.death$
GROUP BY location
ORDER BY 1

-- total cases v population 

SELECT location, date, total_cases, population, round((total_cases/population)*100,2) as percent_of_population_infected
FROM "portfolio project".dbo.death$
ORDER BY 1,2;

-- countries with highest infection rate compared to population 
SELECT location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as population_infected 
FROM "portfolio project".dbo.death$
GROUP BY location, population
ORDER BY 4 desc


-- countries with highest death count per population 
SELECT location, MAX(cast(total_deaths as bigint)) as total_death_count
FROM "portfolio project".dbo.death$
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY 2 desc

-- highest deaths by continent 
SELECT continent , MAX(cast(total_deaths as bigint)) as total_death_count
FROM "portfolio project".dbo.death$
WHERE continent IS not NULL 
GROUP BY continent
ORDER BY 2 desc

-- Global numbers by date
SELECT date, sum(new_Cases) as new_cases, sum(cast(new_deaths as bigint)) as new_deaths, sum(cast(new_deaths as bigint))/sum(new_cases)*100 as death_rate
FROM "portfolio project".dbo.death$
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY 1
-- by country 
SELECT location, sum(new_Cases) as new_cases, sum(cast(new_deaths as bigint)) as new_deaths, sum(cast(new_deaths as bigint))/sum(new_cases)*100 as death_rate
FROM "portfolio project".dbo.death$
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY 1

-- VACCINES

-- total population v vaccination 

SELECT t1.continent, t1.location, t1.date, t1.new_vaccinations,  t1.rolling_vax, (t1.rolling_vax/t1.population)*100 as percentage_name
FROM(
SELECT d.continent, d.location, d.date, v.new_vaccinations, 
sum(cast(v.new_vaccinations as bigint)) over (partition by d.location ORDER BY d.location, d.date) as rolling_vax, d.population
FROM "portfolio project".dbo.vaccinations$ v 
JOIN "portfolio project".dbo.death$ d on d.location=v.location and d.date=v.date
WHERE d.continent is not null
--AND v.new_vaccinations>0 
--ORDER BY 1,2,3 
) t1 
where percentage_name is not null 
order by 1,2,3
