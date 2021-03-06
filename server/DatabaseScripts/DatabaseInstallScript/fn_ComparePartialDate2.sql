/****** Object:  UserDefinedFunction [dbo].[fn_ComparePartialDate2]    Script Date: 04/24/2009 17:12:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************
 * Retorno:
 *  0: datas iguais
 * -1: primeira data é menor que a segunda
 *  1: primeira data é maior que a segunda
 * NULL: sao ambas igualmente incertas
 * -2: a primeira data é a mais incerta
 *  2: a segunda data é a mais incerta
 */

CREATE FUNCTION [dbo].[fn_ComparePartialDate2] (
	@AnoA varchar(100),
	@MesA varchar(100),
	@DiaA varchar(100),
	@AnoB varchar(100),
	@MesB varchar(100),
	@DiaB varchar(100))
	RETURNS Integer AS  
BEGIN 

	DECLARE @Ano INTEGER
	DECLARE @Mes INTEGER
	DECLARE @Dia INTEGER
	
	SET @Ano = dbo.fn_ComparePartialNumber2(@AnoA, @AnoB)
	SET @Mes = dbo.fn_ComparePartialNumber2(@MesA, @MesB)
	SET @Dia = dbo.fn_ComparePartialNumber2(@DiaA, @DiaB)
	
	IF (@Ano IS NULL OR @Ano <> 0) RETURN @Ano
	IF (@Mes IS NULL OR @Mes <> 0) RETURN @Mes
	IF (@Dia IS NULL OR @Dia <> 0) RETURN @Dia
	RETURN 0
END
GO
