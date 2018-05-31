USE SENADO;
DROP PROCEDURE IF EXISTS `consultaServicio`;
 
 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaServicio(	IN iIDTipoServicio  INTEGER(11),
 									IN iPartida        INTEGER(11),
 									OUT lError TINYINT(1), 
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))
 	consultaServicio:BEGIN
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
			DROP TEMPORARY TABLE IF EXISTS tt_ctServicioSolicitado;

			CREATE TEMPORARY TABLE tt_ctServicioSolicitado LIKE ctServicioSolicitado;

			/*Comprueba si existe el servicio*/
			IF EXISTS(SELECT * FROM ctServicioSolicitado WHERE ctServicioSolicitado.iIDTipoServicio = iIDTipoServicio
															AND ctServicioSolicitado.iPartida       = iPartida)

				/*Si existe copia toda la informacion del servicio a la tabla temporal*/
				THEN INSERT INTO tt_ctServicioSolicitado SELECT * FROM ctServicioSolicitado WHERE ctServicioSolicitado.iIDTipoServicio = iIDTipoServicio AND ctServicioSolicitado.iPartida = iPartida;

				/*Si no manda error de que no lo encontro*/
				ELSE 
					SET lError = 1; 
					SET cError = "Servicio solicitado no existe";
					LEAVE consultaServicio;

			END IF;

			/*Valida que el servicio este activo*/
			IF NOT EXISTS(SELECT * FROM tt_ctServicioSolicitado WHERE tt_ctServicioSolicitado.lActivo = 1)
				THEN 
					SET lError = 1; 
					SET cError = "Servicio solicitado no activo";
					LEAVE consultaServicio;

			END IF;

			SELECT * FROM tt_ctServicioSolicitado;

		COMMIT;

	END;//