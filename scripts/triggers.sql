USE proyecto2_fiusac;

#----------------------------------------  
# Triggers para la tabla CARRERAS
#----------------------------------------  
DROP TRIGGER IF EXISTS insert_carrera;
DELIMITER $$
CREATE TRIGGER insert_carrera AFTER INSERT ON CARRERAS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla CARRERAS', 'INSERT');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS update_carrera;
DELIMITER $$
CREATE TRIGGER update_carrera AFTER UPDATE ON CARRERAS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla CARRERAS', 'UPDATE');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS delete_carrera;
DELIMITER $$
CREATE TRIGGER delete_carrera AFTER DELETE ON CARRERAS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ESTUDIANTES', 'DELETE');
END $$
DELIMITER ;

#----------------------------------------  
# Triggers para la tabla ESTUDIANTES
#----------------------------------------  
DROP TRIGGER IF EXISTS insert_estudiante;
DELIMITER $$
CREATE TRIGGER insert_estudiante AFTER INSERT ON ESTUDIANTES
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ESTUDIANTES', 'INSERT');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS update_estudiante;
DELIMITER $$
CREATE TRIGGER update_estudiante AFTER UPDATE ON ESTUDIANTES
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ESTUDIANTES', 'UPDATE');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS delete_estudiante;
DELIMITER $$
CREATE TRIGGER delete_estudiante AFTER DELETE ON ESTUDIANTES
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ESTUDIANTES', 'DELETE');
END $$
DELIMITER ;

#----------------------------------------  
# Triggers para la tabla DOCENTES
#----------------------------------------  
DROP TRIGGER IF EXISTS insert_docente;
DELIMITER $$
CREATE TRIGGER insert_docente AFTER INSERT ON DOCENTES
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla DOCENTES', 'INSERT');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS update_docente;
DELIMITER $$
CREATE TRIGGER update_docente AFTER UPDATE ON DOCENTES
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla DOCENTES', 'UPDATE');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS delete_docente;
DELIMITER $$
CREATE TRIGGER delete_docente AFTER DELETE ON DOCENTES
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla DOCENTES', 'DELETE');
END $$
DELIMITER ;

#----------------------------------------  
# Triggers para la tabla CURSOS
#----------------------------------------  
DROP TRIGGER IF EXISTS insert_curso;
DELIMITER $$
CREATE TRIGGER insert_curso AFTER INSERT ON CURSOS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla CURSOS', 'INSERT');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS update_curso;
DELIMITER $$
CREATE TRIGGER update_curso AFTER UPDATE ON CURSOS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla CURSOS', 'UPDATE');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS delete_curso;
DELIMITER $$
CREATE TRIGGER delete_curso AFTER DELETE ON CURSOS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla CURSOS', 'DELETE');
END $$
DELIMITER ;


#----------------------------------------  
# Triggers para la tabla CURSOS_HABILITADOS
#----------------------------------------  
DROP TRIGGER IF EXISTS insert_curso_habilitado;
DELIMITER $$
CREATE TRIGGER insert_curso_habilitado AFTER INSERT ON CURSOS_HABILITADOS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla CURSOS_HABILITADOS', 'INSERT');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS update_curso_habilitado;
DELIMITER $$
CREATE TRIGGER update_curso_habilitado AFTER UPDATE ON CURSOS_HABILITADOS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla CURSOS_HABILITADOS', 'UPDATE');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS delete_curso_habilitado;
DELIMITER $$
CREATE TRIGGER delete_curso_habilitado AFTER DELETE ON CURSOS_HABILITADOS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla CURSOS_HABILITADOS', 'DELETE');
END $$
DELIMITER ;

#----------------------------------------  
# Triggers para la tabla ASIGNADOS
#----------------------------------------  
DROP TRIGGER IF EXISTS insert_asignado;
DELIMITER $$
CREATE TRIGGER insert_asignado AFTER INSERT ON ASIGNADOS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ASIGNADOS', 'INSERT');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS update_asignado;
DELIMITER $$
CREATE TRIGGER update_asignado AFTER UPDATE ON ASIGNADOS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ASIGNADOS', 'UPDATE');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS delete_asignado;
DELIMITER $$
CREATE TRIGGER delete_asignado AFTER DELETE ON ASIGNADOS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ASIGNADOS', 'DELETE');
END $$
DELIMITER ;

