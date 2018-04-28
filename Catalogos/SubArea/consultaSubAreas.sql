/**
 * 
 * Autor: Jennifer Hernandez
 * Fecha: 28/04/2018
 * Descripcion: Procedimiento que consulta las SubAreas
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alejandro Estrada 09/09/2017 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Para pruebas*/
/*USE cau;*/

  /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaSubAreas(	IN iTipoConsulta INT(3),
 									OUT lError       TINYINT(1), 
 									OUT cSqlState    VARCHAR(50), 
 									OUT cError       VARCHAR(200))
 	consultaSubAreas:BEGIN

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

			/*Crea una tabla temporal con la estructura de la tabla
			 *especificada despues del LIKE
			 */
			DROP TEMPORARY TABLE IF EXISTS tt_ctSubArea;

			CREATE TEMPORARY TABLE tt_ctSubArea LIKE ctSubArea;

			/*Casos para el tipo de consulta*/
			CASE iTipoConsulta

			    WHEN 0 THEN INSERT INTO tt_ctSubArea SELECT * FROM ctSubArea WHERE ctSubArea.lActivo = 0;
			    WHEN 1 THEN INSERT INTO tt_ctSubArea SELECT * FROM ctSubArea WHERE ctSubArea.lActivo = 1;
			    WHEN 2 THEN INSERT INTO tt_ctSubArea SELECT * FROM ctSubArea;

			END CASE;

			/*Resultado de las consultas anteriores*/
			SELECT * FROM tt_ctSubArea;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;