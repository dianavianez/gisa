SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_ComparePartialDate]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fn_ComparePartialDate]
GO


CREATE FUNCTION [dbo].[fn_ComparePartialDate] (
@AnoA varchar(100),
@MesA varchar(100),
@DiaA varchar(100),
@AnoB varchar(100),
@MesB varchar(100),
@DiaB varchar(100))
RETURNS Integer AS  
BEGIN 
declare @Ano integer
declare @Mes integer
declare @Dia integer

set @Ano = dbo.fn_ComparePartialNumber(@AnoA, @AnoB)
set @Mes = dbo.fn_ComparePartialNumber(@MesA, @MesB)
set @Dia = dbo.fn_ComparePartialNumber(@DiaA, @DiaB)

if (@Ano is null) return null
if (@Ano = 4) return 0
if (@Ano <> 0) return @Ano

if (@Mes is null) return @Ano
if (@Mes = 4) return 0
if (@Mes <> 0) return @Mes

if (@Dia is null) return @Mes
return @Dia
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

