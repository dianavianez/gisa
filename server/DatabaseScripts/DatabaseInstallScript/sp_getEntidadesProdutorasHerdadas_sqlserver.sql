SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_getEntidadesProdutorasHerdadas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_getEntidadesProdutorasHerdadas]
GO

/***************************************************************************************************************
 * Para os niveis estruturais que sejam entidade produtora devolve a propria entidade produtora,
 * para niveis documentais (e tambem estruturais que nao seja entidade produtora) devolvemos 
 * os niveis superiores mais proximos que sejam entidade produtora.
 ***************************************************************************************************************/
CREATE PROCEDURE sp_getEntidadesProdutorasHerdadas 
	@NivelID BIGINT
AS


	/* Verificar se o nivel em causa e uma entidade produtora */
	IF EXISTS (SELECT * FROM Nivel WHERE ID = @NivelID AND CatCode = 'CA')
	BEGIN
		SELECT ID, IDControloAut FROM NivelControloAut WHERE ID = @NivelID
		RETURN
	END;
		
	WITH Temp (ID, IDUpper, IDTipoNivelRelacionado, Level)
    AS (
        SELECT ID, IDUpper, IDTipoNivelRelacionado, 0 AS Level
        FROM RelacaoHierarquica rh
        WHERE rh.ID = @NivelID AND rh.isDeleted = 0
        
        UNION ALL
    	
        SELECT RelacaoHierarquica.ID, RelacaoHierarquica.IDUpper, RelacaoHierarquica.IDTipoNivelRelacionado, Level
        FROM RelacaoHierarquica
			INNER JOIN Temp ON Temp.IDUpper = RelacaoHierarquica.ID AND Temp.Level = Level
        WHERE RelacaoHierarquica.IDTipoNivelRelacionado > 6 AND RelacaoHierarquica.isDeleted = 0
    )
    SELECT nca.ID, nca.IDControloAut
    FROM Temp
		INNER JOIN NivelControloAut nca ON nca.ID = Temp.IDUpper -- só os niveis controlados têm uma relação com os controlos de autoridade (entidades produtoras)
		INNER JOIN RelacaoHierarquica rh ON rh.ID = Temp.ID AND rh.IDUpper = Temp.IDUpper AND rh.isDeleted = 0
	ORDER BY dbo.fn_AddPaddingToDateMember_new2(rh.FimAno, 4) DESC, 
		dbo.fn_AddPaddingToDateMember_new(rh.FimMes, 2), 
		dbo.fn_AddPaddingToDateMember_new(rh.FimDia, 2),
		dbo.fn_AddPaddingToDateMember_new2(rh.InicioAno, 4) DESC, 
		dbo.fn_AddPaddingToDateMember_new(rh.InicioMes, 2), 
		dbo.fn_AddPaddingToDateMember_new(rh.InicioDia, 2)	
		
GO

