USE cuentaAhorros

DECLARE @datos XML, @division INT, @multiplicacion INT, @montoFinal INT
DECLARE @i INT=1,
@var2 INT, @cont2 INT =1, @fechaInicial2 DATE, @fechaFinal2 DATE, @idCuentaO INT = 1, @cantCO INT, @IdTasa2 INT, @FechaFin DATE, @FechaIni Date;

DECLARE @saldoCA int, @saldo1CO int, @idca int;

DECLARE @IdMov2 INT = 1, @IdTipoMov2 INT, @CantRetiroHumano INT, @CantRetiroAtm INT, @IdCuentaAhorro INT,@CantMov INT,
@CantCuentas INT,
@IdCuenta INT, @IdEstadoCuenta INT
DECLARE @cont INT=1, @IdCuentaAhorros INT, @IdTipoCuentaAhorro INT, 
@SaldoMin INT, @Saldo INT,@MultaSaldoMin INT, @SaldoFinal INT,@NumRetirosHumano INT,
@NumRetirosAutomatico INT, @ComisionRetiroHumano INT, @ComisionRetiroAutomatico INT,
@diferenciaRetirosHumano INT, @diferenciaRetirosATM INT, @ContRetiroAtm INT, 
@ContRetiroHumano INT, @TasaInteres INT, @Suma INT, @CargoMensual INT

DECLARE 
@IdMov INT,@IdMonMov INT, @IdMonedaCuenta INT, @IdTipoCuenta INT, 
@Venta INT, @Compra Int, @Operacion INT, @Monto INT , 
@nuevoSaldo INT,@IdTipoCambio INT, @IdTipoMov INT, @Val INT, 
@IdNumCuenta INT, @MontoMonedaCuenta INT;

DECLARE @contE INT=1, @IdCuentaAhorrosE INT, @IdEstadoCuentaE INT, @IdTipoCuentaAhorroE INT, 
@SaldoMinE INT, @SaldoE INT,@MultaSaldoMinE INT, @SaldoFinalE INT,@NumRetirosHumanoE INT,
@NumRetirosAutomaticoE INT, @ComisionRetiroHumanoE INT, @ComisionRetiroAutomaticoE INT,
@diferenciaRetirosHumanoE INT, @diferenciaRetirosATME INT, @ContRetiroAtmE INT, 
@ContRetiroHumanoE INT, @TasaInteresE INT, @SumaE INT, @CargoMensualE INT

DECLARE @mesinicio INT, @mesfinal INT;

SELECT @datos = CAST(xmlfile AS xml)
FROM OPENROWSET(BULK 'C:\Users\gmora\OneDrive\Desktop\2 SEMESTRE 2021\Bases de Datos\Tarea Programada 3\cuentaAhorros3\cuentaAhorros3\DatosTarea3.xml', SINGLE_BLOB) AS T(xmlfile)

--insercion usuarios


	INSERT INTO dbo.Usuarios(ValorDocIdentidad, Username,Pass,EsAdmin)
	SELECT  
		ValorDocIdentidad =  T.Item.value('@ValorDocumentoIdentidad', 'varchar(64)'),
		Username =  T.Item.value('@Usuario', 'varchar(64)'),
		Pass =  T.Item.value('@Pass', 'varchar(64)'),
		EsAdmin =  T.Item.value('@EsAdministrador', 'bit')
		
		
	FROM @datos.nodes('Datos/Usuarios/Usuario') as T(Item)

	
	SELECT * FROM dbo.Usuarios

--insercion puede ver
	
	INSERT INTO dbo.UsuarioPuedeVer(NumCuenta,Username,IdUsuario)
	SELECT  

		NumCuenta =  T.Item.value('@NumeroCuenta', 'varchar(64)'),
		Username =  T.Item.value('@Usuario', 'varchar(64)'),
		IdUsuario =  (SELECT Id FROM Usuarios WHERE Username = T.Item.value('@Username', 'varchar(64)'))
		
	FROM @datos.nodes('Datos/Usuarios_Ver/UsuarioPuedeVer') as T(Item)

	
	SELECT * FROM dbo.UsuarioPuedeVer
	
