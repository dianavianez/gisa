SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_AddPaddingToDateMember_new]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fn_AddPaddingToDateMember_new]
GO

CREATE FUNCTION fn_AddPaddingToDateMember_new (@member NVARCHAR(4), @maxLen INTEGER) RETURNS NVARCHAR(4) AS  
BEGIN 
	IF LEN(@member) = @maxLen RETURN @member;
	IF @member IS NULL OR LEN(@member) = 0 OR @member = '?' OR @member = '??' OR @member = '???' OR @member = '????' 
		RETURN replicate('?', @maxLen)
	RETURN replicate('0', @maxLen - LEN(@member)) + @member;
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

