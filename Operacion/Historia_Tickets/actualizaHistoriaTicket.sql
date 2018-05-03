/**
 * 
 * Autor: 
 * Fecha: 11/03/2018
 * Descripcion: Procedimiento que actualiza el registro
 * de un edificio
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Bogar Chavez 11/03/2018 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Para pruebas*/
USE SENADO;
 /*DROP PROCEDURE IF EXISTS `actualizaHistoriaTicket`;*/

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE actualizaHistoriaTicket(IN iPartida INTEGER,
 									IN cCampoMod VARCHAR(150) ,
 									IN cValorViejo VARCHAR(150),
									IN cValorNuevo VARCHAR(150),
									IN cObs TEXT,
									IN cUsuario VARCHAR(50) ,
 									OUT lError TINYINT(1), 
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))
 	actualizaHistoriaTicket:BEGIN

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
			
			/*Valida que el edificio exista*/
			IF NOT EXISTS(SELECT * FROM opHistoriaTicket WHERE opHistoriaTicket.iIDTicket = iIDTicket)

				THEN 
					SET lError = 1; 
					SET cError = "El Edificio no existe";
					LEAVE actualizaHistoriaTicket;

			END IF;

			/*Valida que el edificio no este activo*/
			IF NOT EXISTS(SELECT * FROM opHistoriaTicket WHERE opHistoriaTicket.iIDTicket = iIDTicket 
													AND opHistoriaTicket.lActivo  = 1)

				THEN 
					SET lError = 1; 
					SET cError = "El edificio ya fue borrado con anterioridad";
					LEAVE actualizaHistoriaTicket;

			END IF;

			IF iIDTicket = 0 OR iIDTicket = NULL

				THEN 
					SET lError = 1;
					SET cError = "El identificador de Ticket no tiene valor";
					LEAVE actualizaHistoriaTicket;

			END IF;
            
            IF iPartida = "" OR iPartida = NULL

				THEN 
					SET lError = 1;
					SET cError = "Partida no tiene valor";
					LEAVE actualizaHistoriaTicket;

			END IF;

			IF cCampoMod = "" OR cCampoMod = NULL

				THEN 
					SET lError = 1;
					SET cError = "El campo mod no contine un valor";
					LEAVE actualizaHistoriaTicket;
			END IF;

			IF cValorViejo = "" OR cValorViejo = NULL

				THEN 
					SET lError = 1;
					SET cError = "El valor viejo no tiene valor";
					LEAVE actualizaHistoriaTicket;
			END IF;

			IF cValorNuevo = "" OR cValorNuevo = NULL

				THEN 
					SET lError = 1;
					SET cError = "El Valor Nuevo no tiene valor";
					LEAVE actualizaHistoriaTicket;
			END IF;

			IF cMunicipio = "" OR cMunicipio = NULL

				THEN 
					SET lError = 1;
					SET cError = "El Municipio no tiene valor";
					LEAVE actualizaHistoriaTicket;
			END IF;

			IF cObs = "" OR cObs = NULL

				THEN 
					SET lError = 1;
					SET cError = "El campo observación no tiene valor";
					LEAVE actualizaHistoriaTicket;
			END IF;

			IF cUsuario = "" OR cUsuario = NULL

				THEN 
					SET lError = 1;
					SET cError = "El campo usuario no tiene valor";
					LEAVE actualizaHistoriaTicket;
			END IF;

            IF lActivo = 0 OR lActivo = NULL

				THEN 
					SET lError = 1;
					SET cError = "El campo usuario no tiene valor";
					LEAVE actualizaHistoriaTicket;
			END IF;


			/*Realiza la actualizacion*/
			UPDATE opHistoriaTickets
				SET opHistoriaTickets.iPartida     = iPartida,
					opHistoriaTickets.cCampoMod    = cCampoMod,
					opHistoriaTickets.cValorViejo  = cValorViejo,
					opHistoriaTickets.cValorNuevo  = cValorNuevo,
					opHistoriaTickets.cObs         = cObs,
					opHistoriaTickets.dtFecha      = NOW(),
					opHistoriaTickets.lActivo       = lActivo,
					opHistoriaTickets.cUsuario      = cUsuario
				WHERE opHistoriaTickets.iIDTicket = iIDTicket;
				
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;