#----------------------------------------  
# Triggers para la tabla DESASIGNACIONES
#----------------------------------------  
DROP TRIGGER IF EXISTS insert_desasignacion;
DELIMITER $$
CREATE TRIGGER insert_desasignacion AFTER INSERT ON DESASIGNACIONES
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla DESASIGNACIONES', 'INSERT');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS update_desasignacion;
DELIMITER $$
CREATE TRIGGER update_desasignacion AFTER UPDATE ON DESASIGNACIONES
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla DESASIGNACIONES', 'UPDATE');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS delete_desasignacion;
DELIMITER $$
CREATE TRIGGER delete_desasignacion AFTER DELETE ON DESASIGNACIONES
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla DESASIGNACIONES', 'DELETE');
END $$
DELIMITER ;

#----------------------------------------  
# Triggers para la tabla NOTAS
#----------------------------------------  
DROP TRIGGER IF EXISTS insert_nota;
DELIMITER $$
CREATE TRIGGER insert_nota AFTER INSERT ON NOTAS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla NOTAS', 'INSERT');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS update_nota;
DELIMITER $$
CREATE TRIGGER update_nota AFTER UPDATE ON NOTAS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla NOTAS', 'UPDATE');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS delete_nota;
DELIMITER $$
CREATE TRIGGER delete_nota AFTER DELETE ON NOTAS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla NOTAS', 'DELETE');
END $$
DELIMITER ;

#----------------------------------------  
# Triggers para la tabla ASIGNACIONES
#----------------------------------------  
DROP TRIGGER IF EXISTS insert_asignacion;
DELIMITER $$
CREATE TRIGGER insert_asignacion AFTER INSERT ON ASIGNACIONES
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ASIGNACIONES', 'INSERT');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS update_asignacion;
DELIMITER $$
CREATE TRIGGER update_asignacion AFTER UPDATE ON ASIGNACIONES
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ASIGNACIONES', 'UPDATE');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS delete_asignacion;
DELIMITER $$
CREATE TRIGGER delete_asignacion AFTER DELETE ON ASIGNACIONES
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ASIGNACIONES', 'DELETE');
END $$
DELIMITER ;

#----------------------------------------  
# Triggers para la tabla ACTAS
#----------------------------------------  
DROP TRIGGER IF EXISTS insert_acta;
DELIMITER $$
CREATE TRIGGER insert_acta AFTER INSERT ON ACTAS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ACTAS', 'INSERT');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS update_acta;
DELIMITER $$
CREATE TRIGGER update_acta AFTER UPDATE ON ACTAS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ACTAS', 'UPDATE');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS delete_acta;
DELIMITER $$
CREATE TRIGGER delete_acta AFTER DELETE ON ACTAS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla ACTAS', 'DELETE');
END $$
DELIMITER ;

#----------------------------------------  
# Triggers para la tabla HORARIOS
#----------------------------------------  
DROP TRIGGER IF EXISTS insert_horario;
DELIMITER $$
CREATE TRIGGER insert_horario AFTER INSERT ON HORARIOS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla HORARIOS', 'INSERT');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS update_horario;
DELIMITER $$
CREATE TRIGGER update_horario AFTER UPDATE ON HORARIOS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla HORARIOS', 'UPDATE');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS delete_horario;
DELIMITER $$
CREATE TRIGGER delete_horario AFTER DELETE ON HORARIOS
FOR EACH ROW
BEGIN
    DECLARE fecha DATETIME;
    SET fecha = NOW();
    INSERT INTO HISTORIAL (fecha, descripcion, tipo)
    VALUES (fecha, 'Se ha realizado una acción en la tabla HORARIOS', 'DELETE');
END $$
DELIMITER ;