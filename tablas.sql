CREATE DATABASE IF NOT EXISTS proyecto2_fiusac;
USE proyecto2_fiusac;

DROP TABLE IF EXISTS HORARIOS;
DROP TABLE IF EXISTS ACTAS;
DROP TABLE IF EXISTS ASIGNACIONES;
DROP TABLE IF EXISTS NOTAS;
DROP TABLE IF EXISTS DESASIGNACIONES;
DROP TABLE IF EXISTS ASIGNADOS;
DROP TABLE IF EXISTS CURSOS_HABILITADOS;
DROP TABLE IF EXISTS CURSOS;
DROP TABLE IF EXISTS DOCENTES;
DROP TABLE IF EXISTS ESTUDIANTES;
DROP TABLE IF EXISTS CARRERAS;

CREATE TABLE IF NOT EXISTS CARRERAS (
	codigo_carrera INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (codigo_carrera)
);

CREATE TABLE IF NOT EXISTS ESTUDIANTES(
	carnet BIGINT NOT NULL,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo VARCHAR(50) NOT NULL UNIQUE,
    telefono INT NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    dpi BIGINT NOT NULL UNIQUE,
    codigo_carrera INT NOT NULL,
    creditos SMALLINT NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    PRIMARY KEY (carnet),
    FOREIGN KEY (codigo_carrera) REFERENCES CARRERAS(codigo_carrera)
);

CREATE TABLE IF NOT EXISTS DOCENTES(
	siif INT NOT NULL,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo VARCHAR(50) NOT NULL UNIQUE,
    telefono INT NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    dpi BIGINT NOT NULL UNIQUE,
    fecha_contratacion DATE NOT NULL,
    PRIMARY KEY(siif)
);

CREATE TABLE IF NOT EXISTS CURSOS(
	codigo_curso INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    creditos_necesarios SMALLINT NOT NULL,
    creditos_otorga SMALLINT NOT NULL,
    obligatorio TINYINT NOT NULL,
    codigo_carrera INT NOT NULL,
    PRIMARY KEY (codigo_curso),
    FOREIGN KEY (codigo_carrera) REFERENCES CARRERAS(codigo_carrera)
);

CREATE TABLE IF NOT EXISTS CURSOS_HABILITADOS(
	codigo_curso_habilitado INT NOT NULL AUTO_INCREMENT,
    ciclo VARCHAR(2) NOT NULL,
	seccion VARCHAR(1) NOT NULL,
    anio INTEGER NOT NULL,
    cupo_maximo SMALLINT NOT NULL,
    codigo_curso INT NOT NULL,
    siif INT NOT NULL,
    PRIMARY KEY(codigo_curso_habilitado),
    FOREIGN KEY(codigo_curso) REFERENCES CURSOS(codigo_curso),
    FOREIGN KEY(siif) REFERENCES DOCENTES(siif)
);

CREATE TABLE IF NOT EXISTS ASIGNADOS(
	id_asignado INT NOT NULL AUTO_INCREMENT,
    carnet BIGINT NOT NULL,
    codigo_curso_habilitado INT NOT NULL,
    PRIMARY KEY(id_asignado),
    FOREIGN KEY(carnet) REFERENCES ESTUDIANTES(carnet),
    FOREIGN KEY(codigo_curso_habilitado) REFERENCES CURSOS_HABILITADOS(codigo_curso_habilitado)
);

CREATE TABLE IF NOT EXISTS DESASIGNACIONES(
	id_desasignacion INT NOT NULL AUTO_INCREMENT,
    carnet BIGINT NOT NULL,
    codigo_curso_habilitado INT NOT NULL,
    PRIMARY KEY(id_desasignacion),
    FOREIGN KEY(codigo_curso_habilitado) REFERENCES CURSOS_HABILITADOS(codigo_curso_habilitado)
);

CREATE TABLE IF NOT EXISTS NOTAS(
	id_nota INT NOT NULL AUTO_INCREMENT,
    nota TINYINT NOT NULL,
    carnet BIGINT NOT NULL,
    codigo_curso_habilitado INT NOT NULL,
    PRIMARY KEY(id_nota),
    FOREIGN KEY(carnet) REFERENCES ESTUDIANTES(carnet),
    FOREIGN KEY(codigo_curso_habilitado) REFERENCES CURSOS_HABILITADOS(codigo_curso_habilitado)
);

CREATE TABLE IF NOT EXISTS ASIGNACIONES(
	id_asignacion INT NOT NULL AUTO_INCREMENT,
    codigo_curso_habilitado INT NOT NULL,
    cantidad_asignados SMALLINT NOT NULL,
    PRIMARY KEY(id_asignacion),
    FOREIGN KEY(codigo_curso_habilitado) REFERENCES CURSOS_HABILITADOS(codigo_curso_habilitado)
); 

CREATE TABLE IF NOT EXISTS ACTAS(
	id_acta INT NOT NULL AUTO_INCREMENT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    codigo_curso_habilitado INT NOT NULL,
    PRIMARY KEY(id_acta),
    FOREIGN KEY(codigo_curso_habilitado) REFERENCES CURSOS_HABILITADOS(codigo_curso_habilitado)    
);

CREATE TABLE IF NOT EXISTS HORARIOS(
	id_horario INT NOT NULL AUTO_INCREMENT,
    dia TINYINT NOT NULL,
    horario VARCHAR(15) NOT NULL,
    codigo_curso_habilitado INT NOT NULL,
    PRIMARY KEY(id_horario),
    FOREIGN KEY(codigo_curso_habilitado) REFERENCES CURSOS_HABILITADOS(codigo_curso_habilitado)
);

