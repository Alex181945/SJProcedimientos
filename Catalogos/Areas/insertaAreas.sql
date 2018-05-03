/**
 * 
 * Autor: Bogar Chavez
 * Fecha: 13/03/2018
 * Descripcion: Procedimiento para insertar área.
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Bogar Chavez 13/09/2017 In-06 Fn-
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Para pruebas*/
 /*USE SENADO;*/

 DELIMITER //
CREATE PROCEDURE insertaArea(
                            IN  cArea VARCHAR(150) ,
                            IN  cUsuario VARCHAR(50),									
 							OUT lError TINYINT(1), 
 							OUT cSqlState VARCHAR(50), 
 							OUT cError VARCHAR(200))

 	insertaArea:BEGIN

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
					LEAVE insertaArea;
					
			END IF;
			
			/*Verifica que el area no exista con anterioridad*/
			IF EXISTS(SELECT * FROM ctAreas WHERE ctAreas.cArea = cArea)

				THEN 
					SET lError = 1; 
					SET cError = "El área ya existe";
					LEAVE insertaArea;

			END IF;

            IF NOT EXISTS(SELECT * FROM ctAreas WHERE ctAreas.cArea = cArea
													AND ctAreas.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El área del sistema no existe o no esta activo";
					LEAVE insertaArea;

			END IF;


			/*Se valida que los dato no se encunetre nulos o vacios respecto a la tabla*/
			IF iIDArea = 0 OR iIDArea = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de area no contiene valor";
					LEAVE insertaArea;

			END IF;

			IF cArea = "" OR cArea = NULL

				THEN 
					SET lError = 1;
					SET cError = "El nombre del área no tiene valor";
					LEAVE insertaArea;

			END IF;

			IF lActivo = 0 OR lActivo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Activo no contiene valor";
					LEAVE insertaArea;

			END IF;

			IF cUsuario = "" OR cUsuario = NULL

				THEN 
					SET lError = 1;
					SET cError = "El dato Usuario no contiene un valor";
					LEAVE insertaArea;
			END IF;


			INSERT INTO ctAreas(
									ctAreas.cArea,  
                                    ctAreas.lActivo,
                                    ctAreas.dtCreado,								
									ctAreas.cUsuario )
						VALUES	(   cArea,
									1,
									NOW(),
									cUsuario);

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;