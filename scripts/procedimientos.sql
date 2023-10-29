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

#----------------------------------------  
# Procedimiento para habilitar un curso
#----------------------------------------  
DROP PROCEDURE IF EXISTS habilitarCurso;
DELIMITER $$
CREATE PROCEDURE habilitarCurso(
	IN in_codigo_curso INT,
	IN in_ciclo VARCHAR(2),
	IN in_docente INT,
	IN in_cupo_maximo SMALLINT,
	IN in_seccion VARCHAR(1)
)
proc_habilitar_curso: BEGIN
	DECLARE fecha_actual DATE;
	DECLARE anio_actual INT;
	SET anio_actual = YEAR(CURDATE());

	-- Valida que toda la información sea correcta
	IF NOT EXISTS(SELECT codigo_curso FROM CURSOS WHERE in_codigo_curso = codigo_curso) THEN
		SELECT 'Error, no existe un curso con el código ingresado' AS respuesta;
		LEAVE proc_habilitar_curso;
	ELSEIF cicloValido(in_ciclo) = 0 THEN
		SELECT 'Error, el ciclo debe ser "1S", "2S", "VJ", "VD"' AS respuesta;
		LEAVE proc_habilitar_curso;
	ELSEIF NOT EXISTS(SELECT siif FROM DOCENTES WHERE in_docente = siif) THEN
		SELECT 'Error, el código ingresado no corresponde a ningún docente' AS respuesta;
		LEAVE proc_habilitar_curso;
	ELSEIF esPositivo(in_cupo_maximo) = 0 THEN
		SELECT 'Error, el cupo máximo debe ser un número entero positivo' AS respuesta;
		LEAVE proc_habilitar_curso;
	ELSEIF seccionValida(in_seccion) = 0 THEN
		SELECT 'Error, la sección debe de ser entre A-Z' AS respuesta;
		LEAVE proc_habilitar_curso;
	END IF;

	-- Valida que la sección no sea repetida para el mismo código de curso
	IF EXISTS(
		SELECT codigo_curso
		FROM CURSOS_HABILITADOS
		WHERE(
			in_codigo_curso = codigo_curso AND
			in_ciclo = ciclo AND
			in_seccion = seccion AND
			anio_actual = anio
		)
	) 
    THEN
		SELECT 'Error, ya existe la sección para el curso ingresado' AS respuesta;
		LEAVE proc_habilitar_curso;
	END IF;

	SET in_ciclo = UPPER(in_ciclo);
    SET in_seccion = UPPER(in_seccion);
	-- Agrega el nuevo curso a la tabla
	INSERT INTO CURSOS_HABILITADOS(
		ciclo,
		seccion,
		anio,
		cupo_maximo,
		codigo_curso,
		siif
	)
	VALUES(
		in_ciclo,
		in_seccion,
		anio_actual,
		in_cupo_maximo,
		in_codigo_curso,
		in_docente
	);
	SELECT 'Curso habilitado con éxito' AS respuesta;
    INSERT INTO ASIGNACIONES(codigo_curso_habilitado, cantidad_asignados) VALUES (LAST_INSERT_ID(), 0);
END $$
DELIMITER ;

#----------------------------------------  
# Procedimiento para establecer un horario a un curso habilitado
#----------------------------------------  
DROP PROCEDURE IF EXISTS agregarHorario;
DELIMITER $$
CREATE PROCEDURE agregarHorario(
	IN in_codigo_curso_habilitado INT,
	IN in_dia TINYINT,
	IN in_horario VARCHAR(15)
)
proc_agregar_horario: BEGIN
	-- Validaciones
	IF NOT EXISTS(SELECT codigo_curso_habilitado FROM CURSOS_HABILITADOS WHERE in_codigo_curso_habilitado = codigo_curso_habilitado) THEN
		SELECT 'Error, el id ingresado no corresponde a ningún curso habilitado' AS respuesta;
		LEAVE proc_agregar_horario;
	ELSEIF diaValido(in_dia) = 0 THEN
		SELECT 'Error, el día debe ser entre 1-7' AS respuesta;
		LEAVE proc_agregar_horario;
	ELSEIF NOT horarioValido(in_horario) THEN
		SELECT 'Error, la hora ingresada no es válida' AS respuesta;
		LEAVE proc_agregar_horario;
	END IF;

	-- Ingresa en la tabla
	INSERT INTO HORARIOS(dia, horario, codigo_curso_habilitado) 
	VALUES(in_dia, in_horario, in_codigo_curso_habilitado);

	SELECT 'Horario registrado con éxito' AS respuesta;
