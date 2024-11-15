USE [master]
GO
/****** Object:  Database [Travel_agency]    Script Date: 14.11.2024 3:50:02 ******/
CREATE DATABASE [Travel_agency]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Travel_agency', FILENAME = N'D:\Проги\SQl server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Travel_agency.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Travel_agency_log', FILENAME = N'D:\Проги\SQl server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Travel_agency_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Travel_agency].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Travel_agency] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Travel_agency] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Travel_agency] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Travel_agency] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Travel_agency] SET ARITHABORT OFF 
GO
ALTER DATABASE [Travel_agency] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Travel_agency] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Travel_agency] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Travel_agency] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Travel_agency] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Travel_agency] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Travel_agency] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Travel_agency] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Travel_agency] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Travel_agency] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Travel_agency] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Travel_agency] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Travel_agency] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Travel_agency] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Travel_agency] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Travel_agency] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Travel_agency] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Travel_agency] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Travel_agency] SET  MULTI_USER 
GO
ALTER DATABASE [Travel_agency] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Travel_agency] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Travel_agency] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Travel_agency] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Travel_agency] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Travel_agency', N'ON'
GO
USE [Travel_agency]
GO
/****** Object:  DatabaseRole [Egorrr]    Script Date: 14.11.2024 3:50:03 ******/
CREATE ROLE [Egorrr]
GO
/****** Object:  DatabaseRole [db_Developer]    Script Date: 14.11.2024 3:50:03 ******/
CREATE ROLE [db_Developer]
GO
/****** Object:  DatabaseRole [db_Analyst]    Script Date: 14.11.2024 3:50:03 ******/
CREATE ROLE [db_Analyst]
GO
/****** Object:  DatabaseRole [db_Admin]    Script Date: 14.11.2024 3:50:03 ******/
CREATE ROLE [db_Admin]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [db_Developer]
GO
ALTER ROLE [db_datareader] ADD MEMBER [db_Developer]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [db_Developer]
GO
ALTER ROLE [db_datareader] ADD MEMBER [db_Analyst]
GO
ALTER ROLE [db_owner] ADD MEMBER [db_Admin]
GO
/****** Object:  Schema [db_Admin]    Script Date: 14.11.2024 3:50:03 ******/
CREATE SCHEMA [db_Admin]
GO
/****** Object:  Schema [db_Analyst]    Script Date: 14.11.2024 3:50:03 ******/
CREATE SCHEMA [db_Analyst]
GO
/****** Object:  Schema [db_Developer]    Script Date: 14.11.2024 3:50:03 ******/
CREATE SCHEMA [db_Developer]
GO
/****** Object:  UserDefinedFunction [dbo].[Calculator]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Calculator](
    @Opd1 bigint,
    @Opd2 bigint,
    @Oprt char(1) = ''
)
RETURNS nvarchar(250)
AS
BEGIN
    DECLARE @Result nvarchar(250)

    IF @Oprt = '/' AND @Opd2 = 0
    BEGIN
        SET @Result = 'Делить на ноль нельзя'
    END
    ELSE
    BEGIN
        SET @Result = CONVERT(nvarchar(250),
            CASE @Oprt
                WHEN '+' THEN @Opd1 + @Opd2
                WHEN '-' THEN @Opd1 - @Opd2
                WHEN '*' THEN @Opd1 * @Opd2
                WHEN '/' THEN @Opd1 / @Opd2 
                ELSE 0
            END
        )
    END
    
    RETURN @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[ClientName]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ClientName](@ID int)
returns varchar(80)
as 
begin
	declare @Name_Client varchar(80)
	declare @totalClients int select @totalClients = count(ID_Клиента) from Клиенты
if @ID<= @totalClients
	begin
	select @Name_Client = Фамилия+' '+Имя+' '+Отчество
	from Клиенты
	where ID_Клиента = @ID
	end
else
	begin
	select @Name_Client = 'такого id нет'
	end
	
	return @Name_Client
end
GO
/****** Object:  UserDefinedFunction [dbo].[Parse]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Parse](@String NVARCHAR(500))
RETURNS @table TABLE (
    Number INT IDENTITY(1, 1) NOT NULL,
    Substr NVARCHAR(30)
)
AS
BEGIN
    DECLARE @Str1 NVARCHAR(500), @Pos INT;
    SET @Str1 = @String;

    WHILE LEN(@Str1) > 0
    BEGIN
        SET @Pos = CHARINDEX(' ', @Str1);

        IF @Pos > 0
        BEGIN
            INSERT INTO @table (Substr)
            VALUES (SUBSTRING(@Str1, 1, @Pos - 1));
            SET @Str1 = SUBSTRING(@Str1, @Pos + 1, LEN(@Str1) - @Pos);
        END
        ELSE
        BEGIN
            INSERT INTO @table (Substr)
            VALUES (@Str1);
            BREAK;
        END
    END

    RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[Активные_Номера_Пансионата]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Активные_Номера_Пансионата] (@ID int)
returns @Номера table
	(
		[Название Пансионата] [varchar](100),
		[id  Номера] [int],
		[Название номера] [varchar](100),
		[Категория номера] [varchar](100),
		[Цена номера за сутки] money
	)
	as
begin 
	insert @Номера
	select Пансионаты.Название, [Виды жилья].[ID_Вид жилья], [Виды жилья].Название,[Категория жилья],[Цена за номер в сутки]
	from [Виды жилья]
	join Пансионаты on Пансионаты.ID_Пансионата = [Виды жилья].ID_Пансионата
	left join Путевки ON [Виды жилья].[ID_Вид жилья] = Путевки.[ID_Вид жилья]     
    where Путевки.ID_Пансионата is null
        and Пансионаты.ID_Пансионата = @ID;

	 return;
end;
GO
/****** Object:  Table [dbo].[Виды жилья]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Виды жилья](
	[ID_Вид жилья] [int] IDENTITY(1,1) NOT NULL,
	[Название] [nvarchar](50) NOT NULL,
	[ID_Пансионата] [int] NOT NULL,
	[Категория жилья] [nvarchar](20) NOT NULL,
	[Описание условий проживаний] [text] NOT NULL,
	[Цена за номер в сутки] [money] NOT NULL,
 CONSTRAINT [PK_Виды жилья] PRIMARY KEY CLUSTERED 
(
	[ID_Вид жилья] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Клиенты]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Клиенты](
	[ID_Клиента] [int] IDENTITY(1,1) NOT NULL,
	[Паспортные данные] [nvarchar](50) NOT NULL,
	[Фамилия] [nvarchar](50) NOT NULL,
	[Имя] [nvarchar](50) NOT NULL,
	[Отчество] [nvarchar](50) NULL,
	[Дата рождения] [date] NOT NULL,
	[Адрес] [nvarchar](50) NOT NULL,
	[Город] [nvarchar](50) NOT NULL,
	[Телефон] [nvarchar](30) NOT NULL,
	[Фото] [nvarchar](max) NULL,
 CONSTRAINT [PK_Клиенты] PRIMARY KEY CLUSTERED 
(
	[ID_Клиента] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Пансионаты]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Пансионаты](
	[ID_Пансионата] [int] IDENTITY(1,1) NOT NULL,
	[Название] [nvarchar](100) NOT NULL,
	[Адрес] [nvarchar](50) NOT NULL,
	[Город] [nvarchar](30) NOT NULL,
	[Страна] [nvarchar](100) NOT NULL,
	[Телефон] [nvarchar](50) NOT NULL,
	[Описание территории] [text] NOT NULL,
	[Количество комнат] [int] NOT NULL,
	[Наличие бассейна] [bit] NOT NULL,
	[Наличие мед. услуг] [bit] NOT NULL,
	[Наличие спа-салона] [bit] NOT NULL,
	[Уровень пансионата] [int] NOT NULL,
	[Расстояние до моря] [int] NULL,
	[Logo] [nvarchar](max) NULL,
 CONSTRAINT [PK_Пансионаты] PRIMARY KEY CLUSTERED 
(
	[ID_Пансионата] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Путевки]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Путевки](
	[ID_Путевки] [int] IDENTITY(1,1) NOT NULL,
	[ID_Клиента] [int] NOT NULL,
	[ID_Пансионата] [int] NULL,
	[ID_Вид жилья] [int] NULL,
	[ID_Тура] [int] NULL,
	[Дата заезда] [date] NOT NULL,
	[Дата отъезда] [date] NOT NULL,
	[Наличие детей] [bit] NOT NULL,
	[Наличие мед. страховки] [bit] NOT NULL,
	[Количество человек] [int] NOT NULL,
	[Цена] [money] NULL,
	[Итоговая цена]  AS (case when [Наличие мед. страховки]=(1) then case when [Наличие детей]=(1) then ((5000)*[Количество человек]+(4000))+[Цена] else (5000)*[Количество человек]+[Цена] end else case when [Наличие детей]=(1) then [Цена]+(4000) else [Цена] end end),
 CONSTRAINT [PK_Путевки] PRIMARY KEY CLUSTERED 
(
	[ID_Путевки] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Туры]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Туры](
	[ID_Тура] [int] IDENTITY(1,1) NOT NULL,
	[Название] [nvarchar](100) NOT NULL,
	[Вид транспорта] [nvarchar](50) NOT NULL,
	[Категория жилья на ночь] [nvarchar](50) NOT NULL,
	[Вид питания] [nvarchar](50) NOT NULL,
	[Цена тура в сутки] [money] NOT NULL,
	[Logo] [nvarchar](max) NULL,
 CONSTRAINT [PK_Туры] PRIMARY KEY CLUSTERED 
(
	[ID_Тура] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Туры_для_триггера]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Туры_для_триггера](
	[ID_Тура] [int] IDENTITY(1,1) NOT NULL,
	[Название] [nvarchar](100) NOT NULL,
	[Вид транспорта] [nvarchar](50) NOT NULL,
	[Категория жилья на ночь] [nvarchar](50) NOT NULL,
	[Вид питания] [nvarchar](50) NOT NULL,
	[Цена тура в сутки] [money] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[customers]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[customers] as 
select Клиенты.ID_Клиента, Фамилия, Имя, Отчество, Телефон, Sum([Итоговая цена]) as 'Сумма всех покупок'
from Клиенты join Путевки on Путевки.ID_Клиента = Клиенты.ID_Клиента
group by Клиенты.ID_Клиента, Фамилия, Имя, Отчество, Телефон
having Sum([Итоговая цена])>60000;
GO
/****** Object:  View [dbo].[report]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view  [dbo].[report] as
select customers.ID_Клиента, Фамилия, Имя, Отчество, Туры.Название as 'Название тура'
from customers join Путевки on Путевки.ID_Клиента = customers.ID_Клиента
join Туры On Путевки.ID_Тура = Туры.ID_Тура
GO
/****** Object:  UserDefinedFunction [dbo].[Виды_жилья_фильтр]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Виды_жилья_фильтр] (@Фильтр varchar(100))
returns table 
as 
return select [ID_Вид жилья], Название, [Категория жилья], [Цена за номер в сутки] 
from [Виды жилья]
where [Категория жилья] = @Фильтр
GO
/****** Object:  View [dbo].[View_1]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_1]
AS
SELECT [ID_Вид жилья] AS ID_Вид_жилья, Название, ID_Пансионата, [Категория жилья], [Цена за номер в сутки]
FROM     dbo.[Виды жилья]
WHERE  ([Цена за номер в сутки] > 3000)
GO
/****** Object:  View [dbo].[View_2]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_2]
AS
SELECT ID_Тура, Название, [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]
FROM     dbo.Туры
WHERE  ([Вид транспорта] IN ('Автобус', 'Поезд'))
GO
/****** Object:  View [dbo].[View_3]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[View_3] as
SELECT [ID_Вид жилья] AS ID_Вид_жилья, Название, ID_Пансионата, [Категория жилья], [Цена за номер в сутки]
from [Виды жилья]
WHERE ([Цена за номер в сутки] > 4000 and [Цена за номер в сутки]<7000)
GO
/****** Object:  View [dbo].[View_4]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[View_4] as
SELECT ID_Тура, Название, [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]
FROM	Туры
WHERE  ([Вид транспорта] IN ('Самолет', 'Круизный лайнер'))
GO
SET IDENTITY_INSERT [dbo].[Виды жилья] ON 

INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (1, N'Стандартный номер', 1, N'Стандарт', N'Просторный номер с удобствами', 1528.8280)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (2, N'Люкс', 1, N'Люкс', N'Роскошный номер с видом на море', 3822.0610)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (3, N'Эконом', 1, N'Эконом', N'Уютный номер по низкой цене', 1146.6210)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (4, N'Полулюкс', 1, N'Полулюкс', N'Номер средней ценовой категории', 2293.2370)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (5, N'Двухместный', 1, N'Стандарт', N'Номер для двоих с балконом', 1911.0310)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (6, N'Стандартный номер', 2, N'Стандарт', N'Просторный номер с бассейном', 1800.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (7, N'Люкс', 2, N'Люкс', N'Роскошный номер с видом на горы', 4500.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (8, N'Эконом', 2, N'Эконом', N'Уютный номер с общим санузлом', 1200.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (9, N'Полулюкс', 2, N'Полулюкс', N'Номер с балконом и ванной', 2800.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (10, N'Семейный', 2, N'Стандарт', N'Просторный номер для семьи', 3200.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (11, N'Стандартный номер', 3, N'Стандарт', N'Просторный номер с видом на сад', 3283.2000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (12, N'Люкс', 3, N'Люкс', N'Роскошный номер с джакузи', 8294.4000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (13, N'Эконом', 3, N'Эконом', N'Уютный номер с общим туалетом', 2246.4000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (14, N'Полулюкс', 3, N'Полулюкс', N'Номер с балконом и кондиционером', 5011.2000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (15, N'Двухместный', 3, N'Стандарт', N'Номер для двоих с телевизором', 4492.8000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (16, N'Стандартный номер', 4, N'Стандарт', N'Просторный номер с видом на горы', 1700.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (17, N'Люкс', 4, N'Люкс', N'Роскошный номер с камином', 4900.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (18, N'Эконом', 4, N'Эконом', N'Уютный номер с общей ванной', 1100.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (19, N'Полулюкс', 4, N'Полулюкс', N'Номер с балконом и мини-баром', 2700.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (20, N'Семейный', 4, N'Стандарт', N'Просторный номер для семьи с детской кроваткой', 3300.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (21, N'Стандартный номер', 5, N'Стандарт', N'Просторный номер с видом на море', 2100.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (22, N'Люкс', 5, N'Люкс', N'Роскошный номер с террасой', 5200.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (23, N'Эконом', 5, N'Эконом', N'Уютный номер с общим душем', 1400.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (24, N'Полулюкс', 5, N'Полулюкс', N'Номер с балконом и кондиционером', 3100.0000)
INSERT [dbo].[Виды жилья] ([ID_Вид жилья], [Название], [ID_Пансионата], [Категория жилья], [Описание условий проживаний], [Цена за номер в сутки]) VALUES (25, N'Двухместный', 5, N'Стандарт', N'Номер для двоих с кухней', 2700.0000)
SET IDENTITY_INSERT [dbo].[Виды жилья] OFF
GO
SET IDENTITY_INSERT [dbo].[Клиенты] ON 

INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (1, N'2019567890', N'Иванов', N'Иван', N'Иванович', CAST(N'1990-01-01' AS Date), N'ул. Пушкина, д. 10', N'Москва', N'79150530704', N'Client/Ivan.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (2, N'2019543210', N'Петров', N'Петр', N'Петрович', CAST(N'1985-05-15' AS Date), N'пр. Ленина, д. 5', N'Санкт-Петербург', N'79381594068', N'Client/Petr.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (3, N'2019233445', N'Аюпов', N'Булат', N'Маратович', CAST(N'1988-12-30' AS Date), N'ул. Гагарина, д. 15', N'Новосибирск', N'79384336730', N'Client/Булат.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (4, N'2019667778', N'Шарипов', N'Искандер', N'Сорян не помню', CAST(N'1995-06-20' AS Date), N'пр. Кирова, д. 25', N'Екатеринбург', N'79509328299', N'Client/Искин.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (5, N'2019990001', N'Егория', N'Байгузина', N'Евгеньевна', CAST(N'1980-08-05' AS Date), N'ул. Лермонтова, д. 30', N'Казань', N'79383333429', N'Client/Егория.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (6, N'2019990002', N'Байгузин', N'Егор', N'Евгеньевич', CAST(N'2005-08-23' AS Date), N'ул. 8Марта, д. 6', N'Уфа', N'79096960537', N'Client/Egor2.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (7, N'8018974324', N'Гильманшин', N'Азамат', N'Шамилевич', CAST(N'2005-05-23' AS Date), N'ул. 8Марта, д.6', N'Уфа', N'79098545031', N'Client/Азаматия.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (8, N'4444444444', N'Тимербаев ', N'Данис', N'Раилевич', CAST(N'1988-10-07' AS Date), N'ул. 8Марта, д.6', N'Уфа', N'79505457484', N'Client/Данис.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (9, N'3333333333', N'Азаматия', N'Гильманшина', N'Шамильевна', CAST(N'2005-05-03' AS Date), N'ул. 8Марта, д.6', N'Кунгак', N'89336379627', N'Client/азамаь.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (10, N'3232323222', N'Евгений', N'Байгузин', N'Петров', CAST(N'1978-08-06' AS Date), N'Кузнечная 22', N'Бирск', N'79157087468', N'Client/Батя.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (11, N'7777777777', N'Ахметшин', N'Марсэль', N'Наилевич', CAST(N'1995-03-07' AS Date), N'Бумажная 4', N'Белекей', N'79156587468', N'Client/Марс.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (12, N'8019293456', N'Биба', N'Бобкин', N'Бобочив', CAST(N'2005-05-23' AS Date), N'Бумажная, 5', N'Неизвестно', N'89177725140', N'Client\Egor.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (13, N'5252345345', N'Эльза', N'Тимашева', N'Ринадовна', CAST(N'2005-10-28' AS Date), N'Бумажная 4', N'Бирск', N'79156587468', N'Client\Эльза.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (14, N'8018974324', N'Артур', N'Губайдулин', N'Ильдарович', CAST(N'2005-10-28' AS Date), N'Ул. 8 Марта', N'Уфа', N'82131234324', N'Client\Артур.jpg')
INSERT [dbo].[Клиенты] ([ID_Клиента], [Паспортные данные], [Фамилия], [Имя], [Отчество], [Дата рождения], [Адрес], [Город], [Телефон], [Фото]) VALUES (15, N'4234234234', N'Бигбулатов', N'Тимур', N'ХЗ', CAST(N'1969-01-29' AS Date), N'уфа', N'Уфа', N'83253453453', N'C:\Users\egorb\Downloads\Искин.jpg')
SET IDENTITY_INSERT [dbo].[Клиенты] OFF
GO
SET IDENTITY_INSERT [dbo].[Пансионаты] ON 

INSERT [dbo].[Пансионаты] ([ID_Пансионата], [Название], [Адрес], [Город], [Страна], [Телефон], [Описание территории], [Количество комнат], [Наличие бассейна], [Наличие мед. услуг], [Наличие спа-салона], [Уровень пансионата], [Расстояние до моря], [Logo]) VALUES (1, N'Звездный', N'ул. Первомайская, 1', N'Москва', N'Россия', N'123-456-789', N'Большая территория с бассейном и зоной отдыха', 5, 1, 1, 1, 4, NULL, N'res/1.jpeg')
INSERT [dbo].[Пансионаты] ([ID_Пансионата], [Название], [Адрес], [Город], [Страна], [Телефон], [Описание территории], [Количество комнат], [Наличие бассейна], [Наличие мед. услуг], [Наличие спа-салона], [Уровень пансионата], [Расстояние до моря], [Logo]) VALUES (2, N'Солнечный берег', N'пр. Ленина, 5', N'Санкт-Петербург', N'Россия', N'987-654-321', N'Расположен у моря, отличный вид', 5, 1, 0, 1, 3, 517, N'res/2.jpg')
INSERT [dbo].[Пансионаты] ([ID_Пансионата], [Название], [Адрес], [Город], [Страна], [Телефон], [Описание территории], [Количество комнат], [Наличие бассейна], [Наличие мед. услуг], [Наличие спа-салона], [Уровень пансионата], [Расстояние до моря], [Logo]) VALUES (3, N'Подсолнух', N'ул. Гагарина, 10', N'Сочи', N'Россия', N'111-222-333', N'Уютные номера с видом на море', 5, 1, 1, 0, 4, 52, N'res/3.jpg')
INSERT [dbo].[Пансионаты] ([ID_Пансионата], [Название], [Адрес], [Город], [Страна], [Телефон], [Описание территории], [Количество комнат], [Наличие бассейна], [Наличие мед. услуг], [Наличие спа-салона], [Уровень пансионата], [Расстояние до моря], [Logo]) VALUES (4, N'Веселый отдых', N'пр. Кирова, 15', N'Геленджик', N'Россия', N'555-666-777', N'Бассейн, спортивные площадки', 5, 1, 1, 1, 2, 100, NULL)
INSERT [dbo].[Пансионаты] ([ID_Пансионата], [Название], [Адрес], [Город], [Страна], [Телефон], [Описание территории], [Количество комнат], [Наличие бассейна], [Наличие мед. услуг], [Наличие спа-салона], [Уровень пансионата], [Расстояние до моря], [Logo]) VALUES (5, N'Морской бриз', N'ул. Лермонтова, 20', N'Севастополь', N'Россия', N'888-999-000', N'Панорамные виды на море', 5, 0, 1, 1, 1, 300, NULL)
SET IDENTITY_INSERT [dbo].[Пансионаты] OFF
GO
SET IDENTITY_INSERT [dbo].[Путевки] ON 

INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (1, 1, NULL, NULL, 2, CAST(N'2024-04-01' AS Date), CAST(N'2024-04-10' AS Date), 0, 1, 2, 2700.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (2, 2, 1, 1, NULL, CAST(N'2024-04-03' AS Date), CAST(N'2024-04-12' AS Date), 1, 0, 2, 19110.3120)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (3, 3, NULL, NULL, 2, CAST(N'2024-04-05' AS Date), CAST(N'2024-04-15' AS Date), 0, 0, 3, 6000.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (4, 4, 2, 2, NULL, CAST(N'2024-04-07' AS Date), CAST(N'2024-04-16' AS Date), 1, 1, 2, 45000.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (5, 5, NULL, NULL, 3, CAST(N'2024-04-09' AS Date), CAST(N'2024-04-18' AS Date), 0, 1, 1, 1080.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (6, 1, NULL, NULL, 1, CAST(N'2024-04-11' AS Date), CAST(N'2024-04-20' AS Date), 1, 0, 2, 2700.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (7, 2, 1, 2, NULL, CAST(N'2024-04-13' AS Date), CAST(N'2024-04-20' AS Date), 0, 0, 1, 120.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (8, 3, NULL, NULL, 2, CAST(N'2024-04-15' AS Date), CAST(N'2024-04-25' AS Date), 1, 1, 3, 6000.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (9, 4, 2, 7, NULL, CAST(N'2024-04-17' AS Date), CAST(N'2024-04-26' AS Date), 0, 0, 2, 40500.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (10, 5, NULL, NULL, 3, CAST(N'2024-04-19' AS Date), CAST(N'2024-04-28' AS Date), 1, 1, 2, 1080.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (12, 1, NULL, NULL, 1, CAST(N'2024-04-11' AS Date), CAST(N'2024-04-18' AS Date), 1, 1, 2, 2520.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (13, 1, NULL, NULL, 12, CAST(N'2024-04-11' AS Date), CAST(N'2024-04-18' AS Date), 1, 1, 2, 2352.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (14, 1, NULL, NULL, 1, CAST(N'2024-04-11' AS Date), CAST(N'2024-04-18' AS Date), 1, 1, 2, 2520.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (15, 1, NULL, NULL, 12, CAST(N'2024-04-11' AS Date), CAST(N'2024-04-18' AS Date), 1, 1, 2, 2352.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (17, 1, NULL, NULL, 1, CAST(N'2024-04-11' AS Date), CAST(N'2024-04-18' AS Date), 1, 1, 2, 3024.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (21, 1, NULL, NULL, 1, CAST(N'2024-04-18' AS Date), CAST(N'2024-04-25' AS Date), 1, 1, 2, 1512.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (23, 1, NULL, NULL, 2, CAST(N'2024-03-15' AS Date), CAST(N'2024-03-20' AS Date), 1, 1, 2, 1440.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (25, 1, 2, 2, NULL, CAST(N'2024-03-15' AS Date), CAST(N'2024-03-24' AS Date), 1, 1, 2, 1.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (27, 1, 2, 4, NULL, CAST(N'2024-03-15' AS Date), CAST(N'2024-03-24' AS Date), 1, 1, 2, 23.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (33, 12, 1, 2, NULL, CAST(N'2024-11-05' AS Date), CAST(N'2024-11-23' AS Date), 0, 0, 2, 200.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (34, 15, 3, 3, NULL, CAST(N'2024-11-06' AS Date), CAST(N'2024-11-13' AS Date), 1, 1, 3, 231.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (35, 15, NULL, NULL, 5, CAST(N'2024-10-31' AS Date), CAST(N'2024-11-04' AS Date), 1, 1, 2, 21.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (36, 15, 2, 4, NULL, CAST(N'2024-10-30' AS Date), CAST(N'2024-11-11' AS Date), 1, 1, 1, 0.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (37, 5, 3, 3, NULL, CAST(N'2024-11-05' AS Date), CAST(N'2024-11-15' AS Date), 1, 1, 2, 78.0000)
INSERT [dbo].[Путевки] ([ID_Путевки], [ID_Клиента], [ID_Пансионата], [ID_Вид жилья], [ID_Тура], [Дата заезда], [Дата отъезда], [Наличие детей], [Наличие мед. страховки], [Количество человек], [Цена]) VALUES (39, 14, NULL, NULL, 4, CAST(N'2024-10-29' AS Date), CAST(N'2024-11-02' AS Date), 1, 1, 2, 132.0000)
SET IDENTITY_INSERT [dbo].[Путевки] OFF
GO
SET IDENTITY_INSERT [dbo].[Туры] ON 

INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (1, N'По Европе', N'Автобус', N'Гостиница', N'Двухразовое', 216.0000, N'res/тур1.jpg')
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (2, N'По Азии', N'Самолет', N'Отель', N'Трехразовое', 288.0000, N'res/тур2.jpg')
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (3, N'По Африке', N'Круизный лайнер', N'Кемпинг', N'Одноразовое', 172.8000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (4, N'По Австралии', N'Самолет', N'Отель', N'Одноразовое', 259.2000, N'res/тур4.jpg')
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (5, N'По Америке', N'Автобус', N'Мотель', N'Двухразовое', 230.4000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (6, N'По Европе', N'Поезд', N'Отель', N'Трехразовое', 273.6000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (7, N'По Азии', N'Самолет', N'Гостиница', N'Трехразовое', 316.8000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (8, N'По Африке', N'Автобус', N'Кемпинг', N'Одноразовое', 187.2000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (9, N'По Австралии', N'Круизный лайнер', N'Гостиница', N'Двухразовое', 244.8000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (10, N'По Америке', N'Самолет', N'Мотель', N'Трехразовое', 288.0000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (11, N'По Европе', N'Поезд', N'Отель', N'Двухразовое', 302.4000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (12, N'По Азии', N'Автобус', N'Гостиница', N'Двухразовое', 201.6000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (13, N'По Африке', N'Самолет', N'Кемпинг', N'Трехразовое', 331.2000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (14, N'По Австралии', N'Круизный лайнер', N'Гостиница', N'Одноразовое', 230.4000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (15, N'По Америке', N'Поезд', N'Мотель', N'Трехразовое', 273.6000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (16, N'По Европе', N'Автобус', N'Отель', N'Двухразовое', 244.8000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (17, N'По Азии', N'Самолет', N'Гостиница', N'Трехразовое', 360.0000, NULL)
INSERT [dbo].[Туры] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки], [Logo]) VALUES (18, N'По Африке', N'Круизный лайнер', N'Кемпинг', N'Одноразовое', 201.6000, NULL)
SET IDENTITY_INSERT [dbo].[Туры] OFF
GO
SET IDENTITY_INSERT [dbo].[Туры_для_триггера] ON 

INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (2, N'По Азии', N'Самолет', N'Отель', N'Трехразовое', 288.0000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (3, N'По Африке', N'Круизный лайнер', N'Кемпинг', N'Одноразовое', 172.8000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (4, N'По Австралии', N'Самолет', N'Отель', N'Одноразовое', 259.2000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (5, N'По Америке', N'Автобус', N'Мотель', N'Двухразовое', 230.4000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (22, N'1', N'1', N'11', N'11', 1.0000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (7, N'По Азии', N'Самолет', N'Гостиница', N'Трехразовое', 316.8000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (8, N'По Африке', N'Автобус', N'Кемпинг', N'Одноразовое', 187.2000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (9, N'По Австралии', N'Круизный лайнер', N'Гостиница', N'Двухразовое', 244.8000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (10, N'По Америке', N'Самолет', N'Мотель', N'Трехразовое', 288.0000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (12, N'По Азии', N'Автобус', N'Гостиница', N'Двухразовое', 201.6000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (13, N'По Африке', N'Самолет', N'Кемпинг', N'Трехразовое', 331.2000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (14, N'По Австралии', N'Круизный лайнер', N'Гостиница', N'Одноразовое', 230.4000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (15, N'По Америке', N'Поезд', N'Мотель', N'Трехразовое', 273.6000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (17, N'По Азии', N'Самолет', N'Гостиница', N'Трехразовое', 360.0000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (18, N'По Африке', N'Круизный лайнер', N'Кемпинг', N'Одноразовое', 201.6000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (19, N'По Австралии', N'Автобус', N'Отель', N'Одноразовое', 288.0000)
INSERT [dbo].[Туры_для_триггера] ([ID_Тура], [Название], [Вид транспорта], [Категория жилья на ночь], [Вид питания], [Цена тура в сутки]) VALUES (20, N'По Америке', N'Самолет', N'Мотель', N'Двухразовое', 259.2000)
SET IDENTITY_INSERT [dbo].[Туры_для_триггера] OFF
GO
ALTER TABLE [dbo].[Виды жилья]  WITH CHECK ADD  CONSTRAINT [FK_Виды жилья_Пансионаты] FOREIGN KEY([ID_Пансионата])
REFERENCES [dbo].[Пансионаты] ([ID_Пансионата])
GO
ALTER TABLE [dbo].[Виды жилья] CHECK CONSTRAINT [FK_Виды жилья_Пансионаты]
GO
ALTER TABLE [dbo].[Путевки]  WITH CHECK ADD  CONSTRAINT [FK_Путевки_Виды жилья] FOREIGN KEY([ID_Вид жилья])
REFERENCES [dbo].[Виды жилья] ([ID_Вид жилья])
GO
ALTER TABLE [dbo].[Путевки] CHECK CONSTRAINT [FK_Путевки_Виды жилья]
GO
ALTER TABLE [dbo].[Путевки]  WITH CHECK ADD  CONSTRAINT [FK_Путевки_Клиенты] FOREIGN KEY([ID_Клиента])
REFERENCES [dbo].[Клиенты] ([ID_Клиента])
GO
ALTER TABLE [dbo].[Путевки] CHECK CONSTRAINT [FK_Путевки_Клиенты]
GO
ALTER TABLE [dbo].[Путевки]  WITH CHECK ADD  CONSTRAINT [FK_Путевки_Пансионаты] FOREIGN KEY([ID_Пансионата])
REFERENCES [dbo].[Пансионаты] ([ID_Пансионата])
GO
ALTER TABLE [dbo].[Путевки] CHECK CONSTRAINT [FK_Путевки_Пансионаты]
GO
ALTER TABLE [dbo].[Путевки]  WITH CHECK ADD  CONSTRAINT [FK_Путевки_Туры] FOREIGN KEY([ID_Тура])
REFERENCES [dbo].[Туры] ([ID_Тура])
GO
ALTER TABLE [dbo].[Путевки] CHECK CONSTRAINT [FK_Путевки_Туры]
GO
ALTER TABLE [dbo].[Виды жилья]  WITH CHECK ADD  CONSTRAINT [Ограничение на цену номера в сутки] CHECK  (([Цена за номер в сутки]>(0)))
GO
ALTER TABLE [dbo].[Виды жилья] CHECK CONSTRAINT [Ограничение на цену номера в сутки]
GO
ALTER TABLE [dbo].[Клиенты]  WITH CHECK ADD  CONSTRAINT [Ограничение на длинну паспорта] CHECK  ((len([Паспортные данные])>(9) AND len([Паспортные данные])<(11)))
GO
ALTER TABLE [dbo].[Клиенты] CHECK CONSTRAINT [Ограничение на длинну паспорта]
GO
ALTER TABLE [dbo].[Пансионаты]  WITH CHECK ADD  CONSTRAINT [Ограничение на кол-во комнат] CHECK  (([Количество комнат]>(0)))
GO
ALTER TABLE [dbo].[Пансионаты] CHECK CONSTRAINT [Ограничение на кол-во комнат]
GO
ALTER TABLE [dbo].[Пансионаты]  WITH CHECK ADD  CONSTRAINT [Ограничение на расстояние до моря] CHECK  (([Расстояние до моря]>(0)))
GO
ALTER TABLE [dbo].[Пансионаты] CHECK CONSTRAINT [Ограничение на расстояние до моря]
GO
ALTER TABLE [dbo].[Пансионаты]  WITH CHECK ADD  CONSTRAINT [Ограничение на уровень пансионата] CHECK  (([Уровень пансионата]>(0) AND [Уровень пансионата]<=(5)))
GO
ALTER TABLE [dbo].[Пансионаты] CHECK CONSTRAINT [Ограничение на уровень пансионата]
GO
ALTER TABLE [dbo].[Путевки]  WITH CHECK ADD  CONSTRAINT [Либо Вид жилья, либо тур] CHECK  (([ID_Вид жилья] IS NOT NULL AND [ID_Пансионата] IS NOT NULL OR [ID_Тура] IS NOT NULL AND [ID_Вид жилья] IS NULL AND [ID_Пансионата] IS NULL))
GO
ALTER TABLE [dbo].[Путевки] CHECK CONSTRAINT [Либо Вид жилья, либо тур]
GO
ALTER TABLE [dbo].[Путевки]  WITH CHECK ADD  CONSTRAINT [Ограничения количества человек] CHECK  (([Количество человек]>(0) AND [Количество человек]<=(4)))
GO
ALTER TABLE [dbo].[Путевки] CHECK CONSTRAINT [Ограничения количества человек]
GO
ALTER TABLE [dbo].[Туры]  WITH CHECK ADD  CONSTRAINT [Ограничение цены тура в сутки] CHECK  (([Цена тура в сутки]>(0)))
GO
ALTER TABLE [dbo].[Туры] CHECK CONSTRAINT [Ограничение цены тура в сутки]
GO
/****** Object:  StoredProcedure [dbo].[Актимвные_Путевки]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Актимвные_Путевки]
as
begin
    declare @today date = GETDATE();
    select Путевки.ID_Путевки, Клиенты.Фамилия, Клиенты.Имя, Клиенты.Отчество, Путевки.[Дата заезда], Путевки.[Дата отъезда], Путевки.Цена, Путевки.[Итоговая цена]
    from Путевки
    join Клиенты ON Путевки.ID_Клиента = Клиенты.ID_Клиента
    where Путевки.[Дата отъезда] > @today;
end;
GO
/****** Object:  StoredProcedure [dbo].[Клиент_по_Номеру_телефона]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Клиент_по_Номеру_телефона] @Телефон nvarchar(30) as 
select * from Клиенты
where Телефон like '%' + @Телефон + '%'
GO
/****** Object:  StoredProcedure [dbo].[Обновление_Цены_Номера]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Обновление_Цены_Номера] @Id int, @Проценты int
as
begin
	update [Виды жилья]
	set [Цена за номер в сутки] = [Цена за номер в сутки] + [Цена за номер в сутки]/100*@Проценты 
	where ID_Пансионата = @Id
end;
GO
/****** Object:  StoredProcedure [dbo].[Сколько_дней_длиться_путевка]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Сколько_дней_длиться_путевка] @ID int
as
begin
	declare @результат int
	select результат = DATEDIFF(DAY, [Дата заезда], [Дата отъезда]) from Путевки where ID_Путевки = @ID
    return @результат;
end;
GO
/****** Object:  StoredProcedure [dbo].[Туры_фильтрация]    Script Date: 14.11.2024 3:50:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Туры_фильтрация] @Фильтр varchar(100)
as 
begin
  select *
    from Туры
    where [Вид транспорта] = @Фильтр
        or [Вид питания] = @Фильтр
        or [Категория жилья на ночь] = @Фильтр;
    if not exists (
        select *
        from Туры
        where  [Вид транспорта] = @Фильтр
            or [Вид питания] = @Фильтр
            or [Категория жилья на ночь] = @Фильтр
    )
    BEGIN
        SELECT 'Неправильные данные'
    END
END;
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Путевки"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 312
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Клиенты"
            Begin Extent = 
               Top = 7
               Left = 360
               Bottom = 170
               Right = 599
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'customers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'customers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[14] 4[21] 2[8] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Виды жилья"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 368
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 132
         SortOrder = 84
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[15] 4[26] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Туры"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 322
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 84
         SortOrder = 84
         GroupBy = 1350
         Filter = 2556
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_2'
GO
USE [master]
GO
ALTER DATABASE [Travel_agency] SET  READ_WRITE 
GO
