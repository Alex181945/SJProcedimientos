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

 CREATE PROCEDURE actualizactPersona( IN iIDTipoPersona   INTEGER(11),
 										IN iPersona       INTEGER(11),
 										IN cNombre 		  VARCHAR(150),
 										IN cAPaterno      VARCHAR(150),
 										IN cAMaterno	  VARCHAR(150),
 										IN lGenero	      VARCHAR(150),
 										IN dtFechaNac	  VARCHAR(50),
 										IN lActivo        TINYINT(1),
 										OUT lError        TINYINT(1), 
 										OUT cSqlState     VARCHAR(50), 
 										OUT cError        VARCHAR(200))

 	/*Nombre del Procedimiento*/
 	actualizactPersona:BEGIN

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

			IF iPersona = 0 OR iPersona = NULL

				THEN
						SET lError = 1;
						SET cError = "El ID Persona no tiene valor";
						LEAVE actualizactPersona;
			END IF;

			IF iIDTipoPersona = 0 OR iIDTipoPersona = NULL

				THEN
						SET lError = 1;
						SET cError = "El Tipo Persona no tiene valor";
						LEAVE actualizactPersona;
			END IF;


			IF cNombre = "" OR cNombre = NULL

				THEN
						SET lError = 1;
						SET cError = "El Nombre no tiene valor";
						LEAVE actualizactPersona;

			END IF;

			IF cAPaterno = "" OR cAPaterno = NULL

				THEN
						SET lError = 1;
						SET cError = "El Apellido Paterno no tiene valor";
						LEAVE actualizactPersona;

			END IF;


			IF cAMaterno = "" OR cAMaterno = NULL

				THEN
						SET lError = 1;
						SET cError = "El Apellido Materno no tiene valor";
						LEAVE actualizactPersona;

			END IF;

			IF lGenero = 0 OR lGenero = NULL

				THEN
						SET lError = 1;
						SET cError = "El Genero no tiene valor";
						LEAVE actualizactPersona;

			END IF;

			IF dtFechaNac = "" OR dtFechaNac = NULL

				THEN
						SET lError = 1;
						SET cError = "La Fecha de Nacimiento no tiene valor";
						LEAVE actualizactPersona;

			END IF;

			/*Valida que el usuario exista*/
			IF NOT EXISTS(SELECT * FROM ctPersona WHERE  ctPersona.iPersona  = iPersona
															AND ctPersona.iIDTipoPersona = iIDTipoPersona)
				THEN 
					SET lError = 1; 
					SET cError = "El atributo para el tipo de persona no existe";
					LEAVE actualizactPersona;


			/*Realiza la actualizacion*/
		 			UPDATE ctPersona
		 						SET ctPersona.cNombre      = cNombre,
		 							ctPersona.cAPaterno    = cAPaterno,
		 							ctPersona.cAMaterno    = cAMaterno,
		 							ctPersona.lGenero      = lGenero,
		 							ctPersona.dtFechaNac   = dtFechaNac,
		 							ctPersona.lActivo      = lActivo,
		 							ctPersona.dtModificado = NOW()
 							WHERE ctPersona.iIDTipoPersona = iIDTipoPersona
 									AND ctPersona.iPersona 	   = iPersona;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;