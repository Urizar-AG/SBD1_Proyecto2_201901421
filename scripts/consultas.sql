USE proyecto2_fiusac;

#----------------------------------------  
# Consulta 1: Ver el pensum de una carrera
#---------------------------------------- 
DROP PROCEDURE IF EXISTS consultarPensum;
DELIMITER $$
CREATE PROCEDURE consultarPensum(
	IN in_carrera INT
)
proc_consultar_pensum: BEGIN
	IF NOT EXISTS(SELECT codigo_carrera FROM CARRERAS WHERE in_carrera = codigo_carrera) THEN
		SELECT 'Error, el código ingresado no corresponde a una carrera' AS respuesta;
        LEAVE proc_consultar_pensum;
	END IF;

	SELECT 
		codigo_curso,
		nombre,
		IF(obligatorio = 1, 'Sí', 'No') AS 'obligatorio',
		creditos_necesarios
	FROM CURSOS
	WHERE in_carrera = codigo_carrera OR codigo_carrera = 0;
END $$
DELIMITER ;

#----------------------------------------  
# Consulta 2: Ver la información de un estudiante
#---------------------------------------- 
DROP PROCEDURE IF EXISTS consultarEstudiante;
DELIMITER $$
CREATE PROCEDURE consultarEstudiante(
	IN in_carnet INT
)
proc_consultar_estudiante: BEGIN
	IF NOT EXISTS(SELECT carnet FROM ESTUDIANTES WHERE in_carnet = carnet) THEN
		SELECT 'Error, el carnet ingresado no corresponde a ningún estudiante' AS respuesta;
		LEAVE proc_consultar_estudiante;
	END IF;

	SELECT
		carnet,
		CONCAT(nombres, ' ', apellidos) AS nombre_completo,
		DATE_FORMAT(fecha_nacimiento, '%d-%m-%Y') AS fecha_nacimiento,
		correo,
		telefono,
		direccion,
		dpi,
		(SELECT nombre FROM CARRERAS C WHERE C.codigo_carrera = E.codigo_carrera) AS carrera,
		creditos
	FROM ESTUDIANTES E
	WHERE in_carnet = carnet;
END $$
DELIMITER ;

#----------------------------------------  
# Consulta 3: Ver la información de un profesor
#---------------------------------------- 
DROP PROCEDURE IF EXISTS consultarDocente;
DELIMITER $$
CREATE PROCEDURE consultarDocente(
	IN in_siif INT
)
proc_consultar_docente: BEGIN
	IF NOT EXISTS(SELECT siif FROM DOCENTES WHERE in_siif = siif) THEN
		SELECT 'Error, el código ingresado no corresponde a ningún docente' AS respuesta;
		LEAVE proc_consultar_docente;
	END IF;

	SELECT
		siif AS registro_SIIF,
		CONCAT(nombres, ' ', apellidos) AS nombre_completo,
		DATE_FORMAT(fecha_nacimiento, '%d-%m-%Y') AS fecha_nacimiento,
		correo,
		telefono,
		direccion,
		dpi
	FROM DOCENTES
	WHERE in_siif = siif;
END $$
DELIMITER ;

#----------------------------------------  
# Consulta 4: Ver los estudiantes asignados a un curso
#---------------------------------------- 
DROP PROCEDURE IF EXISTS consultarAsignados;
DELIMITER $$
CREATE PROCEDURE consultarAsignados(
	IN in_codigo_curso INT,
	IN in_ciclo VARCHAR(2),
	IN in_anio INT,
	IN in_seccion VARCHAR(1)
)
proc_consultar_asignados: BEGIN
	DECLARE codigo_habilitado INT;

	-- Validaciones de formato
	IF NOT EXISTS(SELECT codigo_curso FROM CURSOS WHERE in_codigo_curso = codigo_curso) THEN
		SELECT 'Error, el código ingresado no corresponde a ningún curso' AS respuesta;
		LEAVE proc_consultar_asignados;
	ELSEIF cicloValido(in_ciclo) = 0 THEN
		SELECT 'Error, el ciclo debe ser "1S", "2S", "VJ", "VD"' AS respuesta;
		LEAVE proc_consultar_asignados;
	ELSEIF seccionValida(in_seccion) = 0 THEN
		SELECT 'Error, la sección debe de ser entre A-Z' AS respuesta;
		LEAVE proc_consultar_asignados;
	END IF;

	-- Verifica que el curso si este habilitado según el ciclo, año y sección
	SET codigo_habilitado = (
		SELECT codigo_curso_habilitado
		FROM CURSOS_HABILITADOS
		WHERE(
			in_codigo_curso = codigo_curso AND 
			in_ciclo = ciclo AND 
			in_anio = anio AND 
			in_seccion = seccion
		)
	);
	IF codigo_habilitado IS NULL THEN
		SELECT 'El curso no está habilitado para el ciclo, sección y año ingresados' AS respuesta;
		LEAVE proc_consultar_asignados;
	END IF;

	-- Hace la consulta
	SELECT 
		E.carnet, 
		CONCAT(E.nombres, ' ', E.apellidos) AS nombre_completo,
		E.creditos
	FROM ESTUDIANTES E
	INNER JOIN ASIGNADOS A
	ON E.carnet = A.carnet
	WHERE A.codigo_curso_habilitado = codigo_habilitado;	
