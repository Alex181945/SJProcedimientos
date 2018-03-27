/**
 * 
 * Autor: Alberto Robles
 * Fecha: 09/03/2018
 * Descripcion: Procedimiento que inserta usuarios
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alberto Robles 09/03/2018 In-15 Fn-19 
 * 
 * Notas: 0 es igual a falso, 1 es igual a verdadero
 */
 
 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE insertactCarrera(	IN cCarrera     VARCHAR(100),
 									IN cUsuarioR    VARCHAR(50),
 									OUT iID         INT(3),
 									OUT lError      TINYINT(1), 
 									OUT cSqlState   VARCHAR(50), 
 									OUT cError      VARCHAR(200)
 								)

 	/*Nombre del Procedimiento*/
 	insertactCarrera:BEGIN

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
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuarioR)

				THEN
					SET lError = 1; 
					SET cError = "La Carrera del sistema no existe";
					LEAVE insertactCarrera;

			END IF;

			/*
			Autoincremental de forma manual
			Ir y buscar el ultimo registro*/

			SET iID = SELECT MAX(iCarrera) FROM ctCarrera;

			IF iID != 0 
				THEN SET iID = iID + 1;
				ELSE SET iID = 1
			END IF;

			/*Verifica que el usuario a crear no exista con anterioridad*/
			IF EXISTS(SELECT * FROM ctCarrera WHERE ctCarrera.iCarrera = iID)

				THEN 
					SET lError = 1; 
					SET cError = "La carrera: " + cCarrera + " con el ID: " + iID + " ya existe";
					LEAVE insertactCarrera;

			END IF;

			/*Insercion de Carrera*/
			INSERT INTO ctCarrera (	ctCarrera.iCarrera, 
									ctCarrera.cCarrera, 
									ctCarrera.lActivo, 
									ctCarrera.dtCreado
								) 
						VALUES	(	iID,
									cCarrera,
									1,
									NOW());

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;