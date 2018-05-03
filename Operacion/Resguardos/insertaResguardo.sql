
USE Senado;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE insertaResguardo(	IN iIDEdificio      INTEGER,
	 								IN cPiso            VARCHAR(10),
 									IN cOficina         VARCHAR(100),
									IN iIDArea          INTEGER,
 									IN iIDSubArea       INTEGER,
 									IN cResguardante    VARCHAR(50),
 									IN cResponsable     VARCHAR(50),
 									IN cFactura         VARCHAR(100),
 									IN cObs             TEXT,
                                    IN cUsuario         VARCHAR(50),
 									IN lActivo          TINYINT(1),
 									OUT lError          TINYINT(1), 
 									OUT cSqlState       VARCHAR(50), 
 									OUT cError          VARCHAR(200))

 	/*Nombre del Procedimiento*/
 	insertaResguardo:BEGIN

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
					LEAVE insertaResguardo;

			END IF;

			

			/*Valida campos obligatotios como no nulos o vacios*/
			IF iIDResguardo = 0 OR iIDResguardo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Resguardo no contiene valor";
					LEAVE insertaResguardo;

			END IF;

			IF iIDEdificio = 0 OR iIDEdificio = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Edificio no contiene valor";
					LEAVE insertaResguardo;

			END IF;

			IF cPiso = "" OR cPiso = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El piso no contiene valor";
					LEAVE insertaResguardo;

			END IF;

			IF cOficina = "" OR cOficina = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "EL campo oficina no cuenta con algún valor";
					LEAVE insertaResguardo;

			END IF;

			IF iIDArea = 0 OR iIDArea = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Area no contiene valor";
					LEAVE insertaResguardo;

			END IF;

			IF iIDSubArea = 0 OR iIDSubArea = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Edificio no contiene valor";
					LEAVE insertaResguardo;

			END IF;

			IF cResguardante = "" OR cResguardante = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El campo Resguardante no contiene valor";
					LEAVE insertaResguardo;
					

			END IF;

			IF cResponsable = "" OR cResponsable = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El campo Responsable del usuario no contiene valor";
					LEAVE insertaResguardo;

			END IF;

			IF cFactura = "" OR cFactura = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Factura no contiene valor";
					LEAVE insertaResguardo;

			END IF;

			IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El usuario no contiene valor";
					LEAVE insertaResguardo;

			END IF;

			IF lActivo = 0 OR lActivo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Activo no contiene valor";
					LEAVE insertaResguardo;

			END IF;

			/*Validacion de las claves foraneas*//*Aqui tengo duda :c*/
			IF NOT EXISTS(SELECT * FROM ctPerfil WHERE ctPerfil.iPerfil  = iPerfil
												AND ctPerfil.lActivo = 1 )

			THEN
				SET lError = 1; 
				SET cError = "El perfil seleccionado no existe o no esta activo";
				LEAVE insertaResguardo;

			END IF;

			/*Insercion del resguardo*/
			INSERT INTO ctResguardo (ctResguardo.iIDEdificio,
									ctResguardo.cPiso, 
									ctResguardo.cOficina,
									ctResguardo.iIDArea,
									ctResguardo.iIDSubArea, 
									ctResguardo.cResguardante, 
									ctResguardo.cResponsable, 
									ctResguardo.cFactura, 
									ctResguardo.cObs, 
                                    ctResguardo.dtCreado,
									ctResguardo.cUsuario,
									ctResguardo.lActivo) 
									
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
                                    cUsuario,
									1);
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;