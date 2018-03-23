/**
 * 
 * Autor: Bogar Chavez
 * Fecha: 11/03/2018
 * Descripcion: Procedimiento que actualiza el registro
 * de un edificio
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Bogar Chavez 11/03/2018 In-15 Fn-19 
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */

 /*Delimitador de bloque*/
 DELIMITER //

 CREATE PROCEDURE actualizaEdificio(IN iIDEdificio INTEGER(11) ,
 									IN cEdificio VARCHAR(150) ,
									IN iPisos INTEGER,
									IN cPisoEsp VARCHAR(100),
									IN cCalle VARCHAR(150) ,
									IN cNumExt VARCHAR(150) ,
									IN cColonia VARCHAR(150) ,
									IN cMunicipio VARCHAR(150),
									IN cEstado VARCHAR(150) ,
									IN cCP VARCHAR(10),
                                    IN lActivo TINYINT(1),
									IN cUsuario VARCHAR(50) ,
 									OUT lError TINYINT(1), 
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))
 	actualizaEdificio:BEGIN

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
			
			/*Valida que el edificio exista*/
			IF NOT EXISTS(SELECT * FROM ctEdificio WHERE ctEdificio.iIDEdificio = iIDEdificio)

				THEN 
					SET lError = 1; 
					SET cError = "El Edificio no existe";
					LEAVE actualizaEdificio;

			END IF;

			/*Valida que el edificio no este activo*/
			IF NOT EXISTS(SELECT * FROM ctEdificio WHERE ctEdificio.iIDEdificio = iIDEdificio 
													AND ctEdificio.lActivo  = 1)

				THEN 
					SET lError = 1; 
					SET cError = "El edificio ya fue borrado con anterioridad";
					LEAVE actualizaEdificio;

			END IF;

			IF cEdificio = "" OR cEdificio = NULL

				THEN 
					SET lError = 1;
					SET cError = "El nombre del edficio no tiene valor";
					LEAVE actualizaEdificio;

			END IF;

			IF cCalle = "" OR cCalle = NULL

				THEN 
					SET lError = 1;
					SET cError = "El dato calle no contine un valor";
					LEAVE actualizaEdificio;
			END IF;

			IF cNumExt = "" OR cNumExt = NULL

				THEN 
					SET lError = 1;
					SET cError = "El valor Numero Ext no tiene valor";
					LEAVE actualizaEdificio;
			END IF;

			IF cColonia = "" OR cColonia = NULL

				THEN 
					SET lError = 1;
					SET cError = "La colonia no tiene valor";
					LEAVE actualizaEdificio;
			END IF;

			IF cMunicipio = "" OR cMunicipio = NULL

				THEN 
					SET lError = 1;
					SET cError = "El Municipio no tiene valor";
					LEAVE actualizaEdificio;
			END IF;

			IF cEstado = "" OR cEstado = NULL

				THEN 
					SET lError = 1;
					SET cError = "El Estado no tiene valor";
					LEAVE actualizaEdificio;
			END IF;

			IF cCP = NULL OR cCP = ""

				THEN 
					SET lError = 1;
					SET cError = "El Codigo Postal no tiene valor";
					LEAVE actualizaEdificio;
			END IF;


			/*Realiza la actualizacion*/
			UPDATE ctEdificios
				SET ctEdificios.cEdificio     = cEdificio,
					ctEdificios.iPisos        = iPisos,
					ctEdificios.cPisoEsp      = cPisoEsp,
					ctEdificios.cCalle        = cCalle,
					ctEdificios.cNumExt       = cNumExt,
					ctEdificios.cColonia      = cColonia,
					ctEdificios.cMunicipio    = cMunicipio,
					ctEdificios.cEstado       = cEstado,
					ctEdificios.cCP           = cCP,
					ctEdificios.lActivo       = lActivo,
					ctEdificios.dtModificado  = NOW(),
                    ctEdificios.cUsuario      = cUsuario
				WHERE ctEdificios.iIDEdificio = iIDEdificio;
				
		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;