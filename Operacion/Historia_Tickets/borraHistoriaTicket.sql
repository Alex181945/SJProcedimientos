 
 /*USE Senado;

 DELIMITER //

 CREATE PROCEDURE borraHistoriaTicket(	IN iIDTicket  INTEGER,
                                    	IN iPartida INTEGER,
		 								OUT lError TINYINT(1), 
		 								OUT cSqlState VARCHAR(50), 
		 								OUT cError VARCHAR(200))
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

			IF NOT EXISTS(SELECT * FROM opHistoriaTicket WHERE opHistoriaTicket.iIDTicket = iIDTicket)

				THEN 
					SET lError = 1; 
					SET cError = "El ticket no existe";
					LEAVE borraHistoriaTicket;

			END IF;

			IF NOT EXISTS(SELECT * FROM opHistoriaTicket WHERE opHistoriaTicket.iIDTicket = iIDTicket 
													AND opHistoriaTicket.lActivo  = 1)

				THEN 
					SET lError = 1; 
					SET cError = "El resguardo ya fue borrado con anterioridad";
					LEAVE borraHistoriaTicket;

			END IF;

			UPDATE opHistoriaTicket SET opHistoriaTicket.lActivo = 0 WHERE opHistoriaTicket.iIDTicket = iIDTicket;

		COMMIT;

	END;//
	

 DELIMITER ;*/