USE SENADO;
DROP PROCEDURE IF EXISTS `consultaServicios`;

  /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaServicios(IN iTipoConsulta INT(3), 						
 									OUT lError       TINYINT(1), 
 									OUT cSqlState    VARCHAR(50), 
 									OUT cError       VARCHAR(200))
 	consultaServicios:BEGIN

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
			DROP TEMPORARY TABLE IF EXISTS tt_ctServicioSolicitado;

			CREATE TEMPORARY TABLE tt_ctServicioSolicitado LIKE ctServicioSolicitado;

			/*Casos para el tipo de consulta*/
			CASE iTipoConsulta

			    WHEN 0 THEN INSERT INTO tt_ctServicioSolicitado SELECT * FROM ctServicioSolicitado WHERE ctServicioSolicitado.lActivo = 0;
			    WHEN 1 THEN INSERT INTO tt_ctServicioSolicitado SELECT * FROM ctServicioSolicitado WHERE ctServicioSolicitado.lActivo = 1;
			    WHEN 2 THEN INSERT INTO tt_ctServicioSolicitado SELECT * FROM ctServicioSolicitado;

			END CASE;
			/*Resultado de las consultas anteriores*/
			SELECT * FROM tt_ctServicioSolicitado;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;