/**
 * 
 * Autor: Bogar Chavez
 * Fecha: 13/03/2018
 * Descripcion: Procedimiento que actualiza el registro
 * de una area
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Bogar Chavez 13/03/2018 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Para pruebas*/
 /*USE SENADO;*/

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE actualizaArea(	IN iIDArea INTEGER(11),
                                    IN  cArea VARCHAR(150),
                                    IN  lActivo TINYINT(1),
                                    IN  cUsuario VARCHAR(50),
 									OUT lError TINYINT(1),
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))
 	actualizaArea:BEGIN

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
			
			/*Verifica que el area no exista con anterioridad*/
			IF EXISTS(SELECT * FROM ctAreas WHERE ctAreas.iIDArea = iIDArea)

				THEN 
					SET lError = 1; 
					SET cError = "El área ya existe";
					LEAVE actualizaArea;

			END IF;

            IF NOT EXISTS(SELECT * FROM ctAreas WHERE ctAreas.iIDArea = iIDArea
													AND ctAreas.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El área del sistema no existe o no esta activo";
					LEAVE actualizaArea;

			END IF;


			/*Se valida que los dato no se encunetre nulos o vacios respecto a la tabla*/
			IF cArea = "" OR cArea = NULL

				THEN 
					SET lError = 1;
					SET cError = "El nombre del área no tiene valor";
					LEAVE actualizaArea;

			END IF;

			IF cUsuario = "" OR cUsuario = NULL

				THEN 
					SET lError = 1;
					SET cError = "El dato calle Usuario contiene un valor";
					LEAVE actualizaArea;
			END IF;

			/*Realiza la actualizacion*/
			UPDATE ctAreas
				SET
                    ctAreas.cArea         = cArea,
					ctAreas.lActivo       = lActivo,
					ctAreas.dtModificado  = NOW(),
                    ctAreas.cUsuario      = cUsuario
				WHERE ctAreas.iIDArea = iIDArea;
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;