--insercion tipo docs identidad

	INSERT INTO dbo.TipoDocsIdentidad(Id, Nombre)
	SELECT  
		Id = T.Item.value('@Id', 'int'),
		Nombre = T.Item.value('@Nombre', 'varchar(64)')
	FROM @datos.nodes('Datos/Tipo_Doc/TipoDocuIdentidad') as T(Item)

	
	SELECT * FROM dbo.TipoDocsIdentidad
	--insercion tipo monedas

	INSERT INTO dbo.TipoMonedas(Id, Nombre)
	SELECT  
		Id = T.Item.value('@Id', 'int'),
		Nombre = T.Item.value('@Nombre', 'varchar(64)')
	FROM @datos.nodes('Datos/Tipo_Moneda/TipoMoneda') as T(Item)

	SELECT * FROM dbo.TipoMonedas
	
	--insercion tipo parentescos

	INSERT INTO dbo.Parentescos(Id, Nombre)
	SELECT  
		Id = T.Item.value('@Id', 'int'),
		Nombre = T.Item.value('@Nombre', 'varchar(64)')
	FROM @datos.nodes('Datos/Parentezcos/Parentezco') as T(Item)

	
	SELECT * FROM dbo.Parentescos
	--insercion tipo cuentas de ahorro

	INSERT INTO dbo.TiposCuentaAhorros(Id, Nombre,IdTipoMoneda,SaldoMin,MultaSaldoMin,CargoMensual,NumRetirosHumano,NumRetirosAutomatico,ComisionHumano,ComisionCajero,TasaInteres)
	SELECT  
		Id = T.Item.value('@Id', 'int'),
		Nombre = T.Item.value('@Nombre', 'varchar(64)'),
		IdTipoMoneda = T.Item.value('@IdTipoMoneda', 'int'),
		SaldoMin = T.Item.value('@SaldoMinimo', 'float'),
		MultaSaldoMin = T.Item.value('@MultaSaldoMin', 'float'),
		CargoMensual = T.Item.value('@CargoMensual', 'int'),
		NumRetirosHumano = T.Item.value('@NumRetirosHumano', 'int'),
		NumRetirosAutomatico = T.Item.value('@NumRetirosAutomatico', 'int'),
		ComisionHumano = T.Item.value('@ComisionHumano', 'int'),
		ComisionCajero = T.Item.value('@ComisionAutomatico', 'int'),
		TasaInteres = T.Item.value('@Interes', 'int')
		


	FROM @datos.nodes('Datos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro') as T(Item)
	
	
	SELECT * FROM dbo.TiposCuentaAhorros
	
	--insercion tipo mov 
	INSERT INTO dbo.TipoMov(Id,Operacion,Descripcion)
		
	SELECT  
		
		Id = T.Item.value('@Id', 'int'),
		
		Operacion = T.Item.value('@Operacion', 'varchar(64)'),
		Descripcion = T.Item.value('@Descripcion', 'varchar(64)')
		
		
	FROM @datos.nodes('//Datos/Tipo_Movimientos/TipoMovimiento') as T(Item)

	SELECT * FROM TipoMov


	--insercion tipo evento
	INSERT INTO dbo.TipoEvento(Id,Nombre)
		
	SELECT  
		
		Id = T.Item.value('@Id', 'int'),
		Nombre = T.Item.value('@Nombre', 'varchar(64)')

	FROM @datos.nodes('//Datos/TipoEventos/TipoEvento') as T(Item)

	SELECT * FROM TipoEvento

	--insercion tipo mov CO
	INSERT INTO dbo.TipoMovCO(Id,Operacion,Nombre)
		
	SELECT  
		
		Id = T.Item.value('@Id', 'int'),
		
		Operacion = T.Item.value('@Operacion', 'varchar(64)'),
		Nombre = T.Item.value('@Descripcion', 'varchar(64)')
		
		
	FROM @datos.nodes('//Datos/TipoMovimientosCO/TipoMovimientoCO') as T(Item)

	SELECT * FROM TipoMovCO

	-- TASAS INTERSES CO

	INSERT INTO dbo.TasasInteresesCO(Id,Tasa)
		
	SELECT  
		
		Id = T.Item.value('@Id', 'int'),
		
		Tasa= T.Item.value('@TasaInteres', 'float')
		
		
	FROM @datos.nodes('//Datos/TasaInteresesCO/TasaInteresCO') as T(Item)

	SELECT * FROM TasasInteresesCO


	
