/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 17/05/2018
 * Descripcion: Consulta tecnicos disponibles por carga de trabajo
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Alejandro Estrada 09/09/2017 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */
 
 /*Para pruebas*/
USE SENADO;
DROP PROCEDURE IF EXISTS `consultaTecnico`;

/*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaTecnico(	IN iTipoConsulta	VARCHAR(11),
 									OUT lError    		TINYINT(1), 
 									OUT cSqlState 		VARCHAR(50), 
 									OUT cError    		VARCHAR(200))
 	consultaTecnico:BEGIN

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

			CASE iTipoConsulta

			    WHEN "1" THEN

			    	/*Carga de Trabajo*/
			    	IF NOT EXISTS(SELECT iIDTecnico, COUNT(iIDTicket) FROM opTickets 
			    					WHERE DATE(opTickets.dtFecha) = DATE(NOW())
			    					GROUP BY iIDTecnico ASC)

			    		THEN SELECT iIDTecnico FROM ctTecnico WHERE ctTecnico.lActivo = 1 LIMIT 1;

			    		ELSE SELECT iIDTecnico, COUNT(iIDTicket) FROM opTickets WHERE DATE(opTickets.dtFecha) = DATE(NOW()) GROUP BY iIDTecnico ASC;

			    	END IF;

			END CASE;

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;