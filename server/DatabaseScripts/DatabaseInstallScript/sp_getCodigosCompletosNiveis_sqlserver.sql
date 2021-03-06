SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_getCodigosCompletosNiveis]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_getCodigosCompletosNiveis]
GO

/*
 * Este SP assume que a tabela #SPParametersNiveis foi criada e preenchida antes de ser invocado.
 */
CREATE PROCEDURE sp_getCodigosCompletosNiveis
AS
BEGIN

	CREATE TABLE #expansao (IDNivel BIGINT, Geracao SMALLINT)
	CREATE TABLE #codigos (IDNivel BIGINT, Codigo NVARCHAR(255))
	
	CREATE CLUSTERED INDEX ex_idx ON #expansao (IDNivel)
	--CREATE INDEX cod_idx ON #codigos (IDNivel)
	
	DECLARE @geracao SMALLINT
	SET @geracao = 0
	
	INSERT INTO #expansao
		SELECT IDNivel, @geracao
		FROM #SPParametersNiveis
	
	WHILE (@@ROWCOUNT>0)
	BEGIN
		SET @geracao =  @geracao + 1

		INSERT INTO #expansao
		SELECT DISTINCT rh.IDUpper, @geracao
		FROM #expansao
			INNER JOIN RelacaoHierarquica rh ON rh.ID = #expansao.IDNivel AND rh.isDeleted = 0
		WHERE #expansao.Geracao = @geracao - 1
	END
	

	SET @geracao = @geracao - 1

	DECLARE @dash NCHAR(1)
	DECLARE @slash NCHAR(1)
	SET @dash = '-'
	SET @slash = '/'

	INSERT INTO #codigos
	SELECT DISTINCT #expansao.IDNivel, n.Codigo
	FROM #expansao
		INNER JOIN Nivel n ON n.ID = #expansao.IDNivel AND n.isDeleted = 0
		LEFT JOIN RelacaoHierarquica rh ON rh.ID = n.ID AND rh.isDeleted = 0
	WHERE rh.ID IS NULL
	
	WHILE (@geracao > 1)
	BEGIN
		SET @geracao =  @geracao - 1

		INSERT INTO #codigos
			SELECT exps.IDNivel, cPais.Codigo + CASE WHEN exps.IDTipoNivelRelacionado IN (4, 6, 8, 10) THEN @dash ELSE @slash END + exps.Codigo COLLATE SQL_LATIN1_GENERAL_CP850_CS_AS
			FROM #codigos cPais 
				INNER JOIN (
					SELECT DISTINCT #expansao.IDNivel, rh.IDUpper, rh.IDTipoNivelRelacionado, n.Codigo, #expansao.Geracao
					FROM #expansao
						INNER JOIN Nivel n ON n.ID = #expansao.IDNivel AND n.isDeleted = 0
						INNER JOIN RelacaoHierarquica rh ON rh.ID = n.ID AND rh.isDeleted = 0
						LEFT JOIN #codigos cAnteriores ON cAnteriores.IDNivel = #expansao.IDNivel
					WHERE 
						cAnteriores.IDNivel IS NULL AND
						#expansao.Geracao = @geracao
				) exps ON exps.IDUpper = cPais.IDNivel
	END


	SET @geracao =  0

	-- inserir a última geração de nós bem como todos os outros calculados (opção tomada por questões de desempenho)
	INSERT INTO #SPResultsCodigos
		SELECT exps.IDNivel, cPais.Codigo + CASE WHEN exps.IDTipoNivelRelacionado IN (4, 6, 8, 10) THEN @dash ELSE @slash END + exps.Codigo COLLATE SQL_LATIN1_GENERAL_CP850_CS_AS
		FROM #codigos cPais 
			INNER JOIN (
				SELECT DISTINCT #expansao.IDNivel, rh.IDUpper, rh.IDTipoNivelRelacionado, n.Codigo, #expansao.Geracao
				FROM #expansao
					INNER JOIN Nivel n ON n.ID = #expansao.IDNivel AND n.isDeleted = 0
					INNER JOIN RelacaoHierarquica rh ON rh.ID = n.ID AND rh.isDeleted = 0
					--LEFT JOIN #codigos cAnteriores ON cAnteriores.IDNivel = #expansao.IDNivel
				WHERE 
					--cAnteriores.IDNivel IS NULL AND
					#expansao.Geracao = @geracao
			) exps ON exps.IDUpper = cPais.IDNivel

	DROP TABLE #expansao 
	DROP TABLE #codigos
END
GO

