/**
 * 
 * Autor: Alberto Robles
 * Fecha: 16/03/2018
 * Descripcion: Procedimiento que inserta Tipo Persona
 *  y sus atributos
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alberto Robles 16/03/2018 In-15 Fn-19 
 * 
 * Notas: 0 es igual a falso, 1 es igual a verdadero
 */
 
 /*Delimitador de bloque*/

 USE escuelast;
 DROP PROCEDURE IF EXISTS `opInsertaPersona`;
 DELIMITER //

 CREATE PROCEDURE opInsertaPersona( IN iIDTipoPersona INTEGER(11),
		 							IN cNombre		  VARCHAR(150),
		 							IN cAPaterno   	  VARCHAR(150),
		 							IN cAMaterno  	  VARCHAR(150),
		 							IN lGenero		  TINYINT(1),
		 							IN dtFechaNac	  VARCHAR(50),
		 							IN cArray         TEXT,
		 							IN iContador      INTEGER(11),
		 							INOUT iPersona    INTEGER(11),
 									OUT lError        TINYINT(1), 
 									OUT cSqlState     VARCHAR(50), 
 									OUT cError        VARCHAR(200))

 	/*Nombre del Procedimiento*/
 	opInsertaPersona:BEGIN

 		DECLARE cont INTEGER;

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

			/*Variables para control de errores inicializadas*/
			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";
			SET cont      = 0;

			CALL insertactPersona(	iIDTipoPersona,
									cNombre,
									cAPaterno,
									cAMaterno,
									lGenero,
									dtFechaNac,
									iPersona,
									lError,
									cSqlState,
									cError);

			IF lError = TRUE AND cError != ""
				THEN LEAVE opInsertaPersona;
			END IF;

			/*call log_msg(concat('Arreglo: ', cArray));*/
			CALL insertaopAtributoPersona(	iPersona,
											cArray,
											lError,
											cSqlState,
											cError);

			IF lError = TRUE AND cError != ""
				THEN LEAVE opInsertaPersona;
			END IF;

			/*WHILE cont < iContador DO 
		       	cArray;
		        CALL insertaopAtributoPersona();
		        SET cont = cont + 1; 
		    END WHILE;*/


		COMMIT;
	END;//	
 /*Reseteo del delimitador*/	
 DELIMITER ;