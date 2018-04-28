
USE SENADO;

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
			
			/*Se valida que el usuario exista y este activo*/
			IF NOT EXISTS(SELECT * FROM cttiposervicio WHERE cttiposervicio.cUsuario = cUsuario
													AND cttiposervicio.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE actualizaServicio;

			END IF;

			/*Valida que el Servicio exista*/
			IF NOT EXISTS(SELECT * FROM cttiposervicio WHERE cttiposervicio.iIDTipoServicio = iIDTipoServicio)

				THEN 
					SET lError = 1; 
					SET cError = "Tipo de servicio no existe";
					LEAVE actualizaServicio;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/
			IF cTipoServicio = "" OR cTipoServicio = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El Servicio no contiene valor";
					LEAVE actualizaServicio;

			END IF;

			IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Usuario no contiene valor";
					LEAVE actualizaServicio;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE cttiposervicio
				SET cttiposervicio.cTipoServicio    = cTipoServicio,
					cttiposervicio.lActivo      	= lActivo,
					cttiposervicio.dtModificado 	= NOW(),
					cttiposervicio.cUsuario    		= cUsuario
				WHERE cttiposervicio.iIDTipoServicio   = iIDTipoServicio;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;