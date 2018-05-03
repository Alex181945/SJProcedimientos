/**
 * 
 * Autor: Jennifer Hernandez
 * Fecha: 28/04/2018
 * Descripcion: Procedimiento que consulta la Sub Area
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

 CREATE PROCEDURE consultaSubArea ( IN  iIDSubArea   INTEGER,
									IN lActivo TINYINT (1),
                                    OUT lError     TINYINT(1), 
                                    OUT cSqlState  VARCHAR(50), 
                                    OUT cError     VARCHAR(200)
 							      )

 	/*Nombre del Procedimiento*/
 	consultaSubArea:BEGIN

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

            /*INICIO DEL PROCEDIMIENTO*/
			
            DROP TEMPORARY  TABLE IF EXISTS tt_ctSubArea;
			CREATE TEMPORARY TABLE tt_ctSubArea LIKE ctSubArea;

			IF EXISTS(SELECT * FROM ctSubArea WHERE ctSubArea.iIDSubArea = iIDSubArea)

				/*Si existe copia toda la informacion del usuario a la tabla temporal*/
				THEN INSERT INTO tt_ctSubArea SELECT * FROM ctSubArea WHERE ctSubArea.iIDSubArea = iIDSubArea;

				/*Si no manda error de que no lo encontro*/
				ELSE 
					SET lError = 1; 
					SET cError = "No hay información respecto a la subarea";
					LEAVE consultaSubArea;

			END IF;

			/*Valida que el ticket este activo*/
			IF NOT EXISTS(SELECT * FROM tt_ctSubArea WHERE tt_ctSubArea.lActivo = 1)

				THEN 
					SET lError = 1; 
					SET cError = "No activo";
					LEAVE consultaSubArea;

			END IF;

			SELECT * FROM tt_ctSubArea;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;