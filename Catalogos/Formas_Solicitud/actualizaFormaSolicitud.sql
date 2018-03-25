/**
 * 
 * Autor: Jennifer Hernandez
 * Fecha: 25/03/2018
 * Descripcion: Procedimiento que actualiza el registro
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

DELIMITER //

 CREATE PROCEDURE actualizaFormaSolicitud(	IN iIDCreaTicket  INTEGER(11),
 											IN cCreaTicket    VARCHAR(150),
											IN lActivo        TINYINT(1),
 											IN cUsuario       VARCHAR(20),
		 									OUT lError        TINYINT(1), 
		 									OUT cSqlState     VARCHAR(50), 
		 									OUT cError        VARCHAR(200))
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
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario
													AND ctUsuario.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE actualizaFormaSolicitud;

			END IF;

			/*Verifica que la forma de solicitud exista con anterioridad*/
			IF NOT EXISTS(SELECT * FROM ctformasolicitud WHERE ctformasolicitud.iIDCreaTicket = iIDCreaTicket)

				THEN 
					SET lError = 1; 
					SET cError = "Forma de solicitud no encontrada";
					LEAVE actualizaFormaSolicitud;

			END IF;


			/*Valida campos obligatotios como no nulos o vacios*/
			IF iIDCreaTicket = 0 OR iIDCreaTicket = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de la forma de solicitud no contiene valor";
					LEAVE actualizaFormaSolicitud;

			END IF;

            IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El usuario no contiene valor";
					LEAVE actualizaFormaSolicitud;

			END IF;

			
            IF cCreaTicket = "" OR cCreaTicket = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "La forma de solicitud no contiene valor";
					LEAVE actualizaFormaSolicitud;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE ctformasolicitud
				SET ctformasolicitud.cCreaTicket     = cCreaTicket,
                    ctformasolicitud.lActivo         = lActivo,
					ctformasolicitud.dtModificado    = NOW(),
					ctformasolicitud.cUsuario        = cUsuario
				WHERE ctformasolicitud.iIDCreaTicket = iIDCreaTicket;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;

        