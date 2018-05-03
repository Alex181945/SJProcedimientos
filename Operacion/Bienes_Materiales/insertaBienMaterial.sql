
/*USE senado;*/

DELIMITER //

 CREATE PROCEDURE insertaBienMaterial(	IN iIDEdificio      INTEGER,
	 									IN cPiso            VARCHAR(10),
 									    IN cOficina         VARCHAR(100),
 									    IN iIDArea          INTEGER,
 									    IN iIDSubArea       INTEGER,
 									    IN cResguardante    VARCHAR(50),
 									    IN cResponsable     VARCHAR(50),
 									    IN cFactura         VARCHAR(100),
 									    IN cObs             TEXT,
 									    IN cUsuario         VARCHAR(50),
 									    OUT lError     TINYINT(1), 
 									    OUT cSqlState  VARCHAR(50), 
 								        OUT cError     VARCHAR(200)
 								        )

 	/*Nombre del Procedimiento*/
 	insertaBienMaterial:BEGIN

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
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario
													AND ctUsuario.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE insertaBienMaterial;
					
			END IF;

			/*Verifica que el resguardo a crear no exista con anterioridad*/
			IF EXISTS(SELECT * FROM ctBienesMateriales WHERE ctBienesMateriales.iIDBienesMateriales = iIDBienesMateriales)

				THEN 
					SET lError = 1; 
					SET cError = "El Bien Material ya existe";
					LEAVE insertaBienMaterial;

			END IF;

			IF NOT EXISTS(SELECT * FROM ctBienesMateriales WHERE ctBienesMateriales.iIDBienesMateriales = iIDBienesMateriales
													AND ctBienesMateriales.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "No esta activo";
					LEAVE insertaBienMaterial;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/
			IF iIDBienesMateriales = 0 OR iIDBienesMateriales = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Bienes Materiales no contiene valor";
					LEAVE insertaBienMaterial;

			END IF;

			IF iIDEdificio = 0 OR iIDEdificio = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de edificio no contiene valor";
					LEAVE insertaBienMaterial;

			END IF;


			IF cPiso = "" OR cPiso = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El piso no contiene valor";
					LEAVE insertaBienMaterial;

			END IF;

			IF cOficina = "" OR cOficina = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "La oficina no contiene valor";
					LEAVE insertaBienMaterial;

			END IF;

			IF iIDArea = 0 OR iIDArea = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El area no contiene valor";
					LEAVE insertaBienMaterial;

			END IF;

			IF iIDSubArea = 0 OR iIDSubArea = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "La sub-area no contiene valor";
					LEAVE insertaBienMaterial;

			END IF;

			IF cResguardante = "" OR cResguardante = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El resguardante no contiene valor";
					LEAVE insertaBienMaterial;
					

			END IF;

			IF cResponsable = "" OR cResponsable = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El responsable no contiene valor";
					LEAVE insertaBienMaterial;

			END IF;

			IF cFactura = "" OR cFactura = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Factura no contiene valor";
					LEAVE insertaBienMaterial;

			END IF;

			IF lActivo = 0 OR lActivo = NULL 

				THEN 
					SET lError = 1; 
					SET cError ="Activo no contiene valor";
					LEAVE insertaBienMaterial;

			END IF;

            IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Usuario no contiene valor";
					LEAVE insertaBienMaterial;

			END IF;


			/*Insercion del usuario*/
			INSERT INTO ctBienesMateriales (ctBienesMateriales.iIDEdificio, 
									ctBienesMateriales.cPiso, 
									ctBienesMateriales.cOficina, 
									ctBienesMateriales.iIDArea, 
									ctBienesMateriales.iIDSubArea, 
									ctBienesMateriales.cResguardante, 
									ctBienesMateriales.cResponsable, 
									ctBienesMateriales.cFactura,
                                    ctBienesMateriales.cObs, 
									ctBienesMateriales.dtCreado, 
									ctBienesMateriales.lActivo,
                                    ctBienesMateriales.cUsuario) 
						VALUES	(	iIDEdificio,
									cPiso,
									cOficina,
									iIDArea,
									iIDSubArea,
									cResguardante,
									cResponsable,
								    cFactura,
                                    cObs,
                                    NOW(),
                                    1,
									cUsuario);

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;