/*Inicio de procedimientos*/
/*Elementos a considerar: Investigar áreas activas y un elemento de la BD que me haga distinguirlas*/
DELIMITER //
Create procedure consultaAreas (IN iIDArea INTEGER (11), 
                            IN iActivo tinyint (1),
                            OUT lError TINYINT(1), 
 							OUT cSqlState VARCHAR(50), 
 							OUT cError VARCHAR(200))
consultaAreas:BEGIN /*Bloque transaccional */
/*En unos ejemplos que encontre en internet solo escriben BEGIN
y tu pones algo como esto: Consultausuarios:Begin, entonces es lo mismo? 

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
    /*Tengo un poco de duda en la tabla temporal pero bueno...*/
CREATE TEMPORARY TABLE actAreas LIKE ctareas;

IF EXISTS (SELECT * FROM ctareas WHERE ctareas.iIDArea = iIDArea)

				THEN INSERT INTO actAreas (SELECT * FROM ctareas WHERE ctareas.iIDArea = iIDArea);

				/*Si no manda error de que no lo encontro*/
				ELSE
					SET lError = 1; 
					SET cError = "Área no encontrada";
					LEAVE consultaAreas;
    END IF;

IF NOT EXISTS(SELECT * FROM actAreas WHERE actAreas.lActivo = 1)

				THEN 
					SET lError = 1; 
					SET cError = "Área no activa";
					LEAVE consultaAreas;

			END IF;
            			DROP TEMPORARY TABLE actAreas;
    COMMIT;

	END;//
 DELIMITER ;