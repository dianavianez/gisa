IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_canCreateRH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_canCreateRH]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON
GO

/*
* O objectivo é determinar se a nova relação entre duas entidades produtoras vai originar uma cadeia de dependências cíclica
*/

CREATE PROCEDURE sp_canCreateRH @Id BIGINT, @IdUpper BIGINT AS
BEGIN

	-- Tabela onde vão ser guardadas RH para cáculos auxiliares
	CREATE TABLE #RHTemp (ID BIGINT, IDUpper BIGINT, ger INT)

	-- Obter as RH tendo como ponto de partida o IDUpper da relação a criar
	INSERT INTO #RHTemp
	SELECT rh.ID, rh.IDUpper, 0 FROM RelacaoHierarquica rh WHERE rh.ID = @IdUpper AND rh.isDeleted = 0

	-- Obter as RH restantes até às Entidades Detentoras
	DECLARE @ger INT
	SET @ger = 0
	
	WHILE (@@ROWCOUNT>0) 
	BEGIN
		SET @ger = @ger + 1
	
		INSERT INTO #RHTemp
		SELECT rh.ID, rh.IDUpper, @ger FROM RelacaoHierarquica rh 
			INNER JOIN #RHTemp t1 ON t1.IDUpper = rh.ID
			LEFT JOIN #RHTemp t2 ON t2.ID = rh.ID AND t2.IDUpper = rh.IDUpper
		WHERE t1.ger = @ger - 1 
			AND rh.isDeleted = 0
			AND t2.ID IS NULL
			AND t2.IDUpper IS NULL
	END
	
	-- caso o se encontre o ID numa das RH obtidas, a RH não pode ser criada
	IF EXISTS (SELECT * FROM #RHTemp WHERE ID = @Id OR IDUpper = @Id)
		SELECT 0
	ELSE
		SELECT 1
	
	DROP TABLE #RHTemp
END
GO
