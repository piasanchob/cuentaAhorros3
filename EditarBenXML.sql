CREATE PROCEDURE EditarBENXML
@InPorcentaje INT, @InParentesco VARCHAR(64),
@InCedula VARCHAR(64), 
@OutCodeResult INT

AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		DECLARE @P INT
		DECLARE @Var INT,
		@IdCuentaAhorros INT,
		@xmlantes xml,
		@xmldespues xml,
		@idusuario int,
		@ip varchar(64), 
		@idpersona int,
		@idpersonaBEN int;
			
		
		BEGIN TRANSACTION T1
			SET @idpersona = (SELECT Id FROM Personas WHERE ValorDocIdentidad = @InCedula);
			SET @idpersonaBEN = (SELECT IdPersona FROM Beneficiarios WHERE IdPersona = @idpersona);
			SET @IdCuentaAhorros = (SELECT Id FROM CuentaAhorros WHERE IdPersona = @idpersona);
			SET @idusuario = (SELECT IdUsuario FROM CuentaAhorros WHERE IdPersona = @idpersona);

			SET @xmlantes = (SELECT * FROM Beneficiarios WHERE IdPersona = @idpersonaBEN FOR XML AUTO)
			INSERT INTO Evento(IdTipoEvento, XMLantes,XMLdespues,IdUsuario,Fecha,IPadress)
			VALUES (2,@xmlantes,NULL,@idusuario,GETDATE(),@ip)
			SELECT * FROM Evento

		IF (@InParentesco='Padre')
			SET @P=1;
		IF (@InParentesco='Madre')
			SET @P=2;
		IF (@InParentesco='Hijo')
			SET @P=3;
		IF (@InParentesco='Hija')
			SET @P=4;
		IF (@InParentesco='Hermano')
			SET @P=5;
		IF (@InParentesco='Hermana')
			SET @P=6;
		IF (@InParentesco='Amigo')
			SET @P=7;
		IF (@InParentesco='Amiga')
			SET @P=8;
		SET @Var = (SELECT Id FROM Personas WHERE ValorDocIdentidad=@InCedula)

		UPDATE dbo.Beneficiarios
		SET IdParentesco=@P,Porcentaje=@InPorcentaje WHERE IdPersona = @Var;

		
		SET @xmldespues = (SELECT * FROM Beneficiarios WHERE IdPersona = @idpersonaBEN FOR XML AUTO)
		UPDATE Evento
		SET XMLdespues = @xmldespues
		WHERE IdTipoEvento = 2

		COMMIT TRANSACTION T1
	END TRY
	BEGIN CATCH
	if @@TRANCOUNT>0
			ROLLBACK TRANSACTION T1;
			SET @OutCodeResult = 50005;
	END CATCH
	SET NOCOUNT OFF
END
DROP PROCEDURE EditarBENXML
SELECT * FROM Evento