/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 08/09/2018
 * Descripcion: Consulta de los grupos
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo:  Bogar Chavez 13/03/2018 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */
 
 /*Para pruebas*/
 USE escuelast;
 DROP PROCEDURE IF EXISTS `consultaGrupos`;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaGrupos(
									OUT lError     TINYINT(1), 
									OUT cSqlState  VARCHAR(50), 
									OUT cError     VARCHAR(200))
 	consultaGrupos:BEGIN

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

			/*Variables para control de errores inicializadas*/
			SET lError    = 0;
			SET cSqlState = "";
			SET cError    = "";

			/*Busqueda de grupos sin ningun filtro carga todos los grupos*/
			/*Devuelve tambien Nombre de carrera y periodo*/

			SELECT opGrupo.*, 
				(SELECT ctCarrera.cCarrera 
					FROM ctCarrera 
					WHERE ctCarrera.iCarrera  = opGrupo.iCarrera 
						AND ctCarrera.lActivo = 1) AS cCarrera,  
				(SELECT ctPeriodo.cPeriodo 
					FROM ctPeriodo 
					WHERE ctPeriodo.iCarrera   = opGrupo.iCarrera 
						AND ctPeriodo.iPeriodo = opGrupo.iPeriodo
						AND ctPeriodo.lActivo  = 1) AS cPeriodo
			FROM opGrupo WHERE opGrupo.lActivo = 1 ORDER BY iCarrera;


		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;