/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 17/11/2017
 * Descripcion: Procedimiento que inserta alumnos
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alejandro Estrada 09/09/2017 In-15 Fn-19 
 * 
 * Notas: 0 es igual a falso, 1 es igual a verdadero
 */
 
 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE insertaAlumno(OUT lError TINYINT(1), OUT cSqlState VARCHAR(50), OUT cError VARCHAR(200))
 	BEGIN

	 	/*Variables*/
	 	DECLARE itipoPersona INT(11) DEFAULT 0;

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

			/*Procedimiento*/
			SELECT (iIDTipoPersona) INTO itipoPersona FROM ctTipoPersona WHERE cTipoPersona = "ALUMNO" AND lActivo = 1;

			IF (itipoPersona = 0 || itipoPersona = NULL) THEN

				SET lError = 1;
				SET cError = "No esta disponible el tipo de persona ALUMNO";
				SELECT lError, cError;

			END IF;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;