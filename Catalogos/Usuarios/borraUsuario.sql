/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 05/03/2018
 * Descripcion: Procedimiento que borra el registro
 * de un usuario
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alejandro Estrada 09/09/2017 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * Nota: Este procedimiento no borra registros unicamente los
 * inhabilita
 */

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE borraUsuario(	IN cUsuario  VARCHAR(20),
 								IN cUsuarioR VARCHAR(20),
 								OUT lError TINYINT(1), 
 								OUT cSqlState VARCHAR(50), 
 								OUT cError VARCHAR(200))
 	borraUsuario:BEGIN

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
					LEAVE borraUsuario;

			END IF;

			/*Valida que el usuario exista*/
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario)

				THEN 
					SET lError = 1; 
					SET cError = "Usuario no existe";
					LEAVE borraUsuario;

			END IF;

			/*Valida que el usuario no este activo*/
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario 
													AND ctUsuario.lActivo  = 1)

				THEN 
					SET lError = 1; 
					SET cError = "Usuario ya fue borrado con anterioridad";
					LEAVE borraUsuario;

			END IF;

			/*Realiza el borrado logico que es una llamada al procedimiento actualizaUsuario*/
			CALL actualizaUsuario();

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;