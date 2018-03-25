DELIMITER //

 CREATE PROCEDURE consultaFormaSolicitud(   IN cCreaTicket VARCHAR(150),
	                                        IN lActivo BOOL,
	                                        IN cUsuario VARCHAR(50),
                                            OUT lError     TINYINT(1), 
                                            OUT cSqlState  VARCHAR(50), 
                                            OUT cError     VARCHAR(200)
 								            )

 	/*Nombre del Procedimiento*/
 	consultaFormaSolicitud:BEGIN

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
        

			CREATE TEMPORARY TABLE tt_ctFormaSolicitud LIKE ctFormaSolicitud;

			IF EXISTS(SELECT * FROM ctFormaSolicitud WHERE ctFormaSolicitud.iIDCreaTicket = iIDCreaTicket)

				/*Si existe copia toda la informacion del usuario a la tabla temporal*/
				THEN INSERT INTO tt_ctFormaSolicitud SELECT * FROM ctFormaSolicitud WHERE ctFormaSolicitud.iIDCreaTicket = iIDCreaTicket;

				/*Si no manda error de que no lo encontro*/
				ELSE 
					SET lError = 1; 
					SET cError = "No hay solicitudes";
					LEAVE consultaFormaSolicitud;

			END IF;

			/*Valida que el usuario este activo*/
			IF NOT EXISTS(SELECT * FROM tt_ctFormaSolicitud WHERE tt_ctFormaSolicitud.lActivo = 1)

				THEN 
					SET lError = 1; 
					SET cError = "Formato no activo";
					LEAVE consultaFormaSolicitud;

			END IF;

			SELECT * FROM tt_ctFormaSolicitud;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;