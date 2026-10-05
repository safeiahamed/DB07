Use Hospital

--Q1
Create or Alter Procedure dbo.GetPatients
As
Select *
from Patients

EXEC dbo.GetPatients


--Q2
Create Or Alter Procedure dbo.GetConsultantSalary
As
Select Name,Salary
from Consultants

Exec dbo.GetConsultantSalary 

--Q3
Create Or Alter Procedure dbo.GetPatientWard
As
select p.Name,w.Name
from Patients p join Wards w
on w.Id=p.WardId

exec dbo.GetPatientWard

--Q4
Create or Alter Procedure dbo.GetPatientById @Id int
As
select p.Name
from Patients p
where p.Id= @Id

Exec dbo.GetPatientById @Id= 202 

--Q5
Create Or Alter Procedure dbo.GetConsultantBySalary @MinSalary Decimal(18,0)
As
Select c.Name ,c.Salary
From Consultants c
where c.Salary>=@MinSalary

exec dbo.GetConsultantBySalary @MinSalary=20000

--Q6
Create Or Alter Procedure dbo.GetPatientByWardId @WardId int
As
select p.Name ,w.Id,w.Name
from Patients p join Wards w
on w.Id=p.WardId
where w.Id=@WardId

exec dbo.GetPatientByWardId @WardId=1

--Q7
Create or Alter Procedure dbo.GetCountOfPatients @CountOfPatients int Output
As
select @CountOfPatients =COUNT(*)
from Patients 

Declare @Count int
exec dbo.GetCountOfPatients @CountOfPatients=@Count Output
select @Count

--Q8
Create Or Alter Procedure dbo.GetAvgSalary @AVGSalary Decimal(18,0) Output
As
select @AVGSalary=AVG(salary)
from Consultants

declare @AVG Decimal(18,0)
exec dbo.GetAvgSalary @AVGSalary=@AVG output
select @AVG


--Q9
Create Or Alter Procedure dbo.GetTotalMedication @Id int ,@TotalMedication int Output
As
select @TotalMedication=SUM(DA.Quantity)
from Patients p join DrugAdministrations DA
on p.Id=DA.PatientId
where p.Id=@Id

Declare @Total int
exec dbo.GetTotalMedication @Id=202,@TotalMedication=@Total output
select @Total

--Q10
Create Or Alter Procedure dbo.GetSalaryPercentage @Salary Decimal(18,2) output,@Percentage Decimal(10,2)
As
Set @Salary =@Salary +(@Salary*@Percentage /100)

Declare @MySalary Decimal(18,0)=10000
Exec dbo.GetSalaryPercentage @Salary=@MySalary Output,@Percentage=10 
select @MySalary

--Q11
Create Or Alter Procedure dbo.GetQuantity @Quantity int Output,@AdditionalQUantity int
As
set @Quantity=@Quantity+@AdditionalQUantity

declare @Additional int = 400
exec dbo.GetQuantity @Additional output ,100
select @Additional

--Q12
Create Or Alter Procedure dbo.GetAnnualSalary @Salary Decimal(18,0) Output 
As
set @Salary=@Salary*12

Declare @Mysalary Decimal(18,2)=10000
exec dbo.GetAnnualSalary @Mysalary output
select @Mysalary

-- from Q13 to Q24 out Exept Q21
--Q21
Create Or Alter Procedure dbo.GetSalaryPercentage @Salary Decimal(18,2) output,@Percentage Decimal(10,2)
As
Set @Salary =@Salary +(@Salary*@Percentage /100)

Declare @MySalary Decimal(18,0)=10000
Exec dbo.GetSalaryPercentage @Salary=@MySalary Output,@Percentage=10 
select @MySalary

--Q25
Create or Alter Procedure dbo.GetPatients
As
Select p.Name ,p.Id
from Patients p

create Table Result
(
Name Varchar(50),Id int
)

insert into Result
EXEC dbo.GetPatients

--Q26
Create Or Alter Procedure dbo.GetMaxSalary @minSalary int
As
select c.Name,c.Salary
from Consultants c
where c.Salary >=@minSalary

Create table Result1
(
Name Varchar(50),Salary Decimal(18,0)
)
insert into Result1
exec dbo.GetMaxSalary 10000

--Q27
Create Or Alter Procedure dbo.GetPatientWard @WardId int
As
select p.Name,w.Name
from Patients p join Wards w
on w.Id=p.WardId
where w.Id=@WardId

create Table Result2
(
PName VarChar(50),WName VarChar(50)
)
insert into Result2
exec dbo.GetPatientWard 1

-- from Q28 to Q47 out

--Q48
Create Or Alter Procedure dbo.GetStatistics
As
 Select
        (Select Count(*) From Patients) ,
        (Select Count(*) From Consultants),
        (Select Avg(Salary) From Consultants) ,
        (Select Sum(Quantity) From DrugAdministrations)

exec dbo.GetStatistics

--Q49,Q50 Out

--Last Assignment Complete
--Q34
Create Function dbo.GetPatientsByWard(@WardId Int)
Returns Table
As
Return
(
    Select *
    From Patients
    Where WardId = @WardId
)

Select *
From dbo.GetPatientsByWard(1)


--Q35
Create Function dbo.GetConsultantsByMinSalary(@MinSalary Decimal(18,2))
Returns Table
As
Return
(
    Select *
    From Consultants
    Where Salary >= @MinSalary
)
Select *
From dbo.GetConsultantsByMinSalary(10000)


--Q36
Create Function dbo.GetPatientsWithWard(@WardId Int)
Returns Table
As
Return
(
    Select p.Name As PatientName, w.Name As WardName
    From Patients p
    Join Wards w
        On p.WardId = w.Id
    Where w.Id = @WardId
)

Select *
From dbo.GetPatientsWithWard(1)


--Q37
Create Function dbo.GetPatientsAboveAge(@MinAge Int)
Returns @Result Table
(
    Id Int,
    Name Varchar(100),
    DOB Date
)
As
Begin
    Insert Into @Result
    Select Id, Name, DOB
    From Patients
    Where DATEDIFF(YEAR, DOB, GETDATE()) >= @MinAge;
    Return
End

Select *
From dbo.GetPatientsAboveAge(30)


--Q38
Create Function dbo.GetPatientMedicationSummary(@PatientId Int)
Returns @Result Table
(
    TotalMedicationQuantity Int,
    NumberOfAdministrations Int
)
As
Begin
    Insert Into @Result
    Select 
        Sum(Quantity),
        Count(*)
    From DrugAdministrations
    Where PatientId = @PatientId;
    Return
End

Select *
From dbo.GetPatientMedicationSummary(1)


--Q39
Create Function dbo.ClassifyConsultantSalaries(@MinSalary Decimal(18,2))
Returns @Result Table
(
    Id Int,
    Name Varchar(100),
    Salary Decimal(18,2),
    SalaryClassification Varchar(20)
)
As
Begin
    Insert Into @Result
    Select
        Id,
        Name,
        Salary,
        Case
            When Salary < 10000 Then 'Low'
            When Salary < 20000 Then 'Medium'
            Else 'High'
        End
    From Consultants
    Where Salary >= @MinSalary;
    Return
End

Select *
From dbo.ClassifyConsultantSalaries(10000)