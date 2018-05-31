/**
 * 
 * Autor: Alberto Robles
 * Fecha: 27/03/2018
 * Descripcion: Procedimiento que inserta Tipo Persona
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alberto Robles 27/03/2018 In-15 Fn-19 
 * 
 * Notas: 0 es igual a falso, 1 es igual a verdadero
 */
 
 /*Delimitador de bloque*/

 USE escuelajuana;

 DELIMITER //

 CREATE PROCEDURE consultaopGrupoAlumno( IN iGrupo INTEGER,
 											IN iPartida   INTEGER,
 											IN iPersona   INTEGER,
		 										OUT lError     TINYINT(1), 
		 										OUT cSqlState  VARCHAR(50), 
		 										OUT cError     VARCHAR(200))

 	/*Nombre del Procedimiento*/
 	consultaopGrupoAlumno:BEGIN

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
			

 			/*Crea una tabla temporal con la estructura de la tabla
 			 *especificada despues del LIKE
 			 */

			DROP TEMPORARY TABLE IF EXISTS tt_opGrupoAlumno;
 
 			CREATE TEMPORARY TABLE tt_opGrupoAlumno LIKE opGrupoAlumno;

 			
			/*Comprueba si existe el Tipo Persona*/

			IF EXISTS(SELECT * FROM opGrupoAlumno WHERE opGrupoAlumno.iGrupo  = iGrupo
														AND opGrupoAlumno.iPartida  = iPartida
														AND opGrupoAlumno.iPersona = iPersona)

			/*Si existe copia toda la informacion del Tipo Persona a la tabla temporal*/
 				THEN INSERT INTO tt_opGrupoAlumno SELECT * FROM opGrupoAlumno WHERE opGrupoAlumno.iGrupo = iGrupo
 																AND opGrupoAlumno.iPartida  = iPartida
																AND opGrupoAlumno.iPersona = iPersona;

			/*Si no manda error de que no lo encontro*/
 				ELSE 
 					SET lError = 1; 
 					SET cError = "Tipo Grupo no existe";
 					LEAVE consultaopGrupoAlumno;	

 			 END IF;

 			  			/*Valida que el Tipo Persona este activo*/
 			IF NOT EXISTS(SELECT * FROM tt_opGrupoAlumno WHERE tt_opGrupoAlumno.lActivo = 1)


 			THEN 
 					SET lError = 1; 
 					SET cError = "Tipo Grupo no activo";
					LEAVE consultaopGrupoAlumno;
 
 			END IF;
 

 			SELECT * FROM tt_opGrupoAlumno;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;