/**
 * 
 * Autor: Jennifer Hernandez
 * Fecha: 28/04/2018
 * Descripcion: Procedimiento que actualiza la SubArea
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alejandro Estrada 09/09/2017 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Para pruebas*/
/*USE cau;*/

DELIMITER //

 CREATE PROCEDURE actualizaSubArea      (	IN iiDArea      INTEGER,
 											IN iIDSubArea   INTEGER,
											IN cSubArea		VARCHAR (150),
											IN lActivo      TINYINT(1),
 											IN cUsuario     VARCHAR(20),
		 									OUT lError      TINYINT(1), 
		 									OUT cSqlState   VARCHAR(50), 
		 									OUT cError      VARCHAR(200))
 	actualizaSubArea:BEGIN
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
			IF NOT EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario
													AND ctUsuario.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El usuario del sistema no existe o no esta activo";
					LEAVE actualizaSubArea;

			END IF;

			IF NOT EXISTS(SELECT * FROM ctSubArea WHERE ctSubArea.iIDSubArea = iIDSubArea)

				THEN 
					SET lError = 1; 
					SET cError = "Estado de subarea no encontrado";
					LEAVE actualizaSubArea;

			END IF;


			/*Valida campos obligatotios como no nulos o vacios*/
			
			IF iIDArea = 0 OR iIDArea = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de Área no contiene valor";
					LEAVE actualizaSubArea;

			END IF;

			IF iIDSubArea = 0 OR iIDSubArea = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de SubArea no contiene valor";
					LEAVE actualizaSubArea;

			END IF;

            IF cSubArea = "" OR cSubArea = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El campo nombre de Subarea no contiene valor";
					LEAVE actualizaSubArea;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/
            
			IF lActivo = 0 OR lActivo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Activo no contiene valor";
					LEAVE actualizaSubArea;

			END IF;

			IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El usuario no contiene valor";
					LEAVE actualizaSubArea;

			END IF;

			/*Realiza la actualizacion*/
			UPDATE 	ctSubArea
					SET 	ctSubArea.cSubArea  	= cSubArea,
							ctSubArea.lActivo       = lActivo,
							ctSubArea.dtModificado  = NOW(),
							ctSubArea.cUsuario      = cUsuario
					WHERE 	ctSubArea.iIDArea = iIDArea AND 
					ctSubArea.iIDSubArea = iIDSubArea;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;

        