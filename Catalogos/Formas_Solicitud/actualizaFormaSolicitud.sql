DELIMITER //

 CREATE PROCEDURE actualizaFormaSolicitud(	IN cCreaTicket    VARCHAR(150),
                                    IN lActivo     TINYINT(1),
                                    IN cUsuario  VARCHAR(20),
 									IN cUsuarioR   VARCHAR(50),
 									OUT lError TINYINT(1), 
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))
 	actualizaFormaSolicitud:BEGIN
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
			IF NOT EXISTS(SELECT * FROM ctformasolicitud WHERE ctformasolicitud.cUsuario = cUsuarioR
													AND ctformasolicitud.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE actualizaFormaSolicitud;

			END IF;

			/*Verifica que el usuario a crear no exista con anterioridad*/
			IF EXISTS(SELECT * FROM ctformasolicitud WHERE ctformasolicitud.cUsuario = cUsuario)

				THEN 
					SET lError = 1; 
					SET cError = "El usuario ya existe";
					LEAVE actualizaFormaSolicitud;

			END IF;


			/*Valida campos obligatotios como no nulos o vacios*/
            IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El usuario no contiene valor";
					LEAVE actualizaFormaSolicitud;

			END IF;

			
            IF cCreaTicket = "" OR cCreaTicket = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "No contiene valor";
					LEAVE actualizaFormaSolicitud;

			END IF;

	/*Realiza la actualizacion*/
			UPDATE ctformasolicitud
				SET ctformasolicitud.cCreaTicket = cCreaTicket,
                    ctformasolicitud.lActivo,
                    ctformasolicitud.cUsuario,
					ctformasolicitud.dtModificado = NOW(),
					ctformasolicitud.cUsuarioR    = cUsuarioR
				WHERE ctformasolicitud.cCreaTicket   = cCreaTicket;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;

        