SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_manageListaModelosAvaliacao]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_manageListaModelosAvaliacao]
GO

/*
@Operation = 0 => Edit
@Operation = 1 => Delete
*/

CREATE PROCEDURE sp_manageListaModelosAvaliacao (
@Operation BIT,
@IDListaModelosAvaliacao BIGINT,
@Designacao NVARCHAR (768) = NULL,
@DataInicio DATETIME = NULL
) AS
BEGIN
	DECLARE @cont BIGINT
	
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	BEGIN TRANSACTION

		SELECT @cont = COUNT(sfrda.IDFRDBase) 
		FROM SFRDAvaliacao sfrda 
			INNER JOIN ModelosAvaliacao ma ON ma.ID = sfrda.IDModeloAvaliacao
			INNER JOIN ListaModelosAvaliacao lma ON lma.ID = ma.IDListaModelosAvaliacao
		WHERE lma.ID = @IDListaModelosAvaliacao

		IF @cont = 0
		BEGIN
			IF @Operation = 0
				UPDATE ListaModelosAvaliacao SET Designacao = @Designacao, DataInicio = @DataInicio WHERE ID = @IDListaModelosAvaliacao
			ELSE
				DELETE FROM ModelosAvaliacao WHERE IDListaModelosAvaliacao = @IDListaModelosAvaliacao
				DELETE FROM ListaModelosAvaliacao WHERE ID = @IDListaModelosAvaliacao

			SELECT 1
		END
		ELSE
			SELECT 0

	COMMIT
END
GO
