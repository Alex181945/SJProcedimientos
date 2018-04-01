
/*USE Senado;*/

DELIMITER //

 CREATE PROCEDURE actualizaResguardo(	IN iIDResguardo     INTEGER(11),
 										IN cPiso            VARCHAR(10),
	 									IN cOficina         VARCHAR(100),
	 									IN cResguardante    VARCHAR(50),
	 									IN cResponsable     VARCHAR(50),
	 									IN cFactura         VARCHAR(100),
	 									IN cObs             TEXT,
	                                    IN cUsuario         VARCHAR(20),
	 									IN lActivo          TINYINT(1),
	 									OUT lError          TINYINT(1), 
	 									OUT cSqlState       VARCHAR(50), 
	 									OUT cError          VARCHAR(200))
 	actualizaResguardo:BEGIN

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
			
			/*Valida que el resguardo exista*/
			IF NOT EXISTS(SELECT * FROM ctResguardo WHERE ctResguardo.lActivo = 1)

				THEN 
					SET lError = 1; 
					SET cError = "El resguardo no existe o no esta activo";
					LEAVE actualizaResguardo;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/
			IF cPiso = "" OR cPiso = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El piso no contiene valor";
					LEAVE actualizaResguardo;

			END IF;

			IF cOficina = "" OR cOficina = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "EL campo oficina no cuenta con algún valor";
					LEAVE actualizaResguardo;

			END IF;

			IF cResguardante = "" OR cResguardante = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El campo Resguardante no contiene valor";
					LEAVE actualizaResguardo;
					

			END IF;

			IF cResponsable = "" OR cResponsable = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El campo Responsable del usuario no contiene valor";
					LEAVE actualizaResguardo;

			END IF;

			IF cFactura = "" OR cFactura = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Factura no contiene valor";
					LEAVE actualizaResguardo;

			END IF;
			IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El usuario no contiene valor";
					LEAVE actualizaResguardo;

			END IF;

			/*Validacion de las claves foraneas*/
			IF NOT EXISTS(SELECT * FROM ctPerfil WHERE ctPerfil.iPerfil  = iPerfil
												AND ctPerfil.lActivo = 1 )

			THEN
				SET lError = 1; 
				SET cError = "El perfil seleccionado no existe o no esta activo";
				LEAVE actualizaResguardo;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE ctResguardo
				SET ctResguardo.cPiso              = cPiso,
					ctResguardo.cOficina           = cOficina,
					ctResguardo.cResguardante      = cResguardante,
					ctResguardo.cResponsable       = cResponsable,
					ctResguardo.cFactura           = cFactura,
					ctResguardo.cObs               = cObs,
					ctResguardo.cUsuario		   = cUsuario,
					ctResguardo.lActivo            = lActivo,
					ctResguardo.dtModificado       = NOW()
				WHERE ctResguardo.iIDResguardo     = iIDResguardo;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;