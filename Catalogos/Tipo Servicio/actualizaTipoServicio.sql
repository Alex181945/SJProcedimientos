
/*USE SENADO;*/

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE actualizaServicio(IN iIDTipoServicio INTEGER(11),
	 								IN cTipoServicio VARCHAR (50),
 									IN lActivo     TINYINT(1),
									IN cUsuario  VARCHAR(20), 									
 									OUT lError TINYINT(1), 
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))
 	actualizaServicio:BEGIN

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
			
			/*Se valida que el TipoServicio exista y este activo*/
			IF NOT EXISTS(SELECT * FROM ctTipoServicio WHERE ctTipoServicio.cTipoServicio = cTipoServicio
													AND ctTipoServicio.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El tipo de servicio del sistema no existe o no esta activo";
					LEAVE actualizaUsuario;

			END IF;

			/*Valida que el Servicio exista*/
			IF NOT EXISTS(SELECT * FROM ctTipoServicio WHERE ctTipoServicio.iIDTipoServicio = iIDTipoServicio)

				THEN 
					SET lError = 1; 
					SET cError = "Tipo de servicio no existe";
					LEAVE actualizaUsuario;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/
			IF cTipoServicio = "" OR cTipoServicio = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El Servicio no contiene valor";
					LEAVE actualizaUsuario;

			END IF;

			IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Usuario no contiene valor";
					LEAVE actualizaUsuario;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE ctTipoServicio
				SET ctTipoServicio.cUsuario     = cTipoServicio,
					ctTipoServicio.lActivo      = lActivo,
					ctTipoServicio.dtModificado = NOW(),
					ctTipoServicio.cUsuario    = cUsuario
				WHERE ctTipoServicio.iIDTipoServicio   = iIDTipoServicio;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;