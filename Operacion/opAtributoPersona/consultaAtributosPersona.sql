/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 13/05/2018
 * Descripcion: 
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Bogar Chavez 06/09/2017 In-06 Fn-
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 USE escuelast;
 DROP PROCEDURE IF EXISTS `consultaAtributosPersona`;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaAtributosPersona(	IN iTipoConsulta  INTEGER(3),
 											IN iIDTipoPersona INTEGER(11) ,
	 										IN iPersona       INTEGER(11) ,
	 										OUT lError       TINYINT(1), 
	 										OUT cSqlState    VARCHAR(50), 
	 										OUT cError       VARCHAR(200))
 	consultaAtributosPersona:BEGIN

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
			DROP TEMPORARY TABLE IF EXISTS tt_opAtributoPersona;

			CREATE TEMPORARY TABLE tt_opAtributoPersona LIKE opAtributoPersona;

			/*Casos para el tipo de consulta*/
			CASE iTipoConsulta

			    WHEN 0 THEN INSERT INTO tt_opAtributoPersona SELECT * FROM opAtributoPersona WHERE opAtributoPersona.iIDTipoPersona = iIDTipoPersona AND  opAtributoPersona.iPersona = iPersona AND opAtributoPersona.lActivo = 0;
			    WHEN 1 THEN INSERT INTO tt_opAtributoPersona SELECT * FROM opAtributoPersona WHERE opAtributoPersona.iIDTipoPersona = iIDTipoPersona AND  opAtributoPersona.iPersona = iPersona AND opAtributoPersona.lActivo = 1;
			    WHEN 2 THEN INSERT INTO tt_opAtributoPersona SELECT * FROM opAtributoPersona WHERE opAtributoPersona.iIDTipoPersona = iIDTipoPersona AND  opAtributoPersona.iPersona = iPersona;

			END CASE;

			/*Resultado de las consultas anteriores*/
			SELECT * FROM tt_opAtributoPersona;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;