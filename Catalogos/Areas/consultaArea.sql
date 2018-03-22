/**
 * 
 * Autor: Bogar Chavez
 * Fecha: 13/03/2018
 * Descripcion: Procedimiento que consulta y valida area.
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo:  Bogar Chavez 13/03/2018 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */
 
 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaArea(	IN iIDArea INTEGER(20),
	 							IN cArea  VARCHAR(150),
 								OUT lError TINYINT(1), 
 								OUT cSqlState VARCHAR(50), 
 								OUT cError VARCHAR(200))
 	consultaArea:BEGIN

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
			DROP TEMPORARY TABLE IF EXISTS tt_ctAreas;

			CREATE TEMPORARY TABLE tt_ctAreas LIKE ctAreas;

			/*Comprueba si existe el area*/
			IF EXISTS(SELECT * FROM ctAreas WHERE ctAreas.cArea = cArea)

				/*Si existe copia toda la informacion del area a la tabla temporal*/
				THEN INSERT INTO tt_ctAreas SELECT * FROM ctAreas WHERE ctAreas.cArea = cArea;

				/*Si no manda error de que no lo encontro*/
				ELSE 
					SET lError = 1; 
					SET cError = "Área no existe";
					LEAVE consultaArea;

			END IF;

			/*Valida que el area este activo*/
			IF NOT EXISTS(SELECT * FROM tt_ctAreas WHERE tt_ctAreas.lActivo = 1)

				THEN 
					SET lError = 1; 
					SET cError = "Área no activo";
					LEAVE consultaArea;

			END IF;

			SELECT * FROM tt_ctAreas;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;