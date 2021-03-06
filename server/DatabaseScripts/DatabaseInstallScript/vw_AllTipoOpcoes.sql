SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AllTipoOpcoes]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[AllTipoOpcoes]
GO

CREATE VIEW AllTipoOpcoes (TableName, IDFRDBase, IDTipo) as
	SELECT 'TecnicasDeRegisto', IDFRDBase, IDTipoTecnicasDeRegisto FROM SFRDTecnicasDeRegisto
	UNION
	SELECT 'FormaSuporteAcond', IDFRDBase, IDTipoFormaSuporteAcond FROM SFRDFormaSuporteAcond
	UNION
	SELECT 'EstadoDeConservacao', IDFRDBase, IDTipoEstadoDeConservacao FROM SFRDEstadoDeConservacao
	UNION
	SELECT 'Ordenacao', IDFRDBase, IDTipoOrdenacao FROM SFRDOrdenacao
	UNION
	SELECT 'TradicaoDocumental', IDFRDBase, IDTipoTradicaoDocumental FROM SFRDTradicaoDocumental
	UNION
	SELECT 'MaterialDeSuporte', IDFRDBase, IDTipoMaterialDeSuporte FROM SFRDMaterialDeSuporte



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

