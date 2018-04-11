/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 02/04/2018
 * Descripcion: Procedimiento para la consulta de Programas
 * pro modulo
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo:  Bogar Chavez 13/03/2018 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */
 
 /*Para pruebas*/
 /*USE SENADO;*/

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaProgramasModulo(	IN iTipoConsulta INTEGER(3),
 											IN iIDModulo     INTEGER(11),
											OUT lError       TINYINT(1), 
											OUT cSqlState    VARCHAR(50), 
											OUT cError       VARCHAR(200))
 	consultaProgramasModulo:BEGIN

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

			/*Variables para control de errores inicializadas*/
			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";

			/*Consulta de los modulos por perfil*/
			DROP TEMPORARY TABLE IF EXISTS tt_ctProgramasModulo;

			CREATE TEMPORARY TABLE tt_ctProgramasModulo LIKE ctProgramasModulo;

			/*Casos para el tipo de consulta*/
			CASE iTipoConsulta

			    WHEN 0 THEN INSERT INTO tt_ctProgramasModulo SELECT * FROM ctProgramasModulo WHERE ctProgramasModulo.iIDModulo = iIDModulo AND ctProgramasModulo.lActivo = 0;
			    WHEN 1 THEN INSERT INTO tt_ctProgramasModulo SELECT * FROM ctProgramasModulo WHERE ctProgramasModulo.iIDModulo = iIDModulo AND ctProgramasModulo.lActivo = 1;
			    WHEN 2 THEN INSERT INTO tt_ctProgramasModulo SELECT * FROM ctProgramasModulo WHERE ctProgramasModulo.iIDModulo = iIDModulo;

			END CASE;

			/*Resultado de las consultas anteriores*/
			SELECT * FROM tt_ctProgramasModulo;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;