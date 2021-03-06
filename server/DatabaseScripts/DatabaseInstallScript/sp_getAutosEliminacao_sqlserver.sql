SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_getAutosEliminacao]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_getAutosEliminacao]
GO

CREATE PROCEDURE sp_getAutosEliminacao @excludeEmptyAutos BIT AS
BEGIN
	SELECT ae.ID, ae.Designacao, COALESCE(DocsCount, 0), COALESCE(UfsCount, 0)
	FROM AutoEliminacao ae 
		LEFT JOIN (
			SELECT frdaDoc.IDAutoEliminacao, COUNT(frdDoc.ID) DocsCount
			FROM SFRDAvaliacao frdaDoc 
				INNER JOIN FRDBase frdDoc ON frdDoc.ID = frdaDoc.IDFRDBase
			WHERE frdDoc.IDTipoFRDBase = 1 AND
				frdaDoc.isDeleted = 0 AND 
				frdDoc.isDeleted = 0
			GROUP BY frdaDoc.IDAutoEliminacao
			) documentos ON ae.ID = documentos.IDAutoEliminacao
		LEFT JOIN (
			SELECT aeUf.IDAutoEliminacao, COUNT(frdUf.ID) UfsCount
			FROM SFRDUFAutoEliminacao aeUf 
				INNER JOIN FRDBase frdUf ON frdUf.ID = aeUf.IDFRDBase
			WHERE frdUf.IDTipoFRDBase = 2 AND
				aeUf.isDeleted = 0 AND 
				frdUf.isDeleted = 0
			GROUP BY aeUf.IDAutoEliminacao
			) ufs ON ae.ID = ufs.IDAutoEliminacao 
	WHERE NOT @excludeEmptyAutos = 1 OR (@excludeEmptyAutos = 1 AND NOT (documentos.IDAutoEliminacao IS NULL AND ufs.IDAutoEliminacao IS NULL)) AND
		ae.isDeleted=0
END
GO

