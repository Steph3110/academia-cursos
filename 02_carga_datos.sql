USE academia_cursos;

-- Carga inicial: 100 registros por tabla.
-- Requiere MySQL 8.0 o superior.

DROP TEMPORARY TABLE IF EXISTS numeros;
CREATE TEMPORARY TABLE numeros (
    n INT UNSIGNED NOT NULL PRIMARY KEY
);

INSERT INTO numeros (n)
WITH RECURSIVE secuencia AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM secuencia
    WHERE n < 100
)
SELECT n
FROM secuencia;

INSERT INTO estudiantes (
    id_estudiante, nombre, apellido, correo, telefono, ciudad,
    fecha_registro, activo
)
SELECT
    n,
    CONCAT('Estudiante ', n),
    CONCAT('Apellido ', n),
    CONCAT('estudiante', n, '@example.com'),
    CONCAT('9', LPAD(n, 8, '0')),
    ELT(((n - 1) % 10) + 1, 'Santiago', 'Valparaiso', 'Concepcion',
        'La Serena', 'Temuco', 'Rancagua', 'Talca', 'Valdivia',
        'Arica', 'Puerto Montt'),
    DATE_ADD('2026-01-01', INTERVAL (n - 1) DAY),
    TRUE
FROM numeros;

INSERT INTO especialidades (
    id_especialidad, nombre, descripcion, activo
)
SELECT
    n,
    CONCAT('Especialidad ', n),
    CONCAT('Descripcion de la especialidad ', n),
    TRUE
FROM numeros;

INSERT INTO profesores (
    id_profesor, nombre, apellido, correo, telefono, activo
)
SELECT
    n,
    CONCAT('Profesor ', n),
    CONCAT('Apellido ', n),
    CONCAT('profesor', n, '@example.com'),
    CONCAT('9', LPAD(n + 100, 8, '0')),
    TRUE
FROM numeros;

INSERT INTO categorias (
    id_categoria, nombre, descripcion, activo
)
SELECT
    n,
    CONCAT('Categoria ', n),
    CONCAT('Descripcion de la categoria ', n),
    TRUE
FROM numeros;

INSERT INTO medios_pago (
    id_medio_pago, nombre, descripcion, activo
)
SELECT
    n,
    CONCAT('Medio de pago ', n),
    CONCAT('Descripcion del medio de pago ', n),
    TRUE
FROM numeros;

INSERT INTO descuentos (
    id_descuento, nombre, descripcion, tipo_descuento, valor,
    fecha_inicio, fecha_termino, activo
)
SELECT
    n,
    CONCAT('Descuento ', n),
    CONCAT('Beneficio promocional numero ', n),
    CASE WHEN MOD(n, 2) = 0 THEN 'porcentaje' ELSE 'monto_fijo' END,
    CASE WHEN MOD(n, 2) = 0 THEN MOD(n, 25) + 5 ELSE 5000 + (n * 100) END,
    '2026-01-01',
    '2026-12-31',
    TRUE
FROM numeros;

INSERT INTO profesores_especialidades (
    id_profesor, id_especialidad, fecha_asignacion
)
SELECT
    n,
    n,
    DATE_ADD('2025-01-01', INTERVAL (n - 1) DAY)
FROM numeros;

INSERT INTO cursos (
    id_curso, nombre, descripcion, precio_base, fecha_inicio,
    fecha_termino, duracion_horas, cupo_maximo, modalidad, nivel,
    estado, id_profesor, id_categoria, id_especialidad
)
SELECT
    n,
    CONCAT('Curso ', n),
    CONCAT('Descripcion del curso ', n),
    50000 + (n * 1000),
    DATE_ADD('2026-03-01', INTERVAL (n - 1) DAY),
    DATE_ADD('2026-04-30', INTERVAL (n - 1) DAY),
    20 + MOD(n, 41),
    10 + MOD(n, 41),
    ELT(((n - 1) % 3) + 1, 'presencial', 'online', 'hibrida'),
    ELT(((n - 1) % 3) + 1, 'basico', 'intermedio', 'avanzado'),
    ELT(((n - 1) % 4) + 1, 'programado', 'en_curso', 'finalizado',
        'cancelado'),
    n,
    MOD(n - 1, 10) + 1,
    n
FROM numeros;

INSERT INTO inscripciones (
    id_inscripcion, fecha, importe_final, estado, estado_academico,
    fecha_cancelacion, observaciones, id_estudiante, id_curso,
    id_descuento
)
SELECT
    n,
    DATE_ADD('2026-02-01', INTERVAL (n - 1) DAY),
    50000 + (n * 1000),
    'activa',
    'no_iniciado',
    NULL,
    CONCAT('Inscripcion de prueba ', n),
    n,
    n,
    n
FROM numeros;

INSERT INTO planes_pago (
    id_plan_pago, modalidad_pago, numero_cuotas, monto_total,
    fecha_acuerdo, id_inscripcion
)
SELECT
    n,
    'contado',
    1,
    50000 + (n * 1000),
    DATE_ADD('2026-02-01', INTERVAL (n - 1) DAY),
    n
FROM numeros;

INSERT INTO cuotas (
    id_cuota, numero_cuota, monto_programado, fecha_vencimiento,
    id_plan_pago
)
SELECT
    n,
    1,
    50000 + (n * 1000),
    DATE_ADD('2026-03-01', INTERVAL (n - 1) DAY),
    n
FROM numeros;

INSERT INTO pagos (
    id_pago, fecha_pago, monto_pagado, estado_pago, id_cuota,
    id_medio_pago
)
SELECT
    n,
    DATE_ADD('2026-02-15', INTERVAL (n - 1) DAY),
    50000 + (n * 1000),
    ELT(((n - 1) % 3) + 1, 'pendiente', 'confirmado', 'rechazado'),
    n,
    MOD(n - 1, 100) + 1
FROM numeros;

DROP TEMPORARY TABLE numeros;
