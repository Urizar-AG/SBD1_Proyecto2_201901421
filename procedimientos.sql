USE proyecto2_fiusac;

#----------------------------------------  
# Procedimiento para crear una nueva carrera
#----------------------------------------  
DROP PROCEDURE IF EXISTS crearCarrera;
DELIMITER $$
CREATE PROCEDURE crearCarrera(
	IN nombre_carrera VARCHAR(50)
)
proc_crear_carrera: BEGIN
    SET nombre_carrera = UPPER(nombre_carrera);
	IF (SELECT soloLetras(nombre_carrera)) = 1 THEN
		IF NOT EXISTS (SELECT nombre FROM CARRERAS WHERE nombre = nombre_carrera) THEN
			INSERT INTO CARRERAS (nombre) VALUE(nombre_carrera);
            SELECT 'Carrera creada con éxito' AS respuesta;
		ELSE
			SELECT 'Ya existe una carrera registrada con ese nombre' AS respuesta;
		END IF;
	ELSE
	    SELECT 'Error, el nombre de la carrera solo puede contener letras' AS respuesta;
	END IF;
END $$
DELIMITER ;

#----------------------------------------  
# Procedimiento para registrar un nuevo estudiante
#----------------------------------------  
DROP PROCEDURE IF EXISTS registrarEstudiante;
DELIMITER $$
CREATE PROCEDURE registrarEstudiante(
	IN in_carnet BIGINT,
	IN in_nombres VARCHAR(50),
	IN in_apellidos VARCHAR(50),
	IN in_fecha_nacimiento VARCHAR(50),
	IN in_correo VARCHAR(50),
	IN in_telefono INT,
	IN in_direccion VARCHAR(50),
	IN in_dpi BIGINT,
	IN in_carrera INT
)
proc_registrar_estudiante: BEGIN
	DECLARE fecha_nacimiento DATE;
    
	-- Revisa los campos únicos
	IF EXISTS(SELECT carnet FROM ESTUDIANTES WHERE in_carnet = carnet) THEN
		SELECT 'Error, el carnet ingresado ya está registrado' AS respuesta;
		LEAVE proc_registrar_estudiante;
	ELSEIF EXISTS(SELECT correo FROM ESTUDIANTES WHERE in_correo = correo) THEN
		SELECT 'Error, el correo ingresado ya está registrado' AS respuesta;
		LEAVE proc_registrar_estudiante;
	ELSEIF EXISTS(SELECT dpi FROM ESTUDIANTES WHERE in_dpi = dpi) THEN
		SELECT 'Error, el DPI ingresado ya está registrado' AS respuesta;
		LEAVE proc_registrar_estudiante;
	END IF;

	-- Validaciones
	IF (SELECT soloLetras(in_nombres)) = 0 THEN
		SELECT 'Error, el nombre solo puede contener letras' AS respuesta;
		LEAVE proc_registrar_estudiante;
	ELSEIF (SELECT soloLetras(in_apellidos)) = 0 THEN
		SELECT 'Error, el apellido solo puede contener letras' AS respuesta;
		LEAVE proc_registrar_estudiante;
	ELSEIF (SELECT correoValido(in_correo)) = 0 THEN
		SELECT 'Error, el correo ingresado no es válido' AS respuesta;
		LEAVE proc_registrar_estudiante;
	ELSEIF NOT EXISTS(SELECT codigo_carrera FROM CARRERAS WHERE in_carrera = codigo_carrera) THEN
		SELECT 'Error, el número de carrera ingresado no existe' AS respuesta;
		LEAVE proc_registrar_estudiante;
	END IF;
	
	IF STR_TO_DATE(in_fecha_nacimiento, '%d-%m-%Y') IS NOT NULL THEN
    	SET fecha_nacimiento = STR_TO_DATE(in_fecha_nacimiento, '%d-%m-%Y');
	ELSEIF STR_TO_DATE(in_fecha_nacimiento, '%Y-%m-%d') IS NOT NULL THEN
    	SET fecha_nacimiento = STR_TO_DATE(in_fecha_nacimiento, '%Y-%m-%d');
	ELSE
		SELECT 'Error, formato de fecha no válido, debe ser DD-MM-YYYY o YYYY-MM-DD' AS respuesta;
		LEAVE proc_registrar_estudiante;
	END IF;

	-- Inserta el nuevo estudiante en la tabla
    SET in_nombres = UPPER(in_nombres);
    SET in_apellidos = UPPER(in_apellidos);
    SET in_direccion = UPPER(in_direccion);
	INSERT INTO ESTUDIANTES VALUES(
		in_carnet,
		in_nombres, 
		in_apellidos, 
		fecha_nacimiento, 
		in_correo, 
		in_telefono, 
		in_direccion, 
		in_dpi,
		in_carrera,
		0,
		CURDATE()
	);
	SELECT 'Estudiante registrado con éxito' AS respuesta;
END $$
DELIMITER ;

