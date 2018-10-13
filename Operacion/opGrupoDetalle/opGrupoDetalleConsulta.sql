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
 DROP PROCEDURE IF EXISTS `opGrupoDetalleConsulta`;

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE opGrupoDetalleConsulta(	IN iTipoConsulta INTEGER,
 											IN iGrupo        INTEGER,
											OUT lError     	 TINYINT(1), 
											OUT cSqlState  	 VARCHAR(50), 
											OUT cError     	 VARCHAR(200))
 	opGrupoDetalleConsulta:BEGIN

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

			SELECT opGrupoDet.*,
				(SELECT ctTipoPersona.cTipoPersona
					FROM ctTipoPersona 
					WHERE ctTipoPersona.iIDTipoPersona  = opGrupoDet.iTipoPersona 
						AND ctTipoPersona.lActivo = 1) AS cTipoPersona,
				(SELECT CONCAT(ctPersona.cNombre," ", ctPersona.cAPaterno," ", ctPersona.cAMaterno)
					FROM ctPersona 
					WHERE ctPersona.iPersona   = opGrupoDet.iPersona 
						AND ctPersona.lActivo  = 1) AS cPersona,
				(SELECT ctMateria.cMateria 
					FROM ctMateria 
					WHERE ctMateria.iMateria   = opGrupoDet.iMateria
						AND ctMateria.lActivo  = 1) AS cMateria
			FROM opGrupoDet WHERE opGrupoDet.iGrupo = iGrupo 
			AND opGrupoDet.lActivo = 1 ORDER BY opGrupoDet.iPartida;


		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;