/**
 * 
 * Autor: Jennifer Hernandez
 * Fecha: 28/04/2018
 * Descripcion: Procedimiento que actualiza el Estado del Ticket
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
DROP PROCEDURE IF EXISTS `actualizaEstatusTicket`;

DELIMITER //

 CREATE PROCEDURE actualizaEstatusTicket(	IN iIDEstado      INTEGER,
 											IN cEstado    	  VARCHAR(150),
											IN lActivo        TINYINT(1),
 											IN cUsuario       VARCHAR(20),
		 									OUT lError        TINYINT(1), 
		 									OUT cSqlState     VARCHAR(50), 
		 									OUT cError        VARCHAR(200))
 	actualizaEstatusTicket:BEGIN
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
					LEAVE actualizaEstatusTicket;

			END IF;

			/*Verifica que la forma de solicitud exista con anterioridad*/
			IF NOT EXISTS(SELECT * FROM ctEstatusTickets WHERE ctEstatusTickets.iIDEstado = iIDEstado)

				THEN 
					SET lError = 1; 
					SET cError = "Estado del ticket no encontrado";
					LEAVE actualizaEstatusTicket;

			END IF;


			/*Valida campos obligatotios como no nulos o vacios*/
			IF iIDEstado = 0 OR iIDEstado = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Estado no contiene valor";
					LEAVE actualizaEstatusTicket;

			END IF;

            IF cEstado = "" OR cEstado = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El campo Estado no contiene valor";
					LEAVE actualizaEstatusTicket;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/
            IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El usuario no contiene valor";
					LEAVE actualizaEstatusTicket;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE 	ctEstatusTickets
					SET 	ctEstatusTickets.cEstado     	= cEstado,
							ctEstatusTickets.lActivo        = lActivo,
							ctEstatusTickets.dtModificado   = NOW(),
							ctEstatusTickets.cUsuario       = cUsuario
					WHERE 	ctEstatusTickets.iIDEstado 		= iIDEstado;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;

        