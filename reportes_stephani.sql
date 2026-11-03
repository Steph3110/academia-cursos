
-- ==========================================
-- REPORTES SQL - ACADEMIA DE CURSOS
-- Grupo 3 - Stephani
-- ==========================================

USE academia_cursos;

-- REPORTE 1
-- Cursos con precio base inferior a $100.000

SELECT
    id_curso,
    nombre AS curso,
    precio_base
FROM cursos
WHERE precio_base < 100000
ORDER BY precio_base ASC;


-- REPORTE 2
-- Cantidad de inscripciones por curso

SELECT
    c.nombre AS curso,
    COUNT(i.id_inscripcion) AS total_inscripciones
FROM cursos c
LEFT JOIN inscripciones i
    ON c.id_curso = i.id_curso
GROUP BY c.id_curso, c.nombre
ORDER BY total_inscripciones DESC;


-- REPORTE 3
-- Inscripciones pagadas con estudiante, curso y fecha

SELECT
    e.nombre AS estudiante,
    c.nombre AS curso,
    i.fecha,
    i.importe_final
FROM inscripciones i
INNER JOIN estudiantes e
    ON i.id_estudiante = e.id_estudiante
INNER JOIN cursos c
    ON i.id_curso = c.id_curso
WHERE i.estado = 'pagada'
ORDER BY i.fecha;


-- REPORTE 4
-- Ingresos pagados por profesor y categoría

SELECT
    p.nombre AS profesor,
    cat.nombre AS categoria,
    COALESCE(SUM(i.importe_final), 0) AS ingresos_totales
FROM cursos c
INNER JOIN profesores p
    ON c.id_profesor = p.id_profesor
INNER JOIN categorias cat
    ON c.id_categoria = cat.id_categoria
LEFT JOIN inscripciones i
    ON c.id_curso = i.id_curso
    AND i.estado = 'pagada'
GROUP BY p.id_profesor, p.nombre,
         cat.id_categoria, cat.nombre
ORDER BY ingresos_totales DESC;


-- REPORTE 5
-- Promedio de importes finales pagados por curso

SELECT
    c.nombre AS curso,
    ROUND(AVG(i.importe_final), 2) AS promedio_pagado
FROM cursos c
LEFT JOIN inscripciones i
    ON c.id_curso = i.id_curso
    AND i.estado = 'pagada'
GROUP BY c.id_curso, c.nombre
ORDER BY c.id_curso;