DECLARE @FechasProcesar TABLE (Fecha date)
INSERT @FechasProcesar(Fecha)
SELECT  
		Fecha = T.Item.value('@Fecha', 'date')
		
FROM @datos.nodes('//Datos/FechaOperacion') as T(Item)


DECLARE @fechaInicial DATE, @fechaFinal DATE
DECLARE @DiaCierreEC DATE
DECLARE @CuentasCierran TABLE( sec int identity(1,1), Id Int)

SELECT @fechaInicial=MIN(Fecha), @fechaFinal=MAX(Fecha) FROM @FechasProcesar
--SET @fechaInicial='2021-08-02', @fechaFinal= ' 2021-11-30' 
WHILE @fechaInicial<=@fechaFinal
BEGIN
	
	--insercion Personas
	INSERT INTO dbo.Personas(ValorDocIdentidad,Nombre,FechaNac,Tel1,Tel2,Email,IdTipoDoc)
	SELECT  
		ValorDocIdentidad = T.Item.value('@ValorDocumentoIdentidad', 'varchar(64)'),
		Nombre = T.Item.value('@Nombre', 'varchar(64)'),
		FechaNac = T.Item.value('@FechaNacimiento', 'date'),
		Tel1 = T.Item.value('@Telefono1', 'bigint'),
		Tel2 = T.Item.value('@Telefono2', 'bigint'),
		Email = T.Item.value('@Email', 'varchar(64)'),
		IdTipoDoc = T.Item.value('@TipoDocuIdentidad', 'int')

	FROM @datos.nodes('//Datos/FechaOperacion/AgregarPersona') as T(Item) 
	--WHERE T.item.value('../@Fecha', 'DATE') = @fechaInicial;
	
	SELECT * FROM dbo.Personas

	INSERT INTO dbo.TipoCambio(TCCompra,TCVenta,IdMoneda,IdOtra,Fecha)
	SELECT  
		TCCompra = T.Item.value('@Compra', 'int'),
		TCVenta = T.Item.value('@Venta', 'int'),
		IdMoneda = 2,
		IdOtra = 1,
		Fecha = T.item.value('../@Fecha', 'DATE')
		
	
	FROM @datos.nodes('//Datos/FechaOperacion/TipoCambioDolares') as T(Item)

	

	SELECT * FROM dbo.TipoCambio
	--insercion cuentas

	INSERT INTO dbo.CuentaAhorros(IdPersona,Saldo,IdTipoCuenta,NumCuenta,FechaCreacion,IdUsuario)
	
	SELECT  

		IdPersona = (SELECT Id FROM Personas WHERE ValorDocIdentidad = T.Item.value('@ValorDocumentoIdentidadDelCliente', 'varchar(64)')),
		Saldo = T.Item.value('@Saldo', 'int'),
		IdTipoCuenta = T.Item.value('@TipoCuentaId', 'int'),
		NumCuenta = T.Item.value('@NumeroCuenta', 'varchar(64)'),
		FechaCreacion = T.item.value('../@Fecha', 'DATE'),
		IdUsuario = (SELECT Id FROM Usuarios WHERE ValorDocIdentidad = T.Item.value('@ValorDocumentoIdentidadDelCliente', 'varchar(64)'))

	FROM @datos.nodes('//Datos/FechaOperacion/AgregarCuenta') as T(Item)
	--WHERE T.item.value('../@Fecha', 'DATE') = @fechaInicial;
	

	SELECT * FROM dbo.CuentaAhorros
	

	--insercion beneficiarios

	INSERT INTO dbo.Beneficiarios(IdPersona,IdParentesco,Porcentaje,IdNumCuenta)
	SELECT 
		
		IdPersona = (SELECT Id FROM Personas WHERE ValorDocIdentidad = T.Item.value('@ValorDocumentoIdentidadBeneficiario', 'varchar(64)')),
		IdParentesco = T.Item.value('@ParentezcoId', 'int'),
		Porcentaje = T.Item.value('@Porcentaje', 'int'),
		IdNumCuenta = (SELECT Id FROM CuentaAhorros WHERE NumCuenta = T.Item.value('@NumeroCuenta', 'varchar(64)'))
	
	FROM @datos.nodes('//Datos/FechaOperacion/AgregarBeneficiario') as T(Item)
	--WHERE T.item.value('../@Fecha', 'DATE') = @fechaInicial;
	
	

	SELECT * FROM dbo.Beneficiarios

	

	--insercion mov
	INSERT INTO dbo.Movimientos(IdTipoCambio,Descripcion,IdCuenta,IdTipoMov,Monto,IdMoneda,Fecha,MontoMonedaOriginal)
	SELECT  
		
		IdTipoCambio = (SELECT Id FROM TipoCambio WHERE Fecha = T.item.value('../@Fecha', 'DATE')),
		Descripcion = T.Item.value('@Descripcion', 'varchar(64)'),
		IdCuenta = (SELECT Id FROM CuentaAhorros WHERE NumCuenta = T.Item.value('@NumeroCuenta', 'int')),
		IdTipoMov = T.Item.value('@Tipo', 'int'),
		Monto = T.Item.value('@Monto', 'int'),
		IdMoneda = T.Item.value('@IdMoneda', 'int'),
		
		Fecha = T.item.value('../@Fecha', 'DATE'),
		MontoMonedaOriginal = T.Item.value('@Monto', 'int')

		
	FROM @datos.nodes('//Datos/FechaOperacion/Movimientos') as T(Item)
	

	SELECT * FROM dbo.Movimientos

	-- insercion cuenta objetivo 

	INSERT INTO dbo.CuentaObjetivo(Descripcion,DiaAhorro,FechaInicio,FechaFinal,MontoAhorrar,IdCuentaAhorros,NumCuentaObjetivo,Saldo)
	SELECT  
		
		Descripcion = T.Item.value('@Descripcion', 'varchar(64)'),
		DiaAhorro = T.Item.value('@DiadeAhorro', 'int'),
		FechaInicio = T.item.value('../@Fecha', 'DATE'),
		FechaFinal = T.item.value('@FechaFinal', 'DATE'),
		MontoAhorrar = T.Item.value('@MontoAhorrar', 'int'),
		IdCuentaAhorros = (SELECT Id FROM CuentaAhorros WHERE NumCuenta = T.Item.value('@CuentaMaestra', 'int')),
		NumCuentaObjetivo = T.Item.value('@NumeroCO', 'int'),
		Saldo=0
		
		
		

		
	FROM @datos.nodes('//Datos/FechaOperacion/AgregarCO') as T(Item)
	
	SELECT * FROM dbo.CuentaObjetivo

	SET @var2 = (SELECT NuevoSaldo FROM Movimientos WHERE Id= 5)
	IF @var2=NULL
		UPDATE Movimientos
		SET NuevoSaldo=0

	SET @var2 = (SELECT MontoMonedaCuenta FROM Movimientos WHERE Id= 5)
	IF @var2=NULL
		UPDATE Movimientos
		SET MontoMonedaCuenta=0



	SET @CantMov = (SELECT count(Id) from Movimientos  )
	WHILE @cont<=@CantMov
	BEGIN


