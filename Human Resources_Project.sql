SELECT * FROM projects.`human resources`;
desc `human resources`;
----------------------------------Data Cleaning ---------------------------------------------------

-------Rename column name 'id'-----------
alter table `human resources`
change column id emp_id varchar(20) not null;

------Changing date format of birthdate column from'/' to '-' and datatype of birthdate column from text to date-----
set sql_safe_updates=0;
update `human resources`
set birthdate=case
when birthdate like '%/%' 
then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
when birthdate like '%-%'
then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;

alter table `human resources`
modify column birthdate date;

------Changing date format of hire_date column from'/' to '-' and datatype of hire_date column from text to date-----
update `human resources`
set hire_date=case
when hire_date like '%/%' 
then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
when hire_date like '%-%'
then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;

alter table `human resources`
modify column hire_date date;

-------Changing termdate value to only date from date and time, and fllig up empty cells-----------
update `human resources`
set termdate= date(str_to_date(termdate,'%Y-%m-%d %H:%i:%sUTC'))
where termdate is  not null and termdate!='';	

UPDATE `human resources`
SET termdate =Null
WHERE termdate ='';

ALTER TABLE `human resources`
MODIFY COLUMN termdate DATE ;

select termdate from `human resources`;

------Adding Age column to dataset-------------
alter table `human resources`
add column age int;

update `human resources`
set age= timestampdiff(year,birthdate,curdate());

SELECT birthdate,age FROM projects.`human resources`;

---------Finding the youngest and oldest person--------
select
min(age) as youngest,
max(age) as oldest
from `human resources`;

--------------------------------Few Insights from Dataset ------------------------------

-----Gender breakdown of employees in the company-----------
select gender,count(*)as count
from `human resources`
where age>=18 
group by gender;

----Race/Ethinicity breakdown of employees in company-----
select race, count(*) as count
from `human resources`
where age>=18 
group by race
order by count(*) desc;

-----Age distribution of employees in company----
select 
min(age) as youngest,
max(age) as oldest
from `human resources`
where age>=18 and termdate is Null;

select
case 	
when age>=18 and age<=24 then '18-24'
when age>=25 and age<=34 then '25-34'
when age>=35 and age<=44 then '35-44'
when age>=45 and age<=54 then '45-54'
when age>=55 and age<=64 then '55-64'
else '65+'
end as age_group,gender,
count(*)as count
from `human resources`
where age>=18
group by age_group,gender
order by age_group,gender;

---------employees work at headequaters versus remote loation-------
select location,count(*) as count
from `human resources`
where age>=18 
group by location;

--------Gender distribution vary across the departments and job tites ---------
select department,gender,count(*) as count 
from  `human resources`
where age>=18
group by department,gender 
order by department;

-----------Distribution of jobs tiltle across the company-----
select jobtitle,count(*)as count
from  `human resources`
where age>=18
group by jobtitle
order by jobtitle desc;

---------Department having highest turnover rate------
select department,
total_count,
terminated_count/total_count as termination_rate
from (
select department,
count(*) as total_count,
sum(case when termdate <> Null and termdate <=curdate()then 1 else 0
end ) as terminated_count
from  `human resources`
where age >=18
group by department 
) as subquery 
order by termination_rate desc;

----------Distribution of employees across locations by city and state ----------
select location_state,count(*) as count
from  `human resources`
where age>=18
group by location_state
order by count desc;




