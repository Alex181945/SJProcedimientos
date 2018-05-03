/**
 * 
 * Autor: Jennifer Hernandez
 * Fecha: 28/04/2018
 * Descripcion: Procedimiento que borra el Estado del Ticket
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alejandro Estrada 09/09/2017 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Para pruebas*/
USE SENADO;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE borraPerfil    (	IN iPerfil      INTEGER,
			 						IN cUsuario       VARCHAR(50),
			 						OUT lError        TINYINT(1), 
			 						OUT cSqlState     VARCHAR(50), 
			 						OUT cError        VARCHAR(200))
 	borraPerfil:BEGIN

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

			/*Valida el usuario que crea el registro*/
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario
													AND ctUsuario.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE borraPerfil;

			END IF;

			IF NOT EXISTS(SELECT * FROM ctPerfil WHERE ctPerfil.iPerfil = iPerfil)

				THEN 
					SET lError = 1; 
					SET cError = "Perfil no existe";
					LEAVE borraPerfil;

			END IF;
			
			/*Valida que el usuario no este activo*/
			IF NOT EXISTS(SELECT * FROM ctPerfil WHERE ctPerfil.iPerfil = iPerfil 
												AND ctPerfil.lActivo  = 1)

				THEN 
					SET lError = 1; 
					SET cError = "Perfil ya fue borrado con anterioridad";
					LEAVE borraPerfil;

			END IF;
						
			/*Realiza el borrado logico solo se actualiza el campo lActivo*/
			UPDATE ctPerfil 
							SET ctPerfil.lActivo        = 0,
						    ctPerfil.dtModificado   = NOW(),
                			ctPerfil.cUsuario       = cUsuario
            WHERE ctPerfil.iPerfil = iPerfil;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;