END $$
DELIMITER ;

#----------------------------------------  
# Consulta 5: Ver los estudiantes aprobados y reprobados para un curso
#---------------------------------------- 
DROP PROCEDURE IF EXISTS consultarAprobacion;
DELIMITER $$
CREATE PROCEDURE consultarAprobacion(
	IN in_codigo_curso INT,
	IN in_ciclo VARCHAR(2),
	IN in_anio INT,
	IN in_seccion VARCHAR(1)
)
proc_consultar_aprobacion: BEGIN
	DECLARE codigo_habilitado INT;

	-- Validaciones de formato
	IF NOT EXISTS(SELECT codigo_curso FROM CURSOS WHERE in_codigo_curso = codigo_curso) THEN
		SELECT 'Error, el código ingresado no corresponde a ningún curso' AS respuesta;
		LEAVE proc_consultar_aprobacion;
	ELSEIF cicloValido(in_ciclo) = 0 THEN
		SELECT 'Error, el ciclo debe ser "1S", "2S", "VJ", "VD"' AS respuesta;
		LEAVE proc_consultar_aprobacion;
	ELSEIF seccionValida(in_seccion) = 0 THEN
		SELECT 'Error, la sección debe de ser entre A-Z' AS respuesta;
		LEAVE proc_consultar_aprobacion;
	END IF;

	-- Verifica que el curso si este habilitado según el ciclo, año y sección
	SET codigo_habilitado = (
		SELECT codigo_curso_habilitado
		FROM CURSOS_HABILITADOS
		WHERE(
			in_codigo_curso = codigo_curso AND 
			in_ciclo = ciclo AND 
			in_anio = anio AND 
			in_seccion = seccion
		)
	);
	IF codigo_habilitado IS NULL THEN
		SELECT 'El curso no está habilitado para el ciclo, sección y año ingresados' AS respuesta;
		LEAVE proc_consultar_aprobacion;
	END IF;

	-- Hace la consulta
	SELECT
		C.codigo_curso,
		E.carnet,
		CONCAT(E.nombres, ' ', E.apellidos) AS nombre_completo,
		IF(nota >= 61, 'APROBADO', 'REPROBADO') AS estado
	FROM ESTUDIANTES E
	INNER JOIN NOTAS N
	ON E.carnet = N.carnet
	INNER JOIN CURSOS_HABILITADOS C
	ON C.codigo_curso_habilitado = N.codigo_curso_habilitado
	WHERE C.codigo_curso_habilitado = codigo_habilitado;
END $$
DELIMITER ;

