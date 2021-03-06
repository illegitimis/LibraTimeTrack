USE [LibraTimeTrack]
GO
/****** Object:  Table [dbo].[Teams]    Script Date: 04/06/2015 09:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Teams](
	[Name] [char](20) NOT NULL,
 CONSTRAINT [PK_Teams] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ItemTypes]    Script Date: 04/06/2015 09:32:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ItemTypes](
	[ItemType] [tinyint] NOT NULL,
	[Description] [varchar](100) NOT NULL,
 CONSTRAINT [PK_ItemTypes] PRIMARY KEY CLUSTERED 
(
	[ItemType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[insertActivity]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[insertActivity](
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
GO
/****** Object:  Table [dbo].[Persons]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Persons](
	[Name] [varchar](50) NOT NULL,
	[Login] [char](30) NOT NULL,
 CONSTRAINT [PK_Persons_1] PRIMARY KEY CLUSTERED 
(
	[Login] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LoginHistory]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LoginHistory](
	[Login] [char](30) NOT NULL,
	[Password] [varchar](30) NOT NULL,
	[Date] [date] NOT NULL,
 CONSTRAINT [PK_LoginHistory] PRIMARY KEY CLUSTERED 
(
	[Login] ASC,
	[Password] ASC,
	[Date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Teams2Persons]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Teams2Persons](
	[Team] [char](20) NOT NULL,
	[Login] [char](30) NOT NULL,
	[Date] [date] NOT NULL,
 CONSTRAINT [PK_Teams2Persons] PRIMARY KEY CLUSTERED 
(
	[Team] ASC,
	[Login] ASC,
	[Date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PM]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PM](
	[Id] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Url] [char](100) NOT NULL,
	[ItemType] [tinyint] NOT NULL,
	[QmId] [varchar](10) NULL,
 CONSTRAINT [PK_PM] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PM', @level2type=N'COLUMN',@level2name=N'ItemType'
GO
/****** Object:  Table [dbo].[RT]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RT](
	[Id] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Url] [char](100) NOT NULL,
	[ItemType] [tinyint] NOT NULL,
 CONSTRAINT [PK_RT] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RT', @level2type=N'COLUMN',@level2name=N'ItemType'
GO
/****** Object:  Table [dbo].[PM2RT]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PM2RT](
	[PMId] [int] NOT NULL,
	[RTId] [int] NOT NULL,
 CONSTRAINT [PK_PM2RT] PRIMARY KEY CLUSTERED 
(
	[PMId] ASC,
	[RTId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Items]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Items](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RTId] [int] NULL,
	[PMId] [int] NULL,
 CONSTRAINT [PK_Items] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Estimations]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Estimations](
	[Date] [date] NOT NULL,
	[Year] [smallint] NULL,
	[Month] [tinyint] NULL,
	[MonthName] [char](10) NULL,
	[DayOfYear] [smallint] NULL,
	[DayOfMonth] [tinyint] NULL,
	[WeekNo] [tinyint] NULL,
	[WeekDay] [char](10) NULL,
	[DayOfWeek] [tinyint] NULL,
	[PersonLogin] [char](30) NOT NULL,
	[NoHours] [tinyint] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Quarter] [tinyint] NULL,
 CONSTRAINT [PK_Estimation_1] PRIMARY KEY CLUSTERED 
(
	[Date] ASC,
	[PersonLogin] ASC,
	[ItemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Activities]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Activities](
	[Date] [date] NOT NULL,
	[Year] [smallint] NULL,
	[Month] [tinyint] NULL,
	[MonthName] [char](10) NULL,
	[DayOfYear] [smallint] NULL,
	[DayOfMonth] [tinyint] NULL,
	[WeekNo] [tinyint] NULL,
	[WeekDay] [char](10) NULL,
	[DayOfWeek] [tinyint] NULL,
	[PersonLogin] [char](30) NOT NULL,
	[NoHours] [tinyint] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Quarter] [tinyint] NULL,
 CONSTRAINT [PK_Activity_1] PRIMARY KEY CLUSTERED 
(
	[Date] ASC,
	[PersonLogin] ASC,
	[ItemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'cast(datepart(year, Date) as int)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Activities', @level2type=N'COLUMN',@level2name=N'Year'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DATENAME(weekday, Date)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Activities', @level2type=N'COLUMN',@level2name=N'WeekDay'
GO
/****** Object:  StoredProcedure [dbo].[insertRT]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[insertRT] (
@Id int,
@Name varchar(100),
@ItemIdentity int output,
@ItemType tinyint=100)
as
begin

declare @IdentityOutput table ( ID int );

if exists (select top(1) 1 from RT where Id=@Id)
begin
select @ItemIdentity = Id from Items where RTId=@Id;
end

else
begin



declare @Url char(100);
select @Url = 'https://rt.libra.bank/Ticket/Display.html?id='+cast(@Id as CHAR(10));
--select @Url = 'https://librahome/PM/index.php?m=projects&a=view&project_id='+@Id;
insert into RT (Id,Name,Url,ItemType) values (@Id,@Name,@Url,@ItemType);


insert into Items (RTId, PMId) 
	OUTPUT INSERTED.Id into @IdentityOutput
	values (@Id,null) ;
select @ItemIdentity = ID from @IdentityOutput;


end


end
GO
/****** Object:  StoredProcedure [dbo].[insertPM]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[insertPM] (
@Id int,
@Name varchar(100),
@ItemIdentity int output,
@ItemType tinyint=0,
@QmId varchar(10)=null)
as
begin

declare @IdentityOutput table ( ID int );

if exists (select top(1) 1 from PM where Id=@Id)
begin
select @ItemIdentity = Id from Items where PMId=@Id;
end

else
begin

declare @Url char(100);
--select @Url = 'https://rt.libra.bank/Ticket/Display.html?id='+@Id;
select @Url = 'https://librahome/PM/index.php?m=projects&a=view&project_id='+cast(@Id as CHAR(5));
insert into PM (Id,Name,Url,ItemType,QmId) values (@Id,@Name,@Url,@ItemType,@QmId);

insert into Items (RTId, PMId) 
	OUTPUT INSERTED.Id into @IdentityOutput
	values (null, @Id) ;
select @ItemIdentity = ID from @IdentityOutput;

end

end
GO
/****** Object:  StoredProcedure [dbo].[insertEstimation]    Script Date: 04/06/2015 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertEstimation](
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
GO
/****** Object:  Default [DF_PM_Name]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[PM] ADD  CONSTRAINT [DF_PM_Name]  DEFAULT ('todo') FOR [Name]
GO
/****** Object:  Default [DF_PM_IsRT]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[PM] ADD  CONSTRAINT [DF_PM_IsRT]  DEFAULT ((0)) FOR [ItemType]
GO
/****** Object:  Default [DF_RT_Name]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[RT] ADD  CONSTRAINT [DF_RT_Name]  DEFAULT ('todo') FOR [Name]
GO
/****** Object:  Default [DF_RT_Url]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[RT] ADD  CONSTRAINT [DF_RT_Url]  DEFAULT ('''https://rt.libra.bank/Ticket/''+cast(Id as varchar(10))') FOR [Url]
GO
/****** Object:  Default [DF_RT_IsPM]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[RT] ADD  CONSTRAINT [DF_RT_IsPM]  DEFAULT ((0)) FOR [ItemType]
GO
/****** Object:  ForeignKey [FK_LoginHistory_Persons]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[LoginHistory]  WITH CHECK ADD  CONSTRAINT [FK_LoginHistory_Persons] FOREIGN KEY([Login])
REFERENCES [dbo].[Persons] ([Login])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[LoginHistory] CHECK CONSTRAINT [FK_LoginHistory_Persons]
GO
/****** Object:  ForeignKey [FK_Teams2Persons_Persons]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[Teams2Persons]  WITH CHECK ADD  CONSTRAINT [FK_Teams2Persons_Persons] FOREIGN KEY([Login])
REFERENCES [dbo].[Persons] ([Login])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Teams2Persons] CHECK CONSTRAINT [FK_Teams2Persons_Persons]
GO
/****** Object:  ForeignKey [FK_Teams2Persons_Teams]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[Teams2Persons]  WITH CHECK ADD  CONSTRAINT [FK_Teams2Persons_Teams] FOREIGN KEY([Team])
REFERENCES [dbo].[Teams] ([Name])
GO
ALTER TABLE [dbo].[Teams2Persons] CHECK CONSTRAINT [FK_Teams2Persons_Teams]
GO
/****** Object:  ForeignKey [FK_PM_ItemTypes]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[PM]  WITH CHECK ADD  CONSTRAINT [FK_PM_ItemTypes] FOREIGN KEY([ItemType])
REFERENCES [dbo].[ItemTypes] ([ItemType])
GO
ALTER TABLE [dbo].[PM] CHECK CONSTRAINT [FK_PM_ItemTypes]
GO
/****** Object:  ForeignKey [FK_RT_ItemTypes]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[RT]  WITH CHECK ADD  CONSTRAINT [FK_RT_ItemTypes] FOREIGN KEY([ItemType])
REFERENCES [dbo].[ItemTypes] ([ItemType])
GO
ALTER TABLE [dbo].[RT] CHECK CONSTRAINT [FK_RT_ItemTypes]
GO
/****** Object:  ForeignKey [FK_PM2RT_PM]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[PM2RT]  WITH CHECK ADD  CONSTRAINT [FK_PM2RT_PM] FOREIGN KEY([PMId])
REFERENCES [dbo].[PM] ([Id])
GO
ALTER TABLE [dbo].[PM2RT] CHECK CONSTRAINT [FK_PM2RT_PM]
GO
/****** Object:  ForeignKey [FK_PM2RT_RT]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[PM2RT]  WITH CHECK ADD  CONSTRAINT [FK_PM2RT_RT] FOREIGN KEY([RTId])
REFERENCES [dbo].[RT] ([Id])
GO
ALTER TABLE [dbo].[PM2RT] CHECK CONSTRAINT [FK_PM2RT_RT]
GO
/****** Object:  ForeignKey [FK_Items_PM]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[Items]  WITH CHECK ADD  CONSTRAINT [FK_Items_PM] FOREIGN KEY([PMId])
REFERENCES [dbo].[PM] ([Id])
GO
ALTER TABLE [dbo].[Items] CHECK CONSTRAINT [FK_Items_PM]
GO
/****** Object:  ForeignKey [FK_Items_RT]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[Items]  WITH CHECK ADD  CONSTRAINT [FK_Items_RT] FOREIGN KEY([RTId])
REFERENCES [dbo].[RT] ([Id])
GO
ALTER TABLE [dbo].[Items] CHECK CONSTRAINT [FK_Items_RT]
GO
/****** Object:  ForeignKey [FK_Estimations_Items]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[Estimations]  WITH CHECK ADD  CONSTRAINT [FK_Estimations_Items] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Items] ([Id])
GO
ALTER TABLE [dbo].[Estimations] CHECK CONSTRAINT [FK_Estimations_Items]
GO
/****** Object:  ForeignKey [FK_Estimations_Persons]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[Estimations]  WITH CHECK ADD  CONSTRAINT [FK_Estimations_Persons] FOREIGN KEY([PersonLogin])
REFERENCES [dbo].[Persons] ([Login])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Estimations] CHECK CONSTRAINT [FK_Estimations_Persons]
GO
/****** Object:  ForeignKey [FK_Activity_Items]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[Activities]  WITH CHECK ADD  CONSTRAINT [FK_Activity_Items] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Items] ([Id])
GO
ALTER TABLE [dbo].[Activities] CHECK CONSTRAINT [FK_Activity_Items]
GO
/****** Object:  ForeignKey [FK_Activity_Persons]    Script Date: 04/06/2015 09:32:13 ******/
ALTER TABLE [dbo].[Activities]  WITH CHECK ADD  CONSTRAINT [FK_Activity_Persons] FOREIGN KEY([PersonLogin])
REFERENCES [dbo].[Persons] ([Login])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Activities] CHECK CONSTRAINT [FK_Activity_Persons]
GO
