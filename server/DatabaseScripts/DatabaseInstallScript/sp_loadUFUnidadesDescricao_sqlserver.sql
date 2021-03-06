/****** Object:  StoredProcedure [dbo].[sp_loadUFUnidadesDescricao]    Script Date: 07/31/2013 17:44:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_loadUFUnidadesDescricao]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_loadUFUnidadesDescricao]
GO

/****** Object:  StoredProcedure [dbo].[sp_loadUFUnidadesDescricao]    Script Date: 07/31/2013 17:44:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_loadUFUnidadesDescricao] @IDNivel BIGINT, @IDTrustee BIGINT  AS
BEGIN
	CREATE TABLE #SPParametersNiveis (IDNivel BIGINT);
	CREATE TABLE #SPResultsCodigos (IDNivel BIGINT,CodigoCompleto NVARCHAR(300));
	
	INSERT INTO #SPParametersNiveis
	SELECT FRDBase.IDNivel
	FROM SFRDUnidadeFisica
		INNER Join FRDBase ON FRDBase.ID = SFRDUnidadeFisica.IDFRDBase
	WHERE FRDBase.isDeleted=0 AND SFRDUnidadeFisica.isDeleted=0 AND SFRDUnidadeFisica.IDNivel = @IDNivel

  	EXEC sp_getCodigosCompletosNiveis
  	
  	-- calcular permissões
  	CREATE TABLE #effective (IDNivel BIGINT PRIMARY KEY, IDUpper BIGINT, Ler TINYINT)
	INSERT INTO #effective 
	SELECT DISTINCT IDNivel, IDNivel, NULL
	FROM #SPParametersNiveis
	EXEC [dbo].[sp_getEffectiveReadPermissions] @IDTrustee
  	
	SELECT p.IDNivel, COALESCE(nd.Designacao, d.Termo), TipoNivelRelacionado.IDTipoNivelRelacionado, 
		SFRDDatasProducao.InicioAno, SFRDDatasProducao.InicioMes, SFRDDatasProducao.InicioDia, 
		SFRDDatasProducao.FimAno, SFRDDatasProducao.FimMes, SFRDDatasProducao.FimDia, 
		codigo.CodigoCompleto, E.Ler, 
		CASE WHEN (NOT nReq.Data_Req IS NULL AND nReq.Data_Dev IS NULL) OR (NOT nReq.Data_Req IS NULL AND NOT nReq.Data_Dev IS NULL AND nReq.Data_Req > nReq.Data_Dev) THEN 1 ELSE 0 END
	FROM #SPParametersNiveis  p
		INNER JOIN #effective E ON E.IDNivel = p.IDNivel
		INNER JOIN Nivel n ON n.ID = p.IDNivel AND n.isDeleted = 0
		INNER JOIN (
			SELECT rh.ID, MIN(rh.IDTipoNivelRelacionado) IDTipoNivelRelacionado
			FROM RelacaoHierarquica rh
				INNER JOIN #SPParametersNiveis p ON p.IDNivel = rh.ID
			WHERE rh.isDeleted = 0
			GROUP BY rh.ID
		) TipoNivelRelacionado ON TipoNivelRelacionado.ID = p.IDNivel
		INNER JOIN FRDBase frd on frd.IDNivel = p.IDNivel AND frd.isDeleted = 0
		INNER JOIN (
			SELECT #SPResultsCodigos.IDNivel, MIN(#SPResultsCodigos.CodigoCompleto) CodigoCompleto
			FROM #SPResultsCodigos
				INNER JOIN #SPParametersNiveis p ON p.IDNivel = #SPResultsCodigos.IDNivel
			GROUP BY #SPResultsCodigos.IDNivel
		) codigo ON codigo.IDNivel = p.IDNivel
		LEFT JOIN SFRDDatasProducao ON SFRDDatasProducao.IDFRDBase = frd.ID AND SFRDDatasProducao.isDeleted = 0
		LEFT JOIN NivelDesignado nd ON nd.ID = p.IDNivel AND nd.isDeleted = 0
		LEFT JOIN NivelControloAut nca ON nca.ID = n.ID AND n.isDeleted = 0
		LEFT JOIN ControloAutDicionario cad ON cad.IDControloAut = nca.IDControloAut AND cad.IDTipoControloAutForma = 1 AND cad.isDeleted = 0
		LEFT JOIN Dicionario d ON cad.IDDicionario = d.ID  AND d.isDeleted = 0		
		LEFT JOIN (
			SELECT n.ID IDNivel, MAX(req.Data) Data_Req, MAX(dev.Data) Data_Dev
        		FROM Nivel n
				LEFT JOIN DocumentosMovimentados dm ON dm.IDNivel = n.ID AND dm.isDeleted = 0
            			LEFT JOIN Movimento req ON req.ID = dm.IDMovimento and req.CatCode = 'REQ' AND req.isDeleted = 0
            			LEFT JOIN Movimento dev ON dev.ID = dm.IDMovimento AND dev.CatCode = 'DEV' AND dev.isDeleted = 0
        		WHERE n.isDeleted = 0
        		GROUP BY n.ID
    		) nReq ON nReq.IDNivel = n.ID
    		
	DROP TABLE #SPParametersNiveis
	DROP TABLE #SPResultsCodigos
	DROP TABLE #effective
END

GO


