
/*USE Senado;*/

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaHistoriaTicket(   IN iIDTicket INTEGER,
                                            IN iPartida INTEGER,
                                            OUT lError TINYINT(1), 
 									        OUT cSqlState VARCHAR(50), 
 									        OUT cError VARCHAR(200))
 	consultaHistoriaTicket:BEGIN

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

			/*Crea una tabla temporal con la estructura de la tabla
			 *especificada despues del LIKE
			 */
			

			CREATE TEMPORARY TABLE tt_opHistoriaTicket LIKE pHistoriaTicket;

			/*Comprueba si existe el ticket*/
			IF EXISTS(SELECT * FROM opHistoriaTicket WHERE opHistoriaTicket.iIDTicket = iIDTicket
														AND opHistoriaTicket.iPartida = iPartida)

				/*Si existe copia toda la informacion del usuario a la tabla temporal*/
				THEN INSERT INTO tt_opHistoriaTicket SELECT * FROM opHistoriaTicket 
					WHERE opHistoriaTicket.iIDTicket = iIDTicket AND opHistoriaTicket.iPartida = iPartida;

				/*Si no manda error de que no lo encontro*/
				ELSE 
					SET lError = 1; 
					SET cError = "El ticket no existe";
					LEAVE consultaHistoriaTicket;

			END IF;

			SELECT * FROM tt_opHistoriaTicket;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;