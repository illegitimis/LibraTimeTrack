select @@version
--Microsoft SQL Server 2012 (SP1) - 11.0.3000.0 (X64)   Oct 19 2012 13:38:57   
--Copyright (c) Microsoft Corporation  Express Edition (64-bit) on Windows NT 6.1 <X64> (Build 7601: Service Pack 1) 

create database LibraTimeTrack;
-- Verify the database files and sizes
SELECT name, size, size*1.0/128 AS [Size in MBs] FROM sys.master_files WHERE name = N'LibraTimeTrack';

declare @d date=getdate();
select 
cast (datepart(year, @d) as smallint) yy, 
datepart(quarter, @d) q, 
datepart(month, @d) m, 
datename(month, @d) mm, 
datepart(dayofyear, @d) dy, 
datepart(day, @d) d, 
datepart(week, @d) wk,  
datepart(weekday, @d) wd, 
DATENAME(weekday, @d);


----
alter procedure insertPM (
@Id int,
@Name varchar(100),
@IsRT bit=0,
@QmId varchar(10)=null)
as
begin
declare @Url char(100);
--select @Url = 'https://rt.libra.bank/Ticket/Display.html?id='+@Id;
select @Url = 'https://librahome/PM/index.php?m=projects&a=view&project_id='+@Id;

insert into PM (Id,Name,Url,IsRT,QmId) values (@Id,@Name,@Url,@IsRT,@QmId);
insert into Items (RTId, PMId) values (null, @Id);
end
go
---
alter procedure insertRT (
@Id int,
@Name varchar(100),
@IsPM bit=0)
as
begin
declare @Url char(100);
select @Url = 'https://rt.libra.bank/Ticket/Display.html?id='+@Id;
--select @Url = 'https://librahome/PM/index.php?m=projects&a=view&project_id='+@Id;

insert into RT (Id,Name,Url,IsPM) values (@Id,@Name,@Url,@IsPM);
insert into Items (RTId, PMId) values (@Id,null);
end
go
---
alter procedure insertActivity(
@date date,
@login char(30),
@hrs tinyint,
@item int
)
as 
begin

if @hrs<0 
	begin
	--raiseerror(N'Unacceptable',10,1);
	return
	end
else
	begin
		if @hrs>12
			begin 
			--raiseerror(N'Cannot insert more than 12 hrs of activity on a single item on a certain day',10,1);
			return
			end
		else
			begin
			

			--declare @rtid int;
			--select @rtid = RTId from Items where Id=@item;

				
			insert into Activity (Date,PersonLogin,NoHours,ItemId,Year,Month,MonthName,DayOfYear,DayOfMonth,WeekNo,WeekDay,DayOfWeek,Quarter)
			values (
			@date,
			@login ,
			@hrs ,
			@item ,
			cast (datepart(year, @date) as smallint), 
			cast (datepart(month, @date) as tinyint), 
			cast (datename(month, @date) as CHAR(10)), 
			cast(datepart(dayofyear, @date) as smallint), 
			cast (datepart(day, @date) as tinyint), 
			cast (datepart(week, @date) as tinyint),  
			cast(DATENAME(weekday, @date) as CHAR(10)),
			cast (datepart(weekday, @date) as tinyint), 
			cast (datepart(quarter, @date) as tinyint) 
			); 

			end
	end



end
go
---
create procedure insertEstimation(
@date date,
@login char(30),
@hrs tinyint,
@item int
)
as 
begin

if @hrs<0 
	begin
	--raiseerror(N'Unacceptable',10,1);
	return
	end
else
	begin
		if @hrs>12
			begin 
			--raiseerror(N'Cannot insert more than 12 hrs of activity on a single item on a certain day',10,1);
			return
			end
		else
			begin
			

			if ( @hrs>6 and exists (select top(1) 1 from Items where Id=@item and PMId is not null))
			begin 
			--raiseerror(N'Cannot estimate more than 6 hrs of activity on a project on a certain day',10,1);
			return
			end
			
			else
				begin
			insert into Estimations (Date,PersonLogin,NoHours,ItemId,Year,Month,MonthName,DayOfYear,DayOfMonth,WeekNo,WeekDay,DayOfWeek,Quarter)
			values (
			@date,
			@login ,
			@hrs ,
			@item ,
			cast (datepart(year, @date) as smallint), 
			cast (datepart(month, @date) as tinyint), 
			cast (datename(month, @date) as CHAR(10)), 
			cast(datepart(dayofyear, @date) as smallint), 
			cast (datepart(day, @date) as tinyint), 
			cast (datepart(week, @date) as tinyint),  
			cast(DATENAME(weekday, @date) as CHAR(10)),
			cast (datepart(weekday, @date) as tinyint), 
			cast (datepart(quarter, @date) as tinyint) 
			); 
end
			end
	end



end
go



----
----
exec insertRT 450748, 'evaluarea anuala a clientelei', @Id out;
select @Id;
exec insertPM 1280, 'Migrare CLM in T24', @Id out, 0, 'ADC1043';
select @Id;		
exec insertPM 0, 'Nimic', @Id out, 2;
select @Id;		

declare @Id int;

