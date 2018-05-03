
USE Senado;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE actualizaTicket(	IN iIDEstado       INTEGER(11),
 									IN cNumInventario  VARCHAR(50),
 									IN cResguardante   VARCHAR(50),
 									IN cUsuarioEquipo  VARCHAR(50),
 									IN cExtension      VARCHAR(50),
 									IN iIDEdificio     INTEGER(11),
 									IN cPiso           VARCHAR(10),
 									IN cOficina        VARCHAR(100),
 									IN iIDTipoServicio INTEGER(11),
 									IN cUsuarioReporta VARCHAR(50),
 									IN cObs            TEXT,
 									IN iIDCreaTicket   INTEGER(11),
 									IN iIDCriticidad   INTEGER(11),
 									IN cTecnico        VARCHAR(20),
 									IN lTecnicoAcepta  TINYINT(1),
 									IN lNotificacion   TINYINT(1),
 									IN lArrendado      TINYINT(1),
 									IN cUsuarioR       VARCHAR(50),
 									OUT lError          TINYINT(1), 
 									OUT cSqlState       VARCHAR(50), 
 									OUT cError          VARCHAR(200))

 	/*Nombre del Procedimiento*/
 	actualizaTicket:BEGIN

		/*Manejo de Errores*/ 
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1
  			@e1 = RETURNED_SQLSTATE, @e2 = MESSAGE_TEXT;
			SET lError    = 1;
			SET cSqlState = CONCAT("SqlState: ", @e1);
			SET cError    = CONCAT("Exepxcion: ", @e2);
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

			/*Variables para control de errores inicializadas*/
			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";

			/*Valida el usuario que crea el registro*/
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE actualizaTicket;

			END IF;

			

			/*Valida campos obligatotios como no nulos o vacios*/
			IF iIDTicket = 0 OR iIDTicket = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Ticket no contiene valor";
					LEAVE actualizaTicket;

			END IF;

            IF iIDEstado = 0 OR iIDEstado = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Estado no contiene valor";
					LEAVE actualizaTicket;

			END IF;

            IF cNumInventario = "" OR cNumInventario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El número de inventario no contiene valor";
					LEAVE actualizaTicket;

			END IF;

            IF cResguardante = "" OR cResguardante = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El campo Resguardante no contiene valor";
					LEAVE actualizaTicket;
					

			END IF;

            IF cUsuarioEquipo = "" OR cUsuarioEquipo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El usuario del equipo no contiene valor";
					LEAVE actualizaTicket;
					

			END IF;

            IF cExtension = "" OR cExtension = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "La extensión no contiene valor";
					LEAVE actualizaTicket;
					
			END IF;


			IF iIDEdificio = 0 OR iIDEdificio = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Edificio no contiene valor";
					LEAVE actualizaTicket;

			END IF;

			IF cPiso = "" OR cPiso = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El piso no contiene valor";
					LEAVE actualizaTicket;

			END IF;

			IF cOficina = "" OR cOficina = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "EL campo oficina no cuenta con algún valor";
					LEAVE actualizaTicket;

			END IF;

			IF iIDTipoServicio = 0 OR iIDTipoServicio = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Tipo de Servicio no contiene valor";
					LEAVE actualizaTicket;

			END IF;

            IF cUsuarioReporta = "" OR cUsuarioReporta = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El campo de usuario reporta no contiene valor";
					LEAVE actualizaTicket;

			END IF;


			IF iIDCreaTicket = 0 OR iIDCreaTicket = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de crea ticket no contiene valor";
					LEAVE actualizaTicket;

			END IF;

			IF iIDCriticidad = 0 OR iIDCriticidad = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Criticidad no contiene valor";
					LEAVE actualizaTicket;

			END IF;

			IF cTecnico = "" OR cTecnico = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Tecnico no contiene valor";
					LEAVE actualizaTicket;

			END IF;

            IF lTecnicoAcepta = 0 OR lTecnicoAcepta = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El campo Tecnico Acepta no contiene valor";
					LEAVE actualizaTicket;

			END IF;

			IF lNotificacion = 0 OR lNotificacion = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El campo Notificación no contiene valor";
					LEAVE actualizaTicket;

			END IF;

            IF lArrendado = 0 OR lArrendado = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Arrendado no contiene valor";
					LEAVE actualizaTicket;

			END IF;

			IF cUsuarioR = "" OR cUsuarioR = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El usuarioR no contiene valor";
					LEAVE actualizaTicket;

			END IF;

			IF lActivo = 0 OR lActivo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Activo no contiene valor";
					LEAVE actualizaTicket;

			END IF;

			/*Validacion de las claves foraneas*//*Aqui tengo duda :c*/
			IF NOT EXISTS(SELECT * FROM ctPerfil WHERE ctPerfil.iPerfil  = iPerfil
												AND ctPerfil.lActivo = 1 )

			THEN
				SET lError = 1; 
				SET cError = "El perfil seleccionado no existe o no esta activo";
				LEAVE actualizaTicket;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE opTickets
				SET opTickets.iIDEstado        = iIDEstado,
                    opTickets.cNumInventario   = cNumInventario,
                    opTickets.cResguardante    = cResguardante,
                    opTickets.cUsuarioEquipo   = cUsuarioEquipo,
                    opTickets.cExtension       = cExtension,
                    opTickets.iIDEdificio      = iIDEdificio,
					opTickets.cPiso            = cPiso,
					opTickets.cOficina         = cOficina,
					opTickets.iIDTipoServicio  = iIDTipoServicio,
					opTickets.cUsuReporta      = cUsuReporta,
					opTickets.cObs             = cObs,
					opTickets.iIDCreaTicket    = iIDCreaTicket,
					opTickets.iIDCriticidad    = iIDCriticidad,
					opTickets.cTecnico         = cTecnico,
                    opTickets.lTecnicoAcepta   = lTecnicoAcepta,
                    opTickets.lNotificacion    = lNotificacion,
                    opTickets.lArrendado       = lArrendado,
                    opTickets.cUsuarioR		   = cUsuarioR,
					opTickets.dtModificado     = NOW(),
					opTickets.lActivo          = lActivo
					WHERE opTickets.iIDTicket  = iIDTicket;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;