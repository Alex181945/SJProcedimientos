/*USE SENADO;*/

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE insertaServicio(	IN cTipoServicio VARCHAR(150),
                                    IN cUsuario VARCHAR (50),
 									OUT lError     TINYINT(1), 
 									OUT cSqlState  VARCHAR(50), 
 									OUT cError     VARCHAR(200)
 								)

 	/*Nombre del Procedimiento*/
 	insertaServicio:BEGIN

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


			/*Verifica que el servicio a crear no exista con anterioridad*/
			IF EXISTS(SELECT * FROM ctTipoServicio WHERE ctTipoServicio.iIDTipoServicio = iIDTipoServicio)

				THEN 
					SET lError = 1; 
					SET cError = "El tipo de servicio ya existe";
					LEAVE insertaServicio;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/
			IF iIDTipoServicio = 0 OR iIDTipoServicio = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Activo no contiene valor";
					LEAVE insertaServicio;

			END IF;

			IF cTipoServicio = "" OR cTipoServicio = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El tipo de servicio no contiene valor";
					LEAVE insertaServicio;
			END IF;

            /*Valida campos obligatotios como no nulos o vacios*/
			IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El Usuario no contiene valor";
					LEAVE insertaServicio;

			END IF;

			IF lActivo = 0 OR lActivo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Activo no contiene valor";
					LEAVE insertaServicio;

			END IF;

			/*Insercion del usuario*/
			INSERT INTO ctTipoServicio(
                                    ctTipoServicio.cTipoServicio, 
									ctTipoServicio.lActivo, 
									ctTipoServicio.dtCreado,
                                    ctTipoServicio.cUsuario) 
						VALUES	(	cTipoServicio,
									1,
									NOW(),
                                    cUsuario);
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;