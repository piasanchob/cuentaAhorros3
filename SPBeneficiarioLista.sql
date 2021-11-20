

CREATE PROCEDURE ListaBeneficiarios  
@OutCodeResult INT

AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	BEGIN TRANSACTION T1
	--
	DECLARE @contBeneficiarios INT = 1, @cantBeneficiarios INT, @IdPersona INT, @IdBeneficiario INT;

	Declare @TempPersonas AS TABLE (Id INT, IdTipoDoc int, ValorDocIdentidad int, Nombre varchar(64));

	SET @cantBeneficiarios = (SELECT count(Id) FROM Beneficiarios  )

	WHILE @contBeneficiarios <=@cantBeneficiarios
	
		SET @IdBeneficiario = (SELECT Id FROM Beneficiarios WHERE Id= @contBeneficiarios)

		SET @IdPersona = (SELECT IdPersona FROM Beneficiarios WHERE Id= @contBeneficiarios)


		INSERT INTO TempPersonas
		SELECT Id, IdTipoDoc, ValorDocIdentidad, Nombre
		FROM Personas WHERE Id=@IdPersona

		SELECT Id AS Id FROM TempPersonas
		UNION
		SELECT IdTipoDoc AS IdTipoDoc FROM TempPersonas
		UNION
		SELECT ValorDocIdentidad AS ValorDocIdentidad FROM TempPersonas
		UNION
		SELECT Nombre AS Nombre FROM TempPersonas
		U


     SET @contBeneficiarios +=1
	
	
	--
		COMMIT TRANSACTION T1
	END TRY
	BEGIN CATCH
	if @@TRANCOUNT>0
			ROLLBACK TRANSACTION T1;
			SET @OutCodeResult = 50005;
	END CATCH
	SET NOCOUNT OFF
END
DROP PROCEDURE ListaBeneficiarios
EXEC ListaBeneficiarios 5