--Encontrar id de la moneda de la cuenta 

	SET @IdMov = (@cont)

	SET @IdCuentaAhorro =  (SELECT IdCuenta FROM Movimientos WHERE Id=@IdMov)

	SET @IdTipoCuenta = (SELECT IdTipoCuenta FROM CuentaAhorros WHERE Id=@IdCuentaAhorro)

	SET @IdMonedaCuenta = (SELECT IdTipoMoneda FROM TiposCuentaAhorros WHERE Id=@IdTipoCuenta)

-- Encontrar Moneda del Movimiento

	SET @IdMonMov = (SELECT IdMoneda FROM Movimientos WHERE Id =@IdMov )

-- Encontrar Tipo de Cambio

	SET @IdTipoCambio= (SELECT IdTipoCambio FROM Movimientos WHERE Id = @IdMov)

	SET @Venta = (SELECT TCVenta FROM TipoCambio WHERE Id= @IdTipoCambio)

	SET @Compra = (SELECT TCCompra FROM TipoCambio WHERE Id= @IdTipoCambio)

	SET @IdTipoMov= (SELECT IdTipoMov FROM Movimientos WHERE Id= @IdMov)

-- ENCONTRAR OPERACION


	SELECT @Operacion = (SELECT Operacion FROM TipoMov WHERE Id = @IdTipoMov)


