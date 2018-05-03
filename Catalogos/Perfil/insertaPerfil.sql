/**
 * Autor: Jennifer Hernandez
 * Fecha: 28/04/2018
 * Descripcion: Procedimiento que inserta perfil
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

 CREATE PROCEDURE insertaPerfil(IN cPerfil VARCHAR(100),	                                        
	                            IN cUsuario VARCHAR(50),
                                OUT lError     TINYINT(1), 
                                OUT cSqlState  VARCHAR(50), 
                                OUT cError     VARCHAR(200)
 				               )

 	/*Nombre del Procedimiento*/
 	insertaPerfil:BEGIN

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
					LEAVE insertaPerfil;

			END IF;

			IF NOT EXISTS(SELECT * FROM ctPerfil WHERE ctPerfil.iPerfil = iPerfil
													AND ctPerfil.lActivo  = 1)

				THEN
					SET lError = 1; 
					SET cError = "El perfil no existe o no esta activo";
					LEAVE insertaPerfil;

			END IF;

			IF iPerfil = 0 OR iPerfil = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El identificador de perfil no contiene valor";
					LEAVE insertaPerfil;

			END IF;

			IF cPerfil = "" OR cPerfil = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El campo Perfil no contiene valor";
					LEAVE insertaPerfil;

			END IF;

            IF lActivo = 0 OR lActivo = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "Activo no contiene valor";
					LEAVE insertaPerfil;

			END IF;

			/*Valida campos obligatotios como no nulos o vacios*/
            IF cUsuario = "" OR cUsuario = NULL 

				THEN 
					SET lError = 1; 
					SET cError = "El usuario no contiene valor";
					LEAVE insertaPerfil;

			END IF;      

			/*Insercion del usuario*/
			INSERT INTO ctPerfil (ctPerfil.cPerfil,
                                        ctPerfil.lActivo,
									    ctPerfil.dtCreado, 
									    ctPerfil.cUsuario) 
						      VALUES   (cPerfil,
									    1,
									    NOW(),
									    cUsuario);

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;