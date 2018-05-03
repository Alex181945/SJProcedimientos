/**
 * 
 * Autor: Bogar Chavez
 * Fecha: 20/03/2018
 * Descripcion: Procedimiento que borra criticidad
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: 20/03/2018 In-11 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 *
 */

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE borraCriticidad(IN cCriticidad  VARCHAR,
 								OUT lError TINYINT(1), 
 								OUT cSqlState VARCHAR(50), 
 								OUT cError VARCHAR(200))
 	borraCriticidad:BEGIN

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
			IF NOT EXISTS(SELECT * FROM ctCriticidad WHERE ctCriticidad.iIDCriticidad = iIDCriticidad)

				THEN 
					SET lError = 1; 
					SET cError = "Nivel no existe";
					LEAVE borraCriticidad;

			END IF;

			/*Valida que el edificio no este activo*/
			IF NOT EXISTS(SELECT * FROM ctCriticidad WHERE ctCriticidad.cCriticidad = cCriticidad 
													AND ctCriticidad.lActivo  = 1)

				THEN 
					SET lError = 1; 
					SET cError = "El nivel de criticidad ya fue borrado con anterioridad";
					LEAVE borraCriticidad;

			END IF;

			
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;