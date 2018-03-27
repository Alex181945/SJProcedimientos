/**
 * 
 * Autor: Alberto Robles
 * Fecha: 16/03/2018
 * Descripcion: Procedimiento que inserta Tipo Persona
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alberto Robles 16/03/2018 In-15 Fn-19 
 * 
 * Notas: 0 es igual a falso, 1 es igual a verdadero
 */
 
 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE insertactTipoPersona( IN cIDTipoPersona INT(50),
 										IN cTipoPersona VARCHAR(30),
 										IN cNombre 		VARCHAR(150),
 										IN cApePaterno   VARCHAR(150,
 										IN cApeMaterno	 VARCHAR(150),
 										IN lGenero       BOOL,
 										IN dtFechaNac	DateTime(100),
 										IN lActivo       BOOL,
 										IN dtCreado     DateTime(100),
 										IN dtModificado DateTime(10),
 										OUT lError     TINYINT(1), 
 										OUT cSqlState  VARCHAR(50), 
 										OUT cError     VARCHAR(200)
 									)

 	/*Nombre del Procedimiento*/
 	insertaTipoPersona:BEGIN

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

			/*Valida el Tipo Usuario que crea el registro*/
			IF NOT EXISTS(SELECT * FROM ctTipoPersonona WHERE ctTipoPersonona.cTipoPersona = cTipoPersona)

				THEN
					SET lError = 1; 
					SET cError = "El Tipo cTipoPersona del sistema no existe";
					LEAVE ctTipoPersona;

			END IF;

			/*Verifica que el usuario a crear no exista con anterioridad*/
			IF EXISTS(SELECT * FROM ctTipoPersonona  WHERE ctTipoPersonona.cTipoPersonaR = ctTipoPersonona)

				THEN 
					SET lError = 1; 
					SET cError = "El Tipo Persona ya existe";
					LEAVE insertactTipoPersona;

			END IF;

			/*Se valida que los dato no se encunetre nulos o vacios respecto a la tabla*/

			IF cTipoPersona = "" OR cTipoPersona = NULL

				THEN
						SET lEror = 1;
						SET cError = "El Tipo Persona no tiene valor";
						LEAVE cTipoPersona;
			END IF;


			IF cNombre = "" OR cNombre = NULL

				THEN	
						SET lError = 1;
						SET cError = "El Nombre no tiene valor";
						LEAVE cNombre;

			END IF;

			IF cApePaterno = "" cApePaterno = NULL

				THEN
						SET lError = 1;
						SET cError = "El Apellido Paterno no tiene valor";
						LEAVE cApePaterno;

			END IF;


			IF cApeMaterno = "" cApeMaterno = NULL

				THEN
						SET lError = 1;
						SET cError = "El Apellido Materno no tiene valor";
						LEAVE cApeMaterno;

			END IF;

			IF cApeMaterno = "" cApeMaterno = NULL

				THEN
						SET lError = 1;
						SET cError = "El Apellido Materno no tiene valor";
						LEAVE cApeMaterno;

			END IF;

			INSERT INTO ctTipoPerson(ctTipoPerson.cIDTipoPersona
									 ctTipoPerson.cTipoPersona,
									 ctTipoPerson.cNombre,
									 ctTipoPerson.cApePaterno,
									 ctTipoPerson.cApeMaterno,
									 ctTipoPerson.lGenero,
									 ctTipoPerson.dtFechaNac,
									 ctTipoPerson.lActivo,
									 ctTipoPerson.dtCreado,
									 ctTipoPerson.dtModificado)
							VALUES (cIDTipoPersona
									cTipoPersona
									cNombre
									cApePaterno
									cApeMaterno
									1,
									NOW();
									1,
									NOW(),
									NOW());

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;