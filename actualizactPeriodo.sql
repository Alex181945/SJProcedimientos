/**
 * 
 * Autor: Alberto Robles
 * Fecha: 20/03/2018
 * Descripcion: Procedimiento que inserta usuarios
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alberto Robles 20/03/2018 In-15 Fn-19 
 * 
 * Notas: 0 es igual a falso, 1 es igual a verdadero
 */
 
 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE actualizaPeriodo(	IN iIDPeriodo    INTEGER(11),
 									IN cPeriodo      VARCHAR(30),
 									IN cMateria      VARCHAR(30),
 									IN cGrupo        VARCHAR(30),
 									IN lActivo       TINYINT(1),
 									IN cUsuario      VARCHAR(30),
 									OUT lError     TINYINT(1), 
 									OUT cSqlState  VARCHAR(50), 
 									OUT cError     VARCHAR(200)
 								)

 	/*Nombre del Procedimiento*/
 	actualizaPeriodo:BEGIN

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

			/*Variables para control de errores inicializadas*/
			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";

			/*Valida el Periodo que crea el registro*/
			IF NOT EXISTS(SELECT * FROM ctPeriodo WHERE ctPeriodo.iIDPeriodo = iIDPeriodo)

				THEN

					SET lError = 1; 
					SET cError = "El Periodo  no existe";
					LEAVE actualizaPeriodo;

			END IF;

 			/*Valida que el Periodo no este activo*/
 			IF NOT EXISTS(SELECT * FROM ctPeriodo WHERE ctPeriodo.iIDPeriodo = iIDPeriodo
 													AND ctPeriodo.lActivo    = 1)
 
 				THEN 

 					SET lError = 1; 
 					SET cError = "El Periodo ya fue borrado con anterioridad";
 					LEAVE actualizaPeriodo;

 			END IF;

			/*Se valida que los dato no se encunetre nulos o vacios respecto a la tabla*/

			IF cPeriodo = "" OR cPeriodo = NULL

				THEN
						SET lEror = 1;
						SET cError = "El Periodo no tiene valor";
						LEAVE actualizaPeriodo;
			END IF;

			IF cMateria = "" OR cMateria = NULL

				THEN
						SET lEror = 1;
						SET cError = "La Materia no tiene valor";
						LEAVE actualizaPeriodo;
			END IF;

			IF cGrupo = "" OR cGrupo = NULL

				THEN
						SET lEror = 1;
						SET cError = "El Grupo no tiene valor";
						LEAVE actualizaPeriodo;
			END IF;

			UPDATE ctPeriodo 
							  SET ctPeriodo.cPeriodo    = cPeriodo,
								  ctPeriodo.cMateria    = cMateria,
								  ctPeriodo.cGrupo      = cGrupo,
								  ctPeriodo.lActivo     = lActivo,
								  ctPeriodo.dtModificado = NOW(),
								  ctPeriodo.cUsuario    = cUsuario
								  WHERE ctPeriodo.iIDPeriodo;
	

			
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;