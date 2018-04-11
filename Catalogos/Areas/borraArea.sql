/**
 * 
 * Autor: Bogar Chavez
 * Fecha: 13/03/2018
 * Descripcion: Procedimiento que borra el registro
 * de un usuario
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 *
 *
 * Nota: 0 es falso, 1 es verdadero
 * Nota: Este procedimiento no borra areas unicamente los
 * inhabilita
 */

 /*Para pruebas*/
 /*USE SENADO;*/

 /*Delimitador de bloque*/
 DELIMITER //
CREATE PROCEDURE borraArea( IN iIDArea    INTEGER(11),
	 						IN cUsuario   VARCHAR(20),
 							OUT lError    TINYINT(1), 
 							OUT cSqlState VARCHAR(50), 
 							OUT cError    VARCHAR(200))	 
	borraArea:BEGIN

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

			/*Valida que el usuario exista*/
			IF NOT EXISTS(SELECT * FROM ctAreas WHERE ctAreas.iIDArea = iIDArea)

				THEN 
					SET lError = 1; 
					SET cError = "Area no existe";
					LEAVE borraArea;

			END IF;

			/*Valida que el usuario no este activo*/
			IF NOT EXISTS(SELECT * FROM ctAreas WHERE ctAreas.iIDArea = iIDArea 
												AND ctAreas.lActivo  = 1)

				THEN 
					SET lError = 1; 
					SET cError = "Área ya fue borrado con anterioridad";
					LEAVE borraArea;

			END IF;

			/*Realiza el borrado logico solo se actualiza el campo lActivo*/
			UPDATE ctAreas SET
				ctAreas.lActivo       = 0,
				ctAreas.dtModificado  = NOW(),
				ctAreas.cUsuario      = cUsuario 
			WHERE ctAreas.iIDArea = iIDArea;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;