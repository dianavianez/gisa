SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_getCodigoCompletoNivel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_getCodigoCompletoNivel]
GO

CREATE PROCEDURE [dbo].[sp_getCodigoCompletoNivel] 
@nivelID BIGINT
AS
BEGIN
	CREATE TABLE #SPParametersNiveis(
		IDNivel BIGINT
	)
	CREATE TABLE #SPResultsCodigos(
		IDNivel BIGINT, 
		Codigo NVARCHAR(2000)
	)

	INSERT INTO #SPParametersNiveis VALUES(@nivelID)
	EXEC sp_getCodigosCompletosNiveis
	SELECT * FROM #SPResultsCodigos

	DROP TABLE #SPParametersNiveis
	DROP TABLE #SPResultsCodigos
END
GO

