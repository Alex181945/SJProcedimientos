/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 13/05/2018
 * Descripcion: Procedimiento que valida Edificio
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
 DROP PROCEDURE IF EXISTS `consultaTipoAtributo`;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaTipoAtributo( IN iAtributo       INTEGER(11) ,
 										IN iIDTipoPersona  INTEGER(11),
	 									OUT lError         TINYINT(1), 
	 									OUT cSqlState      VARCHAR(50), 
	 									OUT cError         VARCHAR(200))
 	consultaTipoAtributo:BEGIN

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
			DROP TEMPORARY TABLE IF EXISTS tt_ctTipoAtributoTP;

			CREATE TEMPORARY TABLE tt_ctTipoAtributoTP LIKE ctTipoAtributoTP;

			/*Comprueba si existe el Edif*/
			IF EXISTS(SELECT * FROM ctTipoAtributoTP WHERE ctTipoAtributpTP.iAtributo  = iAtributo
														AND ctTipoAtributpTP.iIDTipoPersona = iIDTipoPersona)

				/*Si existe copia toda la informacion del edificio a la tabla temporal*/
				THEN INSERT INTO tt_ctTipoAtributoTP SELECT * FROM ctTipoAtributoTP WHERE ctTipoAtributpTP.iAtributo  = iAtributo
														AND ctTipoAtributpTP.iIDTipoPersona = iIDTipoPersona;

				/*Si no manda error de que no lo encontro*/
				ELSE 
					SET lError = 1; 
					SET cError = "Tipo de persona no existe";
					LEAVE consultaTipoAtributo;

			END IF;

			SELECT * FROM tt_ctTipoAtributoTP;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;