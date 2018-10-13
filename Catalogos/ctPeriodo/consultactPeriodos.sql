/**
 * 
 * Autor: Alberto Robles
 * Fecha: 27/03/2018
 * Descripcion: Procedimiento que inserta Tipo Persona
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alberto Robles 27/03/2018 In-15 Fn-19 
 * 
 * Notas: 0 es igual a falso, 1 es igual a verdadero
 */
 
 /*Delimitador de bloque*/

 USE escuelast;
 DROP PROCEDURE IF EXISTS `consultactPeriodos`;

 DELIMITER //

 CREATE PROCEDURE consultactPeriodos( 	IN iTipoConsulta INT(3),
 										IN iCarrera INT(3),
		 								OUT lError     TINYINT(1), 
		 								OUT cSqlState  VARCHAR(50), 
		 								OUT cError     VARCHAR(200))

 	/*Nombre del Procedimiento*/
 	consultactPeriodos:BEGIN

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

			/* Procedimientos */

			/*Variables para control de errores inicializadas*/
			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";
			

 			/*Crea una tabla temporal con la estructura de la tabla
 			 *especificada despues del LIKE
 			 */

			DROP TEMPORARY TABLE IF EXISTS tt_ctPeriodo;
 
 			CREATE TEMPORARY TABLE tt_ctPeriodo LIKE ctPeriodo;

 			
			/*Casos para el tipo de consulta*/
			CASE iTipoConsulta

			    WHEN 0 THEN INSERT INTO tt_ctPeriodo SELECT * FROM ctPeriodo WHERE ctPeriodo.iCarrera = iCarrera AND ctPeriodo.lActivo = 0;
			    WHEN 1 THEN INSERT INTO tt_ctPeriodo SELECT * FROM ctPeriodo WHERE ctPeriodo.iCarrera = iCarrera AND ctPeriodo.lActivo = 1;
			    WHEN 2 THEN INSERT INTO tt_ctPeriodo SELECT * FROM ctPeriodo WHERE ctPeriodo.iCarrera = iCarrera;

			END CASE;

			/*Resultado de las consultas anteriores*/
 			SELECT * FROM tt_ctPeriodo;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;