
CREATE PROCEDURE ListaBeneficiarios  
@OutCodeResult INT

AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	
	--
	DECLARE @contBeneficiarios INT = 1, @cantBeneficiarios INT, @IdPersona INT, @IdBeneficiario INT, @valorDocIdentidad INT,
	@nombre varchar(64), @Porcentaje INT, @cantCuentas INT, @Suma INT, @MontoRecibido INT, 
	@Operacion INT, @mayor INT, @NumCuenta INT;

	Declare @TempPersonas AS TABLE (Id int identity(1,1),IdPersona INT, ValorDocIdentidad int, Nombre varchar(64), 
	IdBeneficiario INT, Porcentaje INT ,cantCuentas Int, MontoRecibido INT, NumCuenta INT ,MayorCantidad INT )

	SET @cantBeneficiarios = (SELECT count(Id) FROM Beneficiarios  )

	WHILE @contBeneficiarios <=@cantBeneficiarios
	BEGIN
		SET @IdBeneficiario = (SELECT Id FROM Beneficiarios WHERE Id= @contBeneficiarios)

		SET @Porcentaje = (SELECT Porcentaje FROM Beneficiarios WHERE Id= @contBeneficiarios)

		SET @nombre = (SELECT Id FROM Beneficiarios WHERE Id= @contBeneficiarios)

		SET @IdPersona = (SELECT IdPersona FROM Beneficiarios WHERE Id= @contBeneficiarios)

		SET @cantCuentas =  (SELECT count(Id) from CuentaAhorros WHERE IdPersona=@IdPersona  )

		SET @suma = ( SELECT SUM(Saldo) FROM cuentaAhorros WHERE IdPersona= @IdPersona )

		SET @mayor = ( SELECT Max(Saldo) FROM cuentaAhorros WHERE IdPersona= @IdPersona )

		SET @NumCuenta = ( SELECT NumCuenta FROM cuentaAhorros WHERE IdPersona= @IdPersona and Saldo=@mayor )
		
		SET @MontoRecibido =  @suma * (@Porcentaje /100.0 )

		

		INSERT INTO @TempPersonas
		(IdPersona,ValorDocIdentidad,Nombre)

		SELECT Id,ValorDocIdentidad,Nombre FROM PERSONAS WHERE Id=@IdPersona

		UPDATE @TempPersonas
		SET IdBeneficiario=@IdBeneficiario,
	    Porcentaje = @Porcentaje,
		cantCuentas=@cantCuentas,
		MontoRecibido=@MontoRecibido,
		NumCuenta=@NumCuenta,
		MayorCantidad = @mayor
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



CREATE PROCEDURE MultasATM @Ndias INT  
@OutCodeResult INT

AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	
	--
	Declare @MultasAtm AS TABLE (Id int identity(1,1), Promedio INT, Ano Int, Mes INT )
	DECLARE @Pomedio INT, @Ano INT , @Mes INT, @cantMovimientos INT, @cont INT =1, @IdEstadoC INT,
	@Fecha date, @ATM INT = 5, @IdCuentaAhorro INT, @AtmOp INT, @IdTipoMov INT; 

	SET @Fecha = '2022-01-31'
	SET @cantMovimientos =  (SELECT count(Id) from Movimientos );

	WHILE @cont<=@cantMovimientos 


		SET @IdTipoMov =(SELECT IdTipoMov FROM Movimientos WHERE Id=@cont)
		SET @IdCuentaAhorro = (SELECT IdCuenta FROM Movimientos WHERE Id=@cont)



		IF @IdTipoMov = 6
			UPDATE EstadoCuenta
			SET CantOpATM = CantOpATM + 1
			WHERE IdCuentaAhorros=@IdCuenta


		IF @IdTipoMov = 7 
		
			UPDATE EstadoCuenta
			SET CantOpHumano = CantOpHumano + 1
			WHERE IdCuentaAhorros=@IdCuenta


	

		
		SET @cont+=1
	--
	
	END TRY
	BEGIN CATCH
	if @@TRANCOUNT>0
			ROLLBACK TRANSACTION T1;
			SET @OutCodeResult = 50005;
	END CATCH
	SET NOCOUNT OFF
END;














































