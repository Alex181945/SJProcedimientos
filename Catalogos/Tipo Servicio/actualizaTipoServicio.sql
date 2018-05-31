
/*USE SENADO;*/

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE actualizaServicio(IN iIDTipoServicio INTEGER,
	 								IN cTipoServicio VARCHAR (150),
 									IN lActivo     TINYINT(1),
									IN cUsuario  VARCHAR(50), 									
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
			
			/*Valida el usuario que crea el registro*/
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario
													AND ctUsuario.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE actualizaServicio;

			END IF;

			/*Se valida que el TipoServicio exista y este activo*/
			IF NOT EXISTS(SELECT * FROM ctTipoServicio WHERE ctTipoServicio.iIDTipoServicio = iIDTipoServicio
													AND ctTipoServicio.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El tipo de servicio del sistema no existe o no esta activo";
					LEAVE actualizaServicio;

			END IF;

			IF NOT EXISTS(SELECT * FROM ctTipoServicio WHERE ctTipoServicio.iIDTipoServicio = iIDTipoServicio
													AND ctTipoServicio.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El área del sistema no existe o no esta activo";
					LEAVE actualizaServicio;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/

			IF iIDTipoServicio = 0 OR iIDTipoServicio = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Servicio no contiene valor";
					LEAVE actualizaServicio;
			END IF;

			IF cTipoServicio = "" OR cTipoServicio = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El Servicio no contiene valor";
					LEAVE actualizaServicio;

			END IF;

			IF lActivo = 0 OR lActivo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Activo no contiene valor";
					LEAVE actualizaServicio;

			END IF;


			IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Usuario no contiene valor";
					LEAVE actualizaServicio;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE ctTipoServicio
				SET ctTipoServicio.cTipoServicio = cTipoServicio,
					ctTipoServicio.lActivo       = lActivo,
					ctTipoServicio.dtModificado  = NOW(),
					ctTipoServicio.cUsuario      = cUsuario
				WHERE ctTipoServicio.iIDTipoServicio   = iIDTipoServicio;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;