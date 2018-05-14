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
 DROP PROCEDURE IF EXISTS `actualizaAtributoPersona`;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE actualizaAtributoPersona(	IN iAtributoPer   INTEGER(11) ,
 											IN iAtributo      INTEGER(11) ,
 											IN iIDTipoPersona INTEGER(11) ,
 											IN iPersona       INTEGER(11) ,
 											IN cValor         VARCHAR(100),
 											IN cObs           VARCHAR(200),
 											IN lActivo        TINYINT(1),
	 										OUT lError        TINYINT(1), 
	 										OUT cSqlState     VARCHAR(50), 
	 										OUT cError        VARCHAR(200))
 	actualizaAtributoPersona:BEGIN

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
			
			IF iAtributoPer = 0 OR iAtributoPer = NULL

				THEN 
					SET lError = 1;
					SET cError = "El ID del atributo de la persona no tiene valor";
					LEAVE actualizaAtributoPersona;

			END IF;

			IF iAtributo = 0 OR iAtributo = NULL

				THEN 
					SET lError = 1;
					SET cError = "El tipo de atributo no tiene valor";
					LEAVE actualizaAtributoPersona;

			END IF;

			IF iIDTipoPersona = 0 OR iIDTipoPersona = NULL

				THEN 
					SET lError = 1;
					SET cError = "El tipo de persona no tiene valor";
					LEAVE actualizaAtributoPersona;

			END IF;

			IF iPersona = 0 OR iPersona = NULL

				THEN 
					SET lError = 1;
					SET cError = "El ID de la persona no tiene valor";
					LEAVE actualizaAtributoPersona;

			END IF;

			/*Valida que el edificio exista*/
			IF NOT EXISTS(SELECT * FROM opAtributoPersona WHERE  opAtributoPersona.iAtributoPer  = iAtributoPer
															AND opAtributoPersona.iAtributo      = iAtributo
															AND opAtributoPersona.iIDTipoPersona = iIDTipoPersona
															AND opAtributoPersona.iPersona       = iPersona)

				THEN 
					SET lError = 1; 
					SET cError = "El atributo para el tipo de persona no existe";
					LEAVE actualizaAtributoPersona;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE opAtributoPersona
				SET opAtributoPersona.cValor       = cValor,
					opAtributoPersona.cObs         = cObs,
					opAtributoPersona.lActivo      = lActivo,
					opAtributoPersona.dtModificado = NOW()
				WHERE   opAtributoPersona.iAtributoPer   = iAtributoPer
					AND	opAtributoPersona.iAtributo      = iAtributo
					AND	opAtributoPersona.iIDTipoPersona = iIDTipoPersona
					AND	opAtributoPersona.iPersona       = iPersona ;
				
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;