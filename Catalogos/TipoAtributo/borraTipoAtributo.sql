/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 13/05/2018
 * Descripcion: Procedimiento que borra el edificio
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo:  11/09/2017 In-11 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 *
 */

 /*Para pruebas*/
 USE escuelast;
 DROP PROCEDURE IF EXISTS `borraTipoAtributo`;
 /*SELECT
    CONCAT('DROP ',ROUTINE_TYPE,' `',ROUTINE_SCHEMA,'`.`',ROUTINE_NAME,'`;') as stmt
FROM information_schema.ROUTINES; Borra todos los procedimientos*/ 

/*SET FOREIGN_KEY_CHECKS = 0; 
SET @tables = NULL;
SELECT GROUP_CONCAT(table_schema, '.', table_name) INTO @tables
  FROM information_schema.tables 
  WHERE table_schema = 'heroku_4db762767b31ffb'; -- specify DB name here.
SET @tables = CONCAT('DROP TABLE ', @tables);
PREPARE stmt FROM @tables;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SET FOREIGN_KEY_CHECKS = 1;  Borrar todas las tablas*/
 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE borraTipoAtributo(IN iAtributo       INTEGER(11) ,
 									IN iIDTipoPersona  INTEGER(11),
	 								OUT lError         TINYINT(1), 
	 								OUT cSqlState      VARCHAR(50), 
	 								OUT cError         VARCHAR(200))
 	borraTipoAtributo:BEGIN

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

			/*Valida que el edificio exista*/
			IF NOT EXISTS(SELECT * FROM ctTipoAtributoTP WHERE ctTipoAtributpTP.iAtributo  = iAtributo
														AND ctTipoAtributpTP.iIDTipoPersona = iIDTipoPersona)

				THEN 
					SET lError = 1; 
					SET cError = "El tipo de persona no existe";
					LEAVE borraTipoAtributo;

			END IF;

			/*Valida que el edificio no este activo*/
			IF NOT EXISTS(SELECT * FROM ctTipoAtributoTP WHERE ctTipoAtributpTP.iAtributo = iAtributo
													AND ctTipoAtributpTP.iIDTipoPersona = iIDTipoPersona 
													AND  ctTipoAtributoTP.lActivo     = 1)

				THEN 
					SET lError = 1; 
					SET cError = "El tipo de persona ya fue borrado con anterioridad";
					LEAVE borraTipoAtributo;

			END IF;

			/*Realiza el borrado logico que es una llamada al procedimiento actualizaEdificio*/
			UPDATE ctTipoAtributoTP
				SET ctTipoAtributoTP.lActivo       = 0,
					ctTipoAtributoTP.dtModificado  = NOW()
				WHERE ctTipoAtributpTP.iAtributo = iAtributo AND ctTipoAtributoTP.iIDTipoPersona = iIDTipoPersona;


		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;