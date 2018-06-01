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

 CREATE PROCEDURE actualizaopGrupoAlumno( IN iGrupo INTEGER,
 											IN iPartida   INTEGER,
 											IN iPersona   INTEGER,
		 									OUT lError      TINYINT(1), 
		 									OUT cSqlState   VARCHAR(50), 
		 									OUT cError      VARCHAR(200))

 	/*Nombre del Procedimiento*/
	actualizaopGrupoAlumno:BEGIN

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

			IF iGrupo = 0 OR iGrupo = NULL

				THEN
						SET lError = 1;
						SET cError = "El ID Grupo no tiene valor";
						LEAVE actualizaopGrupoAlumno;
			END IF;

			IF iPartida = 0 OR iPartida = NULL

				THEN
						SET lError = 1;
						SET cError = "El iD partida no tiene valor";
						LEAVE actualizaopGrupoAlumno;
			END IF;

			IF iPersona = 0 OR iPersona = NULL

				THEN
						SET lError = 1;
						SET cError = "La ID Persona no tiene valor";
						LEAVE actualizaopGrupoAlumno;

			END IF;

			/*Valida que el usuario exista*/
			IF NOT EXISTS(SELECT * FROM opGrupoAlumno WHERE  opGrupoAlumno.iGrupo  = iGrupo
																AND opGrupoAlumno.iPartida = iPartida
																AND opGrupoDet.iPersona = iPersona)
				THEN 
					SET lError = 1; 
					SET cError = "El atributo para el tipo de persona no existe";
					LEAVE actualizaopGrupoAlumno;

			END IF;


			/*Realiza la actualizacion*/
		 			UPDATE opGrupoAlumno
		 						SET opGrupoAlumno.lActivo      = lActivo,
		 							opGrupoAlumno.dtModificado = NOW()
 							WHERE opGrupoAlumno.iGrupo = iGrupo
 									AND opGrupoAlumno.iPartida = iPartida
 									AND opGrupoAlumno.iPersona = iPersona;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;