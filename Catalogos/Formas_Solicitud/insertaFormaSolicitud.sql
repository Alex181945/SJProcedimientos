DELIMITER //

 CREATE PROCEDURE consultaFormaSolicitud(   IN iIDCreaTicket INTEGER,
                                            IN cCreaTicket VARCHAR(150),
                                            IN cUsuario VARCHAR(50),
                                            OUT lError     TINYINT(1), 
                                            OUT cSqlState  VARCHAR(50), 
                                            OUT cError     VARCHAR(200)
 								            )

 	/*Nombre del Procedimiento*/
 	insertaFormaSolicitud:BEGIN

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
			IF NOT EXISTS(SELECT * FROM ctformasolicitud WHERE ctformasolicitud.cUsuario = cUsuarioR
													AND ctformasolicitud.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE insertaFormaSolicitud;

			END IF;

			/*Verifica que el usuario a crear no exista con anterioridad*/
			IF EXISTS(SELECT * FROM ctformasolicitud WHERE ctformasolicitud.cUsuario = cUsuario)

				THEN 
					SET lError = 1; 
					SET cError = "El usuario ya existe";
					LEAVE insertaFormaSolicitud;

			END IF;


			/*Valida campos obligatotios como no nulos o vacios*/
            IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El usuario no contiene valor";
					LEAVE insertaFormaSolicitud;

			END IF;

			
            IF cCreaTicket = "" OR cCreaTicket = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "No contiene valor";
					LEAVE insertaFormaSolicitud;

			END IF;
           

/*Insercion del usuario*/
			INSERT INTO ctformasolicitud (	ctformasolicitud.cCreaTicket,
                                    ctformasolicitud.lActivo,
                                    ctformasolicitud.cUsuario, 									 
									ctformasolicitud.dtCreado, 
									ctUsuario.cUsuarioR) 
						VALUES	(	cCreaTicket,
									lActivo,
									cUsuario,
									1,
									NOW(),
									cUsuarioR);


	

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;