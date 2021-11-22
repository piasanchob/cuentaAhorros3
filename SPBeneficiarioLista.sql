
CREATE PROCEDURE ListaBeneficiarios  
@OutCodeResult INT

AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	
	--
	DECLARE @contBeneficiarios INT = 1, @cantBeneficiarios INT, @IdPersona INT, @IdBeneficiario INT, @valorDocIdentidad INT,
	@nombre varchar(64), @Porcentaje INT, @cantCuentas INT, @Suma INT, @MontoRecibido INT, 
	@Operacion INT, @mayor INT, @NumCuenta INT, @Fecha DATE;

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



CREATE PROCEDURE MultasATM @Ndias INT,
@OutCodeResult INT

AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	
	--
	Declare @MultasAtm AS TABLE (Id int identity(1,1),IdCuentaA INT ,Promedio INT, Ano Int, Mes INT )
	DECLARE @Pomedio INT, @Ano INT , @Mes INT, @cantMovimientos INT, @cont INT =1, @IdEstadoC INT,
	@FechaFinal date, @ATM INT = 5, @IdCuentaAhorro INT, @AtmOp INT=0, @IdTipoMov INT, @fechaInicial DATE,
	@contCuentasA INT = 1, @cantCuentas INT, @IdCuentaA INT, @FechaMov Date, @cont2 INT =1 , @AtmOp2 INT =0, @fecha INT ; 

	SET @FechaFinal = '2022-01-31'
	
	SET @fechaInicial =( SELECT DATEADD(DAY,-@Ndias, @FechaFinal))

	SET @cantMovimientos =  (SELECT count(Id) from Movimientos );
	SET @Ano = (SELECT YEAR ( @fechaInicial))

	SET @cantCuentas = (SELECT count(Id) from CuentaAhorros )


	WHILE @contCuentasA<= @cantCuentas
	BEGIN 
		
		SET @IdCuentaAhorro =( SELECT  Id FROM CuentaAhorros WHERE Id=@contCuentasA)

		SET @AtmOp = (SELECT CantOpATM FROM EstadoCuenta WHERE Id=@IdCuentaAhorro)
		
		IF (@AtmOp>8)
			
		BEGIN
			
			WHILE @cont2<=@cantMovimientos 
			BEGIN
				SET @IdCuentaA = (SELECT IdCuenta FROM Movimientos WHERE  Id=@cont2)
				SET @IdTipoMov =(SELECT IdTipoMov FROM Movimientos WHERE  Id=@cont2)

				WHILE @fechaInicial<=@FechaFinal	
				BEGIN
					IF (@IdTipoMov = 6 AND @IdCuentaA = @IdCuentaAhorro)
						Begin
							SET @AtmOp2 +=1
							SET @Fecha = (SELECT MONTH (@fechaInicial))
						END
					ELSE
					BEGIN
						SET @fechaInicial = (SELECT(DATEADD(DAY,1,@fechaInicial)))
						BREAK;
					END
					SET @fechaInicial = (SELECT(DATEADD(DAY,1,@fechaInicial)))
				
				END
				--Print(@AtmOp2)
				SET @cont2+=1
			END;

			IF @AtmOp2 >5
			BEGIN 
				INSERT INTO @MultasAtm
				(IdCuentaA,Promedio,Ano, Mes)

				SELECT @IdCuentaAhorro,@AtmOp/6.0,@Ano,@fecha FROM CuentaAhorros WHERE Id=@contCuentasA
			END 
		END;
		
		SET @contCuentasA+=1
	END

	
	--
	
	END TRY
	BEGIN CATCH
	if @@TRANCOUNT>0
			ROLLBACK TRANSACTION T1;
			SET @OutCodeResult = 50005;
	END CATCH
	SET NOCOUNT OFF
END;


DROP PROCEDURE MultasATM

EXEC MultasATM 7,5





