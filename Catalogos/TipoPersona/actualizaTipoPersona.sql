/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 13/05/2018
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
 DROP PROCEDURE IF EXISTS `actualizaTipoPersona`;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE actualizaTipoPersona( IN iIDTipoPersona INTEGER(11) ,
 										IN cTipoPersona   VARCHAR(100),
 										IN lActivo        TINYINT(1),
	 									OUT lError        TINYINT(1), 
	 									OUT cSqlState     VARCHAR(50), 
	 									OUT cError        VARCHAR(200))
 	actualizaTipoPersona:BEGIN

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
			IF NOT EXISTS(SELECT * FROM ctTipoPersona WHERE ctTipoPersona.iIDTipoPersona = iIDTipoPersona)

				THEN 
					SET lError = 1; 
					SET cError = "El tipo de persona no existe";
					LEAVE actualizaTipoPersona;

			END IF;

			IF cTipoPersona = "" OR cTipoPersona = NULL

				THEN 
					SET lError = 1;
					SET cError = "El tipo de persona no tiene valor";
					LEAVE actualizaTipoPersona;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE ctTipoPersona
				SET ctTipoPersona.cTipoPersona  = cTipoPersona,
					ctTipoPersona.lActivo       = lActivo,
					ctTipoPersona.dtModificado  = NOW()
				WHERE ctTipoPersona.iIDTipoPersona = iIDTipoPersona;
				
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;