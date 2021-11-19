USE cuentaAhorros

DELETE FROM dbo.Personas;
	DBCC CHECKIDENT ('[Personas]', RESEED, 0);
	SELECT * FROM dbo.Personas;
	DELETE FROM dbo.TipoDocsIdentidad;
	DBCC CHECKIDENT ('[TipoDocsIdentidad]', RESEED, 0);
	SELECT * FROM dbo.TipoDocsIdentidad;
	DELETE FROM dbo.CuentaAhorros;
	DBCC CHECKIDENT ('[CuentaAhorros]', RESEED, 0);
	SELECT * FROM dbo.CuentaAhorros;
	DELETE FROM dbo.TiposCuentaAhorros
	DBCC CHECKIDENT ('[TiposCuentaAhorros]', RESEED, 0);
	SELECT * FROM dbo.TiposCuentaAhorros;
	DELETE FROM dbo.TipoMonedas
	DBCC CHECKIDENT ('[TipoMonedas]', RESEED, 0);
	SELECT * FROM dbo.TipoMonedas;
	DELETE FROM dbo.Beneficiarios
	DBCC CHECKIDENT ('[Beneficiarios]', RESEED, 0);
	SELECT * FROM dbo.Beneficiarios;
	DELETE FROM dbo.Parentescos
	DBCC CHECKIDENT ('[Parentescos]', RESEED, 0);
	SELECT * FROM dbo.Parentescos;
	DELETE FROM dbo.Usuarios
	DBCC CHECKIDENT ('[Usuarios]', RESEED, 0);
	SELECT * FROM dbo.Usuarios;
	DELETE FROM dbo.UsuarioPuedeVer;
	DBCC CHECKIDENT ('[UsuarioPuedeVer]', RESEED, 0);
	SELECT * FROM dbo.UsuarioPuedeVer;
	DELETE FROM dbo.CuentaObjetivo;
	DBCC CHECKIDENT ('[CuentaObjetivo]', RESEED, 0);
	SELECT * FROM dbo.CuentaObjetivo;
	DELETE FROM dbo.Movimientos;
	DBCC CHECKIDENT ('[Movimientos]', RESEED, 0);
	SELECT * FROM dbo.Movimientos;
	DELETE FROM dbo.TipoCambio;
	DBCC CHECKIDENT ('[TipoCambio]', RESEED, 0);
	SELECT * FROM dbo.TipoCambio;
	DELETE FROM dbo.TipoMonedas;
	DBCC CHECKIDENT ('[TipoMonedas]', RESEED, 0);
	SELECT * FROM dbo.TipoMonedas;
	DELETE FROM dbo.TipoMov;
	DBCC CHECKIDENT ('[TipoMov]', RESEED, 0);
	SELECT * FROM dbo.TipoMov;
	DELETE FROM dbo.EstadoCuenta;
	DBCC CHECKIDENT ('[EstadoCuenta]', RESEED, 0);
	SELECT * FROM dbo.EstadoCuenta;
	DELETE FROM dbo.CuentaObjetivo;
	DBCC CHECKIDENT ('[CuentaObjetivo]', RESEED, 0);
	SELECT * FROM dbo.CuentaObjetivo;
	DELETE FROM dbo.Evento;
	DBCC CHECKIDENT ('[EVENTO]', RESEED, 0);
	SELECT * FROM dbo.EVENTO;
	DELETE FROM dbo.MovCuentaObjetivo;
	DBCC CHECKIDENT ('[MovCuentaObjetivo]', RESEED, 0);
	SELECT * FROM dbo.MovCuentaObjetivo;
	DELETE FROM dbo.MovInteresesCO;
	DBCC CHECKIDENT ('[MovInteresesCO]', RESEED, 0);
	SELECT * FROM dbo.MovInteresesCO;
	DELETE FROM dbo.TasasInteresesCO;
	DBCC CHECKIDENT ('[TasasInteresesCO]', RESEED, 0);
	SELECT * FROM dbo.TasasInteresesCO;
	DELETE FROM dbo.TipoEvento;
	DBCC CHECKIDENT ('[TipoEvento]', RESEED, 0);
	SELECT * FROM dbo.TipoEvento;
	DELETE FROM dbo.TipoEvento;
	DBCC CHECKIDENT ('[TipoEvento]', RESEED, 0);
	SELECT * FROM dbo.TipoEvento;