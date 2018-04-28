
/*USE SENADO;*/

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE borraServicio(IN iIDTipoServicio INTEGER (11),
	 							IN cTipoServicio  VARCHAR(20),
 								OUT lError TINYINT(1), 
 								OUT cSqlState VARCHAR(50), 
 								OUT cError VARCHAR(200))
 	borraServicio:BEGIN

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


			/*Valida que el tipo de servicio exista*/
			IF NOT EXISTS(SELECT * FROM ctTipoServicio WHERE ctTipoServicio.iIDTipoServicio = iIDTipoServicio)

				THEN 
					SET lError = 1; 
					SET cError = "Tipo de servicio no existe";
					LEAVE borraServicio;

			END IF;

			/*Valida que el tipo de servicio no este activo*/
			IF NOT EXISTS(SELECT * FROM ctTipoServicio WHERE ctTipoServicio.iIDTipoServicio = iIDTipoServicio 
													AND ctTipoServicio.lActivo  = 1)

				THEN 
					SET lError = 1; 
					SET cError = "Tipo de servicio ya fue borrado con anterioridad";
					LEAVE borraServicio;

			END IF;

			/*Realiza el borrado logico solo se actualiza el campo lActivo*/
			UPDATE ctTipoServicio SET 
				ctTipoServicio.lActivo       = 0,
				ctTipoServicio.dtModificado  = NOW(),
				iIDTipoServicio.cUsuario = cUsuario,
			 WHERE ctTipoServicio.iIDTipoServicio   = iIDTipoServicio;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;