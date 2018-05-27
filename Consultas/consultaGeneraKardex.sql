/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 18/05/2018
 * Descripcion: Procedimiento que actualiza el registro
 * de un tipo de persona
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Bogar Chavez 11/03/2018 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Para pruebas*/
 USE escuelast;
 DROP PROCEDURE IF EXISTS `consultaGeneraKardex`;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaGeneraKardex(	IN iPersona   INTEGER(11) ,
 										OUT lError    TINYINT(1), 
 										OUT cSqlState VARCHAR(50), 
 										OUT cError    VARCHAR(200))
 	consultaGeneraKardex:BEGIN

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
			
			IF iPersona = 0 OR iPersona = NULL

				THEN 
					SET lError = 1;
					SET cError = "El ID de la persona no tiene valor";
					LEAVE consultaGeneraKardex;

			END IF;

			SELECT opCalificacion.*, opCalfMateria.iPartida, 
				opCalfMateria.deCalificacion, opCalfMateria.cObs 
				FROM opCalificacion INNER JOIN opCalfMateria ON opCalfMateria.iPersona = opCalificacion.iPersona AND opCalfMateria.iMateria = opCalificacion.iMateria
			WHERE opCalificacion.iPersona = iPersona;
				
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;