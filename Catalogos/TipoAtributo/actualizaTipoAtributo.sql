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
 DROP PROCEDURE IF EXISTS `actualizaTipoAtributo`;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE actualizaTipoAtributo(IN iAtributo      INTEGER(11) ,
 										IN iIDTipoPersona INTEGER(11) ,
 										IN cAtributo      VARCHAR(100),
 										IN cValorIni      VARCHAR(100),
 										IN cTipoDato      VARCHAR(100),
 										IN lActivo        TINYINT(1),
	 									OUT lError        TINYINT(1), 
	 									OUT cSqlState     VARCHAR(50), 
	 									OUT cError        VARCHAR(200))
 	actualizaTipoAtributo:BEGIN

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
			IF NOT EXISTS(SELECT * FROM ctTipoAtributpTP WHERE ctTipoAtributpTP.iAtributo = iAtributo
														AND ctTipoAtributpTP.iIDTipoPersona = iIDTipoPersona)

				THEN 
					SET lError = 1; 
					SET cError = "El tipo de atributo por tipo de persona no existe";
					LEAVE actualizaTipoAtributo;

			END IF;

			IF cAtributo = "" OR cAtributo = NULL

				THEN 
					SET lError = 1;
					SET cError = "El tipo de atributo no tiene valor";
					LEAVE actualizaTipoAtributo;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE ctTipoAtributpTP
				SET ctTipoAtributpTP.cAtributo    = cAtributo,
					ctTipoAtributpTP.lActivo      = lActivo,
					ctTipoAtributpTP.dtModificado = NOW()
				WHERE ctTipoAtributpTP.iAtributo  = iAtributo AND ctTipoAtributpTP.iIDTipoPersona = iIDTipoPersona;
				
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;