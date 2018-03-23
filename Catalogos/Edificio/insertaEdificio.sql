/**
 * 
 * Autor: Bogar Chavez
 * Fecha: 06/03/2018
 * Descripcion: 
 *  
 * Modificaciones:
 * <Quien modifico:> <Cuando modifico:> <Donde modifico:>
 * Ejemplo: Bogar Chavez 06/09/2017 In-06 Fn-
 *
 * Nota: 0 es falso, 1 es verdadero
 * 
 */
 DELIMITER //
CREATE PROCEDURE insertaEdificio(	IN cEdificio VARCHAR(150) ,
									IN iPisos INTEGER,
									IN cPisoEsp VARCHAR(100),
									IN cCalle VARCHAR(150) ,
									IN cNumExt VARCHAR(150) ,
									IN cColonia VARCHAR(150) ,
									IN cMunicipio VARCHAR(150),
									IN cEstado VARCHAR(150) ,
									IN cCP VARCHAR(10),
									IN cUsuario VARCHAR(50) ,
 									OUT lError TINYINT(1), 
 									OUT cSqlState VARCHAR(50), 
 									OUT cError VARCHAR(200))

 	insertaEdificio:BEGIN

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


			/*Verifica que el edificio no exista con anterioridad*/
			IF EXISTS(SELECT * FROM ctEdificios WHERE ctEdificios.cEdificio = cEdificio)

				THEN 
					SET lError = 1; 
					SET cError = "El Edificio ya existe";
					LEAVE ctEdificios;

			END IF;


			/*Se valida que los dato no se encunetre nulos o vacios respecto a la tabla*/
			
			IF cEdificio = "" OR cEdificio = NULL

				THEN 
					SET lError = 1;
					SET cError = "El nombre del edficio no tiene valor";
					LEAVE ctEdificios;

			END IF;

			IF cCalle = "" OR cCalle = NULL

				THEN 
					SET lError = 1;
					SET cError = "El dato calle no contine un valor";
					LEAVE ctEdificios;
			END IF;

			IF cNumExt = "" OR cNumExt = NULL

				THEN 
					SET lError = 1;
					SET cError = "El valor Numero Ext no tiene valor";
					LEAVE ctEdificios;
			END IF;

			IF cColonia = "" OR cColonia = NULL

				THEN 
					SET lError = 1;
					SET cError = "La colonia no tiene valor";
					LEAVE ctEdificios;
			END IF;

			IF cMunicipio = "" OR cMunicipio = NULL

				THEN 
					SET lError = 1;
					SET cError = "El Municipio no tiene valor";
					LEAVE ctEdificios;
			END IF;

			IF cEstado = "" OR cEstado = NULL

				THEN 
					SET lError = 1;
					SET cError = "El Estado no tiene valor";
					LEAVE ctEdificios;
			END IF;

			IF cCP = NULL OR cCP = ""

				THEN 
					SET lError = 1;
					SET cError = "El Codigo Postal no tiene valor";
					LEAVE ctEdificios;
			END IF;



			INSERT INTO ctEdificios(
									ctEdificios.cEdificio, 
									ctEdificios.iPisos, 
									ctEdificios.cPisoEsp, 
									ctEdificios.cCalle, 
									ctEdificios.cNumExt, 
									ctEdificios.cColonia, 
									ctEdificios.cMunicipio, 
									ctEdificios.cEstado, 
									ctEdificios.cCP, 
									ctEdificios.lActivo,
									ctEdificios.dtCreado
									ctEdificios.cUsuario )
						VALUES	(
									cEdificio,
									iPisos,
									cPisoEsp,
									cCalle,
									cNumExt,
									cColonia,
									cMunicipio,
									cEstado,
									cCP,
									1,
									NOW(),
									cUsuario);

		COMMIT;

	END;//
	
 /*Reseteo del delimitador*/	
 DELIMITER ;