CREATE PROCEDURE ElminarCOXML 
	@InNumCuenta INT,
	@OutCodeResult INT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		DECLARE 
			@IdCuentaAhorros INT,
			@idusuario INT,
			@xmlantes XML,
			@IdCo INT ,
			@ip varchar(64),
			@Var INT

		
		BEGIN TRANSACTION T1
			
			SET @IdCuentaAhorros = (SELECT Id FROM CuentaAhorros WHERE NumCuenta = @InNumCuenta);
			SET @idusuario = (SELECT IdUsuario FROM CuentaAhorros WHERE NumCuenta = @InNumCuenta);
			SET @IdCo= (SELECT Id FROM CuentaObjetivo WHERE IdCuentaAhorros=@IdCuentaAhorros)
			
			
			
			SET @Var = (SELECT Id FROM CuentaObjetivo WHERE Id=1)
			UPDATE CuentaObjetivo 
			SET Activo=0
			WHERE Id= @IdCo;


			SET @xmlantes = (SELECT * FROM CuentaObjetivo WHERE IdCuentaAhorros = @IdCuentaAhorros FOR XML AUTO)
			SET @ip = (SELECT LOCAL_NET_ADDRESS AS [IP Address Of SQL Server] FROM SYS.DM_EXEC_CONNECTIONS 
			WHERE SESSION_ID = @@SPID)

			
			INSERT INTO Evento(IdTipoEvento, XMLantes,XMLdespues,IdUsuario,IPadress,Fecha)
			VALUES (6,@xmlantes,NULL,@idusuario,@ip,GETDATE())
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

SELECT * FROM EVENTO 


DROP PROCEDURE ElminarCOXML

EXEC  ElminarCOXML 11000001, 5


