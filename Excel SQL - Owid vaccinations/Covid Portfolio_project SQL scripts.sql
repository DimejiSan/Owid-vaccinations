--select * from Portfolio_project.dbo.owiddeaths
--select location, date, population, total_cases, new_cases, total_deaths
--from Portfolio_project.dbo.owiddeaths
--order by 1, 2

select * from Portfolio_project.dbo.owiddeaths
where continent is not null
order by 2 

-- looking at the stats for Top 10 Most Populated West African Countries

----total cases vs total deaths 
--Shows current likelihood of death if you contract covid in 10 Most Populated West African Countries

select location, continent, date, total_cases, new_cases, total_deaths, (Convert(float, total_deaths)/Nullif (Convert(float, total_cases), 0))*100 as DeathPercentage
from Portfolio_project.dbo.owiddeaths
where location like 'Nigeria' or location = 'Ghana' or location like 'Mali' or location = 'Togo' or location = 'Burkina Faso' or location = 'Cameroon' or location = 'Niger' or location = 'Senegal' or location = 'Guinea' or location like 'Benin'
order by 1, 2


--total cases vs population
--shows population percentage that contracted covid in 10 Most Populated West African Countries

select location, continent, date, total_cases, population, (Convert(float, total_cases)/Nullif (Convert(float, population), 0))*100 as PopPercentage
from Portfolio_project.dbo.owiddeaths
where location like 'Nigeria' or location = 'Ghana' or location like 'Mali' or location = 'Togo' or location = 'Burkina Faso' or location = 'Cameroon' or location = 'Niger' or location = 'Senegal' or location = 'Guinea' or location like 'Benin'
order by 1, 2


--Highest infection rate compared to population
--shows highest infection rate in 10 Most populated West African countries compared to the population

select location, population, max(total_cases) as HighestInfectionCount, (Convert(float, MAX(total_cases)/Nullif (Convert(float, population), 0)))*100 as InfectedPopPercentage
from Portfolio_project.dbo.owiddeaths
where location like 'Nigeria' or location = 'Ghana' or location like 'Mali' or location = 'Togo' or location = 'Burkina Faso' or location = 'Cameroon' or location = 'Niger' or location = 'Senegal' or location = 'Guinea' or location like 'Benin'
group by location, population
order by InfectedPopPercentage desc


--Highest death count per population in 10 Most Populated West African Countries
--(cast nvarchar(255) as integar)

select location, max(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_project.dbo.owiddeaths
where location like 'Nigeria' or location = 'Ghana' or location like 'Mali' or location = 'Togo' or location = 'Burkina Faso' or location = 'Cameroon' or location = 'Niger' or location = 'Senegal' or location = 'Guinea' or location like 'Benin'
group by location
order by TotalDeathCount desc


--Highest death count by continent - Africa

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_project.dbo.owiddeaths
where continent is not null
and continent like 'Africa'
group by continent
order by TotalDeathCount desc



--Total world Population vs Vaccinations
--USING CTE

with TotalPopvsVaccs (continent, location, date, population, new_vaccinations, SumVaccinationsCount)
as
(
select owd.location, owd.continent, owd.date, owd.population, owv.new_vaccinations
, sum(convert(float, owv.new_vaccinations)) over (partition by owd.location 
order by owd.location, owd.date) as SumVaccinationsCount
from Portfolio_project..owiddeaths owd join Portfolio_project..owidvaccinations owv on owd.location=owv.location and owd.date=owv.date
where owd.continent is not null 
)
select *, (SumVaccinationsCount/population)*100
from TotalPopvsVaccs
order by 1,2

-- Create Temp Table 1
drop table if exists #WorldPercentVaccs
create table #WorldPercentVaccs
(continent nvarchar (255),
location nvarchar (255),
date datetime,
population int,
new_vaccinations numeric,
SumVaccinationsCount numeric
)
insert into #WorldPercentVaccs
select owd.location, owd.continent, owd.date, owd.population, owv.new_vaccinations
, sum(convert(float, owv.new_vaccinations)) over (partition by owd.location 
order by owd.location, owd.date) as SumVaccinationsCount
from Portfolio_project..owiddeaths owd join Portfolio_project..owidvaccinations owv on owd.location=owv.location and owd.date=owv.date
where owd.continent is not null 

select *, (SumVaccinationsCount/population)*100
from #WorldPercentVaccs
order by 1,2





--Total West African Population vs Vaccinations
--Using CTE

with TotalWAPopvsVaccs (continent, location, date, population, new_vaccinations, SumTotalVaccsCount)
as
(
select owd.location, owd.continent, owd.date, owd.population, owv.new_vaccinations
, sum(CONVERT(float, owv.new_vaccinations)) over (partition by owd.location
order by owd.location, owd.date) as SumTotalVaccsCount
from Portfolio_project..owiddeaths owd join Portfolio_project..owidvaccinations owv on owd.location=owv.location and owd.date=owv.date
where owd.continent is not null and owd.continent like 'Africa'
and owd.location like 'Nigeria' or owd.location = 'Ghana' or owd.location like 'Mali' or owd.location = 'Togo' or owd.location = 'Burkina Faso' or owd.location = 'Cameroon' or owd.location = 'Niger' or owd.location = 'Senegal' or owd.location = 'Guinea' or owd.location like 'Benin'
)
select *, (SumTotalVaccsCount/population)*100
from TotalWAPopvsVaccs
order by 1, 2


--Create Temp Table 2

drop table if exists #WestAfricaPercentVaccs

create table #WestAfricaPercentVaccs 
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
population int,
new_vaccinations numeric,
SumTotalVaccsCount numeric
)
insert into #WestAfricaPercentVaccs
select owd.location, owd.continent, owd.date, owd.population, owv.new_vaccinations
, sum(CONVERT(float, owv.new_vaccinations)) over (partition by owd.location
order by owd.location, owd.date) as SumTotalVaccsCount
from Portfolio_project..owiddeaths owd join Portfolio_project..owidvaccinations owv on owd.location=owv.location and owd.date=owv.date
where owd.continent is not null and owd.continent like 'Africa'
and owd.location like 'Nigeria' or owd.location = 'Ghana' or owd.location like 'Mali' or owd.location = 'Togo' or owd.location = 'Burkina Faso' or owd.location = 'Cameroon' or owd.location = 'Niger' or owd.location = 'Senegal' or owd.location = 'Guinea' or owd.location like 'Benin'

select *, (SumTotalVaccsCount/population)*100
from #WestAfricaPercentVaccs
order by 1, 2

--END
