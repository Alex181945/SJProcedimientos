 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaBienesMateriales(	IN iIDBienesMateriales INTEGER(11),
 									        OUT lError TINYINT(1), 
 									        OUT cSqlState VARCHAR(50), 
 									        OUT cError VARCHAR(200))
 	consultaBienesMateriales:BEGIN

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

			DROP TEMPORARY TABLE IF EXISTS tt_ctBienesMateriales;

			CREATE TEMPORARY TABLE tt_ctBienesMateriales LIKE iIDBienesMateriales;

			/*Comprueba si existe el bienMaterial*/
			IF EXISTS(SELECT * FROM ctBienesMateriales WHERE ctBienesMateriales.iIDBienesMateriales = iIDBienesMateriales)

				/*Si existe copia toda la informacion a la tabla temporal*/
				THEN INSERT INTO tt_ctBienesMateriales SELECT * FROM ctBienesMateriales WHERE ctBienesMateriales.iIDBienesMateriales = ctBienesMateriales;

				/*Si no manda error de que no lo encontro*/
				ELSE 
					SET lError = 1; 
					SET cError = "El Bien Material no existe";
					LEAVE consultaBienesMateriales;

			END IF;

			/*Valida que el bienMaterial este activo*/
			IF NOT EXISTS(SELECT * FROM tt_ctBienesMateriales WHERE tt_ctBienesMateriales.lActivo = 1)

				THEN 
					SET lError = 1; 
					SET cError = "Bien Material deshabilitado";
					LEAVE consultaBienesMateriales;

			END IF;

			SELECT * FROM tt_ctBienesMateriales;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;