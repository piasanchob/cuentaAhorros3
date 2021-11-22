CREATE PROCEDURE AgregarBenXML
@InParentezco VARCHAR(64),
@InPorcentaje INT, 
@InIdent VARCHAR(64),
@InCuenta VARCHAR(64),
@OutCodeResult INT

AS
	BEGIN
		SET NOCOUNT ON
		BEGIN TRY

		DECLARE @P INT;
		DECLARE @Var INT;
		Declare @IdNumCuenta INT,
		@xmldespues xml,
		@idusuario int,
		@ip varchar(64)
			

		IF (@InParentezco='Padre')
			SET @P=1;
		IF (@InParentezco='Madre')
			SET @P=2;
		IF (@InParentezco='Hijo')
			SET @P=3;
		IF (@InParentezco='Hija')
			SET @P=4;
		IF (@InParentezco='Hermano')
			SET @P=5;
		IF (@InParentezco='Hermana')
			SET @P=6;
		IF (@InParentezco='Amigo')
			SET @P=7;
		IF (@InParentezco='Amiga')
			SET @P=8;

		SET @Var = (SELECT Id FROM Personas WHERE ValorDocIdentidad=@InIdent)


		SET @IdNumCuenta = (SELECT IdNumCuenta FROM Beneficiarios WHERE id=@Var)
		SET @idusuario = (SELECT IdUsuario FROM CuentaAhorros WHERE NumCuenta = @InCuenta);

		INSERT INTO dbo.Beneficiarios (IdParentesco,Porcentaje,IdPersona,IdNumCuenta)
		VALUES (@P,@InPorcentaje,@Var,@IdNumCuenta);

		SET @ip = (SELECT LOCAL_NET_ADDRESS AS [IP Address Of SQL Server] FROM SYS.DM_EXEC_CONNECTIONS 
		WHERE SESSION_ID = @@SPID)
		SET @xmldespues = (SELECT * FROM Beneficiarios WHERE IdNumCuenta = @IdNumCuenta FOR XML AUTO);

		INSERT INTO Evento(IdTipoEvento, XMLantes,XMLdespues,IdUsuario,Fecha,IPadress)
		VALUES (1,NULL,@xmldespues,@idusuario,GETDATE(),@ip)
		SELECT * FROM Evento


		COMMIT TRANSACTION T1
	END TRY
	BEGIN CATCH
	if @@TRANCOUNT>0
			ROLLBACK TRANSACTION T1;
			SET @OutCodeResult = 50005;
	END CATCH
	SET NOCOUNT OFF

END

SELECT * FROM EVENTO 


DROP PROCEDURE AgregarBenXML

EXEC  AgregarBenXML 11000001, 5