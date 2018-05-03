USE Senado;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE insertaHistoriaTicket(	IN iPartida INTEGER,
	 										IN cCampoMod    VARCHAR(150),
 									        IN cValorViejo  VARCHAR(150),
 									        IN cValorNuevo  VARCHAR(150),
 		 									IN cObs         TEXT,
                                            IN cUsuario     VARCHAR(20),
 									        OUT lError      TINYINT(1), 
 									        OUT cSqlState   VARCHAR(50), 
 									        OUT cError      VARCHAR(200))

 	/*Nombre del Procedimiento*/
 	insertaHistoriaTicket:BEGIN

 		/*Varibales*/	 
		DECLARE iPartida INT unsigned DEFAULT 0;

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

			/*Variables para control de errores inicializadas*/
			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";
			
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario
													AND ctUsuario.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE insertaHistoriaTicket;

			END IF;

			IF NOT EXISTS(SELECT * FROM opHistoriaTicket WHERE opHistoriaTicket.iIDTicket = iIDTicket)

				THEN
					SET lError = 1; 
					SET cError = "El ticket de servicio no existe";
					LEAVE insertaHistoriaTicket;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/
			IF iIDTicket = 0 OR iIDTicket = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador del ticket no contiene valor";
					LEAVE insertaHistoriaTicket;

			END IF;

			IF cCampoMod = "" OR cCampoMod = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El campo a modificar no contiene valor";
					LEAVE insertaHistoriaTicket;

			END IF;

            IF cValorViejo = "" OR cValorViejo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El valor viejo no contiene valor";
					LEAVE insertaHistoriaTicket;

			END IF;

			IF cValorNuevo = "" OR cValorNuevo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El valor nuevo no contiene valor";
					LEAVE insertaHistoriaTicket;

			END IF;

			/*Realiza el autoincremental por ticket*/
			SELECT MAX(opHistoriaTicket.iPartida) INTO iPartida FROM opHistoriaTicket 
				WHERE opHistoriaTicket.iIDTicket = iIDTicket;

			IF iPartida = 0

				THEN SET iPartida = 1;
				ELSE SET iPartida = iPartida + 1;

			END IF;

			
			/*Insercion del resguardo*/
			INSERT INTO opHistoriaTicket (  opHistoriaTicket.iPartida, 
											opHistoriaTicket.cCampoMod, 
											opHistoriaTicket.cValorViejo, 
											opHistoriaTicket.cValorNuevo, 
											opHistoriaTicket.cObs, 
											opHistoriaTicket.dtFecha,
											opHistoriaTicket.cUsuario,
											opHistoriaTicket.lActivo) 
								VALUES	(	iPartida,
											cCampoMod,
											cValorViejo,
											cValorNuevo,
											cObs,
		                                    NOW(),
											cUsuario,
											1);

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;