
/*USE Senado;*/

/*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE borraBienMaterial(IN iIDBienesMateriales INTEGER(11),
 										IN cUsuario            VARCHAR(50),
		 								OUT lError             TINYINT(1), 
		 								OUT cSqlState          VARCHAR(50), 
		 								OUT cError             VARCHAR(200))
 	borraBienMaterial:BEGIN

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

			/*Valida que el bien exista*/
			IF NOT EXISTS(SELECT * FROM ctBienesMateriales WHERE ctBienesMateriales.iIDBienesMateriales = iIDBienesMateriales)

				THEN 
					SET lError = 1; 
					SET cError = "El bien material no existe";
					LEAVE borraBienMaterial;

			END IF;

			/*Valida que el bien material no este activo*/
			IF NOT EXISTS(SELECT * FROM ctBienesMateriales WHERE ctBienesMateriales.iIDBienesMateriales = iIDBienesMateriales 
													AND ctBienesMateriales.lActivo  = 1)

				THEN 
					SET lError = 1; 
					SET cError = "El registro ya fue borrado con anterioridad";
					LEAVE borraBienMaterial;

			END IF;

			/*Realiza el borrado logico solo se actualiza el campo lActivo*/
			UPDATE ctBienesMateriales SET ctBienesMateriales.lActivo          = 0,
										  ctBienesMateriales.cUsuario         = cUsuario,
                    					  ctBienesMateriales.dtModificado     = NOW() 
                WHERE ctBienesMateriales.iIDBienesMateriales = iIDBienesMateriales;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;