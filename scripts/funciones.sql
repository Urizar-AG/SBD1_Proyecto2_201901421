USE proyecto2_fiusac;

#----------------------------------------  
# Función para validar que la cadena contenga solo números 
#----------------------------------------  
DROP FUNCTION IF EXISTS soloNumeros;
DELIMITER $$
CREATE FUNCTION soloNumeros(
	numero VARCHAR(100)
)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	RETURN IF (numero REGEXP '^[0-9]+$', TRUE, FALSE);
END $$
DELIMITER ;

#----------------------------------------  
# Función para validar que la cadena contenga solo letras o espacio
#----------------------------------------  
DROP FUNCTION IF EXISTS soloLetras;
DELIMITER $$
CREATE FUNCTION soloLetras(
	texto VARCHAR(100)
)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	RETURN IF (texto REGEXP '^[a-zA-ZáéíóúÁÉÍÓÚ ]+$', TRUE, FALSE);
END $$
DELIMITER ;

#----------------------------------------  
# Función para validar que la cadena sea un formato de correo válido
#----------------------------------------  
DROP FUNCTION IF EXISTS correoValido;
DELIMITER $$
CREATE FUNCTION correoValido(
	correo VARCHAR(60)
)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	RETURN IF (correo REGEXP '^[a-zA-Z0-9]+@[a-zA-Z]+(\.[a-zA-Z]+)+$', TRUE, FALSE);
END $$
DELIMITER ;

#----------------------------------------  
# Función para validar que un SMALLINT sea positivo
#---------------------------------------- 
DROP FUNCTION IF EXISTS esPositivo;
DELIMITER $$
CREATE FUNCTION esPositivo(
	numero SMALLINT
)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	IF numero >= 0 THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END $$
DELIMITER ;

#----------------------------------------  
# Función para validar el ciclo
#---------------------------------------- 
DROP FUNCTION IF EXISTS cicloValido;
DELIMITER $$
CREATE FUNCTION cicloValido(
	ciclo VARCHAR(2)
)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	IF ciclo = '1S' OR ciclo = '1s' THEN
		RETURN TRUE;
	ELSEIF ciclo = '2S' OR ciclo = '2s' THEN
		RETURN TRUE;
	ELSEIF ciclo = 'VJ' OR ciclo = 'vj' OR ciclo = 'Vj' OR ciclo = 'vJ' THEN
		RETURN TRUE;
	ELSEIF ciclo = 'VD' OR ciclo = 'vd' OR ciclo = 'Vd' OR ciclo = 'vD' THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END $$
DELIMITER ;

#----------------------------------------  
# Función para validar la seccion
#---------------------------------------- 
DROP FUNCTION IF EXISTS seccionValida;
DELIMITER $$
CREATE FUNCTION seccionValida(
	seccion VARCHAR(1)
)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	RETURN IF (seccion REGEXP '^[a-zA-Z]$', TRUE, FALSE);
END $$
DELIMITER ;

#----------------------------------------  
# Función para validar el formato del horario
#---------------------------------------- 
DROP FUNCTION IF EXISTS horarioValido;
DELIMITER $$
CREATE FUNCTION horarioValido(
	horario VARCHAR(15)
)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	RETURN IF (horario REGEXP '^(([0-1][0-9]:[0-5][0-9])|(2[0-3]:[0-5][0-9]))-(([0-1][0-9]:[0-5][0-9])|(2[0-3]:[0-5][0-9]))$', TRUE, FALSE);
END $$
DELIMITER ;

#----------------------------------------  
# Función para validar el número de día
#---------------------------------------- 
DROP FUNCTION IF EXISTS diaValido;
DELIMITER $$
CREATE FUNCTION diaValido(
	dia TINYINT
)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	RETURN IF (dia REGEXP '^[1-7]$', TRUE, FALSE);
END $$
DELIMITER ;