END $$
DELIMITER ;

#----------------------------------------  
# Procedimiento para asignar un estudiante a un curso
#----------------------------------------  
DROP PROCEDURE IF EXISTS asignarCurso;
DELIMITER $$
CREATE PROCEDURE asignarCurso(
	IN in_codigo_curso INT,
	IN in_ciclo VARCHAR(2),
	IN in_seccion VARCHAR(1),
	IN in_carnet BIGINT
)
proc_asignar_curso: BEGIN
	DECLARE carrera_estudiante INT;
	DECLARE carrera_curso INT;
	DECLARE creditos_estudiante SMALLINT;
	DECLARE creditos_curso SMALLINT;
	DECLARE codigo_habilitado INT;
    -- DECLARE codigo_habilitado_aux INT;

	DECLARE anio_actual INT;
	SET anio_actual = YEAR(CURDATE());

	-- Validaciones de formato
	IF NOT soloNumeros(in_codigo_curso) THEN
		SELECT 'Error, el código del curso debe ser numérico' AS respuesta;
		LEAVE proc_asignar_curso;
	ELSEIF NOT cicloValido(in_ciclo) THEN
		SELECT 'Error, el ciclo debe ser "1S", "2S", "VJ", "VD"' AS respuesta;
		LEAVE proc_asignar_curso;
	ELSEIF NOT seccionValida(in_seccion) THEN
		SELECT 'Error, la sección debe de ser entre A-Z' AS respuesta;
		LEAVE proc_asignar_curso;
	ELSEIF NOT soloNumeros(in_carnet) THEN
		SELECT 'Error, el carnet debe ser numérico' AS respuesta;
		LEAVE proc_asignar_curso;
	END IF;

	-- Valida que el código del curso y el carnet existan
	IF NOT EXISTS(SELECT codigo_curso FROM CURSOS WHERE in_codigo_curso = codigo_curso) THEN
		SELECT 'Error, no existe un curso con el código ingresado' AS respuesta;
		LEAVE proc_asignar_curso;
	ELSEIF NOT EXISTS(SELECT carnet FROM ESTUDIANTES WHERE in_carnet = carnet) THEN
		SELECT 'Error, no existe ningún estudiante con ese número de carnet' AS respuesta;
		LEAVE proc_asignar_curso;
	END IF;

	-- Verifica que el estudiante pueda asignarse al curso (sea un curso de su carrera y cumpla con los créditos)
	SET carrera_estudiante = (SELECT codigo_carrera FROM ESTUDIANTES WHERE in_carnet = carnet);
	SET carrera_curso = (SELECT codigo_carrera FROM CURSOS WHERE in_codigo_curso = codigo_curso);
	IF carrera_estudiante <> carrera_curso AND carrera_curso <> 0 THEN
		SELECT 'Error, el curso no pertenece a la carrera del estudiante' AS respuesta;
		LEAVE proc_asignar_curso;
	END IF;

	-- Válida que el estudiante cuente con los créditos necesarios
	SET creditos_estudiante = (SELECT creditos FROM ESTUDIANTES WHERE in_carnet = carnet);
	SET creditos_curso = (SELECT creditos_necesarios FROM CURSOS WHERE in_codigo_curso = codigo_curso);
	IF creditos_curso > creditos_estudiante THEN
		SELECT 'Error, el estudiante no cuenta con los créditos necesarios para asignarse el curso' AS respuesta;
		LEAVE proc_asignar_curso;
	END IF;

	-- Verifica el match con curso habilitado (existencia de curso en cursos habilitados, ciclo, sección y año)
	SET in_ciclo = UPPER(in_ciclo);
	SET in_seccion = UPPER(in_seccion);
	
    -- Busca el match del curso con el ciclo y el año
	IF NOT EXISTS(
		SELECT codigo_curso_habilitado 
		FROM CURSOS_HABILITADOS 
		WHERE(
			in_codigo_curso = codigo_curso AND
			in_ciclo = ciclo AND
			anio_actual = anio
		)
    )THEN
		SELECT 'Error, el curso no está habilitado para el ciclo indicado en el año actual' AS respuesta;
        LEAVE proc_asignar_curso;
	ELSE
		-- EL curso si está habilitado en el período y año indicado, debe validar la sección
		IF NOT EXISTS(
			SELECT codigo_curso_habilitado 
			FROM CURSOS_HABILITADOS 
			WHERE(
				in_codigo_curso = codigo_curso AND
				in_ciclo = ciclo AND
                in_seccion = seccion AND
				anio_actual = anio
			)
        ) THEN
			SELECT 'Error, la sección ingresada no existe para el ciclo y año actual' AS respuesta;
            LEAVE proc_asignar_curso;
		END IF;
	END IF;
    
    -- Si el estudiante ya se deasigno no sé puede asignar nuevamente
    IF EXISTS(
		SELECT CURSOS_HABILITADOS.codigo_curso_habilitado
        FROM CURSOS_HABILITADOS
        INNER JOIN DESASIGNACIONES
        ON CURSOS_HABILITADOS.codigo_curso_habilitado = DESASIGNACIONES.codigo_curso_habilitado AND in_carnet = DESASIGNACIONES.carnet AND in_codigo_curso = CURSOS_HABILITADOS.codigo_curso
    ) THEN
		SELECT 'Error, el estudiante ya ha realizado una desasignación para el curso en el período actual' AS respuesta;
        LEAVE proc_asignar_curso;
	END IF;
    
    -- Verifica si el estudiante ya está asignado al curso sin importar la sección que sea
    IF EXISTS(
		SELECT CURSOS_HABILITADOS.codigo_curso_habilitado
        FROM CURSOS_HABILITADOS
        INNER JOIN ASIGNADOS 
        ON CURSOS_HABILITADOS.codigo_curso_habilitado = ASIGNADOS.codigo_curso_habilitado AND in_carnet = ASIGNADOS.carnet AND in_codigo_curso = CURSOS_HABILITADOS.codigo_curso
    ) THEN
		SELECT 'Error, el estudiante ya se encuentra asignado al curso' AS respuesta;
        LEAVE proc_asignar_curso;
	END IF;
    
	-- Recupera el código del curso habilitado
    SET codigo_habilitado = (
		SELECT codigo_curso_habilitado 
		FROM CURSOS_HABILITADOS 
		WHERE(
			in_codigo_curso = codigo_curso AND
			in_ciclo = ciclo AND
            in_seccion = seccion AND
			anio_actual = anio
		)
    );
    
    -- Revisa si hay cupo en la sección para poder asignar al estudiante
    IF NOT (SELECT cantidad_asignados FROM ASIGNACIONES WHERE codigo_habilitado = codigo_curso_habilitado) <
    (SELECT cupo_maximo FROM CURSOS_HABILITADOS WHERE codigo_habilitado = codigo_curso_habilitado) THEN
		SELECT 'Error, no se puede asignar al estudiante, la sección alcanzó el cupo máximo' AS respuesta;
        LEAVE proc_asignar_curso;
	END IF ;
    
    -- Si llego aquí quiere decir que el estudiante puede ser asignado
    INSERT INTO ASIGNADOS(codigo_curso_habilitado, carnet)
    VALUES(codigo_habilitado, in_carnet);
    SELECT 'Estudiante asignado con éxito' AS respuesta;
    
    UPDATE ASIGNACIONES
    SET cantidad_asignados = cantidad_asignados + 1
    WHERE codigo_habilitado = codigo_curso_habilitado;
