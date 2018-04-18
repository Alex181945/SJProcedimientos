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
 /*USE SENADO;
 DROP PROCEDURE IF EXISTS `consultaModulosProgramasPerfil`;*/

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE consultaModulosProgramasPerfil(	IN iTipoConsulta INTEGER(3),
		 											IN iIDPerfil     INTEGER(11),
													OUT lError       TINYINT(1), 
													OUT cSqlState    VARCHAR(50), 
													OUT cError       VARCHAR(200))
 	consultaModulosProgramasPerfil:BEGIN

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

			IF iTipoConsulta = 0 OR iTipoConsulta = NULL

				THEN 
					SET lError = 1; 
					SET cError = "El tipo de consulta no contiene valor";
					LEAVE consultaModulosProgramasPerfil;

			END IF;

			IF iIDPerfil = 0 OR iIDPerfil = NULL

				THEN 
					SET lError = 1; 
					SET cError = "El tipo de perfil no contiene valor";
					LEAVE consultaModulosProgramasPerfil;

			END IF;

			SELECT ctModuloPerfil.iIDModulo, 
				(SELECT ctModulos.cModulo FROM ctModulos 
					WHERE ctModulos.iIDModulo = ctModuloPerfil.iIDModulo AND ctModulos.lActivo = 1) as cModulo, 
				ctProgramasModulo.iPartida, 
				ctProgramasModulo.cPrograma, 
				ctProgramasModulo.cRuta, 
				ctProgramasModulo.lActivo 
			FROM ctModuloPerfil INNER JOIN ctProgramasModulo 
				ON ctModuloPerfil.iIDModulo = ctProgramasModulo.iIDModulo AND ctProgramasModulo.lActivo = 1
			WHERE ctModuloPerfil.iIDPerfil = iIDPerfil AND ctModuloPerfil.lActivo = 1;


		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;