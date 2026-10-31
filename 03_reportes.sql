-- Proyecto: Academia de cursos - Grupo 3
-- Integrantes: Stephani González y Emilio Solís
USE academia_cursos;

-- 1. Listar los cursos con un precio base inferior a $100.000.
SELECT id_curso, nombre, precio_base
FROM cursos
WHERE precio_base < 100000
ORDER BY precio_base, nombre;

-- 2. Contar las inscripciones por curso, incluidos los cursos sin inscripciones.
SELECT
    c.id_curso,
    c.nombre AS curso,
    COUNT(i.id_inscripcion) AS cantidad_inscripciones
FROM cursos AS c
LEFT JOIN inscripciones AS i ON i.id_curso = c.id_curso
GROUP BY c.id_curso, c.nombre
ORDER BY c.id_curso;

-- 3. Mostrar estudiante, curso y fecha de las inscripciones pagadas.
SELECT
    e.nombre AS estudiante,
    c.nombre AS curso,
    i.fecha
FROM estudiantes AS e
INNER JOIN inscripciones AS i ON i.id_estudiante = e.id_estudiante
INNER JOIN cursos AS c ON c.id_curso = i.id_curso
WHERE i.estado = 'pagada'
ORDER BY i.fecha, e.nombre;

-- 4. Calcular el total recaudado por profesor y categoria con inscripciones pagadas.
SELECT
    p.id_profesor,
    p.nombre AS profesor,
    cat.id_categoria,
    cat.nombre AS categoria,
    SUM(i.importe_final) AS total_recaudado
FROM Profesor AS p
INNER JOIN Curso AS c ON c.id_profesor = p.id_profesor
INNER JOIN Categoria AS cat ON cat.id_categoria = c.id_categoria
INNER JOIN Inscripcion AS i ON i.id_curso = c.id_curso
WHERE i.estado = 'pagada'
GROUP BY p.id_profesor, p.nombre, cat.id_categoria, cat.nombre
ORDER BY p.nombre, cat.nombre;

-- 5. Calcular el importe final promedio de las inscripciones pagadas por curso.
SELECT
    c.id_curso,
    c.nombre AS curso,
    AVG(i.importe_final) AS promedio_importe_final_pagado
FROM Curso AS c
LEFT JOIN Inscripcion AS i
    ON i.id_curso = c.id_curso
    AND i.estado = 'pagada'
GROUP BY c.id_curso, c.nombre
ORDER BY c.id_curso;