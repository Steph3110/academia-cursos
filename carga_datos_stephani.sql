
USE academia_cursos;

-- =========================================
-- CARGA DE DATOS - STEPHANI
-- TABLA: ESTUDIANTES
-- =========================================

INSERT INTO estudiantes (nombre, correo, ciudad)
VALUES
('Sofia Morales', 'sofia.morales@example.com', 'Santiago'),
('Lucas Herrera', 'lucas.herrera@example.com', 'Valparaiso'),
('Martina Rojas', 'martina.rojas@example.com', 'Concepcion'),
('Benjamin Castro', 'benjamin.castro@example.com', 'Temuco'),
('Catalina Fuentes', 'catalina.fuentes@example.com', 'Santiago'),
('Vicente Soto', 'vicente.soto@example.com', 'La Serena'),
('Florencia Vega', 'florencia.vega@example.com', 'Rancagua'),
('Agustin Paredes', 'agustin.paredes@example.com', 'Talca'),
('Josefa Navarro', 'josefa.navarro@example.com', 'Valdivia'),
('Tomas Salinas', 'tomas.salinas@example.com', 'Puerto Montt');

SELECT *
FROM academia_cursos.estudiantes;

SELECT
    id_estudiante,
    nombre,
    correo,
    ciudad
FROM academia_cursos.estudiantes
ORDER BY id_estudiante;

-- =========================================
-- TABLA: PROFESORES
-- =========================================

INSERT INTO profesores (nombre, especialidad)
VALUES
('Claudia Mendez', 'Programacion'),
('Rodrigo Silva', 'Analisis de datos'),
('Daniela Torres', 'Diseno digital'),
('Felipe Contreras', 'Marketing'),
('Carolina Araya', 'Finanzas');

SELECT *
FROM academia_cursos.profesores;

-- =====================================
-- TABLA: CATEGORIAS
-- =====================================

INSERT INTO categorias (nombre)
VALUES
('Programación'),
('Análisis de datos'),
('Diseño gráfico'),
('Marketing digital'),
('Finanzas');

SELECT *
FROM academia_cursos.categorias;

-- =====================================
-- TABLA: CURSOS
-- =====================================

INSERT INTO cursos
(id_profesor, id_categoria, nombre, precio_base)
VALUES
(1, 1, 'Introducción a Python', 79900),
(1, 1, 'Desarrollo web básico', 119900),
(2, 2, 'Análisis de datos con Excel', 69900),
(2, 2, 'Introducción a SQL', 89900),
(3, 3, 'Diseño gráfico digital', 129900),
(3, 3, 'Diseño de presentaciones', 59900),
(4, 4, 'Marketing en redes sociales', 99900),
(4, 4, 'Publicidad digital', 149900),
(5, 5, 'Finanzas personales', 74900),
(5, 5, 'Gestión financiera para emprendedores', 139900);

SELECT
    c.id_curso,
    c.nombre AS curso,
    p.nombre AS profesor,
    cat.nombre AS categoria,
    c.precio_base
FROM academia_cursos.cursos c
INNER JOIN academia_cursos.profesores p
    ON c.id_profesor = p.id_profesor
INNER JOIN academia_cursos.categorias cat
    ON c.id_categoria = cat.id_categoria
ORDER BY c.id_curso;;

-- =====================================
-- TABLA: INSCRIPCIONES
-- =====================================

INSERT INTO inscripciones
(id_estudiante, id_curso, fecha, importe_final, estado)
VALUES
(1, 1, '2026-04-01', 79900, 'pagada'),
(2, 2, '2026-04-02', 119900, 'pagada'),
(3, 3, '2026-04-03', 69900, 'pendiente'),
(4, 4, '2026-04-04', 89900, 'pagada'),
(5, 5, '2026-04-05', 129900, 'cancelada'),
(6, 6, '2026-04-06', 59900, 'pagada'),
(7, 7, '2026-04-07', 99900, 'pagada'),
(8, 8, '2026-04-08', 149900, 'pendiente'),
(9, 9, '2026-04-09', 74900, 'pagada'),
(10, 10, '2026-04-10', 139900, 'pagada');

SELECT
    i.id_inscripcion,
    e.nombre AS estudiante,
    c.nombre AS curso,
    i.fecha,
    i.importe_final,
    i.estado
FROM academia_cursos.inscripciones i
INNER JOIN academia_cursos.estudiantes e
    ON i.id_estudiante = e.id_estudiante
INNER JOIN academia_cursos.cursos c
    ON i.id_curso = c.id_curso
ORDER BY i.id_inscripcion;