/**
 * 
 * Autor: Alejandro Estrada
 * Fecha: 02/04/2018
 * Descripcion: Consulta personalizada para cargar los modulos y programas
 * ligados a un determiando tipo de perfil
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
 DROP PROCEDURE IF EXISTS `consultaTipoPersona`;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaTipoPersona(	IN iTipoPersona   INTEGER,
										OUT lError     TINYINT(1), 
										OUT cSqlState  VARCHAR(50), 
										OUT cError     VARCHAR(200))
 	consultaTipoPersona:BEGIN

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

			

			IF iTipoPersona != 0 OR iTipoPersona != NULL

				THEN

					SELECT 	ctpersona.* , 
							opatributopersona.cObs 
					FROM ctPersona 
						INNER JOIN opatributopersona 
							ON opatributopersona.iPersona = ctpersona.iPersona WHERE ctPersona.iIDTipoPersona = iTipoPersona;

					LEAVE consultaTipoPersona;

			END IF;


		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;