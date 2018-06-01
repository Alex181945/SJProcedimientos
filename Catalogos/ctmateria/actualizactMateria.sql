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

 CREATE PROCEDURE actualizactMateria( IN iMateria    INTEGER,
 										IN cMateria  VARCHAR(100),
 										IN iCarrera   INTEGER,
 										IN iPeriodo   INTEGER,
		 									OUT lError      TINYINT(1), 
		 									OUT cSqlState   VARCHAR(50), 
		 									OUT cError      VARCHAR(200))

 	/*Nombre del Procedimiento*/
	actualizactMateria:BEGIN

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

			IF iMateria = 0 OR iMateria = NULL

				THEN
						SET lError = 1;
						SET cError = "El ID Materia no tiene valor";
						LEAVE actualizactMateria;
			END IF;

			IF cMateria = "" OR cMateria = NULL

				THEN
						SET lError = 1;
						SET cError = "La Materia no tiene valor";
						LEAVE actualizactMateria;
			END IF;


			IF iCarrera = 0 OR iCarrera = NULL

				THEN
						SET lError = 1;
						SET cError = "El ID Carrera no tiene valor";
						LEAVE actualizactMateria;
			END IF;


			IF iPeriodo = 0 OR iPeriodo = NULL

				THEN
						SET lError = 1;
						SET cError = "El ID Periodo no tiene valor";
						LEAVE actualizactMateria;
			END IF;

			/*Valida que el usuario exista*/
			IF NOT EXISTS(SELECT * FROM ctMateria WHERE  ctMateria.iMateria  = iMateria
																AND ctMateria.cMateria = cMateria
																AND ctMateria.iCarrera = iCarrera
																AND ctMateria.iPeriodo = iPeriodo)
				THEN 
					SET lError = 1; 
					SET cError = "El atributo para el tipo de persona no existe";
					LEAVE actualizactMateria;

			END IF;


			/*Realiza la actualizacion*/
		 			UPDATE ctMateria
		 						SET ctMateria.cMateria   = cMateria,
		 						    ctMateria.lActivo      = lActivo,
		 							ctMateria.dtModificado = NOW()
 							WHERE ctMateria.iMateria = iMateria
 									AND ctMateria.iCarrera = iCarrera
									AND ctMateria.iPeriodo = iPeriodo;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;