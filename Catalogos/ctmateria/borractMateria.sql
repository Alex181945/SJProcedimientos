/**
 * 
 * Autor: Alberto Robles
 * Fecha: 03/04/2018
 * Descripcion: Procedimiento que inserta Tipo Persona
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alberto Robles 03/04/2018 In-15 Fn-19 
 * 
 * Notas: 0 es igual a falso, 1 es igual a verdadero
 */
 
 /*Delimitador de bloque*/

 USE escuelajuana;

 DELIMITER //

 CREATE PROCEDURE borractMateria( IN iMateria    INTEGER,
 										IN cMateria  VARCHAR(100),
 										IN iCarrera   INTEGER,
 										IN iPeriodo   INTEGER,
	 										OUT lError      TINYINT(1), 
	 										OUT cSqlState   VARCHAR(50), 
	 										OUT cError      VARCHAR(200))

 	/*Nombre del Procedimiento*/
 	borractMateria:BEGIN

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
 			
			/*Comprueba si existe el Tipo Persona*/

		/*	IF NOT EXISTS(SELECT * FROM ctPersona WHERE ctPersona.iIDTipoPersona = iIDTipoPersona
															AND ctPersona.cNombre = cNombre
															AND ctPersona.cAPaterno = cAPaterno
															AND ctPersona.cAMaterno= cAMaterno
															AND ctPersona.lGenero= lGenero
															AND ctPersona.dtFechaNac= dtFechaNac)


 			THEN 
 					SET lError = 1; 
 					SET cError = "El atributo de la persona no existe";
 					LEAVE borractPersona;
 
 			END IF;*/
 			/*Valida que el Tipo Persona no este activo*/

			IF NOT EXISTS(SELECT * FROM ctMateria WHERE ctMateria.iMateria = iMateria
																	AND ctMateria.cMateria = cMateria
																	AND ctMateria.iCarrera = iCarrera
																	AND ctMateria.iPeriodo = iPeriodo
																	AND ctMateria.lActivo = 1)
 				THEN 
 					SET lError = 1; 
 					SET cError = "El Atributo Grupo Alumno ya fue borrado con anterioridad";
 					LEAVE borractMateria;
 
 			END IF;
 
 			/*Realiza el borrado logico que es una llamada al procedimiento actualizaTipoPersona*/
 			UPDATE ctMateria
 				SET ctMateria.cMateria      = cMateria,
 					ctMateria.lActivo       = 0,
 					ctMateria.dtModificado  = NOW()
 				WHERE ctMateria.iMateria = iMateria
 						AND ctMateria.iCarrera = iCarrera
						AND ctMateria.iPeriodo = iPeriodo;
 
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;