#----------------------------------------  
# Consulta 6: Ver todas las actas que se han generado para un curso
#---------------------------------------- 
DROP PROCEDURE IF EXISTS consultarActas;
DELIMITER $$
CREATE PROCEDURE consultarActas(
	IN in_codigo_curso INT 
)
proc_consultar_acta: BEGIN
	IF NOT EXISTS(SELECT codigo_curso FROM CURSOS WHERE in_codigo_curso = codigo_curso) THEN
		SELECT 'Error, el código ingresado no corresponde a ningún curso' AS respuesta;
		LEAVE proc_consultar_acta;
	END IF;

	SELECT
		C.codigo_curso,
		C.seccion,
		(CASE 
			WHEN C.ciclo = '1S' THEN 'PRIMER SEMESTRE'
			WHEN C.ciclo = '2S' THEN 'SEGUNDO SEMETRE'
			WHEN C.ciclo = 'VJ' THEN 'VACACIONES DE JUNIO'
			WHEN C.ciclo = 'VD' THEN 'VACACIONES DE DICIEMBRE'
		END) AS 'ciclo',
		C.anio AS 'año',
		A.cantidad_asignados,
		DATE_FORMAT(AC.fecha, '%d-%m-%Y') AS fecha,
		AC.hora
	FROM CURSOS_HABILITADOS C
	INNER JOIN ACTAS AC
	ON C.codigo_curso_habilitado = AC.codigo_curso_habilitado
	INNER JOIN ASIGNACIONES A
	ON C.codigo_curso_habilitado = A.codigo_curso_habilitado
	WHERE C.codigo_curso = in_codigo_curso
	ORDER BY AC.fecha, AC.hora;
END $$
DELIMITER ;

#----------------------------------------  
# Consulta 7: Ver información sobre las desaginaciones
# de un curso en una sección específica
#---------------------------------------- 
DROP PROCEDURE IF EXISTS consultarDesasignacion;
DELIMITER $$
CREATE PROCEDURE consultarDesasignacion(
	IN in_codigo_curso INT,
	IN in_ciclo VARCHAR(2),
	IN in_anio INT,
	IN in_seccion VARCHAR(1)
)
proc_consultar_desasignacion: BEGIN
	DECLARE codigo_habilitado INT;
	DECLARE cantidad_desasignados INT;

	-- Validaciones de formato
	IF NOT EXISTS(SELECT codigo_curso FROM CURSOS WHERE in_codigo_curso = codigo_curso) THEN
		SELECT 'Error, el código ingresado no corresponde a ningún curso' AS respuesta;
		LEAVE proc_consultar_desasignacion;
	ELSEIF cicloValido(in_ciclo) = 0 THEN
		SELECT 'Error, el ciclo debe ser "1S", "2S", "VJ", "VD"' AS respuesta;
		LEAVE proc_consultar_desasignacion;
	ELSEIF seccionValida(in_seccion) = 0 THEN
		SELECT 'Error, la sección debe de ser entre A-Z' AS respuesta;
		LEAVE proc_consultar_desasignacion;
	END IF;

	-- Verifica que el curso si este habilitado según el ciclo, año y sección
	SET codigo_habilitado = (
		SELECT codigo_curso_habilitado
		FROM CURSOS_HABILITADOS
		WHERE(
			in_codigo_curso = codigo_curso AND 
			in_ciclo = ciclo AND 
			in_anio = anio AND 
			in_seccion = seccion
		)
	);
	IF codigo_habilitado IS NULL THEN
		SELECT 'El curso no está habilitado para el ciclo, sección y año ingresados' AS respuesta;
		LEAVE proc_consultar_desasignacion;
	END IF;

	-- Obtiene la cantidad de desasignados
	SET cantidad_desasignados = (SELECT COUNT(id_desasignacion) 
		FROM DESASIGNACIONES D 
		WHERE D.codigo_curso_habilitado = codigo_habilitado
	);

	-- Hace la consulta
	SELECT 
		C.codigo_curso,
		C.seccion,
		(CASE 
			WHEN C.ciclo = '1S' THEN 'PRIMER SEMESTRE'
			WHEN C.ciclo = '2S' THEN 'SEGUNDO SEMETRE'
			WHEN C.ciclo = 'VJ' THEN 'VACACIONES DE JUNIO'
			WHEN C.ciclo = 'VD' THEN 'VACACIONES DE DICIEMBRE'
		END) AS 'ciclo',
		C.anio AS 'año',
		cantidad_asignados,
		cantidad_desasignados,
		CONCAT(
			ROUND(
				((cantidad_desasignados * 100)/(cantidad_asignados + cantidad_desasignados)), 
				2
			), 
			'%'
		) AS 'porcentaje_desasignacion'
	FROM CURSOS_HABILITADOS C
	INNER JOIN ASIGNACIONES A
	ON C.codigo_curso_habilitado = A.codigo_curso_habilitado
	WHERE C.codigo_curso_habilitado = codigo_habilitado;
END $$
DELIMITER ;
	