/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 13/02/2018
 * Descripcion: Procedimiento que inserta usuarios
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alejandro Estrada 09/09/2017 In-15 Fn-19 
 * 
 * Notas: 0 es igual a falso, 1 es igual a verdadero
 */
 
 /*Para pruebas*/
/*USE SENADO;*/

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE insertaUsuario(	IN cUsuario    VARCHAR(50),
 									IN cContrasena VARCHAR(30),
 									IN cNombre     VARCHAR(150),
 									IN cPaterno    VARCHAR(150),
 									IN cMaterno    VARCHAR(150),
 									IN cPuesto     VARCHAR(100),
 									IN cExtension  VARCHAR(50),
 									IN cCorreo     VARCHAR(100),
 									IN lHonorarios TINYINT(1),
 									IN iPerfil     INT(11),
 									IN cUsuarioR   VARCHAR(50),
 									OUT lError     TINYINT(1), 
 									OUT cSqlState  VARCHAR(50), 
 									OUT cError     VARCHAR(200)
 								)

 	/*Nombre del Procedimiento*/
 	insertaUsuario:BEGIN

		/*Manejo de Errores*/ 
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1
  			@e1 = RETURNED_SQLSTATE, @e2 = MESSAGE_TEXT;
			SET lError    = 1;
			SET cSqlState = CONCAT("SqlState: ", @e1);
			SET cError    = CONCAT("Exepxcion: ", @e2);
			ROLLBACK;
		END; 

		/*Manejo de Advertencias*/ 
		DECLARE EXIT HANDLER FOR SQLWARNING
		BEGIN
			GET DIAGNOSTICS CONDITION 1
  			@w1 = RETURNED_SQLSTATE, @w2 = MESSAGE_TEXT;
			SET lError    = 1;
			SET cSqlState = CONCAT("SqlState: ", @w1);
			SET cError    = CONCAT("Advertencia: ", @w2);
			ROLLBACK;
		END;	 
		
		START TRANSACTION;

			/*Variables para control de errores inicializadas*/
			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";

			/*Valida el usuario que crea el registro*/
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuarioR
													AND ctUsuario.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE insertaUsuario;

			END IF;

			/*Verifica que el usuario a crear no exista con anterioridad*/
			IF EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario)

				THEN 
					SET lError = 1; 
					SET cError = "El usuario ya existe";
					LEAVE insertaUsuario;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/
			IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El usuario no contiene valor";
					LEAVE insertaUsuario;

			END IF;

			IF cContrasena = "" OR cContrasena = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "La contraseña no contiene valor";
					LEAVE insertaUsuario;

			END IF;

			IF cNombre = "" OR cNombre = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El nombre del usuario no contiene valor";
					LEAVE insertaUsuario;
					

			END IF;

			IF cPaterno = "" OR cPaterno = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El apellido paterno del usuario no contiene valor";
					LEAVE insertaUsuario;

			END IF;

			IF cCorreo = "" OR cCorreo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El correo del usuario no contiene valor";
					LEAVE insertaUsuario;

			END IF;

			IF lHonorarios = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "No se indico el tipo de contrato del usuario";
					LEAVE insertaUsuario;

			END IF;

			IF iPerfil = 0 OR iPerfil = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "No se indico un perfil para el usuario";
					LEAVE insertaUsuario;

			END IF;

			/*Validacion de las claves foraneas*/
			IF NOT EXISTS(SELECT * FROM ctPerfil WHERE ctPerfil.iPerfil  = iPerfil
												AND ctPerfil.lActivo = 1 )

			THEN
				SET lError = 1; 
				SET cError = "El perfil seleccionado no existe o no esta activo";
				LEAVE insertaUsuario;

			END IF;

			/*Insercion del usuario*/
			INSERT INTO ctUsuario (	ctUsuario.cUsuario, 
									ctUsuario.cContrasena, 
									ctUsuario.cNombre, 
									ctUsuario.cPaterno, 
									ctUsuario.cMaterno, 
									ctUsuario.cPuesto, 
									ctUsuario.cExtension, 
									ctUsuario.cCorreo, 
									ctUsuario.lHonorarios, 
									ctUsuario.iPerfil, 
									ctUsuario.lActivo, 
									ctUsuario.dtCreado, 
									ctUsuario.cUsuarioR) 
						VALUES	(	cUsuario,
									cContrasena,
									cNombre,
									cPaterno,
									cMaterno,
									cPuesto,
									cExtension,
									cCorreo,
									lHonorarios,
									iPerfil,
									1,
									NOW(),
									cUsuarioR);

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;