-- Encontrar Monto

	SET @Monto = (SELECT Monto FROM Movimientos WHERE Id=@IdMov)

	IF (@IdMonedaCuenta= 1 AND @IdMonMov=1)			
		IF @Operacion = 1

			SET @MontoMonedaCuenta=(@Monto) 
			
			
			
		ELSE
			
			SET @MontoMonedaCuenta=-@Monto 
			
	ELSE IF (@IdMonedaCuenta = 1 AND @IdMonMov=2)
		
		IF @Operacion = 1
		
			SET @MontoMonedaCuenta = (@Compra * @Monto)
			
			
		ELSE
			
			
			SET @MontoMonedaCuenta = (@Compra * -@Monto)
			
			

	ELSE IF (@IdMonedaCuenta = 2 AND @IdMonMov=1)
		
		IF @Operacion = 1
			
			
			SET @MontoMonedaCuenta = (@Monto /@Venta) 

		
		
		ELSE
			
			SET @MontoMonedaCuenta = (@Monto / -@Venta)
			
			
	ELSE IF (@IdMonedaCuenta= 2 AND @IdMonMov	=2 )
		IF @Operacion = 1

			SET @MontoMonedaCuenta=@Monto 

		ELSE
			
			SET @MontoMonedaCuenta= -@Monto 


	UPDATE Movimientos
	SET MontoMonedaCuenta = @MontoMonedaCuenta
	WHERE Id=@IdMov


	SET @cont= @cont+1;

	END


	SET @CantCuentas = (SELECT count(Id) from CuentaAhorros  )

	WHILE @i<=@CantCuentas
	BEGIN
	SET @nuevoSaldo = (SELECT SUM(MontoMonedaCuenta)
	FROM Movimientos
	WHERE IdCuenta=@i);

	UPDATE CuentaAhorros
	SET Saldo = @nuevoSaldo
	WHERE Id=@i


	SET @i +=1

	END
	SET @CantMov = (SELECT count(Id) from Movimientos  )
	WHILE @IdMov2<=@CantMov
	BEGIN 
	SET @IdTipoMov2 =(SELECT IdTipoMov FROM Movimientos WHERE Id=@IdMov2)
	SET @FechaInicial = (SELECT Fecha FROM Movimientos WHERE Id=@IdMov2)
	SET @IdCuenta = (SELECT IdCuenta FROM Movimientos WHERE Id=@IdMov2)



	IF @IdTipoMov2 = 6
		UPDATE EstadoCuenta
		SET CantOpATM = CantOpATM + 1
		WHERE IdCuentaAhorros=@IdCuenta


	IF @IdTipoMov2 = 7 
		
		UPDATE EstadoCuenta
		SET CantOpHumano = CantOpHumano + 1
		WHERE IdCuentaAhorros=@IdCuenta

	

	SET @IdMov2+=1
	END
	SET @CantCuentas = (SELECT count(Id) from CuentaAhorros  )

	WHILE @cont2<=@CantCuentas
	BEGIN


	SET @IdCuentaAhorros = (SELECT Id FROM CuentaAhorros WHERE Id= @cont2)
	-- SET IDCUENTA AHORRO DE LA TABLA ESTADO DE CUENTA 
	SET @IdEstadoCuenta = (SELECT Id FROM EstadoCuenta WHERE IdCuentaAhorros=@IdCuentaAhorros)

	 SET @FechaInicial2 = (SELECT FechaInicio FROM EstadoCuenta WHERE IdCuentaAhorros=@IdCuentaAhorros)

	SET @IdTipoCuentaAhorro =(SELECT IdTipoCuenta FROM cuentaAhorros WHERE Id=@IdCuentaAhorros)
	-- SET INTERES
	SET @TasaInteres = (SELECT TasaInteres FROM TiposCuentaAhorros WHERE  Id= @IdTipoCuentaAhorro)
	-- SET DE MULTAS
	SET @SaldoMin = (SELECT SaldoMin FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorro)




	SET @MultaSaldoMin = (SELECT MultaSaldoMin FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorro)



	SET @Saldo = (SELECT Saldo FROM cuentaAhorros WHERE Id = @IdCuentaAhorros )
	--CARGO MENSUAL 

	SET @CargoMensual = (SELECT CargoMensual FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorro)
	-- SET NUMEROS DE RETIROS DE LA TABLA TIPOS CUENTA AHORROS 

	SET @NumRetirosHumano = (SELECT NumRetirosHumano FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorro)

	SET @NumRetirosAutomatico=  (SELECT NumRetirosAutomatico FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorro)

	-- SET DE COMISIONES DE LA TABLA TIPOS CUENTA AHORROS
	SET @ComisionRetiroHumano = (SELECT ComisionHumano FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorro)

	SET @ComisionRetiroAutomatico=  (SELECT ComisionCajero FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorro)

	
	--SET RETIROS DE CAJERO DE LA TABLA ESTADO DE CUENTA 
	SET @ContRetiroAtm = (SELECT CantOpATM FROM EstadoCuenta WHERE IdCuentaAhorros = @IdCuentaAhorros)
	SET @ContRetiroHumano = (SELECT CantOpHumano FROM EstadoCuenta WHERE IdCuentaAhorros = @IdCuentaAhorros)

	SET @diferenciaRetirosHumano =  (@ContRetiroHumano - @NumRetirosHumano)

	SET @diferenciaRetirosATM = (@ContRetiroAtm- @NumRetirosAutomatico)

	UPDATE EstadoCuenta 
	SET SaldoInicial = @Saldo
	WHERE Id= @IdEstadoCuenta
	 

	IF @TasaInteres =10

		SET @Suma = @Saldo * 0.1
		SET @SaldoFinal = (@Saldo + @Suma)

	IF @TasaInteres = 15

		SET @Suma = @Saldo * 0.15
		SET @SaldoFinal = @Saldo + @Suma

	IF  @TasaInteres = 20
		SET @Suma = @Saldo * 0.2
		SET @SaldoFinal = @Saldo + @Suma




	IF @Saldo<=@SaldoMin 
		SET @SaldoFinal = @Saldo - @MultaSaldoMin


	IF (@diferenciaRetirosHumano >0)

		SET @SaldoFinal = @Saldo - (@diferenciaRetirosHumano * @ComisionRetiroHumano)

	IF (@diferenciaRetirosATM >0)

		SET @SaldoFinal = @Saldo - (@diferenciaRetirosATM * @ComisionRetiroAutomatico)



	SET @SaldoFinal = @Saldo - @CargoMensual

	SET @fechaInicial2= (SELECT(DATEADD(month,1,@fechaInicial)))


	UPDATE EstadoCuenta
	SET SaldoFinal=@SaldoFinal, FechaFinal= @fechaFinal2
	WHERE Id=@IdEstadoCuenta

	SET @cont2+=1

	END;


	WHILE @contE<25
		BEGIN


		SET @IdCuentaAhorrosE = (SELECT Id FROM CuentaAhorros WHERE Id= @contE)
		-- SET IDCUENTA AHORRO DE LA TABLA ESTADO DE CUENTA 
		SET @IdEstadoCuentaE = (SELECT Id FROM EstadoCuenta WHERE Id=@IdCuentaAhorrosE)

		SET @IdTipoCuentaAhorroE =(SELECT IdTipoCuenta FROM cuentaAhorros WHERE Id=@IdCuentaAhorrosE)
		-- SET INTERES
		SET @TasaInteresE = (SELECT TasaInteres FROM TiposCuentaAhorros WHERE  Id= @IdTipoCuentaAhorroE)
		-- SET DE MULTAS
		SET @SaldoMinE = (SELECT SaldoMin FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorroE)




		SET @MultaSaldoMinE = (SELECT MultaSaldoMin FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorroE)



		SET @SaldoE = (SELECT Saldo FROM cuentaAhorros WHERE Id = @IdCuentaAhorrosE )
		--CARGO MENSUAL 

		SET @CargoMensualE = (SELECT CargoMensual FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorroE)
		-- SET NUMEROS DE RETIROS DE LA TABLA TIPOS CUENTA AHORROS 

		SET @NumRetirosHumanoE = (SELECT NumRetirosHumano FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorroE)

		SET @NumRetirosAutomaticoE=  (SELECT NumRetirosAutomatico FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorroE)

		-- SET DE COMISIONES DE LA TABLA TIPOS CUENTA AHORROS
		SET @ComisionRetiroHumanoE = (SELECT ComisionHumano FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorroE)

		SET @ComisionRetiroAutomaticoE=  (SELECT ComisionCajero FROM dbo.TiposCuentaAhorros WHERE Id= @IdTipoCuentaAhorroE)

	
		--SET RETIROS DE CAJERO DE LA TABLA ESTADO DE CUENTA 
		SET @ContRetiroAtmE = (SELECT CantOpATM FROM EstadoCuenta WHERE IdCuentaAhorros = @IdCuentaAhorrosE)
		SET @ContRetiroHumanoE = (SELECT CantOpHumano FROM EstadoCuenta WHERE IdCuentaAhorros = @IdCuentaAhorrosE)

		SET @diferenciaRetirosHumanoE =  (@ContRetiroHumanoE - @NumRetirosHumanoE)

		SET @diferenciaRetirosATME = (@ContRetiroAtmE- @NumRetirosAutomaticoE)

		UPDATE EstadoCuenta 
		SET SaldoInicial = @SaldoE
		WHERE Id= @IdEstadoCuentaE
	 

		IF @TasaInteresE =10

			SET @SumaE = @SaldoE * 0.1
			SET @SaldoFinalE = (@SaldoE + @Suma)

		IF @TasaInteresE = 15

			SET @SumaE = @SaldoE * 0.15
			SET @SaldoFinalE = @SaldoE + @SumaE

		IF  @TasaInteresE = 20
			SET @SumaE = @SaldoE * 0.2
			SET @SaldoFinalE = @SaldoE + @SumaE




		IF @SaldoE<=@SaldoMinE
			SET @SaldoFinalE = @SaldoE - @MultaSaldoMinE


		IF (@diferenciaRetirosHumanoE >0)

			SET @SaldoFinalE = @SaldoE - (@diferenciaRetirosHumanoE * @ComisionRetiroHumanoE)

		IF (@diferenciaRetirosATME >0)

			SET @SaldoFinalE = @SaldoE - (@diferenciaRetirosATME * @ComisionRetiroAutomaticoE)



		SET @SaldoFinalE = @SaldoE - @CargoMensualE


		UPDATE EstadoCuenta
		SET SaldoFinal=@SaldoFinalE
		WHERE Id=@IdEstadoCuentaE
	SET @contE+=1

	END;
	Declare @diaFin INT, @diaIni INT;
	SET @cantCO = (SELECT count(Id) from CuentaObjetivo  );
	WHILE @idCuentaO<=@cantCO
	BEGIN

		SET @FechaFin= (SELECT FechaFinal FROM CuentaObjetivo WHERE Id=@idCuentaO)

		SET @FechaIni= (SELECT FechaInicio FROM CuentaObjetivo WHERE Id=@idCuentaO)

		SET @IdTasa2= ABS(DATEDIFF(MONTH,@FechaFin,@FechaIni))

		UPDATE CuentaObjetivo
		SET IdTasa=@IdTasa2
		WHERE Id=@idCuentaO

	SET @idCuentaO= @idCuentaO +1
	END;


	 
	 --intereses CO
	DECLARE @contCO INT = 1, @CantCuentasCO INT, @fechaInicioCO date, @fechaFinalCO date, @numMeses int, @saldoCO INT, 
	@IdTasaCO INT, @IdTasa INT, @tasa INT, @añoinicio DATE, @mes INT, @diaahorro INT, @fechaAhorro date, @diafechainicio INT; 
	DECLARE @IDCO int, @IdCuentaIntereses int, @MontoIntereses int, @montoAhorrar int;
	SET @CantCuentasCO = (SELECT count(Id) from CuentaObjetivo  );

	-- tabla temporal intereses CO
	--CREATE TABLE InteresesCO (Id int identity(1,1), IDCO int, IdCuenta int, MontoIntereses int);
	
	WHILE @contCO<=@CantCuentas
	BEGIN
		-- mapeo fechas inicial
		SET @diaahorro = (SELECT (DiaAhorro) FROM CuentaObjetivo WHERE Id = @contCO )
		SET @fechaInicioCO = (SELECT (FechaInicio) FROM CuentaObjetivo WHERE Id = @contCO );
		SET @montoAhorrar =(SELECT MontoAhorrar FROM CuentaObjetivo WHERE Id = @contCO);
		
		SET @mesinicio = (SELECT MONTH(@fechaInicioCO));

		
		SET @diafechainicio = (SELECT DAY(@fechaInicioCO));
		IF @diafechainicio = @diaahorro

		
			SET @IDCO = (SELECT (Id) FROM CuentaObjetivo WHERE Id = @contCO)
			SET @IdCuentaIntereses = (SELECT (@IdCuentaAhorros) FROM CuentaObjetivo WHERE Id = @contCO)

		

			-- mapeo mes final
			SET @fechaFinalCO = (SELECT (FechaFinal) FROM CuentaObjetivo WHERE Id = @contCO );

			
			SET @mesfinal = (SELECT MONTH(@fechaFinalCO));

			-- resta
			SET @numMeses = ABS((@mesfinal - @mesinicio));

			-- mapeo saldo y tasa intereses
			SET @saldoCO = (SELECT (Saldo) FROM CuentaObjetivo WHERE Id = @contCO );
			SET @IdTasaCO = (SELECT IdTasa FROM CuentaObjetivo WHERE Id = @contCO);


			SET @IdTasa = (SELECT Id FROM TasasInteresesCO WHERE Id = @IdTasaCO); --mes
			SET @tasa = (SELECT Tasa FROM TasasInteresesCO WHERE Id = @IdTasaCO);
			


			SET @division = (@tasa / 100)

			SET @division= @division/12.0


			SET @multiplicacion = (@montoAhorrar * @division);

			SET @montoFinal= @montoAhorrar+@multiplicacion



			DECLARE @descripCO varchar(64);
			SET @descripCO = (SELECT Descripcion FROM CuentaObjetivo WHERE Id = @contCO );
			-- monto acumulado va en tabla CO en columna interes acumulado, este insert iria abajo 
			--INSERT INTO InteresesCO (IDCO, IdCuenta,MontoIntereses) VALUES (@IDCO, @IdCuentaIntereses,@tasa, @descripCO)

		

		INSERT INTO MovInteresesCO (Fecha,Monto,IdCuentaObjetivo,NuevoInteresAcumulado,Descripcion) VALUES
		(@FechaInicioCO,@montoFinal,@IDCO,@tasa,@descripCO)

		
		SET @idca = (SELECT IdCuentaAhorros FROM CuentaObjetivo WHERE Id = @contCO)
		SET @saldoCA = (SELECT Saldo FROM CuentaAhorros WHERE Id = @idca)
		SET @saldo1CO = (SELECT Saldo FROM CuentaObjetivo WHERE Id = @contCO)
		
		UPDATE CuentaObjetivo 
		SET Saldo = Saldo + @saldoCA
		WHERE Id = @contCO
		UPDATE CuentaAhorros 
		SET Saldo = 0
		WHERE Id = @idca
		-- contador del while 
		SET @contCO+=1
	END;

	SET @fechaInicial = (SELECT(DATEADD(DAY,1,@fechaInicial)))
END;
--DELETE FROM Personas WHERE Id >42
--DELETE FROM TipoCambio WHERE Id >121

