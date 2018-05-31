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

 CREATE PROCEDURE actualizactPeriodo( IN iPeriodo  INTEGER,
 										IN cPeriodo  VARCHAR(100),
		 									OUT lError      TINYINT(1), 
		 									OUT cSqlState   VARCHAR(50), 
		 									OUT cError      VARCHAR(200))

 	/*Nombre del Procedimiento*/
	actualizactPeriodo:BEGIN

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

			IF iPeriodo = 0 OR iPeriodo = NULL

				THEN
						SET lError = 1;
						SET cError = "El ID Periodo no tiene valor";
						LEAVE actualizactPeriodo;
			END IF;

			IF cPeriodo = "" OR cPeriodo = NULL

				THEN
						SET lError = 1;
						SET cError = "El iD Periodo no tiene valor";
						LEAVE actualizactPeriodo;
			END IF;

			/*Valida que el usuario exista*/
			IF NOT EXISTS(SELECT * FROM ctPeriodo WHERE  ctPeriodo.iPeriodo  = iPeriodo
																AND ctPeriodo.cPeriodo = cPeriodo)
				THEN 
					SET lError = 1; 
					SET cError = "El atributo para el tipo de persona no existe";
					LEAVE actualizactPeriodo;

			END IF;


			/*Realiza la actualizacion*/
		 			UPDATE ctPeriodo
		 						SET ctPeriodo.cPeriodo   = cPeriodo,
		 						    ctPeriodo.lActivo      = lActivo,
		 							ctPeriodo.dtModificado = NOW()
 							WHERE opGrupoAlumno.iPeriodo = iPeriodo;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;