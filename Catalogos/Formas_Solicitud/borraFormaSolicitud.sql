/**
 * 
 * Autor: Jennifer Hernandez
 * Fecha: 25/03/2018
 * Descripcion: Procedimiento que borra el registro
 * de una forma de solicitud
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alejandro Estrada 09/09/2017 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Para pruebas*/
/*USE SENADO;*/

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE borraFormatoSolicitud(	IN iIDCreaTicket  INTEGER(11),
			 								IN cUsuario       VARCHAR(20),
			 								OUT lError        TINYINT(1), 
			 								OUT cSqlState     VARCHAR(50), 
			 								OUT cError        VARCHAR(200))
 	borraFormatoSolicitud:BEGIN

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
					LEAVE borraFormatoSolicitud;

			END IF;

						
			/*Valida que el ticket no este activo*/
			IF NOT EXISTS(SELECT * FROM ctFormaSolicitud WHERE ctFormaSolicitud.iIDCreaTicket = iIDCreaTicket 
														AND ctFormaSolicitud.lActivo  = 1)

				THEN 
					SET lError = 1; 
					SET cError = "La forma de solicitud ya fue borrado con anterioridad";
					LEAVE borraFormatoSolicitud;

			END IF;

			/*Realiza el borrado logico solo se actualiza el campo lActivo*/
			UPDATE ctFormaSolicitud SET ctFormaSolicitud.lActivo       = 0,
										ctFormaSolicitud.dtModificado  = NOW(),
                						ctFormaSolicitud.cUsuario      = cUsuario
                 WHERE ctFormaSolicitud.iIDCreaTicket = iIDCreaTicket;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;