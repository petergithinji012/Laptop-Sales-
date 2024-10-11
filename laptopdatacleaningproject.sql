use practice;

select * from laptopdata;

#Renaming the column name Unnamed: 0 to id
alter table laptopdata 
change `Unnamed: 0` `id` int;

# Removing a special symbol ? from column Weight
delete from laptopdata
where Weight = '?';
#select * from laptopdata where Weight = '?';

describe laptopdata;

# converting the column weight as decimal by removing kg extension unit
select cast(replace(Weight,'kg','') as decimal(10,2)) as Weight from laptopdata;
update laptopdata
set Weight = (replace(Weight,'kg',''));

# Rounding the column price into two decimal palces and updating the changes into the table
select round(price,2) as Price from laptopdata;
update laptopdata
set Price = round(price,2);
select * from laptopdata;

# Splitting the Memory column into Memmory_Size and Memory_Type
select substring_index(Memory,' ',1) as Memory_Size,
substring_index(Memory,' ',-1) as Memory_Type from laptopdata; 
alter table laptopdata
add (Memory_Size nvarchar(225),
Memory_Type nvarchar(225));

update laptopdata
set Memory_Size = substring_index(Memory,' ',1),
Memory_Type = substring_index(Memory,' ',-1);

# cleaning the Opsys column to an understandable.
select * from laptopdata;
select distinct(OpSys) from laptopdata;
select (case when OpSys in ('Windows 10', 'Windows 10 S','Windows 7') then 'Windows'
when OpSys in ('macOS','Mac OS X') then 'Mac Os'
when OpSys in ('No OS','Chrome OS') then 'Undefined'
else OpSys end) as OperatingSystem
from laptopdata;
update laptopdata
set OpSys = case when OpSys in ('Windows 10', 'Windows 10 S','Windows 7') then 'Windows'
when OpSys in ('macOS','Mac OS X') then 'Mac Os'
when OpSys in ('No OS','Chrome OS') then 'Undefined'
else OpSys end;

alter  table laptopdata
drop column Memory;
select * from laptopdata;

# deleting the duplicate rows which may affect my analysis journey.
with cte as (select *,row_number() over( partition by 
Company,TypeName,Inches,ScreenResolution,Cpu,Ram,Gpu,Memory_Type,Price,
OpSys,Memory_Size,Weight order by id) as row_num from laptopdata)
select * from cte where row_num >1;
delete from laptopdata 
where id in ( select id from cte where row_num >1);

# Exploratory Data Analysis with aim to know which are factors which affect laptop sales.
select * from laptopdata;
select OpSys,round(sum(Price),2) as Price from laptopdata
group by OpSys order by Price desc;

select Company,round(sum(Price),2) as Price from laptopdata
group by Company order by Price desc;

select TypeName,round(sum(Price),2) as Price from laptopdata
group by TypeName order by Price desc;

select Ram,round(sum(Price),2) as Price from laptopdata
group by Ram order by Price desc;

# categorizing column weight in order to identify what is the weight of  laptops mostly preferred.
select (case when Weight  between 1 and 2 then '1-2 kgs'
when Weight  between 2 and 3 then '2-3 kgs'
when Weight  between 3 and 4 then '3-4 kgs'
else 'above 4 kgs' end) as Weight from laptopdata;

update laptopdata
set Weight = case when Weight  between 1 and 2 then '1-2 kgs'
when Weight  between 2 and 3 then '2-3 kgs'
when Weight  between 3 and 4 then '3-4 kgs'
else 'above 4 kgs' end;
select * from laptopdata;

select Weight,round(sum(Price),2) as Price from laptopdata
group by Weight order by Price desc;

# Proceed to machine learning in order to construct a predictive model!!!!



