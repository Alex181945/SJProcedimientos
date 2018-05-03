USE Senado;

 DELIMITER //

 CREATE PROCEDURE borraResguardo(	IN iIDResguardo  INTEGER,
 									IN cUsuario      VARCHAR(50),
	 								OUT lError       TINYINT(1), 
	 								OUT cSqlState    VARCHAR(50), 
	 								OUT cError       VARCHAR(200))
 	borraResguardo:BEGIN

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
			IF NOT EXISTS(SELECT * FROM ctResguardo WHERE ctResguardo.iIDResguardo = iIDResguardo)

				THEN 
					SET lError = 1; 
					SET cError = "El resguardo no existe";
					LEAVE borraResguardo;

			END IF;

			/*Valida que el resguardo no este activo*/
			IF NOT EXISTS(SELECT * FROM ctResguardo WHERE ctResguardo.iIDResguardo = iIDResguardo 
													AND ctResguardo.lActivo  = 1)

				THEN 
					SET lError = 1; 
					SET cError = "El resguardo ya fue borrado con anterioridad";
					LEAVE borraResguardo;

			END IF;

			/*Realiza el borrado logico solo se actualiza el campo lActivo*/
			UPDATE ctResguardo SET  ctResguardo.lActivo        = 0,
									ctResguardo.cUsuario	   = cUsuario,
									ctResguardo.dtModificado   = NOW() 
								WHERE ctResguardo.iIDResguardo = iIDResguardo;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;