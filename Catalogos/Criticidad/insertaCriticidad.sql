/**
 * insertaCriticidad
 * Autor: Bogar Chavez
 * Fecha: 09/03/2018
 * Descripcion: 
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Bogar Chavez 09/09/2017 In-06 Fn-
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

/*Para pruebas*/
/*USE SENADO;*/

DELIMITER //
CREATE PROCEDURE insertaCriticidad( IN 	cCriticidad VARCHAR(150) NOT NULL,
									IN 	cUsuario VARCHAR(50) NOT NULL,
 									OUT lError TINYINT(1), 
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))

 	insertaCriticidad:BEGIN

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
					LEAVE insertaCriticidad;

			END IF;

			IF cUsuario = "" OR cUsuario = NULL

				THEN 
					SET lError = 1;
					SET cError = "El usuario no contiene un valor";
					LEAVE insertaCriticidad;
			END IF;

			INSERT INTO ctCriticidad(
									ctCriticidad.cCriticidad,
									ctCriticidad.lActivo,
									ctCriticidad.dtCreado,
									ctCriticidad.cUsuario)
						VALUES	(
									cCriticidad,
									1,
									NOW(),
									cUsuario);

		COMMIT;

	END;//
	
 DELIMITER ;