IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_registerLicense]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_registerLicense]
GO

/****** Object:  StoredProcedure [dbo].[sp_registerLicense]    Script Date: 05/20/2009 10:29:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_registerLicense] @SequenceNumber INT, @GrantDate DATETIME, @SerialNumber NVARCHAR(19), @Modules NVARCHAR(20), @FloatingLicensesCount SMALLINT, @GranterName NVARCHAR(256), @AssemblyVersion NVARCHAR(256) AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	BEGIN TRANSACTION
	DECLARE @GrantDateDB DATETIME
	--		SELECT @GrantDateDB = GrantDate FROM ClientLicense WHERE SequenceNumber = @SequenceNumber AND GrantDate = @GrantDate
	SELECT @GrantDateDB = MAX(GrantDate)
	FROM ClientLicense
	WHERE SequenceNumber = @SequenceNumber
	
	IF  NOT @GrantDateDB IS NULL
	BEGIN
		-- prever o caso de tentarmos registar uma vers�o mais antiga que a mais recente j� existente
		IF @GrantDateDB > @GrantDate
		BEGIN
			ROLLBACK TRAN
			--RAISERROR('DEPRECATEDLICENSE', 10, 1)
			SELECT 5
			RETURN
		END
	END

	INSERT INTO ClientLicense (SequenceNumber, GrantDate, SerialNumber, FloatingLicensesCount, GranterName, AssemblyVersion, isDeleted) Values (@SequenceNumber, @GrantDate, @SerialNumber, @FloatingLicensesCount, @GranterName, @AssemblyVersion, 0)
	SELECT 0
	COMMIT TRAN

	DECLARE @char NVARCHAR(1)
	DECLARE @listLen INT

	SET @listLen = LEN(@Modules)
	WHILE @listLen > 0 
	BEGIN
		SET @listLen = @listLen -1
		SET @char = SUBSTRING(@Modules, @listLen, 1)	
		IF ISNUMERIC(@char) = 1 AND @char <> ','
			INSERT INTO LicenseModules (SequenceNumber, GrantDate, IDModule) 
			VALUES (@SequenceNumber, @GrantDate, CAST(@char AS INT))
	END
END
GO
