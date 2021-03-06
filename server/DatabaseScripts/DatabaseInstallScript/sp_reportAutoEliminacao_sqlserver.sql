/****** Object:  StoredProcedure [dbo].[sp_reportAutoEliminacao]    Script Date: 07/31/2013 17:47:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_reportAutoEliminacao]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_reportAutoEliminacao]
GO

/****** Object:  StoredProcedure [dbo].[sp_reportAutoEliminacao]    Script Date: 07/31/2013 17:47:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_reportAutoEliminacao] @IDTrustee BIGINT, @IDAutoEliminacao BIGINT
AS
BEGIN
	DECLARE @IDTipoFRDBaseRecolha BIGINT
	DECLARE @IDTipoFRDBaseUnidadeFisica BIGINT
	DECLARE @IDTipoNivelDocumental BIGINT
	DECLARE @IDTipoNivelRelacionadoDocumento BIGINT
	DECLARE @IDTipoNivelRelacionadoSerie BIGINT
	DECLARE @IDTipoNivelOutro BIGINT
	DECLARE @IDTipoNivelRelacionadoSubSerie BIGINT
	SET @IDTipoFRDBaseRecolha = 1
	SET @IDTipoFRDBaseUnidadeFisica = 2
	SET @IDTipoNivelDocumental = 3
	SET @IDTipoNivelOutro = 4
	SET @IDTipoNivelRelacionadoDocumento = 9
	SET @IDTipoNivelRelacionadoSerie = 7
	SET @IDTipoNivelRelacionadoSubSerie = 8

	-- tabela temporaria, irá conter todos os documentos que devam constar do auto de eliminacao
	CREATE TABLE #Documentos (ID BIGINT, IDSerie BIGINT);

	-- tabela temporaria, irá conter:
	-- * todas as unidades fisicas que tenham sido explicitamente seleccionadas para o auto de eliminação
	-- * todas as unidades fisicas que tenham documentos que devam constar do auto de eliminação
	CREATE TABLE #UnidadesFisicas (ID BIGINT, Seleccionada BIT, IDDocumental BIGINT); -- IDs não únicos se uma UF estiver associada a mais que um nível documental eliminado

	-- tabela temporaria, irá conter:
	-- * todas as séries que tenham documentos que devam constar do auto de eliminação
	-- * todas as séries que tenham UFs que tenham sido explicitamente seleccionadas para o auto de eliminação
	-- * todas as séries que tenham UFs com documentos que devam constar do auto de eliminação
	CREATE TABLE #Series (ID BIGINT);

	-- tabela temporaria, ira definir a associação de todos os documentos e series (no caso de 
	-- os documentos em questão constituirem série) com as entidades produtoras correspondentes 
	-- que devam constar do auto de eliminacao
	CREATE TABLE #NiveisDocumentaisEstruturais (IDDocumental BIGINT, IDEstrutural BIGINT);


	-- Obter todos os documentos incluidos no auto de eliminacao especificado
	-- Determinar o nivel acima para todos os documentos que constituam serie
	INSERT INTO #Documentos (ID, IDSerie) -- distinct é necessário por causa do join com a tabela RelacaoHierarquica, à conta do qual podem aparecer vários resultados para o mesmo documento, se este não constituir série e tiver vários produtores
		SELECT DISTINCT rh.ID, CASE WHEN nUpper.IDTipoNivel = 3 THEN rh.IDUpper ELSE NULL END  -- só devolver a série para os documentos que a tenham
		FROM RelacaoHierarquica rh
			INNER JOIN FRDBase frd ON frd.IDNivel = rh.ID
			INNER JOIN SFRDAvaliacao frda ON frda.IDFRDBase = frd.ID
			INNER JOIN Nivel nUpper ON nUpper.ID = rh.IDUpper
		WHERE 
			rh.IDTipoNivelRelacionado = @IDTipoNivelRelacionadoDocumento AND
			frd.IDTipoFRDBase = @IDTipoFRDBaseRecolha AND
			frda.IDAutoEliminacao = @IDAutoEliminacao AND
			rh.isDeleted = 0 AND 
			frd.isDeleted = 0 AND 
			frda.isDeleted = 0 AND 
			nUpper.isDeleted = 0
	
	-- Iterar sobre os dados enquanto os niveis acima dos IDSerie nao forem todos estruturais
	-- No final a coluna IDSerie contem o ID da serie de cada documento (para os documentos 
	-- que constituam serie) ou NULL (para os documentos soltos)
	WHILE (@@ROWCOUNT > 0)
	BEGIN
		UPDATE #Documentos SET IDSerie = rh.IDUpper
		FROM #Documentos 
			INNER JOIN RelacaoHierarquica rh ON rh.ID = #Documentos.IDSerie
			INNER JOIN Nivel nUpper ON nUpper.ID = rh.IDUpper
		WHERE nUpper.IDTipoNivel = @IDTipoNivelDocumental
			AND rh.isDeleted = 0
			AND nUpper.isDeleted = 0
	END

	-- unidades físicas seleccionadas
	INSERT INTO #UnidadesFisicas
	SELECT DISTINCT nUF.ID, 1, frd.IDNivel -- o distinct é necessário por causa do join com a tabela RelacaoHierarquica (ie, pode tratar-se de uma série com múltiplos produtores)
	FROM Nivel nUF
		INNER JOIN FRDBase frdUF ON frdUF.IDNivel = nUF.ID
		INNER JOIN SFRDUFAutoEliminacao sfrdae ON sfrdae.IDFRDBase = frdUF.ID
		INNER JOIN SFRDUnidadeFisica sfrduf ON sfrduf.IDNivel = nUF.ID
		INNER JOIN FRDBase frd ON frd.ID = sfrduf.IDFRDBase
		INNER JOIN Nivel n ON n.ID = frd.IDNivel
		INNER JOIN RelacaoHierarquica rh ON rh.ID=n.ID
	WHERE
		sfrdae.IDAutoEliminacao = @IDAutoEliminacao AND
		nUF.IDTipoNivel = @IDTipoNivelOutro AND
		frdUF.IDTipoFRDBase = @IDTipoFRDBaseUnidadeFisica AND
		frd.IDTipoFRDBase = @IDTipoFRDBaseRecolha AND
		n.IDTipoNivel = @IDTipoNivelDocumental AND  -- não queremos as associações de unidades físicas a niveis estruturais
		rh.IDTipoNivelRelacionado != @IDTipoNivelRelacionadoDocumento AND -- só queremos associações a série e subséries
		nUF.isDeleted = 0 AND 
		frd.isDeleted = 0 AND 
		sfrdae.isDeleted = 0 AND
		sfrduf.isDeleted = 0 AND
		frd.isDeleted = 0 AND
		n.isDeleted = 0 AND
		rh.isDeleted = 0

	-- Substituir todas as subséries pelas séries respectivas. Este caso só se põe nas unidades 
	-- fisicas "seleccionadas", as que venham parar ao auto por estarem associadas a documentos 
	-- com o auto aparecerão nesta tabela directamente associadas aos seus documentos
	WHILE (@@ROWCOUNT > 0)
	BEGIN
		UPDATE #UnidadesFisicas SET IDDocumental = rh.IDUpper
		FROM #UnidadesFisicas 
			INNER JOIN RelacaoHierarquica rh ON rh.ID = #UnidadesFisicas.IDDocumental
			INNER JOIN Nivel nUpper ON nUpper.ID = rh.IDUpper
		WHERE nUpper.IDTipoNivel = @IDTipoNivelDocumental AND
			rh.IDTipoNivelRelacionado = @IDTipoNivelRelacionadoSubSerie AND
			rh.isDeleted = 0 AND
			nUpper.isDeleted = 0
	END

	-- unidades físicas que tenham documentos com o auto
	INSERT INTO #UnidadesFisicas
	SELECT nUF.ID, 0, #Documentos.ID
	FROM Nivel nUF
		INNER JOIN SFRDUnidadeFisica sfrduf ON sfrduf.IDNivel = nUF.ID
		INNER JOIN FRDBase frdDoc ON frdDoc.ID = sfrduf.IDFRDBase
		INNER JOIN #Documentos ON #Documentos.ID = frdDoc.IDNivel
	WHERE 
		nUF.IDTipoNivel = @IDTipoNivelOutro AND
		frdDoc.IDTipoFRDBase = @IDTipoFRDBaseRecolha AND
		nUF.isDeleted = 0 AND
		sfrduf.isDeleted = 0 AND 
		frdDoc.isDeleted = 0;

	-- unidades físicas sem série/documento mas com auto de eliminação
	INSERT INTO #UnidadesFisicas
	SELECT nUF.ID, 1, NULL
	FROM Nivel nUF
		INNER JOIN FRDBase frdUF ON frdUF.IDNivel = nUF.ID
		INNER JOIN SFRDUFAutoEliminacao sfrdae ON sfrdae.IDFRDBase = frdUF.ID
		LEFT JOIN SFRDUnidadeFisica sfrduf ON sfrduf.IDNivel = nUF.ID
	WHERE 
		sfrdae.IDAutoEliminacao = @IDAutoEliminacao AND
		nUF.IDTipoNivel = @IDTipoNivelOutro AND
		nUF.isDeleted = 0 AND
		frdUF.isDeleted = 0 AND
		sfrdae.isDeleted = 0 AND
		sfrduf.IDNivel IS NULL

	-- obter as séries que tenham documentos com o auto
	-- e obter as que tenham unidades físicas seleccionadas para o auto
	INSERT INTO #Series (ID)
	SELECT DISTINCT rh.ID -- distinct é necessário por causa do Join com a tabela RelacaoHierarquica
	FROM RelacaoHierarquica rh
		INNER JOIN Nivel nSerie ON nSerie.ID = rh.ID
		INNER JOIN #Documentos ON #Documentos.IDSerie = nSerie.ID -- este IDSerie não contém só séries, no entanto, os níveis estruturais são depois filtrados no WHERE
		INNER JOIN FRDBase frdSerie ON frdSerie.IDNivel = nSerie.ID
	WHERE 
		rh.IDTipoNivelRelacionado = @IDTipoNivelRelacionadoSerie AND
		nSerie.IDTipoNivel = @IDTipoNivelDocumental AND
		frdSerie.IDTipoFRDBase = @IDTipoFRDBaseRecolha AND
		rh.isDeleted = 0 AND 
		nSerie.isDeleted = 0 AND
		frdSerie.isDeleted = 0
	UNION
	SELECT DISTINCT rh.ID
	FROM RelacaoHierarquica rh -- distinct é necessário por causa do Join com a tabela RelacaoHierarquica
		INNER JOIN Nivel nSerie ON nSerie.ID = rh.ID
		INNER JOIN FRDBase frdSerie ON frdSerie.IDNivel = nSerie.ID
		INNER JOIN #UnidadesFisicas ON #UnidadesFisicas.IDDocumental=nSerie.ID  --#UnidadesFisicas.ID = sfrduf.IDNivel 
	WHERE 
		rh.IDTipoNivelRelacionado = @IDTipoNivelRelacionadoSerie AND
		nSerie.IDTipoNivel = @IDTipoNivelDocumental AND
		frdSerie.IDTipoFRDBase = @IDTipoFRDBaseRecolha AND
		#UnidadesFisicas.Seleccionada = 1 AND
		rh.isDeleted = 0 AND 
		nSerie.isDeleted = 0 AND
		frdSerie.isDeleted = 0

	-- Obter niveis estruturais para cada uma das series/documentos soltos. 
	-- Cada serie/documento solto pode ter mais que um nivel estrutural superior
	INSERT INTO #NiveisDocumentaisEstruturais (IDDocumental, IDEstrutural)
		SELECT #Series.ID, rh.IDUpper
		FROM #Series
			INNER JOIN RelacaoHierarquica rh ON rh.ID = #Series.ID AND rh.isDeleted = 0 
		UNION
		SELECT #Documentos.ID, rh.IDUpper 
		FROM #Documentos
			INNER JOIN RelacaoHierarquica rh ON rh.ID = #Documentos.ID AND rh.isDeleted = 0 
		WHERE #Documentos.IDSerie IS NULL -- considerar apenas os documentos que não costituam série
		
	-- calcular permissões para #Series
	CREATE TABLE #effective (IDNivel BIGINT PRIMARY KEY, IDUpper BIGINT, Ler TINYINT)
	INSERT INTO #effective 
	SELECT DISTINCT ID, ID, NULL
	FROM #Series
	EXEC [dbo].[sp_getEffectiveReadPermissions] @IDTrustee

	-- devolver toda a informação respeitante a séries
	SELECT #Series.ID "ID",
		nd.Designacao, 
		CASE WHEN E.Ler = 1 THEN frddp.InicioAno ELSE '' END,
		CASE WHEN E.Ler = 1 THEN frddp.InicioMes ELSE '' END,
		CASE WHEN E.Ler = 1 THEN frddp.InicioDia ELSE '' END,
		CASE WHEN E.Ler = 1 THEN frddp.FimAno ELSE '' END, 
		CASE WHEN E.Ler = 1 THEN frddp.FimMes ELSE '' END,
		CASE WHEN E.Ler = 1 THEN frddp.FimDia ELSE '' END,
		CASE WHEN E.Ler = 1 THEN frda.Preservar ELSE '' END		
	FROM #Series
		INNER JOIN #effective E ON E.IDNivel = #Series.ID
		INNER JOIN Nivel nSeries ON nSeries.ID = #Series.ID AND nSeries.isDeleted = 0
		INNER JOIN NivelDesignado nd ON nd.ID = nSeries.ID AND nd.isDeleted = 0
		INNER JOIN FRDBase frd ON frd.IDNivel = nSeries.ID AND frd.isDeleted = 0
		INNER JOIN SFRDAvaliacao frda ON frda.IDFRDBase = frd.ID AND frd.isDeleted = 0
		LEFT JOIN SFRDDatasProducao frddp ON frddp.IDFRDBase = frd.ID AND frddp.isDeleted = 0
	WHERE
		frd.IDTipoFRDBase = 1
		
	TRUNCATE TABLE #effective

	-- devolver toda a informação respeitante a unidades físicas
	SELECT UnidadesFisicas.ID "ID",
		ndUF.Designacao, sfrdcota.Cota, 
		ta.Designacao "TipoAcondicionamento", sfrddf.MedidaLargura,
		frddp.InicioAno, frddp.InicioMes, frddp.InicioDia, 
		frddp.FimAno, frddp.FimMes, frddp.FimDia
	FROM (SELECT DISTINCT ID FROM #UnidadesFisicas) UnidadesFisicas
		INNER JOIN Nivel nUF ON nUF.ID = UnidadesFisicas.ID AND nUF.isDeleted = 0
		INNER JOIN NivelDesignado ndUF ON ndUF.ID = nUF.ID AND ndUF.isDeleted = 0
		INNER JOIN FRDBase frdUF ON frdUF.IDNivel = nUF.ID AND frdUF.isDeleted = 0
		LEFT JOIN SFRDDatasProducao frddp ON frddp.IDFRDBase = frdUF.ID AND frddp.isDeleted = 0
		LEFT JOIN SFRDUFCota sfrdcota ON sfrdcota.IDFRDBase = frdUF.ID AND sfrdcota.isDeleted = 0
		LEFT JOIN SFRDUFDescricaoFisica sfrddf ON sfrddf.IDFRDBase = frdUF.ID AND sfrddf.isDeleted = 0
		LEFT JOIN TipoAcondicionamento ta ON ta.ID = sfrddf.IDTipoAcondicionamento AND ta.isDeleted = 0
		
	-- permissoes para #Documentos
	TRUNCATE TABLE #effective
	INSERT INTO #effective 
	SELECT DISTINCT ID, ID, NULL
	FROM #Documentos
	EXEC [dbo].[sp_getEffectiveReadPermissions] @IDTrustee

	-- devolver toda a informação referente a documentos
	SELECT #Documentos.ID "ID", 
		#Documentos.IDSerie "IDSerie", 
		nd.Designacao, 
		CASE WHEN E.Ler = 1 THEN frddp.InicioAno ELSE '' END,
		CASE WHEN E.Ler = 1 THEN frddp.InicioMes ELSE '' END, 
		CASE WHEN E.Ler = 1 THEN frddp.InicioDia ELSE '' END,
		CASE WHEN E.Ler = 1 THEN frddp.FimAno ELSE '' END,
		CASE WHEN E.Ler = 1 THEN frddp.FimMes ELSE '' END,
		CASE WHEN E.Ler = 1 THEN frddp.FimDia ELSE '' END,
		CASE WHEN E.Ler = 1 THEN frda.Preservar ELSE '' END		
	FROM #Documentos
		INNER JOIN #effective E ON E.IDNivel = #Documentos.ID
		INNER JOIN Nivel nDocs ON nDocs.ID = #Documentos.ID AND nDocs.isDeleted = 0
		INNER JOIN NivelDesignado nd ON nd.ID = nDocs.ID AND nd.isDeleted = 0
		INNER JOIN FRDBase frd ON frd.IDNivel = nDocs.ID AND frd.isDeleted = 0
		LEFT JOIN SFRDDatasProducao frddp ON frddp.IDFRDBase = frd.ID AND frddp.isDeleted = 0
		LEFT JOIN SFRDAvaliacao frda ON frda.IDFRDBase = frd.ID AND frda.isDeleted = 0
	WHERE
		frd.IDTipoFRDBase = 1

	-- devolver toda a informação respeitante a entidades produtoras
	SELECT IDDocumental "ID", d.Termo Designacao
	FROM #NiveisDocumentaisEstruturais
		INNER JOIN NivelControloAut nca ON nca.ID = #NiveisDocumentaisEstruturais.IDEstrutural AND nca.isDeleted = 0
		INNER JOIN ControloAut ca ON ca.ID = nca.IDControloAut AND ca.isDeleted = 0
		INNER JOIN ControloAutDicionario cad ON cad.IDControloAut = ca.ID AND cad.isDeleted = 0
		INNER JOIN Dicionario d ON d.ID = cad.IDDicionario AND d.isDeleted = 0

	-- devolver toda a informação respeitante à associação de unidades físicas
	-- a níveis documentais (séries e documentos)
	SELECT #UnidadesFisicas.ID "ID", #UnidadesFisicas.Seleccionada, #UnidadesFisicas.IDDocumental
	FROM #UnidadesFisicas

	DROP TABLE #Documentos
	DROP TABLE #UnidadesFisicas
	DROP TABLE #Series
	DROP TABLE #NiveisDocumentaisEstruturais
	DROP TABLE #effective
END


GO


