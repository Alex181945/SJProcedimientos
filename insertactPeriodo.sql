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

 CREATE PROCEDURE insertactPeriodo(	IN ciPeriodo     INT(50),
 									IN cPeriodo      VARCHAR(30),
 									IN cMateria      VARCHAR(30),
 									IN cGrupo        VARCHAR(30),
 									IN lActivo     TINYINT(1),
 									IN dtCreado     DateTime(100),
 									IN dtModificado DateTime(10),
 									OUT lError     TINYINT(1), 
 									OUT cSqlState  VARCHAR(50), 
 									OUT cError     VARCHAR(200)
 								)

 	/*Nombre del Procedimiento*/
 	insertactPeriodo:BEGIN

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
			IF NOT EXISTS(SELECT * FROM ctPeriodo WHERE ctPeriodo.cPeriodo = cPeriodo)

				THEN

					SET lError = 1; 
					SET cError = "El Periodo del sistema no existe";
					LEAVE cPeriodo;

			END IF;

			/*Se valida que los dato no se encunetre nulos o vacios respecto a la tabla*/

			IF cPeriodo = "" OR cPeriodo = NULL

				THEN
						SET lEror = 1;
						SET cError = "El Periodo no tiene valor";
						LEAVE cPeriodo;
			END IF;

			IF cMateria = "" OR cMateria = NULL

				THEN
						SET lEror = 1;
						SET cError = "La Materia no tiene valor";
						LEAVE cMateria;
			END IF;

			IF cGrupo = "" OR cGrupo = NULL

				THEN
						SET lEror = 1;
						SET cError = "El Grupo no tiene valor";
						LEAVE cGrupo;
			END IF;

			INSERT INTO cPeriodo (cPeriodo.ciPeriodo,
								  cPeriodo.cMateria,
								  cPeriodo.cGrupo,
								  cPeriodo.lActivo,
								  cPeriodo.dtCreado,
								  cPeriodo.dtModificado )
							VALUES (ciPeriodo
									cPeriodo
									cMateria
									cGrupo
									1,
									NOW(),
									NOW());


			
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;