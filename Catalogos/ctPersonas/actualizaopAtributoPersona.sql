/**
 * 
 * Autor: Alberto Robles
 * Fecha: 26/03/2018
 * Descripcion: Procedimiento que inserta Tipo Persona
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alberto Robles 26/03/2018 In-15 Fn-19 
 * 
 * Notas: 0 es igual a falso, 1 es igual a verdadero
 */
 
 /*Delimitador de bloque*/

  USE escuelajuana;

 DELIMITER //

 CREATE PROCEDURE actualizaopAtributoPersona( IN iAtributoPer   INTEGER,
 											  IN iAtributo      INTEGER,
 											  IN iIDTipoPersona INTEGER,
 											  IN iPersona 	    INTEGER,
				 							  IN cValor			VARCHAR(150),
				 							  IN cObs   		VARCHAR(150),
		 										OUT lError        TINYINT(1), 
		 										OUT cSqlState     VARCHAR(50), 
		 										OUT cError        VARCHAR(200))

 	/*Nombre del Procedimiento*/
	actualizaopAtributoPersona:BEGIN

		/*Manejo de Errores*/ 
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1
  			@e1 = RETURNED_SQLSTATE, @e2 = MESSAGE_TEXT;
			SET lError    = 1;
			SET cSqlState = CONCAT("SqlState: ", @e1);
			SET cError    = CONCAT("Exepxcion: ", @e2);
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

			/* Procedimientos */

			/*Variables para control de errores inicializadas*/
			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";

			/*Se valida que los dato no se encunetre nulos o vacios respecto a la tabla*/

			IF iAtributoPer = 0 OR iAtributoPer = NULL

				THEN
						SET lError = 1;
						SET cError = "El atributo Persona no tiene valor";
						LEAVE actualizaopAtributoPersona;
			END IF;

			IF iAtributo = 0 OR iAtributo = NULL

				THEN
						SET lError = 1;
						SET cError = "El Atributo no tiene valor";
						LEAVE actualizaopAtributoPersona;
			END IF;


			IF iIDTipoPersona = 0 OR iIDTipoPersona = NULL

				THEN
						SET lError = 1;
						SET cError = "El ID persona no tiene valor";
						LEAVE actualizaopAtributoPersona;

			END IF;

			IF iPersona = 0 OR iPersona = NULL

				THEN
						SET lError = 1;
						SET cError = "La Clave de la Persona no tiene valor";
						LEAVE actualizaopAtributoPersona;

			END IF;


			IF cValor = "" OR cValor = NULL

				THEN
						SET lError = 1;
						SET cError = "El Valor del Atributo no tiene valor";
						LEAVE actualizaopAtributoPersona;
			END IF;

			/*Valida que el usuario exista*/
			IF NOT EXISTS(SELECT * FROM opAtributoPersona WHERE  opAtributoPersona.iAtributoPer  = iAtributoPer
																AND opAtributoPersona.iAtributo = iAtributo
																AND opAtributoPersona.iIDTipoPersona = iIDTipoPersona
																AND opAtributoPersona.iPersona = iPersona)
				THEN 
					SET lError = 1; 
					SET cError = "El atributo para el tipo de persona no existe";
					LEAVE actualizaopAtributoPersona;

			END IF;


			/*Realiza la actualizacion*/
		 			UPDATE opAtributoPersona
		 						SET opAtributoPersona.cValor      = cValor,
		 							opAtributoPersona.cObs    = cObs,
		 							opAtributoPersona.lActivo      = lActivo,
		 							opAtributoPersona.dtModificado = NOW()
 							WHERE opAtributoPersona.iAtributoPer = iAtributoPer
 									AND opAtributoPersona.iAtributo = iAtributo
 									AND opAtributoPersona.iIDTipoPersona = iIDTipoPersona
 									AND opAtributoPersona.iPersona = iPersona;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;