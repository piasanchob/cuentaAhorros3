CREATE PROCEDURE ListaBeneficiarios  
@OutCodeResult INT

AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	BEGIN TRANSACTION T1
	--
	DECLARE @contBeneficiarios INT = 1, @cantBeneficiarios INT, @IdPersona INT, @IdBeneficiario INT;

	CREATE TABLE TempPersonas LIKE Personas;

	SET @cantBeneficiarios = (SELECT count(Id) FROM Beneficiarios  )

	WHILE @contBeneficiarios <=@cantBeneficiarios
	
		SET @IdBeneficiario = (SELECT Id FROM Beneficiarios WHERE Id= @contBeneficiarios)

		SET @IdPersona = (SELECT IdPersona FROM Beneficiarios WHERE Id= @contBeneficiarios)

		(SELECT * FROM Personas WHERE Id=@IdPersona)


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