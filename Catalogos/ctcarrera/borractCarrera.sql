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

 CREATE PROCEDURE borractCarrera( IN iCarrera INTEGER,
 										IN cCarrera  VARCHAR(100),
	 										OUT lError      TINYINT(1), 
	 										OUT cSqlState   VARCHAR(50), 
	 										OUT cError      VARCHAR(200))

 	/*Nombre del Procedimiento*/
 	borractCarrera:BEGIN

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

			IF NOT EXISTS(SELECT * FROM ctCarrera WHERE ctCarrera.iCarrera = iCarrera
																	AND ctCarrera.cCarrera = cCarrera
																	AND ctCarrera.lActivo = 1)
 				THEN 
 					SET lError = 1; 
 					SET cError = "El Atributo Carrera ya fue borrado con anterioridad";
 					LEAVE borractCarrera;
 
 			END IF;
 
 			/*Realiza el borrado logico que es una llamada al procedimiento actualizaTipoPersona*/
 			UPDATE ctCarrera
 				SET ctCarrera.cCarrera      = cCarrera,
 					ctCarrera.lActivo       = 0,
 					ctCarrera.dtModificado  = NOW()
 				WHERE ctCarrera.iCarrera = iCarrera;
 
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;