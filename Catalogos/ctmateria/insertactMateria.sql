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

 USE escuelajuana;

 DELIMITER //

 CREATE PROCEDURE insertactMateria( IN cMateria  VARCHAR(100),
 										IN iCarrera   INTEGER,
 										IN iPeriodo   INTEGER,
		 									OUT lError      TINYINT(1), 
		 									OUT cSqlState   VARCHAR(50), 
		 									OUT cError      VARCHAR(200))

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

			/*Valida el Tipo Tipo Persona que crea el registro*/
		/*	IF EXISTS(SELECT * FROM ctPersona WHERE ctPersona.iIDTipoPersona = iIDTipoPersona)

				THEN
					SET lError = 1; 
					SET cError = "El Tipo de Persona del sistema no existe";
					LEAVE insertaopAtributoPersona;

			END IF;*/


			/*Se valida que los dato no se encunetre nulos o vacios respecto a la tabla*/

			IF cMateria = "" OR cMateria = NULL

				THEN
						SET lError = 1;
						SET cError = "La Materia no tiene valor";
						LEAVE insertactMateria;
			END IF;

			IF iCarrera = 0 OR iCarrera = NULL

				THEN
						SET lError = 1;
						SET cError = "La ID Carrera no tiene valor";
						LEAVE insertactMateria;
			END IF;

			IF iPeriodo = 0 OR iPeriodo = NULL

				THEN
						SET lError = 1;
						SET cError = "La ID Periodo no tiene valor";
						LEAVE insertactMateria;
			END IF;

			INSERT INTO ctMateria(ctMateria.cMateria,
									ctMateria.iCarrera,
									ctMateria.iPeriodo,
									ctMateria.lActivo,
									ctMateria.dtCreado)
											VALUES (cMateria,
													iCarrera,
													iPeriodo,
													 1,
													 NOW());
		COMMIT;
	END;//	
 /*Reseteo del delimitador*/	
 DELIMITER ;