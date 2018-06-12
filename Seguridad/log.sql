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
 DROP PROCEDURE IF EXISTS `log_msg`;
 DELIMITER //
	CREATE PROCEDURE `log_msg`(IN msg text)
	BEGIN
	    insert into logtable(logtable.log) values (msg);
	END;//
 /*Reseteo del delimitador*/	
 DELIMITER ;