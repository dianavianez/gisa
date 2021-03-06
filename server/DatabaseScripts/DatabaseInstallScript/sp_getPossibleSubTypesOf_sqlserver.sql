SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_getPossibleSubTypesOf]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_getPossibleSubTypesOf]
GO

/* ***********************************************************************************************************************************
 * Devolve os TipoNivelRelacionados possíveis como subordinados do nível especificado em @nivelID.
 * Para cada um dos TipoNivelRelacionados encontrados são devolvidos ainda os intervalos de tempo em que 
 * são admissiveis como subordinados.
 *************************************************************************************************************************************/
CREATE PROCEDURE sp_getPossibleSubTypesOf @nivelID BIGINT
AS
BEGIN
	-- Se nao existirem relacoes a niveis superiores sao permitidos subniveis de quaiquer tipos
	IF (SELECT COUNT(*) FROM RelacaoHierarquica WHERE ID = @nivelID AND isDeleted = 0) = 0
	BEGIN
		SELECT SubIDTipoNivelRelacionado, Designacao,  InicioAno, InicioMes, InicioDia, FimAno, FimMes, FimDia
		FROM (
			SELECT DISTINCT tnrLower.ID SubIDTipoNivelRelacionado, tnrLower.Designacao, NULL InicioAno, NULL InicioMes, NULL InicioDia, NULL FimAno, NULL FimMes, NULL FimDia, tnrLower.GUIOrder
			FROM RelacaoTipoNivelRelacionado rtnr
				INNER JOIN TipoNivelRelacionado tnrLower ON rtnr.ID = tnrLower.ID
				INNER JOIN TipoNivelRelacionado tnrUpper ON rtnr.IDUpper = tnrUpper.ID
			WHERE tnrLower.IDTipoNivel = 2  -- considerar apenas niveis estruturais
				AND tnrUpper.IDTipoNivel = 2  -- considerar apenas niveis estruturais
		) results
			ORDER BY GUIOrder
	END
	ELSE
	BEGIN
		SELECT DISTINCT SubIDTipoNivelRelacionado, COALESCE(Designacao, ''), COALESCE(InicioAno, ''), COALESCE(InicioMes, ''), COALESCE(InicioDia, ''), COALESCE(FimAno, ''), COALESCE(FimMes, ''), COALESCE(FimDia, ''), GUIOrder
		FROM (
			-- Obter subniveis possiveis
			SELECT /*rh.ID NivelID, rh.IDUpper NivelIDUpper, rh.IDTipoNivelRelacionado, */rtnr.ID SubIDTipoNivelRelacionado, tnr.Designacao, rh.InicioAno, rh.InicioMes, rh.InicioDia, rh.FimAno, rh.FimMes, rh.FimDia, tnr.GUIOrder
			FROM  RelacaoHierarquica rh
				INNER JOIN TipoNivelRelacionado tnrUpper ON rh.IDTipoNivelRelacionado = tnrUpper.ID
				INNER JOIN RelacaoTipoNivelRelacionado rtnr ON rtnr.IDUpper = tnrUpper.ID
				INNER JOIN TipoNivelRelacionado tnr ON tnr.ID = rtnr.ID
			WHERE
				rh.ID = @nivelID
				AND tnr.IDTipoNivel = 2  -- considerar apenas niveis estruturais
				AND rh.isDeleted = 0
			UNION
			-- Obter subniveis possiveis por possibilidade de recorrencia do mesmo nivel
			SELECT /*rh.ID NivelID, rh.IDUpper NivelIDUpper, rh.IDTipoNivelRelacionado, */rh.IDTipoNivelRelacionado SubIDTipoNivelRelacionado, tnrUpper.Designacao,  rh.InicioAno, rh.InicioMes, rh.InicioDia, rh.FimAno, rh.FimMes, rh.FimDia, tnrUpper.GUIOrder
			FROM  RelacaoHierarquica rh
				INNER JOIN TipoNivelRelacionado tnrUpper ON rh.IDTipoNivelRelacionado = tnrUpper.ID
			WHERE
				rh.ID = @nivelID
				 AND tnrUpper.IDTipoNivel = 2  -- considerar apenas niveis estruturais
				 AND (tnrUpper.Recursivo IS NULL OR tnrUpper.Recursivo = 1)
				AND rh.isDeleted = 0
		) results
		ORDER BY GUIOrder
	END
END
GO

