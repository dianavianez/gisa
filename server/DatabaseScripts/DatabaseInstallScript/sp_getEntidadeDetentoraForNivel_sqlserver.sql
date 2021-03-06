SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_getEntidadeDetentoraForNivel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_getEntidadeDetentoraForNivel]
GO

CREATE PROCEDURE sp_getEntidadeDetentoraForNivel @nivelID BIGINT AS
BEGIN

	-- Podem existir vários detentores para um dado nível, e precisamos de os descobrir todos
	CREATE TABLE #expansao (IDNivel BIGINT, Geracao SMALLINT)
	
	DECLARE @geracao SMALLINT
	SET @geracao = 0
	
	INSERT INTO #expansao values(@nivelID, @geracao)
	
	WHILE (@@ROWCOUNT>0)
	BEGIN
		SET @geracao =  @geracao + 1

		INSERT INTO #expansao
			SELECT DISTINCT rh.IDUpper, @geracao
			FROM #expansao
				INNER JOIN RelacaoHierarquica rh ON rh.ID = #expansao.IDNivel
			WHERE #expansao.Geracao = @geracao - 1 AND
			rh.isDeleted = 0
	END

	-- Seleccionar apenas as entidades detentoras do caminho
	SELECT DISTINCT IDNivel 
	FROM #expansao e 
		INNER JOIN Nivel n ON n.ID = e.IDNivel 
		LEFT JOIN RelacaoHierarquica rh ON rh.ID=n.ID 
	WHERE rh.ID IS NULL AND n.IDTipoNivel = 1
END
GO

