/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 31/03/2018
 * Descripcion: Procedimiento para insertar tickets
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
 DROP PROCEDURE IF EXISTS `insertaTicket`;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE insertaTicket(	
 									IN iIDEstado       INTEGER(11),
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
 									OUT lError         TINYINT(1), 
 									OUT cSqlState      VARCHAR(50), 
 									OUT cError         VARCHAR(200))
 	insertaTicket:BEGIN

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

			/*Validacion de campos obligatorios*/
			IF iIDEstado = 0 OR iIDEstado = NULL

				THEN
					SET lError = 1;
					SET cError = "El estatus del ticke no contiene valor";
					LEAVE insertaTicket;

			END IF;

			IF iIDEdificio = 0 OR iIDEdificio = NULL

				THEN
					SET lError = 1;
					SET cError = "El edificio no contiene valor";
					LEAVE insertaTicket;

			END IF;

			IF cPiso = "" OR cPiso = NULL

				THEN
					SET lError = 1;
					SET cError = "El piso no contiene valor";
					LEAVE insertaTicket;

			END IF;

			IF cOficina = "" OR cOficina = NULL

				THEN
					SET lError = 1;
					SET cError = "La oficina no contiene valor";
					LEAVE insertaTicket;

			END IF;

			IF iIDTipoServicio = 0 OR iIDTipoServicio = NULL

				THEN
					SET lError = 1;
					SET cError = "El tipo de servicio no contiene valor";
					LEAVE insertaTicket;

			END IF;

			IF cUsuarioReporta = "" OR cUsuarioReporta = NULL

				THEN
					SET lError = 1;
					SET cError = "El edificio no contiene valor";
					LEAVE insertaTicket;

			END IF;

			IF lNotificacion = 0 OR lNotificacion = NULL

				THEN
					SET lError = 1;
					SET cError = "La notificacion no contiene valor";
					LEAVE insertaTicket;

			END IF;

			IF lArrendado = 0 OR lArrendado = NULL

				THEN
					SET lError = 1;
					SET cError = "Arrendado no contiene valor";
					LEAVE insertaTicket;

			END IF;

			IF cUsuarioR = "" OR cUsuarioR = NULL

				THEN
					SET lError = 1;
					SET cError = "El usuario del sistema no contiene valor";
					LEAVE insertaTicket;

			END IF;

			/*Validacion de claves foraneas*/

			IF NOT EXISTS(SELECT * FROM ctEstatusTickets WHERE ctEstatusTickets.iIDEstado = iIDEstado
															AND ctEstatusTickets.lActivo = 1)
				THEN
					SET lError = 1;
					SET cError = "El estatus del ticket no existe o no esta activo";
					LEAVE insertaTicket;

			END IF;

			IF NOT EXISTS(SELECT * FROM ctEdificios WHERE ctEdificios.iIDEdificio = iIDEdificio
															AND ctEdificios.lActivo = 1)
				THEN
					SET lError = 1;
					SET cError = "El edificio no existe o no esta activo";
					LEAVE insertaTicket;

			END IF;

			IF NOT EXISTS(SELECT * FROM ctTipoServicio WHERE ctTipoServicio.iIDTipoServicio = iIDTipoServicio
															AND ctTipoServicio.lActivo = 1)
				THEN
					SET lError = 1;
					SET cError = "El tipo de servicio no existe o no esta activo";
					LEAVE insertaTicket;

			END IF;

			IF NOT EXISTS(SELECT * FROM ctCriticidad WHERE ctCriticidad.iIDCriticidad = iIDCriticidad
															AND ctCriticidad.lActivo = 1)
				THEN
					SET lError = 1;
					SET cError = "La criticidad no existe o no esta activo";
					LEAVE insertaTicket;

			END IF;

			IF NOT EXISTS(SELECT * FROM ctFormaSolicitud WHERE ctFormaSolicitud.iIDCreaTicket = iIDCreaTicket
															AND ctFormaSolicitud.lActivo = 1)
				THEN
					SET lError = 1;
					SET cError = "La forma de solicitud no existe o no esta activo";
					LEAVE insertaTicket;

			END IF;


			/*Inserta registro*/
			INSERT INTO opTickets (
									opTickets.iIDEstado,
									opTickets.cNumInventario,
									opTickets.cResguardante,
									opTickets.cUsuarioEquipo,
									opTickets.cExtension,
									opTickets.iIDEdificio,
									opTickets.cPiso,
									opTickets.cOficina,
									opTickets.iIDTipoServicio,
									opTickets.cUsuarioReporta,
									opTickets.cObs,
									opTickets.iIDCreaTicket,
									opTickets.iIDCriticidad,
									opTickets.cTecnico,
									opTickets.lTecnicoAcepta,
									opTickets.lNotificacion,
									opTickets.lArrendado,
									opTickets.cUsuarioR,
									opTickets.dtFecha
								)
							VALUES(
								iIDEstado,
								cNumInventario,
								cResguardante,
								cUsuarioEquipo,
								cExtension,
								iIDEdificio,
								cPiso,
								cOficina,
								iIDTipoServicio,
								cUsuarioReporta,
								cObs,
								iIDCreaTicket,
								iIDCriticidad,
								cTecnico,
								lTecnicoAcepta,
								lNotificacion,
								lArrendado,
								cUsuarioR,
								NOW()
								);


		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;