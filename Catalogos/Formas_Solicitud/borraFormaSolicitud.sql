 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE borraUsuario(	IN cCreaTicket  VARCHAR(150),
 								IN cUsuarioR VARCHAR(20),
 								OUT lError TINYINT(1), 
 								OUT cSqlState VARCHAR(50), 
 								OUT cError VARCHAR(200))
 	borraUsuario:BEGIN

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

			/*Se valida que el usuarioR exista y este activo*/
			IF NOT EXISTS(SELECT * FROM ctFormaSolicitud WHERE ctFormaSolicitud.cCreaTicket = cUsuarioR
													AND ctFormaSolicitud.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El ticket en el sistema no existe o no esta activo";
					LEAVE borraFormatoSolicitud;

			END IF;

						
			/*Valida que el ticket no este activo*/
			IF NOT EXISTS(SELECT * FROM ctFormaSolicitud WHERE ctFormaSolicitud.cCreaTicket = cCreaTicket 
													AND ctFormaSolicitud.lActivo  = 1)

				THEN 
					SET lError = 1; 
					SET cError = "Usuario ya fue borrado con anterioridad";
					LEAVE borraFormatoSolicitud;

			END IF;

			/*Realiza el borrado logico solo se actualiza el campo lActivo*/
			UPDATE ctFormaSolicitud SET ctFormaSolicitud.lActivo = 0 WHERE ctFormaSolicitud.cCreaTicket = cCreaTicket;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;