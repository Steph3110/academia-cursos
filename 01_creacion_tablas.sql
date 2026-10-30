
-- ============================================
-- Script 01: Creacion de tablas
-- ============================================

CREATE DATABASE IF NOT EXISTS academia_cursos;

USE academia_cursos;

-- 1. TABLA ESTUDIANTES
CREATE TABLE estudiantes (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    ciudad VARCHAR(100) NOT NULL
);

-- 2. TABLA PROFESORES
CREATE TABLE profesores (
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL
);

-- 3. TABLA CATEGORIAS
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- 4. TABLA CURSOS
CREATE TABLE cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    id_profesor INT NOT NULL,
    id_categoria INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_precio
        CHECK (precio_base >= 0),

    CONSTRAINT fk_curso_profesor
        FOREIGN KEY (id_profesor)
        REFERENCES profesores(id_profesor),

    CONSTRAINT fk_curso_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria)
);

CREATE TABLE inscripciones (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_curso INT NOT NULL,
    fecha DATE NOT NULL,
    importe_final DECIMAL(10,2) NOT NULL,
    estado ENUM('pendiente', 'pagada', 'cancelada')
        NOT NULL DEFAULT 'pendiente',

    -- El importe no puede ser negativo
    CONSTRAINT chk_importe
        CHECK (importe_final >= 0),

    -- Relacion con estudiantes
    CONSTRAINT fk_inscripcion_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiantes(id_estudiante),

    -- Relacion con cursos
    CONSTRAINT fk_inscripcion_curso
        FOREIGN KEY (id_curso)
        REFERENCES cursos(id_curso),

    -- Evita inscripciones duplicadas
    CONSTRAINT uq_estudiante_curso
        UNIQUE (id_estudiante, id_curso)
);