END $$
DELIMITER ;

#----------------------------------------  
# Procedimiento para desasignar un estudiante a un curso
#----------------------------------------  
DROP PROCEDURE IF EXISTS desasignarCurso;
DELIMITER $$
CREATE PROCEDURE desasignarCurso(
	IN in_codigo_curso INT,
	IN in_ciclo VARCHAR(2),
	IN in_seccion VARCHAR(1),
	IN in_carnet BIGINT
)
proc_desasignar_curso: BEGIN
	DECLARE codigo_habilitado INT;
	DECLARE anio_actual INT;
	SET anio_actual = YEAR(CURDATE());

	-- Validaciones de formato
	IF NOT soloNumeros(in_codigo_curso) THEN
		SELECT 'Error, el código del curso debe ser numérico' AS respuesta;
		LEAVE proc_desasignar_curso;
	ELSEIF NOT cicloValido(in_ciclo) THEN
		SELECT 'Error, el ciclo debe ser "1S", "2S", "VJ", "VD"' AS respuesta;
		LEAVE proc_desasignar_curso;
	ELSEIF NOT seccionValida(in_seccion) THEN
		SELECT 'Error, la sección debe de ser entre A-Z' AS respuesta;
		LEAVE proc_desasignar_curso;
	ELSEIF NOT soloNumeros(in_carnet) THEN
		SELECT 'Error, el carnet debe ser numérico' AS respuesta;
		LEAVE proc_desasignar_curso;
	END IF;

	-- Valida que el código del curso y el carnet existan
	IF NOT EXISTS(SELECT codigo_curso FROM CURSOS WHERE in_codigo_curso = codigo_curso) THEN
		SELECT 'Error, no existe un curso con el código ingresado' AS respuesta;
		LEAVE proc_desasignar_curso;
	ELSEIF NOT EXISTS(SELECT carnet FROM ESTUDIANTES WHERE in_carnet = carnet) THEN
		SELECT 'Error, no existe ningún estudiante con ese número de carnet' AS respuesta;
		LEAVE proc_desasignar_curso;
	END IF;

	SET in_ciclo = UPPER(in_ciclo);
	SET in_seccion = UPPER(in_seccion);

    -- Busca el match del curso con el ciclo y el año
	IF NOT EXISTS(
		SELECT codigo_curso_habilitado 
		FROM CURSOS_HABILITADOS 
		WHERE(
			in_codigo_curso = codigo_curso AND
			in_ciclo = ciclo AND
			anio_actual = anio
		)
    )THEN
		SELECT 'Error, el curso no está habilitado para el ciclo indicado en el año actual' AS respuesta;
        LEAVE proc_desasignar_curso;
	ELSE
		-- EL curso si está habilitado en el período y año indicado, debe validar la sección
		IF NOT EXISTS(
			SELECT codigo_curso_habilitado 
			FROM CURSOS_HABILITADOS 
			WHERE(
				in_codigo_curso = codigo_curso AND
				in_ciclo = ciclo AND
                in_seccion = seccion AND
				anio_actual = anio
			)
        ) THEN
			SELECT 'Error, la sección ingresada no existe para el ciclo y año actual' AS respuesta;
            LEAVE proc_desasignar_curso;
		END IF;
	END IF;

    -- Verifica que el estudiante este asignado al curso sin importar la sección que sea
    IF NOT EXISTS(
		SELECT CURSOS_HABILITADOS.codigo_curso_habilitado
        FROM CURSOS_HABILITADOS
        INNER JOIN ASIGNADOS 
        ON CURSOS_HABILITADOS.codigo_curso_habilitado = ASIGNADOS.codigo_curso_habilitado AND in_carnet = ASIGNADOS.carnet AND in_codigo_curso = CURSOS_HABILITADOS.codigo_curso
    ) THEN
		SELECT 'Error, el estudiante no está asignado al curso' AS respuesta;
        LEAVE proc_desasignar_curso;
	END IF;

	-- Recupera el código del curso habilitado
    SET codigo_habilitado = (
		SELECT codigo_curso_habilitado 
		FROM CURSOS_HABILITADOS 
		WHERE(
			in_codigo_curso = codigo_curso AND
			in_ciclo = ciclo AND
            in_seccion = seccion AND
			anio_actual = anio
		)
    );

	-- Si llego aquí el estudiante puede ser desasignado
    INSERT INTO DESASIGNACIONES(codigo_curso_habilitado, carnet)
    VALUES(codigo_habilitado, in_carnet);
    SELECT 'Estudiante desasignado con éxito' AS respuesta;
    
	-- Lo elimina de la tabla de asignados
	DELETE FROM ASIGNADOS
	WHERE codigo_curso_habilitado = codigo_habilitado AND carnet = in_carnet;
	-- Actualiza la tabla de asignaciones, para actualizar el cupo
    UPDATE ASIGNACIONES
    SET cantidad_asignados = cantidad_asignados - 1
    WHERE codigo_habilitado = codigo_curso_habilitado;
