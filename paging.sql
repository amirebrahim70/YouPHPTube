USE [TEST1]
GO
/****** Object:  StoredProcedure [Customer].[CustomerSelect]    Script Date: 09/04/1398 08:14:08 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		AMIR TAGHIPOUR
-- Create date: 2019/02/23
-- Description:	select data by using paging method and national code range
-- =============================================
ALTER PROCEDURE [Customer].[CustomerSelect] --[Customer].[CustomerSelect] Null,Null,'1198476117','5490067624',10,33
	-- Add the parameters for the stored procedure here
	@fname nvarchar(20),
	@lname nvarchar(20),
	@startcode nvarchar(12),
	@endcode nvarchar(12),
	@count int,
	@startpage int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select row_number() over(order by codemelli) as rownum,firstname,lastname,codemelli into #temp from [Customer].[ExcelImport]
where (codemelli between @startcode and @endcode or(@startcode is null or @endcode is null))  and (firstname=@fname or @fname is null) and (lastname=@lname or @lname is null)
 SELECT *
         FROM #temp
         WHERE Rownum >= (@StartPage - 1) * @count + 1
               AND Rownum <= @StartPage * @count
         ORDER BY Rownum;
         DECLARE @ColCount INT;
         DECLARE @Counts BIGINT;
         SELECT @Counts = COUNT(*)
         FROM #temp;
         IF @Counts % @count = 0
             SET @ColCount = @Counts / @count;
         ELSE
         SET @ColCount = CAST(@Counts / @count AS INT) + 1;
         SELECT @ColCount AS TotalPage;
END