----
insert into Teams (Name) 
select 'DevTeam' union 
select 'DevCraiova' union 
select 'IBK' union 
select 'T24' 
----
insert into Teams2Persons (Team,Login,Date)
select 'DevTeam','raluca.baros',GETDATE() union
select 'DevTeam','ciprian.popescu',GETDATE() union
select 'DevTeam','alexandru.munteanu',GETDATE() 
--
declare @Id int;
exec insertPM 1384,'Actualizare date in IBS (Q3 mutat din Q2)',@Id,0,'CEP1027'
exec insertPM 1164,'acces unik ibk ptr user',@Id,0,'OPR0398'
exec insertPM 2233,'Modificare date din raportul 213 - IBS',@Id,1
exec insertPM 1280,'Migrare CLM in T24',@Id,0,'ADC1043'

exec insertRT 393613,'Automatizare interogari CRC/BC',@Id,101--ADC1039
exec insertRT 364790,'remediere erori preluare Greylist IBS in T24',@Id 	
exec insertRT 450748,'evaluarea anuala a clientelei',@Id 	
exec insertRT 454657,'FINREP',@Id 	
exec insertRT 455244,'Investigare ID 200094878',@Id 	
exec insertRT 455980,'mesaj eroare raport MONEYGRAM',@Id 	
exec insertRT 456005,'Verificare Clienti inactivi pt inchidere ',@Id 	
exec insertRT 456289,'Flux conventie salarii adaugare Type document',@Id 	
exec insertRT 456659,'cont online 2089376 ramas in eroare',@Id 	
exec insertRT 456722,'impartire benzi - pt Audit',@Id 	
exec insertRT 457054,'Extragere crestere de provizion la creditele in sold la 31.12.2014 fata de 31.12.2013',@Id 	
exec insertRT 457164,'Completare camp Beneficiar real -Cont Online',@Id 	
exec insertRT 457400,'eroare cerere ID 20095719 ',@Id 	
exec insertRT 457437,'situatii conform cerinta BNR',@Id 	
exec insertRT 458040,'URGENT RAP BNR',@Id 	
exec insertRT 458348,'Raport restructurate',@Id 	
exec insertRT 458978,'impartire credite lcr - 7 benzi -control BNR',@Id 	
exec insertRT 459478,'FINREP F02',@Id 	
exec insertRT 459615,'Procentul de dobanda in portofoliul de credite',@Id 	
exec insertRT 459622,'Rugaminte urgenta pt DELOITTE',@Id 	

----
exec insertActivity
1	1-apr.	13	Mi	Andrei Popescu	Raport restructurate	5,0
1	1-apr.	13	Mi	Andrei Popescu	Modificare date din raportul 213 - IBS 	2,5
1	1-apr.	13	Mi	Andrei Popescu	Migrare CLM in T24	1,0
1	1-apr.	13	Mi	Raluca Baros	Atomatizare interogari CRC/BC	5,0
1	1-apr.	13	Mi	Raluca Baros	remediere erori preluare Greylist IBS in T24	3,0
1	1-apr.	13	Mi	Alex Munteanu	URGENT RAP BNR	3
1	1-apr.	13	Mi	Alex Munteanu	FINREP	2
1	1-apr.	13	Mi	Alex Munteanu	Modificare Raportare CRC	3,5
1	1-apr.	13	Mi	Alex Munteanu	Completare camp Beneficiar real -Cont Online	3			

2	2-apr.	13	J	Andrei Popescu	FINREP	2,0
2	2-apr.	13	J	Andrei Popescu	situatii conform cerinta BNR	2,0

2	2-apr.	13	J	Alex Munteanu	Completare camp Beneficiar real -Cont Online	3
2	2-apr.	13	J	Alex Munteanu	URGENT RAP BNR	3,0
2	2-apr.	13	J	Alex Munteanu	FINREP	1
2	2-apr.	13	J	Alex Munteanu	Raport restructurate	3
2	2-apr.	13	J	Alex Munteanu	Procentul de dobanda in portofoliul de credite	1
2	2-apr.	13	J	Alex Munteanu	Rugaminte urgenta pt DELOITTE	1
2	2-apr.	13	J	Raluca Baros	Actualizare date in IBS	2
2	2-apr.	13	J	Raluca Baros	Automatizare interogari CRC/BC	4
2	2-apr.	13	J	Raluca Baros	Completare camp Beneficiar real -Cont Online	2

3	3-apr.	13	V	Alex Munteanu	Raport restructurate	1
3	3-apr.	13	V	Alex Munteanu	impartire credite lcr - 7 benzi -control BNR	0,5
3	3-apr.	13	V	Alex Munteanu	FINREP F02	2
3	3-apr.	13	V	Alex Munteanu	Modificare Raportare CRC	4,5
3	3-apr.	13	V	Raluca Baros	OPR0398	2
3	3-apr.	13	V	Raluca Baros	Automatizare interogari CRC/BC	3
----
--Name	Login
--Alexandru Munteanu	?
exec insertEstimation '2015-04-01','alexandru.munteanu',0,3
exec insertEstimation '2015-04-02','alexandru.munteanu',0,3
exec insertEstimation '2015-04-03','alexandru.munteanu',0,3
--Andrei Popescu	               
exec insertEstimation '2015-04-01','ciprian.popescu',4,2
exec insertEstimation '2015-04-02','ciprian.popescu',4,2
exec insertEstimation '2015-04-03','ciprian.popescu',4,2
--Raluca Baros	                  
exec insertEstimation '2015-04-01','raluca.baros',6,7
exec insertEstimation '2015-04-02','raluca.baros',6,7
exec insertEstimation '2015-04-03','raluca.baros',6,7
						
						
						
						
						


	 		
			