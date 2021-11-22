CREATE PROCEDURE AgregarCuentaObjetivoXML


	@InNumCuenta INT,
	@InFechaInicio DATE,
	@InFechaFinal DATE,
	@InCuota INT,
	@InObjetivo INT,
	@InSaldo INT,
	@InInteresAcumulado INT,
	@InDescripcion VARCHAR(64),
	@InActivo BIT,
	@InDiaAhorro INT,
	@InMontoAhorrar INT,
	@InNumCuentaO INT,
	@OutCodeResult INT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		DECLARE 
			@IdNumCuenta INT,
			@IdCuentaAhorros INT,
			@xmldespues xml,
			@idusuario int,
			@ip varchar(64)
			
		
		BEGIN TRANSACTION T1
		
			
			SET @IdNumCuenta = (SELECT Id FROM CuentaAhorros WHERE NumCuenta = @InNumCuenta);

			
			SET @idusuario = (SELECT IdUsuario FROM CuentaAhorros WHERE NumCuenta = @InNumCuenta);
			INSERT INTO dbo.CuentaObjetivo(IdCuentaAhorros,
			IdTasa,
			FechaInicio,
			FechaFinal,
			Cuota,
			Objetivo,
			Saldo,
			InteresAcumulado,
			Descripcion,
			DiaAhorro,
			MontoAhorrar,
			NumCuentaObjetivo,
			Activo)
			

			VALUES(
			@IdNumCuenta,
			NULL,
			@InFechaInicio,
			@InFechaFinal,
			@InCuota,
			@InObjetivo,
			@InSaldo,
			@InInteresAcumulado,
			@InDescripcion,
			@InDiaAhorro,
			@InMontoAhorrar,
			@InNumCuentaO,
			@InActivo)
			SET @ip = (SELECT LOCAL_NET_ADDRESS AS [IP Address Of SQL Server] FROM SYS.DM_EXEC_CONNECTIONS 
			WHERE SESSION_ID = @@SPID)
			SET @xmldespues = (SELECT * FROM CuentaObjetivo WHERE IdCuentaAhorros = @IdNumCuenta FOR XML AUTO);

			INSERT INTO Evento(IdTipoEvento, XMLantes,XMLdespues,IdUsuario,Fecha,IPadress)
			VALUES (4,NULL,@xmldespues,@idusuario,GETDATE(),@ip)
			 SELECT * FROM Evento

		COMMIT TRANSACTION T1
	END TRY
	BEGIN CATCH
	IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION T1;
			SET @OutCodeResult = 50005;
	END CATCH
	SET NOCOUNT OFF
END
DROP PROCEDURE AgregarCuentaObjetivoXML

SELECT * FROM EVENTO 

