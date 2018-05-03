/**
 * 
 * Autor: Bogar Chavez
 * Fecha: 20/03/2018
 * Descripcion: Procedimiento que actualiza la criticidad
 * 
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Bogar Chavez 20/03/2018 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE actualizaCriticidad(IN cCriticidad VARCHAR(150) ,
                                    IN lActivo TINYINT(1),
									IN cUsuario VARCHAR(50) ,
 									OUT lError TINYINT(1), 
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))
 	actualizaCriticidad:BEGIN

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
			
			IF cCriticidad = "" OR cCriticidad = NULL

				THEN 
					SET lError = 1;
					SET cError = "La Criticidad no tiene valor";
					LEAVE actualizaCriticidad;

			END IF;

			IF lActivo = 0 OR lActivo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Activo no contiene valor";
					LEAVE actualizaCriticidad;

			END IF;

			IF cUsuario = "" OR cUsuario = NULL

				THEN 
					SET lError = 1;
					SET cError = "El usuario no contiene un valor";
					LEAVE actualizaCriticidad;
			END IF;


			/*Realiza la actualizacion*/
			UPDATE ctCriticidad
				SET ctCriticidad.cCriticidad     = cCriticidad,
					ctCriticidad.lActivo       = lActivo,
					ctCriticidad.dtModificado  = NOW(),
                    ctCriticidad.cUsuario      = cUsuario
				WHERE ctCriticidad.iIDCriticidad = iIDCriticidad;
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;