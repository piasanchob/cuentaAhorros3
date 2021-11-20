
CREATE PROCEDURE ListaBeneficiarios  
@OutCodeResult INT

AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	
	--
	DECLARE @contBeneficiarios INT = 1, @cantBeneficiarios INT, @IdPersona INT, @IdBeneficiario INT, @valorDocIdentidad INT,
	@nombre varchar(64), @Porcentaje INT, @cantCuentas INT, @Suma INT, @Multiplicacion INT, @Operacion INT ;

	Declare @TempPersonas AS TABLE (Id int identity(1,1),IdPersona INT, ValorDocIdentidad int, Nombre varchar(64), 
	IdBeneficiario INT, Porcentaje INT ,cantCuentas Int, MontoRecibido INT )

	SET @cantBeneficiarios = (SELECT count(Id) FROM Beneficiarios  )

	WHILE @contBeneficiarios <=@cantBeneficiarios
	BEGIN
		SET @IdBeneficiario = (SELECT Id FROM Beneficiarios WHERE Id= @contBeneficiarios)

		SET @Porcentaje = (SELECT Porcentaje FROM Beneficiarios WHERE Id= @contBeneficiarios)

		SET @nombre = (SELECT Id FROM Beneficiarios WHERE Id= @contBeneficiarios)

		SET @IdPersona = (SELECT IdPersona FROM Beneficiarios WHERE Id= @contBeneficiarios)

		SET @cantCuentas =  (SELECT count(Id) from CuentaAhorros WHERE IdPersona=@IdPersona  )

		SET @suma = ( SELECT SUM(Saldo) FROM cuentaAhorros WHERE IdPersona= @IdPersona )
		
		SET @Multiplicacion = (@Porcentaje * 100 )

		SET @Multiplicacion = (@suma * @Multiplicacion)

		INSERT INTO @TempPersonas
		(IdPersona,ValorDocIdentidad,Nombre)

		SELECT Id,ValorDocIdentidad,Nombre FROM PERSONAS WHERE Id=@IdPersona

		UPDATE @TempPersonas
		SET IdBeneficiario=@IdBeneficiario,
	     Porcentaje = @Porcentaje,
		 cantCuentas=@cantCuentas,
		 MontoRecibido=@Multiplicacion
		 WHERE Id=@contBeneficiarios
		

      SET @contBeneficiarios +=1
	  
  END;
	
	SELECT * FROM @TempPersonas
	--
	
	END TRY
	BEGIN CATCH
	if @@TRANCOUNT>0
			ROLLBACK TRANSACTION T1;
			SET @OutCodeResult = 50005;
	END CATCH
	SET NOCOUNT OFF
END;

DROP PROCEDURE ListaBeneficiarios

EXEC ListaBeneficiarios 5