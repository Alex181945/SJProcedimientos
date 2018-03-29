/**
 * 
 * Autor: Alberto Robles
 * Fecha: 28/03/2018
 * Descripcion: Procedimiento que inserta usuarios
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alberto Robles 28/03/2018 In-15 Fn-19 
 * 
 * Notas: 0 es igual a falso, 1 es igual a verdadero
 */
 
 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaPeriodo(	IN iIDPeriodo     INTEGER(11),
 									OUT lError     TINYINT(1), 
 									OUT cSqlState  VARCHAR(50), 
 									OUT cError     VARCHAR(200)
 								)

 	/*Nombre del Procedimiento*/
 	consultaPeriodo:BEGIN

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

			/*Procedimiento*/

			/*Variables para control de errores inicializadas*/
			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";

			 /*Crea una tabla temporal con la estructura de la tabla
 			 *especificada despues del LIKE
 			 */
 			DROP TEMPORARY TABLE IF EXISTS tt_ctPeriodo;
 
 			CREATE TEMPORARY TABLE tt_ctPeriodo LIKE ctPeriodo;

			/*Comprueba si existe el Periodo*/
			IF NOT EXISTS(SELECT * FROM ctPeriodo WHERE ctPeriodo.iIDPeriodo = iIDPeriodo)

			/*Si existe copia toda la informacion del Periodo a la tabla temporal*/
 				THEN INSERT INTO tt_ctPeriodo SELECT * FROM ctPeriodo WHERE ctPeriodo.iIDPeriodo = iIDPeriodo;
 
 				/*Si no manda error de que no lo encontro*/
 				ELSE 
 					SET lError = 1; 
					SET cError = "El Periodo  no existe";
					LEAVE consultaPeriodo;

			END IF;

 			/*Valida que el Periodo no este activo*/
 			IF NOT EXISTS(SELECT * FROM ctPeriodo WHERE ctPeriodo.lActivo  = 1)
 
 				THEN 
 					SET lError = 1; 
 					SET cError = "El Periodo no activo";
 					LEAVE consultaPeriodo;

 			END IF;

			SELECT * FROM tt_ctPeriodo;
			
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;