END $$
DELIMITER ;

#----------------------------------------  
# Procedimiento para ingresar notas
#----------------------------------------  
DROP PROCEDURE IF EXISTS ingresarNota;
DELIMITER $$
CREATE PROCEDURE ingresarNota(
	IN in_codigo_curso INT,
	IN in_ciclo VARCHAR(2),
	IN in_seccion VARCHAR(1),
	IN in_carnet BIGINT,
	IN in_nota TINYINT
)
proc_ingresar_nota: BEGIN
	DECLARE codigo_habilitado INT;
	DECLARE anio_actual INT;
	SET anio_actual = YEAR(CURDATE());

	-- Validaciones de formato
	IF NOT soloNumeros(in_codigo_curso) THEN
		SELECT 'Error, el código del curso debe ser numérico' AS respuesta;
		LEAVE proc_ingresar_nota;
	ELSEIF NOT cicloValido(in_ciclo) THEN
		SELECT 'Error, el ciclo debe ser "1S", "2S", "VJ", "VD"' AS respuesta;
		LEAVE proc_ingresar_nota;
	ELSEIF NOT seccionValida(in_seccion) THEN
		SELECT 'Error, la sección debe de ser entre A-Z' AS respuesta;
		LEAVE proc_ingresar_nota;
	ELSEIF NOT soloNumeros(in_carnet) THEN
		SELECT 'Error, el carnet debe ser numérico' AS respuesta;
		LEAVE proc_ingresar_nota;
	ELSEIF NOT esPositivo(in_nota) THEN
		SELECT 'Error, la nota debe ser un número positivo' AS respuesta;
		LEAVE proc_ingresar_nota;
	END IF;

	-- Valida que el código del curso y el carnet existan
	IF NOT EXISTS(SELECT codigo_curso FROM CURSOS WHERE in_codigo_curso = codigo_curso) THEN
		SELECT 'Error, no existe un curso con el código ingresado' AS respuesta;
		LEAVE proc_ingresar_nota;
	ELSEIF NOT EXISTS(SELECT carnet FROM ESTUDIANTES WHERE in_carnet = carnet) THEN
		SELECT 'Error, no existe ningún estudiante con ese número de carnet' AS respuesta;
		LEAVE proc_ingresar_nota;
	END IF;

	SET in_ciclo = UPPER(in_ciclo);
	SET in_seccion = UPPER(in_seccion);

    -- Busca el match del curso con el ciclo y el año
	IF NOT EXISTS(
		SELECT codigo_curso_habilitado 
		FROM CURSOS_HABILITADOS 
		WHERE(
			in_codigo_curso = codigo_curso AND
			in_ciclo = ciclo AND
			anio_actual = anio
		)
    )THEN
		SELECT 'Error, el curso no está habilitado para el ciclo indicado en el año actual' AS respuesta;
        LEAVE proc_ingresar_nota;
	ELSE
		-- EL curso si está habilitado en el período y año indicado, debe validar la sección
		IF NOT EXISTS(
			SELECT codigo_curso_habilitado 
			FROM CURSOS_HABILITADOS 
			WHERE(
				in_codigo_curso = codigo_curso AND
				in_ciclo = ciclo AND
                in_seccion = seccion AND
				anio_actual = anio
			)
        ) THEN
			SELECT 'Error, la sección ingresada no existe para el ciclo y año actual' AS respuesta;
            LEAVE proc_ingresar_nota;
		END IF;
	END IF;

    -- Verifica que el estudiante este asignado al curso sin importar la sección que sea
    IF NOT EXISTS(
		SELECT CURSOS_HABILITADOS.codigo_curso_habilitado
        FROM CURSOS_HABILITADOS
        INNER JOIN ASIGNADOS 
        ON CURSOS_HABILITADOS.codigo_curso_habilitado = ASIGNADOS.codigo_curso_habilitado AND in_carnet = ASIGNADOS.carnet AND in_codigo_curso = CURSOS_HABILITADOS.codigo_curso
    ) THEN
		SELECT 'Error, el estudiante no está asignado al curso' AS respuesta;
        LEAVE proc_ingresar_nota;
	END IF;

	-- Recupera el código del curso habilitado
    SET codigo_habilitado = (
		SELECT codigo_curso_habilitado 
		FROM CURSOS_HABILITADOS 
		WHERE(
			in_codigo_curso = codigo_curso AND
			in_ciclo = ciclo AND
            in_seccion = seccion AND
			anio_actual = anio
		)
    );

	-- Revisa que no se haya registrado ya una nota para el estudiante
    IF EXISTS(SELECT id_nota FROM NOTAS WHERE codigo_habilitado = codigo_curso_habilitado AND in_carnet = carnet) THEN
		SELECT 'Error, ya se ha registrado una nota para el estudiante en el curso ingresado' AS respuesta;
        LEAVE proc_ingresar_nota;
	END IF;

	-- Si llego aquí se puede ingresar la nota del estudiante
	INSERT INTO NOTAS(nota, carnet, codigo_curso_habilitado)
	VALUES(in_nota, in_carnet, codigo_habilitado);
	SELECT 'Nota ingresada con éxito' AS respuesta;

	-- Si la nota es >= 61 el estudiante obtiene los créditos que da el curso
	IF in_nota >= 61 THEN
		UPDATE ESTUDIANTES
		SET creditos = creditos + (SELECT creditos_otorga FROM CURSOS WHERE in_codigo_curso = codigo_curso)
		WHERE in_carnet = carnet;
	END IF;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS generarActa;
