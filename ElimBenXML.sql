CREATE PROCEDURE ElimBenXML
@InCedula VARCHAR(64),
@OutCodeResult INT
AS
	
	BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	DECLARE @Var VARCHAR(64);
	DECLARE @IdPersona INT,
	@IdCuentaAhorros INT,
	@idusuario INT,
	@xmlantes XML,
	@ip varchar(64)

	SET @IdPersona= (SELECT Id FROM Personas WHERE ValorDocIdentidad = @InCedula)
	
	UPDATE Beneficiarios
	SET Activo = 0
	WHERE IdPersona=@IdPersona;

	SET @xmlantes = (SELECT * FROM Beneficiarios WHERE IdPersona = @IdPersona FOR XML AUTO)
	SET @ip = (SELECT LOCAL_NET_ADDRESS AS [IP Address Of SQL Server] FROM SYS.DM_EXEC_CONNECTIONS 
	WHERE SESSION_ID = @@SPID)
	INSERT INTO Evento(IdTipoEvento, XMLantes,XMLdespues,IdUsuario,Fecha,IPadress)
	VALUES (3,@xmlantes,NULL,@idusuario,GETDATE(),@ip)
	SELECT * FROM Evento
	COMMIT TRANSACTION T1
	END TRY
	BEGIN CATCH
	if @@TRANCOUNT>0
			ROLLBACK TRANSACTION T1;
			SET @OutCodeResult = 50005;
	END CATCH
	SET NOCOUNT OFF
		
END;
DROP PROCEDURE ElimBenXML
SELECT * FROM Evento