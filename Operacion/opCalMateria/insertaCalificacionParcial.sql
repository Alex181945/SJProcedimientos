/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 18/05/2018
 * Descripcion: Procedimiento que actualiza el registro
 * de un tipo de persona
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Bogar Chavez 11/03/2018 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Para pruebas*/
 USE escuelast;
 DROP PROCEDURE IF EXISTS `insertaCalificacionParcial`;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE insertaCalificacionParcial(	IN iPersona      INTEGER(11) ,
 												IN iMateria      INTEGER(11) ,
	 											IN iPeriodo      INTEGER(11) ,
	 											IN iGrupo        INTEGER(11) ,
	 											IN deCalficacion DECIMAL(10,2),
	 											IN cObs          VARCHAR(150),
	 											IN lActivo       TINYINT(1),
		 										OUT lError       TINYINT(1), 
		 										OUT cSqlState    VARCHAR(50), 
		 										OUT cError       VARCHAR(200))
 	insertaCalificacionParcial:BEGIN

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
			
			IF iPersona = 0 OR iPersona = NULL

				THEN 
					SET lError = 1;
					SET cError = "El ID de la persona no tiene valor";
					LEAVE insertaCalificacionParcial;

			END IF;

			IF iMateria = 0 OR iMateria = NULL

				THEN 
					SET lError = 1;
					SET cError = "El ID de la materia de atributo no tiene valor";
					LEAVE insertaCalificacionParcial;

			END IF;

			IF deCalficacion < (0,00) OR deCalficacion > (100,00) OR deCalficacion = NULL

				THEN 
					SET lError = 1;
					SET cError = "La calificacion promedio tiene valores fuera de rango (0,100) o no tiene valor";
					LEAVE insertaCalificacionParcial;

			END IF;

			/*Valida que la persona a la que se le vaya ingresar la calificacion sea alumno*/
			IF NOT EXISTS(SELECT * FROM ctPersona WHERE ctPersona.iPersona = iPersona 
				AND ctPersona.iIDTipoPersona = (SELECT iIDTipoPersona FROM ctTipoPersona WHERE ctTipoPersona.ctTipoPersona = "Alumno" LIMIT 1))

				THEN
					SET lError = 1;
					SET cError = "El tipo de perfil de la persona no aplica la asignacion de calificacion";
					LEAVE insertaCalificacionParcial;

			END IF;

			/*Realiza la actualizacion*/
			INSERT INTO opCalfMateria  (opCalfMateria.iPersona, 
										opCalfMateria.iMateria, 
										opCalfMateria.iPartida,  
										opCalfMateria.deCalficacion, 
										opCalfMateria.cObs, 
										opCalfMateria.lActivo, 
										opCalfMateria.dtCreado) 
								VALUES (iPersona,
										iMateria,
										((SELECT COUNT(iPartida) FROM opCalfMateria 
											WHERE opCalfMateria.iPersona = iPersona 
												AND opCalfMateria.iMateria = iMateria) + 1), /*Contador*/
										deCalfProm,
										cObs,
										1,
										NOW());
				
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;