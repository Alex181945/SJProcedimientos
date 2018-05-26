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
 DROP PROCEDURE IF EXISTS `insertaTipoPersona`;

 DELIMITER //
CREATE PROCEDURE insertaTipoPersona(IN cTipoPersona VARCHAR(100) ,
 									OUT lError TINYINT(1), 
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))

 	insertaTipoPersona:BEGIN

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
			
			IF cTipoPersona = "" OR cTipoPersona = NULL

				THEN 
					SET lError = 1;
					SET cError = "El tipo de persona no tiene valor";
					LEAVE insertaTipoPersona;

			END IF;


			/*Verifica que el tipo de persona no exista con anterioridad*/
			IF EXISTS(SELECT * FROM ctTipoPersona WHERE ctTipoPersona.cTipoPersona = cTipoPersona)

				THEN 
					SET lError = 1; 
					SET cError = "El tipo de persona ya existe";
					LEAVE insertaTipoPersona;

			END IF;

			INSERT INTO ctTipoPersona(
									ctTipoPersona.cTipoPersona,
									ctTipoPersona.lActivo,
									ctTipoPersona.dtCreado) 
						VALUES	(	cTipoPersona,
									1,
									NOW());

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;