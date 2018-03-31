/*Inicio de procedimientos*/
/*Elementos a considerar: Investigar áreas activas y un elemento de la BD que me haga distinguirlas*/

USE Senado;

DELIMITER //
Create procedure consultaResguardo (IN iIDResguardo INTEGER, 
		                            OUT lError TINYINT(1), 
		 							OUT cSqlState VARCHAR(50), 
		 							OUT cError VARCHAR(200))
consultaResguardo:BEGIN /*Bloque transaccional */

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

			DROP TEMPORARY TABLE IF EXISTS tt_ctResguardo;

			/*tt_ctResguardo --> Tabla temporal*/    
			CREATE TEMPORARY TABLE tt_ctResguardo LIKE ctResguardo;

			IF EXISTS (SELECT * FROM ctResguardo WHERE ctResguardo.iIDResguardo = iIDResguardo)

							THEN INSERT INTO tt_ctResguardo (SELECT * FROM ctResguardo WHERE ctResguardo.iIDResguardo = iIDResguardo);

							/*Si no manda error de que no lo encontro*/
							ELSE
								SET lError = 1; 
								SET cError = "Resguardo no encontrado";
								LEAVE consultaResguardo;
    		END IF;

			IF NOT EXISTS(SELECT * FROM tt_ctResguardo WHERE tt_ctResguardo.lActivo = 1)

							THEN 
								SET lError = 1; 
								SET cError = "Resguardo no disponible"; 
			                    /*El resguardo no esta habilitado*/
								LEAVE consultaResguardo;

			END IF;

            SELECT * FROM tt_ctResguardo;

    	COMMIT;

	END;//
 DELIMITER ;