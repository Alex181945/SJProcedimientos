/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 05/03/2018
 * Descripcion: Procedimiento que actualiza el registro
 * de un usuario
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alejandro Estrada 09/09/2017 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Para pruebas*/
/*USE SENADO;*/

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE actualizaUsuario(	IN cUsuario  VARCHAR(20),
 									IN cContrasena VARCHAR(30),
 									IN cNombre     VARCHAR(150),
 									IN cPaterno    VARCHAR(150),
 									IN cMaterno    VARCHAR(150),
 									IN cPuesto     VARCHAR(100),
 									IN cExtension  VARCHAR(50),
 									IN cCorreo     VARCHAR(100),
 									IN lHonorarios TINYINT(1),
 									IN iPerfil     INT(11),
 									IN lActivo     TINYINT(1),
 									IN cUsuarioR   VARCHAR(50),
 									OUT lError TINYINT(1), 
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))
 	actualizaUsuario:BEGIN

		/*Manejo de Errores*/ 
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1
  			@e1 = RETURNED_SQLSTATE, @e2 = MESSAGE_TEXT;
			SET lError    = 1;
			SET cSqlState = CONCAT("SqlState: ", @e1);
			SET cError    = CONCAT("Exepcion: ", @e2);
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

			/*Procedimiento*/

			/*Variables para control de errores inicializadas*/
			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";
			
			/*Se valida que el usuarioR exista y este activo*/
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuarioR
													AND ctUsuario.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE actualizaUsuario;

			END IF;

			/*Valida que el usuario exista*/
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario)

				THEN 
					SET lError = 1; 
					SET cError = "Usuario no existe";
					LEAVE actualizaUsuario;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/
			IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El usuario no contiene valor";
					LEAVE actualizaUsuario;

			END IF;

			IF cContrasena = "" OR cContrasena = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "La contraseña no contiene valor";
					LEAVE actualizaUsuario;

			END IF;

			IF cNombre = "" OR cNombre = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El nombre del usuario no contiene valor";
					LEAVE actualizaUsuario;
					

			END IF;

			IF cPaterno = "" OR cPaterno = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El apellido paterno del usuario no contiene valor";
					LEAVE actualizaUsuario;

			END IF;

			IF cCorreo = "" OR cCorreo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El correo del usuario no contiene valor";
					LEAVE actualizaUsuario;

			END IF;

			IF lHonorarios = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "No se indico el tipo de contrato del usuario";
					LEAVE actualizaUsuario;

			END IF;

			IF iPerfil = 0 OR iPerfil = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "No se indico un perfil para el usuario";
					LEAVE actualizaUsuario;

			END IF;

			/*Validacion de las claves foraneas*/
			IF NOT EXISTS(SELECT * FROM ctPerfil WHERE ctPerfil.iPerfil  = iPerfil
												AND ctPerfil.lActivo = 1 )

			THEN
				SET lError = 1; 
				SET cError = "El perfil seleccionado no existe o no esta activo";
				LEAVE actualizaUsuario;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE ctUsuario
				SET ctUsuario.cUsuario     = cUsuario,
					ctUsuario.cContrasena  = cContrasena,
					ctUsuario.cNombre      = cNombre,
					ctUsuario.cPaterno     = cPaterno,
					ctUsuario.cMaterno     = cMaterno,
					ctUsuario.cPuesto      = cPuesto,
					ctUsuario.cExtension   = cExtension,
					ctUsuario.cCorreo      = cCorreo,
					ctUsuario.lHonorarios  = lHonorarios,
					ctUsuario.iPerfil      = iPerfil,
					ctUsuario.lActivo      = lActivo,
					ctUsuario.dtModificado = NOW(),
					ctUsuario.cUsuarioR    = cUsuarioR
				WHERE ctUsuario.cUsuario   = cUsuario;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;