#----------------------------------------  
# Procedimiento para registrar un nuevo docente
#----------------------------------------  
DROP PROCEDURE IF EXISTS registrarDocente;
DELIMITER $$
CREATE PROCEDURE registrarDocente(
	IN in_nombres VARCHAR(50),
	IN in_apellidos VARCHAR(50),
	IN in_fecha_nacimiento VARCHAR(50),
	IN in_correo VARCHAR(50),
	IN in_telefono INT,
	IN in_direccion VARCHAR(50),
	IN in_dpi BIGINT,
	IN in_siif INT
)
proc_registrar_docente: BEGIN
	DECLARE fecha_nacimiento DATE;

	-- Revisa los campos únicos
	IF EXISTS(SELECT siif FROM DOCENTES WHERE in_siif = siif) THEN
		SELECT 'Error, el SIIF ingresado ya está registrado' AS respuesta;
		LEAVE proc_registrar_docente;
	ELSEIF EXISTS(SELECT correo FROM DOCENTES WHERE in_correo = correo) THEN
		SELECT 'Error, el correo ingresado ya está registrado' AS respuesta;
		LEAVE proc_registrar_docente;
	ELSEIF EXISTS(SELECT dpi FROM DOCENTES WHERE in_dpi = dpi) THEN
		SELECT 'Error, el DPI ingresado ya está registrado' AS respuesta;
		LEAVE proc_registrar_docente;
	END IF;

	-- Validaciones
	IF (SELECT correoValido(in_correo)) = 0 THEN
		SELECT 'Error, el correo ingresado no es válido' AS respuesta;
		LEAVE proc_registrar_docente;
	END IF;
	IF STR_TO_DATE(in_fecha_nacimiento, '%d-%m-%Y') IS NOT NULL THEN
    	SET fecha_nacimiento = STR_TO_DATE(in_fecha_nacimiento, '%d-%m-%Y');
	ELSEIF STR_TO_DATE(in_fecha_nacimiento, '%Y-%m-%d') IS NOT NULL THEN
    	SET fecha_nacimiento = STR_TO_DATE(in_fecha_nacimiento, '%Y-%m-%d');
	ELSE
		SELECT 'Error, formato de fecha no válido, debe ser DD-MM-YYYY o YYYY-MM-DD' AS respuesta;
		LEAVE proc_registrar_docente;
	END IF;

	-- Inserta el nuevo docente en la tabla
    SET in_nombres = UPPER(in_nombres);
    SET in_apellidos = UPPER(in_apellidos);
    SET in_direccion = UPPER(in_direccion);
	INSERT INTO DOCENTES VALUES(
		in_siif,
		in_nombres,
		in_apellidos,
		fecha_nacimiento,
		in_correo,
		in_telefono,
		in_direccion,
		in_dpi,
		CURDATE()
	);
	SELECT 'Docente registrado con éxito' AS respuesta;
END $$
DELIMITER ;

#----------------------------------------  
# Procedimiento para crear un nuevo curso
#----------------------------------------  
DROP PROCEDURE IF EXISTS crearCurso;
DELIMITER $$
CREATE PROCEDURE crearCurso(
	IN in_codigo INT,
	IN in_nombre VARCHAR(50),
	IN in_creditos_necesarios SMALLINT,
	IN in_creditos_otorga SMALLINT,
	IN in_carrera INT,
	IN in_obligatorio TINYINT
)
proc_crear_curso: BEGIN
	-- Revisa los campos únicos
	IF EXISTS(SELECT codigo_curso FROM CURSOS WHERE in_codigo = codigo_curso) THEN
		SELECT 'Error, el código ingresado para el curso ya está registrado' AS respuesta;
		LEAVE proc_crear_curso;
	END IF;

	-- Validaciones
	IF (esPositivo(in_creditos_necesarios)) = 0 THEN
		SELECT 'Error, la cantidad de créditos necesarios debe ser positiva' AS respuesta;
		LEAVE proc_crear_curso;
	ELSEIF (esPositivo(in_creditos_otorga)) = 0 THEN
		SELECT 'Error, la cantidad de créditos que otorga debe ser positiva' AS respuesta;
		LEAVE proc_crear_curso;
	ELSEIF in_obligatorio < 0 THEN
		SELECT 'Error, obligatoriedad solo puede ser 0 o 1, false or true' AS respuesta;
		LEAVE proc_crear_curso;
	ELSEIF in_obligatorio > 1 THEN
		SELECT 'Error, obligatoriedad solo puede ser 0 o 1, false or true' AS respuesta;
		LEAVE proc_crear_curso;
	ELSEIF NOT EXISTS (SELECT codigo_carrera FROM CARRERAS WHERE in_carrera = codigo_carrera) THEN
		SELECT 'Error, el número de carrera ingresado no existe' AS respuesta;
		LEAVE proc_crear_curso;
	END IF;

	-- Crea el nuevo curso en la tabla
	SET in_nombre = UPPER(in_nombre);
	INSERT INTO CURSOS VALUES(
		in_codigo,
		in_nombre,
		in_creditos_necesarios,
		in_creditos_otorga,
		in_obligatorio,
		in_carrera
	);
	SELECT 'Curso creado con éxito' AS respuesta;
END $$
DELIMITER ;
