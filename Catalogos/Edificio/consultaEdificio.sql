/**
 * 
 * Autor: Bogar Chavez
 * Fecha: 11/03/2018
 * Descripcion: Procedimiento que valida Edificio
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Bogar Chavez 11/03/2018 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */
 
 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaEdificio(	IN iIDEdificio  INTEGER(20),
 									OUT lError TINYINT(1), 
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))
 	consultaEdificio:BEGIN

		/*Manejo de Errores*/ 
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1
  			@e1 = RETURNED_SQLSTATE, @e2 = MESSAGE_TEXT;
			SET lError    = 1;
			SET cSqlState = CONCAT("SqlState: ", @e1);
			SET cError    = CONCAT("Exepcion: ", @e2);
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

			/*Procedimiento*/

			/*Variables para control de errores inicializadas*/
			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";

			/*Crea una tabla temporal con la estructura de la tabla
			 *especificada despues del LIKE
			 */
			DROP TEMPORARY TABLE IF EXISTS tt_ctEdificios;

			CREATE TEMPORARY TABLE tt_ctEdificios LIKE ctEdificio;

			/*Comprueba si existe el Edif*/
			IF EXISTS(SELECT * FROM ctEdificios WHERE ctEdificios.iIDEdificio = iIDEdificio)

				/*Si existe copia toda la informacion del edificio a la tabla temporal*/
				THEN INSERT INTO tt_ctEdificios SELECT * FROM ctEdificios WHERE ctEdificios.iIDEdificio = iIDEdificio;

				/*Si no manda error de que no lo encontro*/
				ELSE 
					SET lError = 1; 
					SET cError = "Edificio no existe";
					LEAVE consultaEdificio;

			END IF;

			/*Valida que el edificio este activo*/
			IF NOT EXISTS(SELECT * FROM tt_ctEdificios WHERE tt_ctEdificios.lActivo = 1)

				THEN 
					SET lError = 1; 
					SET cError = "Edificio no activo";
					LEAVE consulta;

			END IF;

			SELECT * FROM tt_ctEdificios;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;