DELIMITER $$
CREATE PROCEDURE generarActa(
	IN in_codigo_curso INT,
	IN in_ciclo VARCHAR(2),
	IN in_seccion VARCHAR(1)
)
proc_generar_acta: BEGIN
	DECLARE codigo_habilitado INT;
	DECLARE numero_asignados INT;
	DECLARE anio_actual INT;
	SET anio_actual = YEAR(CURDATE());

	-- Validaciones de formato
	IF NOT soloNumeros(in_codigo_curso) THEN
		SELECT 'Error, el código del curso debe ser numérico' AS respuesta;
		LEAVE proc_generar_acta;
	ELSEIF NOT cicloValido(in_ciclo) THEN
		SELECT 'Error, el ciclo debe ser "1S", "2S", "VJ", "VD"' AS respuesta;
		LEAVE proc_generar_acta;
	ELSEIF NOT seccionValida(in_seccion) THEN
		SELECT 'Error, la sección debe de ser entre A-Z' AS respuesta;
		LEAVE proc_generar_acta;
	END IF;

	-- Valida que el código exista
	IF NOT EXISTS(SELECT codigo_curso FROM CURSOS WHERE in_codigo_curso = codigo_curso) THEN
		SELECT 'Error, no existe un curso con el código ingresado' AS respuesta;
		LEAVE proc_generar_acta;
	END IF;

	SET in_ciclo = UPPER(in_ciclo);
	SET in_seccion = UPPER(in_seccion);

    -- Busca el match del curso con el ciclo y el año
	IF NOT EXISTS(
		SELECT codigo_curso_habilitado 
		FROM CURSOS_HABILITADOS 
		WHERE(
			in_codigo_curso = codigo_curso AND
			in_ciclo = ciclo AND
			anio_actual = anio
		)
    )THEN
		SELECT 'Error, el curso no está habilitado para el ciclo indicado en el año actual' AS respuesta;
        LEAVE proc_generar_acta;
	ELSE
		-- EL curso si está habilitado en el período y año indicado, debe validar la sección
		IF NOT EXISTS(
			SELECT codigo_curso_habilitado 
			FROM CURSOS_HABILITADOS 
			WHERE(
				in_codigo_curso = codigo_curso AND
				in_ciclo = ciclo AND
                in_seccion = seccion AND
				anio_actual = anio
			)
        ) THEN
			SELECT 'Error, la sección ingresada no existe para el ciclo y año actual' AS respuesta;
            LEAVE proc_generar_acta;
		END IF;
	END IF;

	-- Recupera el código del curso habilitado
    SET codigo_habilitado = (
		SELECT codigo_curso_habilitado 
		FROM CURSOS_HABILITADOS 
		WHERE(
			in_codigo_curso = codigo_curso AND
			in_ciclo = ciclo AND
            in_seccion = seccion AND
			anio_actual = anio
		)
    );

	-- Valida que no se haya generado ya el acta para el curso
	IF EXISTS(SELECT id_acta FROM ACTAS WHERE codigo_habilitado = codigo_curso_habilitado) THEN
		SELECT 'Error, ya se ha generado el acta de notas para el curso' AS respuesta;
		LEAVE proc_generar_acta;
	END IF;

	-- Revisa que se haya ingresado todas las notas para el curso según el número de asignados
	SET numero_asignados = (SELECT cantidad_asignados FROM ASIGNACIONES WHERE codigo_habilitado = codigo_curso_habilitado);
	IF numero_asignados = 0 THEN
		SELECT 'Error, no se puede generar el acta. El curso no tiene estudiantes asignados' AS respuesta;
		LEAVE proc_generar_acta;
	ELSEIF numero_asignados > (SELECT count(nota) FROM NOTAS WHERE codigo_habilitado = codigo_curso_habilitado) THEN
		SELECT 'Error, no es posible generar el acta. El ingreso de notas para el curso aún no está completo' AS respuesta;
		LEAVE proc_generar_acta;
	END IF;

	-- Si llego a aquí se puede generar el acta
	INSERT INTO ACTAS(fecha, hora, codigo_curso_habilitado)
	VALUES(CURDATE(), CURTIME(), codigo_habilitado);
	SELECT 'Acta de notas generada con éxito' AS respuesta;
END $$
DELIMITER ;
