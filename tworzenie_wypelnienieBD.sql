-- tworzenie bazy Geodesy

IF EXISTS (SELECT name FROM master.sys.databases WHERE name = N'Geodesy')			
BEGIN
    PRINT 'Database Geodesy already exist'
END
ELSE
BEGIN
    CREATE DATABASE Geodesy
    PRINT 'Database Geodesy is created.'
END
GO

-- prze³¹czenie kontekstu bazy danych na Geodesy

USE Geodesy																	
GO



-------------------- TWORZENIE TABEL

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--tabela county zawieraj¹ca powiaty 

CREATE TABLE [dbo].[county](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_county] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--tabela borough zawieraj¹ca gminy

CREATE TABLE [dbo].[borough](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[countyID] [int] NOT NULL,
 CONSTRAINT [PK_borough] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- tabela district zawierajaca obreby

CREATE TABLE [dbo].[district](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[boroughID] [int] NOT NULL,
 CONSTRAINT [PK_district] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- tabela job_type zawieraj¹ca rodzaje prac geodezyjnych wykonywanych przez firme oraz informacje o sposobie wyceny

CREATE TABLE [dbo].[job_type](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[jobType] [nvarchar](50) NOT NULL,
	[price] [money] NULL,
	[countMethod] [nvarchar](50) NULL,
 CONSTRAINT [PK_job_type] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- tabela employees zawieraj¹ca informacje o pracownikach

CREATE TABLE [dbo].[employees](
	[ID] [int] NOT NULL IDENTITY(1,1),
	[name] [nvarchar](50) NOT NULL,
	[lastName] [nvarchar](50) NOT NULL,
	[mobile] [nchar](9) NULL,
	[position] [nvarchar](50) NOT NULL,
	[salary] [money] NOT NULL,
	[extraTimeWage] [money] NULL,
	[expYears] [int] NOT NULL,
	[admissionDate] [date] NOT NULL,
 CONSTRAINT [PK_employees] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- tabela extra_time zawierajaca informacje o nadgodzinach

CREATE TABLE [dbo].[extra_time](
	[employeeID] [int] NOT NULL,
	[date] [date] NOT NULL,
	[hours] [int] NOT NULL
) ON [PRIMARY]
GO

-- tabela survey instruments zawieraj¹ca informacje o instrumentach geodezyjnych

CREATE TABLE [dbo].[survey_instruments](
	[ID] [int] NOT NULL IDENTITY(1,1),
	[name] [nvarchar](50) NOT NULL,
	[type] [nvarchar](20) NOT NULL,
	[serialNo] [nvarchar](20) NULL,
	[lastInspection] [date] NULL,
 CONSTRAINT [PK_survey_instruments] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- tabela all_jobs, bedaca glowna tabela, zawiera wszystkie wymagane informacje o zlenonych pracach geodezyjnych

CREATE TABLE [dbo].[all_jobs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TZnumber] [nvarchar](50) NOT NULL,
	[districtID] [int] NOT NULL,
	[jobTypeID] [int] NOT NULL,
	[area] [int] NULL,
	[length] [int] NULL,
	[noOfAxles] [int] NULL,
	[customerID] [int] NOT NULL,
	[jobRecievedDate] [date] NOT NULL,
	[status] [nvarchar](50) NOT NULL,
	[jobEndedDate] [date] NULL,
 CONSTRAINT [PK_all_jobs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

-- tabela z przydzialem zadan do pracownikow, obsluguje relacje wiele - do - wielu

CREATE TABLE [dbo].[job_assignments](
	[jobID] [int] NOT NULL,
	[employeeID] [int] NOT NULL,
	[instrumentID] [int] NULL
) ON [PRIMARY]

GO

-- tabela z informacjami o zleceniodawcach

CREATE TABLE [dbo].[customers](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[companyName] [nvarchar](50) NOT NULL,
	[emailAddress] [nvarchar](50) NULL,
	[mobile] [nchar](9) NOT NULL,
	[address] [nvarchar](50) NOT NULL,
	[postalCode] [nvarchar](6) NOT NULL,
	[city] [nvarchar](50) NOT NULL,
	[coopStartDate] [date] NOT NULL,
	[noOfJobsGiven] [int] NOT NULL,
 CONSTRAINT [PK_customers] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

-- tabela z infomacjami o platnosciach i fakturach

CREATE TABLE [dbo].[payments](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NOT NULL,
	[jobID] [int] NOT NULL,
	[FVnumber] [nvarchar](50) NOT NULL,
	[cost] [money] NOT NULL,
	[FVdate] [date] NOT NULL,
	[status] [bit] NOT NULL,
	[paymentDate] [date] NULL,
 CONSTRAINT [PK_payments] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



-------------------- TWORZENIE RELACJI POMIÊDZY TABELAMI

-- relacja pomiêdzy gminami a powiatami

ALTER TABLE [dbo].[borough]  WITH NOCHECK ADD  CONSTRAINT [FK_borough_county] FOREIGN KEY([countyID])
REFERENCES [dbo].[county] ([ID])
GO
ALTER TABLE [dbo].[borough] CHECK CONSTRAINT [FK_borough_county]
GO

-- relacja pomiêdzy obrêbami a gminami

ALTER TABLE [dbo].[district]  WITH NOCHECK ADD  CONSTRAINT [FK_district_borough] FOREIGN KEY([boroughID])
REFERENCES [dbo].[borough] ([ID])
GO
ALTER TABLE [dbo].[district] CHECK CONSTRAINT [FK_district_borough]
GO

-- relacja pomiêdzy pracownikami a nadgodzinami

ALTER TABLE [dbo].[extra_time]  WITH CHECK ADD  CONSTRAINT [FK_extra_time_employees] FOREIGN KEY([employeeID])
REFERENCES [dbo].[employees] ([ID])
GO
ALTER TABLE [dbo].[extra_time] CHECK CONSTRAINT [FK_extra_time_employees]
GO

-- relacja pomiêdzy pracami geodezyjnymi a obrebami

ALTER TABLE [dbo].[all_jobs]  WITH CHECK ADD  CONSTRAINT [FK_all_jobs_district] FOREIGN KEY([districtID])
REFERENCES [dbo].[district] ([ID])
GO
ALTER TABLE [dbo].[all_jobs] CHECK CONSTRAINT [FK_all_jobs_district]
GO

-- relacja pomiêdzy pracami geodezyjnymi a rodzajami robót geodezyjnych

ALTER TABLE [dbo].[all_jobs]  WITH CHECK ADD  CONSTRAINT [FK_all_jobs_job_type] FOREIGN KEY([jobTypeID])
REFERENCES [dbo].[job_type] ([ID])
GO
ALTER TABLE [dbo].[all_jobs] CHECK CONSTRAINT [FK_all_jobs_job_type]
GO

-- relacja pomiêdzy pracami geodezyjnymi a zleceniodawcami

ALTER TABLE [dbo].[all_jobs]  WITH CHECK ADD  CONSTRAINT [FK_all_jobs_customers] FOREIGN KEY([customerID])
REFERENCES [dbo].[customers] ([ID])
GO
ALTER TABLE [dbo].[all_jobs] CHECK CONSTRAINT [FK_all_jobs_customers]
GO

-- relacja wiele - do - wielu pomiêdzy pracownikami a przydzielonymi im zadaniami w tabeli buforowej z przydzia³em prac

ALTER TABLE [dbo].[job_assignments]  WITH CHECK ADD  CONSTRAINT [FK_job_assignments_all_jobs] FOREIGN KEY([jobID])
REFERENCES [dbo].[all_jobs] ([ID])
GO
ALTER TABLE [dbo].[job_assignments] CHECK CONSTRAINT [FK_job_assignments_all_jobs]
GO

ALTER TABLE [dbo].[job_assignments]  WITH CHECK ADD  CONSTRAINT [FK_job_assignments_employees] FOREIGN KEY([employeeID])
REFERENCES [dbo].[employees] ([ID])
GO
ALTER TABLE [dbo].[job_assignments] CHECK CONSTRAINT [FK_job_assignments_employees]
GO

ALTER TABLE [dbo].[job_assignments]  WITH CHECK ADD  CONSTRAINT [FK_job_assignments_survey_instruments] FOREIGN KEY([instrumentID])
REFERENCES [dbo].[survey_instruments] ([ID])
GO
ALTER TABLE [dbo].[job_assignments] CHECK CONSTRAINT [FK_job_assignments_survey_instruments]
GO

-- relacja pomiedzy platnosciami a zleceniodawcami

ALTER TABLE [dbo].[payments]  WITH CHECK ADD  CONSTRAINT [FK_payments_customers] FOREIGN KEY([customerID])
REFERENCES [dbo].[customers] ([ID])
GO
ALTER TABLE [dbo].[payments] CHECK CONSTRAINT [FK_payments_customers]
GO

-- relacja pomiedzy platnosciami a pracami geodezyjnymi

ALTER TABLE [dbo].[payments]  WITH CHECK ADD  CONSTRAINT [FK_payments_all_jobs] FOREIGN KEY([jobID])
REFERENCES [dbo].[all_jobs] ([ID])
GO
ALTER TABLE [dbo].[payments] CHECK CONSTRAINT [FK_payments_all_jobs]
GO



-------------------- DODATKOWE CONSTRAINTY

-- TABELA EMPLOYEES - sprawdzenie poprawnosci numeru telefonu 

ALTER TABLE [dbo].[employees]  WITH CHECK ADD  CONSTRAINT [CK_emp_checkMobileValue] CHECK  (([mobile] like N'[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[employees] CHECK CONSTRAINT [CK_emp_checkMobileValue]
GO

-- TABELA ALL_JOBS - sprawdzenie poprawnosci wpisywanego numeru pracy geodezyjnej (TZ)

ALTER TABLE [dbo].[all_jobs]  WITH CHECK ADD  CONSTRAINT [CK_jobs_CheckTZnumber] CHECK  (([TZnumber] like 'GK.6640.%'))
GO
ALTER TABLE [dbo].[all_jobs] CHECK CONSTRAINT [CK_jobs_CheckTZnumber]
GO

-- TABELA CUSTOMERS - sprawdzenie poprawnosci numeru telefonu

ALTER TABLE [dbo].[customers]  WITH CHECK ADD  CONSTRAINT [CK_cust_mobile] CHECK  (([mobile] like N'[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[customers] CHECK CONSTRAINT [CK_cust_mobile]
GO

-- TABELA CUSTOMERS - sprawdzenie poprawnosci kodu pocztowego

ALTER TABLE [dbo].[customers]  WITH CHECK ADD  CONSTRAINT [CK_cust_postalcode] CHECK  (([postalCode] like N'[0-9][0-9]-[0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[customers] CHECK CONSTRAINT [CK_cust_postalcode]
GO

-- TABELA CUSTOMERS - sprawdzenie poprawnosci adresu email

ALTER TABLE [dbo].[customers]  WITH CHECK ADD  CONSTRAINT [CK_cust_email] CHECK  (([emailAddress] like '%@%'))
GO
ALTER TABLE [dbo].[customers] CHECK CONSTRAINT [CK_cust_email]
GO

-- TABELA PAYMENTS - domyslne wartosci kolumn status oraz payment date

ALTER TABLE [dbo].[payments] ADD  CONSTRAINT [DF_payments_status]  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[payments] ADD  CONSTRAINT [DF_payments_paymentDate]  DEFAULT (NULL) FOR [paymentDate]
GO



-------------------- TRIGGERY

-- trigger ustawiajacy status zlecenia na ZAKONCZONE po zmianie jobEndedDate na dzisiejsza date

CREATE TRIGGER TR_jobFinishedDate ON [dbo].[all_jobs]
	AFTER UPDATE
	AS
		BEGIN
		SET NOCOUNT ON;
			IF UPDATE (jobEndedDate)
				BEGIN
					UPDATE all_jobs SET [status] = 'ZAKOÑCZONE'
					WHERE [ID] IN (SELECT ID FROM inserted)
					PRINT 'Praca zostala zakonczona!'
				END
		END
GO

-- trigger tworzacy fakture w tabeli payments po zmianie jobEndedDate na dzisiejsza date w tabeli all_jobs

CREATE TRIGGER TR_newPayment ON [dbo].[all_jobs]
	AFTER UPDATE
	AS
	DECLARE @custID int = (SELECT customerID FROM all_jobs WHERE ID = (SELECT ID FROM inserted))
	DECLARE @jobid int = (SELECT ID FROM inserted)
	DECLARE @fvno nchar(50) = CONCAT(ROUND((RAND()*(100-1)+1),0),'/' ,(SELECT CONVERT(varchar, GETDATE(), 112)))
	DECLARE @cost money = (SELECT CASE 
									WHEN a.jobTypeID = 1 THEN a.area * (SELECT price FROM job_type WHERE ID = 1)
								    WHEN a.jobTypeID = 2 OR a.jobTypeID = 4 THEN (SELECT price FROM job_type WHERE ID = 2)
									WHEN a.jobTypeID = 3 OR a.jobTypeID = 5 THEN a.length/100 * (SELECT price FROM job_type WHERE ID = 3)
								    WHEN a.jobTypeID = 6 THEN a.noOfAxles *	(SELECT price FROM job_type WHERE ID = 6)	
								    WHEN a.jobTypeID = 7 THEN (SELECT price FROM job_type WHERE ID = 7)
								    ELSE (SELECT price FROM job_type WHERE ID = 8) 
								  END
							FROM all_jobs AS a
							JOIN job_type AS j ON (j.ID = a.jobTypeID)
							WHERE a.ID = (SELECT ID FROM inserted))		
		BEGIN
		SET NOCOUNT ON;
			IF UPDATE (jobEndedDate)
				BEGIN
					INSERT INTO [dbo].[payments] (customerID, jobID, FVnumber, cost, FVdate)  
					VALUES (@custID, @jobid, @fvno, @cost, GETDATE())
					PRINT 'Faktura zostala dodana!'
				END
		END
GO

-- trigger wstawiajacy date zaplacenia faktury w momencie zmiany jej statusu na 1

CREATE TRIGGER TR_paymentDate ON [dbo].[payments]	
	AFTER UPDATE
	AS
		BEGIN
		SET NOCOUNT ON;
			IF UPDATE(status)
				BEGIN
					UPDATE [dbo].[payments] SET [paymentDate] = GETDATE() WHERE ID = (SELECT ID FROM inserted)
					PRINT 'Data platnosci zostala zapisana!'
			END
		END
GO

-- trigger zmieniajacy pensje pracownika po awansie na stanowisko starszego geodety/kartografa

ALTER TRIGGER TR_sgk_promotion ON [dbo].[employees]
	AFTER UPDATE
		AS
			BEGIN
			SET NOCOUNT ON;
				UPDATE [dbo].[employees] SET [salary] = 5000, [extraTimeWage] = 30
				FROM [dbo].[employees] AS e
				JOIN inserted AS i ON (i.ID = e.ID)
				AND i.position IN ('starszy geodeta', 'starszy kartograf')
			END
GO



-------------------- WYPE£NIANIE TABEL - za pomoc¹ BULK INSERT z pliku tekstowego

BULK INSERT Geodesy.dbo.county
FROM 'D:\INFORMATYKA\NAUKA SQL\Geodesy\insertData\county.txt'
WITH (
	FIRSTROW = 2
	,CODEPAGE = 1250
	,ROWTERMINATOR = '\n'
)
GO

BULK INSERT Geodesy.dbo.borough
FROM 'D:\INFORMATYKA\NAUKA SQL\Geodesy\insertData\borough.txt'
WITH (
	FIRSTROW = 2
	,CODEPAGE = 1250
	,ROWTERMINATOR = '\n'
)
GO

BULK INSERT Geodesy.dbo.district
FROM 'D:\INFORMATYKA\NAUKA SQL\Geodesy\insertData\district.txt'
WITH (
	FIRSTROW = 2
	,CODEPAGE = 1250
	,ROWTERMINATOR = '\n'
)
GO

BULK INSERT Geodesy.dbo.job_type
FROM 'D:\INFORMATYKA\NAUKA SQL\Geodesy\insertData\job_type.txt'
WITH (
	FIRSTROW = 2
	,CODEPAGE = 1250
	,ROWTERMINATOR = '\n'
)
GO

BULK INSERT Geodesy.dbo.all_jobs
FROM 'D:\INFORMATYKA\NAUKA SQL\Geodesy\insertData\jobs.txt'
WITH (
	FIRSTROW = 2
	,ROWTERMINATOR ='\n'
)
GO

BULK INSERT Geodesy.dbo.job_assignments
FROM 'D:\INFORMATYKA\NAUKA SQL\Geodesy\insertData\job_assignment.txt'
WITH (
	FIRSTROW = 2
	,ROWTERMINATOR ='\n'
)
GO

BULK INSERT Geodesy.dbo.customers
FROM 'D:\INFORMATYKA\NAUKA SQL\Geodesy\insertData\customers.txt'
WITH (
	FIRSTROW = 2
	,CODEPAGE = 1250
	,ROWTERMINATOR = '\n'
)
GO

BULK INSERT Geodesy.dbo.payments
FROM 'D:\INFORMATYKA\NAUKA SQL\Geodesy\insertData\payments.txt'
WITH (
	FIRSTROW = 2
	,CODEPAGE = 1250
	,ROWTERMINATOR = '\n'
)
GO



--------------------- WYPE£NIANIE TABEL - za pomoc¹ kaluzuli INSERT INTO

-- wypelnienie tabeli employees

SET IDENTITY_INSERT [dbo].[employees] OFF

GO
INSERT [dbo].[employees] ([name], [lastName], [mobile], [position], [salary], [extraTimeWage], [expYears], [admissionDate]) 
	VALUES ('Jacek', 'Jakubski', 612456789, 'starszy geodeta', 5000, 30, 10, '2013-11-10')
GO
INSERT [dbo].[employees] ([name], [lastName], [mobile], [position], [salary], [extraTimeWage], [expYears], [admissionDate]) 
	VALUES ('Krzysztof', 'Krasucki', 606666999, 'starszy kartograf', 5000, 30, 15, '2005-12-09')
GO
INSERT [dbo].[employees] ([name], [lastName], [mobile], [position], [salary], [extraTimeWage], [expYears], [admissionDate]) 
	VALUES ('£ukasz', '£ukomski', 606646695, 'starszy geodeta', 5000, 30, 9, '2010-05-15')
GO
INSERT [dbo].[employees] ([name], [lastName], [mobile], [position], [salary], [extraTimeWage], [expYears], [admissionDate]) 
	VALUES ('Micha³', 'Michalczuk', 644788994, 'geodeta', 3500, 25, 6, '2015-01-16')
GO
INSERT [dbo].[employees] ([name], [lastName], [mobile], [position], [salary], [extraTimeWage], [expYears], [admissionDate]) 
	VALUES ('Tomasz', 'Tomalik', 600544001, 'geodeta', 3500, 25, 4, '2018-02-20')
GO
INSERT [dbo].[employees] ([name], [lastName], [mobile], [position], [salary], [extraTimeWage], [expYears], [admissionDate]) 
	VALUES ('Lucyna', 'Jab³oñska', 648998547, 'm³odszy geodeta', 2500, 20, 2, '2020-04-11')
INSERT [dbo].[employees] ([name], [lastName], [mobile], [position], [salary], [extraTimeWage], [expYears], [admissionDate]) 
	VALUES ('Agnieszka', 'Asnowska', 663454111, 'm³odszy kartograf', 2500, 20, 3, '2020-11-20')
GO

-- wypelnienie tabeli extra_time

INSERT INTO [dbo].[extra_time] ([employeeID], [date], [hours]) VALUES (5, GETDATE(), 1)
GO
INSERT INTO [dbo].[extra_time] ([employeeID], [date], [hours]) VALUES (1, GETDATE(), 2)
GO
INSERT INTO [dbo].[extra_time] ([employeeID], [date], [hours]) VALUES (3, GETDATE(), 1)
GO
INSERT INTO [dbo].[extra_time] ([employeeID], [date], [hours]) VALUES (5, '2021-12-13', 2)
GO
INSERT INTO [dbo].[extra_time] ([employeeID], [date], [hours]) VALUES (3, '2021-12-13', 1)
GO
INSERT INTO [dbo].[extra_time] ([employeeID], [date], [hours]) VALUES (6, '2021-12-10', 3)
GO

-- wypelnienie tabeli survey_instruments

SET IDENTITY_INSERT [dbo].[employees] OFF

INSERT INTO [dbo].[survey_instruments] ([name], [type], [serialNo], [lastInspection]) VALUES ('LEICA GS15', 'odbiornik GNSS', '123456', GETDATE())
GO
INSERT INTO [dbo].[survey_instruments] ([name], [type], [serialNo], [lastInspection]) VALUES ('ZENITH 25 4PRO', 'odbiornik GNSS', '000579', NULL)
GO
INSERT INTO [dbo].[survey_instruments] ([name], [type], [serialNo], [lastInspection]) VALUES ('LEICA TC407', 'tachimetr', '30057', '2015-07-20')
GO
INSERT INTO [dbo].[survey_instruments] ([name], [type], [serialNo], [lastInspection]) VALUES ('TOPCON EM320', 'tachimetr', '8844444', GETDATE())
GO
INSERT INTO [dbo].[survey_instruments] ([name], [type], [serialNo], [lastInspection]) VALUES ('PENTAX AL240', 'niwelator optyczny', '00009', NULL)
GO

