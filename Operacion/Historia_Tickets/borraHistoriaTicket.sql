USE Senado;

 DELIMITER //

 CREATE PROCEDURE borraHistoriaTicket(	IN iIDTicket INTEGER,
                                    	IN iPartida  INTEGER,
										IN cUsuario  VARCHAR(50),
		 								OUT lError   TINYINT(1), 
		 								OUT cSqlState VARCHAR(50), 
		 								OUT cError    VARCHAR(200))
 	borraHistoriaTicket:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1
  			@e1 = RETURNED_SQLSTATE, @e2 = MESSAGE_TEXT;
			SET lError    = 1;
			SET cSqlState = CONCAT("SqlState: ", @e1);
			SET cError    = CONCAT("Exepcion: ", @e2);
			ROLLBACK;
		END; 

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

			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";

			/*Valida el usuario que crea el registro*/
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario
													AND ctUsuario.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE borraHistoriaTicket;

			END IF;
						
			/*Realiza el borrado logico solo se actualiza el campo lActivo*/
			UPDATE opHistoriaTicket SET opHistoriaTicket.lActivo        = 0,
									    opHistoriaTicket.dtModificado   = NOW(),
                						opHistoriaTicket.cUsuario       = cUsuario
            WHERE opHistoriaTicket.iIDTicket = iIDTicket;

		COMMIT;

	END;//
	

 DELIMITER ;*/