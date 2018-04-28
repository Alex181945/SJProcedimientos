/**
 * 
 * Autor: Jennifer Hernández
 * Fecha: 28/04/2018
 * Descripcion: Procedimiento que consulta todos las criticidades
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alejandro Estrada 09/09/2017 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero solo aplica para los campos logicos
 * Nota: 0 es para inactivos, 1 para activos, 2 para ambos
 * 
 */

 /*Para pruebas*/
/*USE SENADO;*/

  /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaCriticidades  (	IN iTipoConsulta INT(3),
											OUT lError       TINYINT(1), 
											OUT cSqlState    VARCHAR(50), 
											OUT cError       VARCHAR(200))
 	consultaCriticidades:BEGIN

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
			DROP TEMPORARY TABLE IF EXISTS tt_ctCriticidad;

			CREATE TEMPORARY TABLE tt_ctCriticidad LIKE ctCriticidad;

			/*Casos para el tipo de consulta*/
			CASE iTipoConsulta

			    WHEN 0 THEN INSERT INTO tt_ctCriticidad SELECT * FROM ctCriticidad WHERE ctCriticidad.lActivo = 0;
			    WHEN 1 THEN INSERT INTO tt_ctCriticidad SELECT * FROM ctCriticidad WHERE ctCriticidad.lActivo = 1;
			    WHEN 2 THEN INSERT INTO tt_ctCriticidad SELECT * FROM ctCriticidad;

			END CASE;

			/*Resultado de las consultas anteriores*/
			SELECT * FROM tt_ctCriticidad;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;