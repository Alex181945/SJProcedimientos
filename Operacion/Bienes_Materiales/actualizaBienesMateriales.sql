
/*USE Senado;*/

 DELIMITER //

 CREATE PROCEDURE actualizaBienesMateriales(	IN iIDBienesMateriales INTEGER(11),
 												IN iIDEdificio         INTEGER(11),
 												IN cPiso               VARCHAR(10),
	 									        IN cOficina            VARCHAR(100),
	 									        IN cResguardante       VARCHAR(50),
	 									        IN iIDArea             INTEGER(11),
 									        	IN iIDSubArea          INTEGER(11),
	 									        IN cResponsable        VARCHAR(50),
	 									        IN cFactura            VARCHAR(100),
	 									        IN cObs                TEXT,
	                                            IN lActivo             TINYINT(1),
	 									        IN cUsuario            VARCHAR(50),
	 									        OUT lError             TINYINT(1), 
	 									        OUT cSqlState          VARCHAR(50), 
	 									        OUT cError             VARCHAR(200)
 								        )
 	actualizaBienesMateriales:BEGIN

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
			
			/*Valida que el usuario exista*/
			IF NOT EXISTS(SELECT * FROM ctBienesMateriales WHERE ctBienesMateriales.iIDBienesMateriales = iIDBienesMateriales)

				THEN 
					SET lError = 1; 
					SET cError = "El Bien material no existe";
					LEAVE actualizaBienesMateriales;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/
			

			IF iIDEdificio = 0 OR iIDEdificio = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El edificio no contiene valor";
					LEAVE actualizaBienesMateriales;

			END IF;


			IF cPiso = "" OR cPiso = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El piso no contiene valor";
					LEAVE actualizaBienesMateriales;

			END IF;

			IF cOficina = "" OR cOficina = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "La oficina no contiene valor";
					LEAVE actualizaBienesMateriales;

			END IF;

			IF iIDArea = 0 OR iIDArea = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El area no contiene valor";
					LEAVE actualizaBienesMateriales;

			END IF;

			IF iIDSubArea = 0 OR iIDSubArea = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "La sub-area no contiene valor";
					LEAVE actualizaBienesMateriales;

			END IF;

			IF cResguardante = "" OR cResguardante = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El resguardante no contiene valor";
					LEAVE actualizaBienesMateriales;
					

			END IF;

			IF cResponsable = "" OR cResponsable = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El responsable no contiene valor";
					LEAVE actualizaBienesMateriales;

			END IF;

			IF cFactura = "" OR cFactura = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Factura no contiene valor";
					LEAVE actualizaBienesMateriales;

			END IF;

            IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Usuario no contiene valor";
					LEAVE actualizaBienesMateriales;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE ctBienesMateriales
				SET ctBienesMateriales.iIDEdificio      = iIDEdificio,
					ctBienesMateriales.cPiso            = cPiso,
					ctBienesMateriales.cOficina         = cOficina,
					ctBienesMateriales.iIDArea          = iIDArea,
					ctBienesMateriales.iIDSubArea       = iIDSubArea,
					ctBienesMateriales.cResguardante    = cResguardante,
					ctBienesMateriales.cResponsable     = cResponsable,
					ctBienesMateriales.cFactura         = cFactura,
					ctBienesMateriales.cObs             = cObs,
					ctBienesMateriales.lActivo          = lActivo,
                    ctBienesMateriales.cUsuario         = cUsuario,
                    ctBienesMateriales.dtModificado     = NOW()
				WHERE ctBienesMateriales.iIDBienesMateriales   = iIDBienesMateriales;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;