/**
 * 
 * Autor: Alberto Robles
 * Fecha: 16/03/2018
 * Descripcion: Procedimiento que inserta usuarios
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alberto Robles 16/39/2018 In-15 Fn-19 
 * 
 * Notas: 0 es igual a falso, 1 es igual a verdadero
 */
 
 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE insertactMateria(	IN ciMateria     INT(50),
 									IN cMateria      VARCHAR(30),
 									IN cTipoPersona  VARCHAR(50),
 									IN cNombre       VARCHAR(150),
 									IN cApePaterno   VARCHAR(150):
 									IN cApeMaterno   VARCHAR(150);
									IN iCarrera     INT(1),
 									IN iPeriodo      INT(100),
 									IN lActivo       TINYINT(1),
 									IN dtCreado      DateTime(10),
 									IN dtModificado  DateTime(10),
 									OUT lError       TINYINT(1), 
 									OUT cSqlState    VARCHAR(50), 
 									OUT cError       VARCHAR(200)
 								)

 	/*Nombre del Procedimiento*/
 	insertactMateria:BEGIN

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

			/*Valido de la Materia que crea el registro*/
			IF NOT EXISTS(SELECT * FROM insertactMateria WHERE ctMateria.cMateria = cMateria)

				THEN
					SET lError = 1; 
					SET cError = "La Materia en el sistema no existe"; 
					LEAVE ctMateria;

			END IF;

			/*Verifica que la Materia a crear no exista con anterioridad*/
			IF EXISTS(SELECT * FROM ctMateria  WHERE ctMateria.cMateria = cMateria)

				THEN 
					SET lError = 1; 
					SET cError = "La Materia ya existe";
					LEAVE ctMateria;

			/*Se valida que los dato no se encunetre nulos o vacios respecto a la tabla*/

			IF cMateria = "" OR cMateria = NULL

				THEN
						SET lEror = 1;
						SET cError = "La Materia no tiene valor";
						LEAVE cMateria;
			END IF;

			IF cTipoPersona = "" OR cTipoPersona = NULL

				THEN
						SET lEror = 1;
						SET cError = "El Tipo Perona no tiene valor";
						LEAVE cTipoPersona;
			END IF;

			IF cNombre = "" OR cNombre = NULL

				THEN
						SET lEror = 1;
						SET cError = "El Nombre no tiene valor";
						LEAVE cNombre;
			END IF;

			IF cApePaterno = "" OR cApePaterno = NULL

				THEN
						SET lEror = 1;
						SET cError = "El Apellido Paterno no tiene valor";
						LEAVE cApePaterno;
			END IF;

			IF cApeMaterno = "" OR cApeMaterno = NULL

				THEN
						SET lEror = 1;
						SET cError = "El Apellido Materno no tiene valor";
						LEAVE cApeMaterno;
			END IF;

			IF iCarrera = "" OR iCarrera = NULL

				THEN
						SET lEror = 1;
						SET cError = "La Carrera no tiene valor";
						LEAVE iCarrera;
			END IF;

			IF iPeriodo = "" OR iPeriodo = NULL

				THEN
						SET lEror = 1;
						SET cError = "El Periodo no tiene valor";
						LEAVE iPeriodo;
			END IF;



			INSERT INTO ctMateria(ctMateria.ciMateria,
								  ctMateria.cMateria,
								  ctMateria.cTipoPersona,
								  ctMateria.cNombre,
								  ctMateria.cApePaterno,
								  ctMateria.cApeMaterno,
								  ctMateria.iCarrera,
								  ctMateria.iPeriodo,
								  ctMateria.lActivo,
								  ctMateria.dtCreado,
								  ctMateria.dtModificado)
							VALUES(ciMateria
								   ctMateria
								   cTipoPersona
								   cNombre
								   cApePaterno	
								   cApeMaterno
								   iCarrera
								   iPeriodo
								   1,
								   NOW(),
								   NOW());

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;