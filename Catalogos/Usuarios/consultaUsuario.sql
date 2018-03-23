/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 23/11/2017
 * Descripcion: Procedimiento que valida usuario
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alejandro Estrada 09/09/2017 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Para pruebas*/
/*USE SENADO;*/
 
 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaUsuario(	IN cUsuario  VARCHAR(20),
 									OUT lError TINYINT(1), 
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))
 	consultaUsuario:BEGIN

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
			DROP TEMPORARY TABLE IF EXISTS tt_ctUsuario;

			CREATE TEMPORARY TABLE tt_ctUsuario LIKE ctUsuario;

			/*Comprueba si existe el usuario*/
			IF EXISTS(SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario)

				/*Si existe copia toda la informacion del usuario a la tabla temporal*/
				THEN INSERT INTO tt_ctUsuario SELECT * FROM ctUsuario WHERE ctUsuario.cUsuario = cUsuario;

				/*Si no manda error de que no lo encontro*/
				ELSE 
					SET lError = 1; 
					SET cError = "Usuario no existe";
					LEAVE consultaUsuario;

			END IF;

			/*Valida que el usuario este activo*/
			IF NOT EXISTS(SELECT * FROM tt_ctUsuario WHERE tt_ctUsuario.lActivo = 1)

				THEN 
					SET lError = 1; 
					SET cError = "Usuario no activo";
					LEAVE consultaUsuario;

			END IF;

			SELECT * FROM tt_ctUsuario;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;