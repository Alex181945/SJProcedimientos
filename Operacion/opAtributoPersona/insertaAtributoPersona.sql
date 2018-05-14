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
 DROP PROCEDURE IF EXISTS `insertaAtributoPersona`;

 DELIMITER //
CREATE PROCEDURE insertaAtributoPersona(IN iAtributo       INTEGER(11),
										IN iIDTipoPersona  INTEGER(11),
										IN iPersona        INTEGER(11),
									 	IN cValor          VARCHAR(100),
 									 	IN cObs            VARCHAR(200),
 									 	OUT lError         TINYINT(1), 
 									 	OUT cSqlState      VARCHAR(50), 
 									 	OUT cError         VARCHAR(200))

 	insertaAtributoPersona:BEGIN

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

			/*Se valida que los dato no se encunetre nulos o vacios respecto a la tabla*/
			
			IF iAtributo = 0 OR iAtributo = NULL

				THEN 
					SET lError = 1;
					SET cError = "El tipo de atributo no tiene valor";
					LEAVE insertaAtributoPersona;

			END IF;

			IF iIDTipoPersona = 0 OR iIDTipoPersona = NULL

				THEN 
					SET lError = 1;
					SET cError = "El tipo de persona no tiene valor";
					LEAVE insertaAtributoPersona;

			END IF;

			IF iPersona = 0 OR iPersona = NULL

				THEN 
					SET lError = 1;
					SET cError = "El ID persona no tiene valor";
					LEAVE insertaAtributoPersona;

			END IF;

			IF cValor = "" OR cValor = NULL

				THEN 
					SET lError = 1;
					SET cError = "El atributo no tiene valor";
					LEAVE insertaAtributoPersona;

			END IF;

			/*Verifica que el tipo de persona no exista con anterioridad*/
			IF EXISTS(SELECT * FROM opAtributoPersona WHERE opAtributoPersona.iAtributo      = iAtributo
														AND opAtributoPersona.iIDTipoPersona = iIDTipoPersona 
														AND opAtributoPersona.cValor         = cValor)

				THEN 
					SET lError = 1; 
					SET cError = "La informacion que se desea insertar ya existe";
					LEAVE insertaAtributoPersona;

			END IF;

			INSERT INTO opAtributoPersona(
									opAtributoPersona.iAtributo,
									opAtributoPersona.iIDTipoPersona,
									opAtributoPersona.iPersona,
									opAtributoPersona.cValor,
									opAtributoPersona.cObs,
									opAtributoPersona.lActivo,
									opAtributoPersona.dtCreado) 
						VALUES	(	iAtributo,
									iIDTipoPersona,
									iPersona,
									cValor,
									cObs,
									1,
									NOW());

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;