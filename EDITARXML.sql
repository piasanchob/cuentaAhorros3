CREATE PROCEDURE EditarCOXML
	@InNumCuenta INT,
	@InFechaInicio DATE,
	@InFechaFinal DATE,
	@InCuota INT,
	@InObjetivo INT,
	@InDescripcion VARCHAR(64),
	@OutCodeResult INT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		DECLARE 
			@IdCuentaAhorros INT,
			@xmlantes xml,
			@xmldespues xml,
			@idusuario int,
			@ip varchar(64)
			
		
		BEGIN TRANSACTION T1

			SET @IdCuentaAhorros = (SELECT Id FROM CuentaAhorros WHERE NumCuenta = @InNumCuenta);
			SET @idusuario = (SELECT IdUsuario FROM CuentaAhorros WHERE NumCuenta = @InNumCuenta);

			SET @xmlantes = (SELECT * FROM CuentaObjetivo WHERE IdCuentaAhorros = @IdCuentaAhorros FOR XML AUTO)

			SET @ip = (SELECT LOCAL_NET_ADDRESS AS [IP Address Of SQL Server] FROM SYS.DM_EXEC_CONNECTIONS 
			WHERE SESSION_ID = @@SPID)

			INSERT INTO Evento(IdTipoEvento, XMLantes,XMLdespues,IdUsuario,Fecha,IPadress)
			VALUES (5,@xmlantes,NULL,@idusuario,GETDATE(),@ip)
			SELECT * FROM Evento

			UPDATE CuentaObjetivo

			SET FechaInicio=@InFechaInicio,
			 FechaFinal=@InFechaFinal,
			 Cuota=@InCuota ,
			 Objetivo =@InObjetivo ,
			 Descripcion= @InDescripcion
			

			WHERE IdCuentaAhorros = @IdCuentaAhorros;
			SET @xmldespues = (SELECT * FROM CuentaObjetivo WHERE IdCuentaAhorros = @IdCuentaAhorros FOR XML AUTO)
			UPDATE Evento
			SET XMLdespues = @xmldespues
			WHERE IdTipoEvento = 5

		COMMIT TRANSACTION T1
	END TRY
	BEGIN CATCH
	IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION T1;
			SET @OutCodeResult = 50005;
	END CATCH
	SET NOCOUNT OFF
END


SELECT * FROM EVENTO 


DROP PROCEDURE ElminarCOXML

EXEC  EditarCOXML 11000001, '2021-08-20','2022-01-18', 5,'VACACIONES', 'Descrip', 5
