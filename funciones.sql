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
	RETURN IF (numero REGEXP '^[0-9]+$',true,false);
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
	RETURN IF (texto REGEXP '^[a-zA-ZáéíóúÁÉÍÓÚ ]+$', true, false);
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
RETURN IF 
	(correo REGEXP '^[a-zA-Z0-9]+@[a-zA-Z]+(\.[a-zA-Z]+)+$',true,false);
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
