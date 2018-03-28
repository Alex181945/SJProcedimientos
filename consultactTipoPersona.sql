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
 DELIMITER //

 CREATE PROCEDURE consultaTipoPersona( IN iIDTipoPersona INTEGER,
 										OUT lError     TINYINT(1), 
 										OUT cSqlState  VARCHAR(50), 
 										OUT cError     VARCHAR(200))

 	/*Nombre del Procedimiento*/
 	consultaTipoPersona:BEGIN

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
			IF NOT EXISTS(SELECT * FROM ctTipoPersona WHERE ctTipoPersona.cTipoPersona = cTipoPersona)

				THEN
					SET lError = 1; 
					SET cError = "El Tipo Tipo Persona del sistema no existe";
					LEAVE insertaTipoPersona;

			END IF;


 			/*Crea una tabla temporal con la estructura de la tabla
 			 *especificada despues del LIKE
 			 */

			DROP TEMPORARY TABLE IF EXISTS tt_ctTipoPersona;
 
 			CREATE TEMPORARY TABLE tt_ctTipoPersona LIKE ctTipoPersona;

			/*Comprueba si existe el Tipo Persona*/

			IF EXISTS(SELECT * FROM ctTipoPersona WHERE ctTipoPersona.iIDTipoPersona = iIDTipoPersona)

			/*Si existe copia toda la informacion del Tipo Persona a la tabla temporal*/
 				THEN INSERT INTO tt_ctTipoPersona SELECT * FROM ctTipoPersona WHERE ctTipoPersona.iIDTipoPersona = iIDTipoPersona;

			/*Si no manda error de que no lo encontro*/
 				ELSE 
 					SET lError = 1; 
 					SET cError = "Tipo Persona no existe";
 					LEAVE consultaTipoPersona;	

 			 END IF;
 
 			/*Valida que el Tipo Persona este activo*/
 			IF NOT EXISTS(SELECT * FROM tt_ctTipoPersona WHERE tt_ctTipoPersona.lActivo = 1)


 			THEN 
 					SET lError = 1; 
 					SET cError = "Tipo Persona no activo";
					LEAVE consultaTipoPersona;
 
 			END IF;
 
 			SELECT * FROM tt_ctTipoPersona;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;