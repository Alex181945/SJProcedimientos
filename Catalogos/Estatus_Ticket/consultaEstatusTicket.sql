/**
 * 
 * Autor: Jennifer Hernandez
 * Fecha: 28/04/2018
 * Descripcion: Procedimiento que consulta el Estado de Ticket
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alejandro Estrada 09/09/2017 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Para pruebas*/
USE SENADO;
DROP PROCEDURE IF EXISTS `consultaEstatusTicket`;

DELIMITER //

 CREATE PROCEDURE consultaEstatusTicket (   IN iIDEstado   INTEGER,
                                            OUT lError     TINYINT(1), 
                                            OUT cSqlState  VARCHAR(50), 
                                            OUT cError     VARCHAR(200)
 								        )

 	/*Nombre del Procedimiento*/
 	consultaEstatusTicket:BEGIN

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
        
        	DROP TEMPORARY TABLE IF EXISTS tt_ctEstatusTickets;

			CREATE TEMPORARY TABLE tt_ctEstatusTickets LIKE ctEstatusTickets;

			IF EXISTS(SELECT * FROM ctEstatusTickets WHERE ctEstatusTickets.iIDEstado = iIDEstado)

				/*Si existe copia toda la informacion del usuario a la tabla temporal*/
				THEN INSERT INTO tt_ctEstatusTickets SELECT * FROM ctEstatusTickets WHERE ctEstatusTickets.iIDEstado = iIDEstado;

				/*Si no manda error de que no lo encontro*/
				ELSE 
					SET lError = 1; 
					SET cError = "No hay información respecto al Estado del Ticket";
					LEAVE consultaEstatusTicket;

			END IF;

			/*Valida que el ticket este activo*/
			/*IF NOT EXISTS(SELECT * FROM tt_ctEstatusTickets WHERE tt_ctEstatusTickets.lActivo = 1)

				THEN 
					SET lError = 1; 
					SET cError = "Estado de activo no activo";
					LEAVE consultaEstatusTicket;

			END IF;*/

			SELECT * FROM tt_ctEstatusTickets;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;