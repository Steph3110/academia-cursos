USE academia_cursos;

INSERT INTO estudiantes (id_estudiante, nombre, correo, ciudad) VALUES
(1, 'Camila Rojas', 'camila.rojas@example.com', 'Santiago'),
(2, 'Matias Fuentes', 'matias.fuentes@example.com', 'Valparaiso'),
(3, 'Valentina Soto', 'valentina.soto@example.com', 'Concepcion'),
(4, 'Diego Morales', 'diego.morales@example.com', 'La Serena'),
(5, 'Fernanda Castro', 'fernanda.castro@example.com', 'Temuco'),
(6, 'Joaquin Herrera', 'joaquin.herrera@example.com', 'Santiago'),
(7, 'Antonia Vega', 'antonia.vega@example.com', 'Rancagua'),
(8, 'Benjamin Silva', 'benjamin.silva@example.com', 'Puerto Montt'),
(9, 'Isidora Torres', 'isidora.torres@example.com', 'Valdivia'),
(10, 'Nicolas Ramirez', 'nicolas.ramirez@example.com', 'Arica');

INSERT INTO profesores (id_profesor, nombre, especialidad) VALUES
(1, 'Paula Mendez', 'Programacion y desarrollo web'),
(2, 'Cristobal Reyes', 'Analisis de datos'),
(3, 'Daniela Paredes', 'Diseno grafico'),
(4, 'Sebastian Vidal', 'Marketing digital'),
(5, 'Carolina Navarro', 'Finanzas'),
(6, 'Felipe Araya', 'Ingles'),
(7, 'Macarena Leon', 'Fotografia'),
(8, 'Rodrigo Campos', 'Emprendimiento'),
(9, 'Francisca Riquelme', 'Ofimatica'),
(10, 'Andres Molina', 'Liderazgo');

INSERT INTO categorias (id_categoria, nombre) VALUES
(1, 'Programacion'),
(2, 'Datos'),
(3, 'Diseno'),
(4, 'Marketing'),
(5, 'Finanzas'),
(6, 'Idiomas'),
(7, 'Fotografia'),
(8, 'Negocios'),
(9, 'Ofimatica'),
(10, 'Desarrollo personal');

INSERT INTO cursos (id_curso, id_profesor, id_categoria, nombre, precio_base) VALUES
(1, 1, 1, 'Fundamentos de Python', 79900.00),
(2, 1, 1, 'Desarrollo web con HTML y CSS', 129900.00),
(3, 2, 2, 'Introduccion al analisis de datos', 89900.00),
(4, 3, 3, 'Diseno grafico para principiantes', 149900.00),
(5, 4, 4, 'Redes sociales para emprendimientos', 99900.00),
(6, 5, 5, 'Finanzas personales', 189900.00),
(7, 6, 6, 'Ingles para el trabajo', 74900.00),
(8, 7, 7, 'Fotografia digital', 109900.00),
(9, 8, 8, 'Plan de negocios', 134900.00),
(10, 9, 9, 'Excel intermedio', 59900.00);

INSERT INTO Inscripciones
    (id_inscripcion, id_estudiante, id_curso, fecha, importe_final, estado)
VALUES
(1, 1, 1, '2026-03-02', 71900.00, 'pagada'),
(2, 2, 1, '2026-03-04', 79900.00, 'pagada'),
(3, 3, 1, '2026-03-07', 79900.00, 'pendiente'),
(4, 4, 2, '2026-03-10', 119900.00, 'pagada'),
(5, 5, 2, '2026-03-12', 129900.00, 'cancelada'),
(6, 6, 3, '2026-03-15', 79900.00, 'pagada'),
(7, 7, 3, '2026-03-17', 84900.00, 'pagada'),
(8, 8, 4, '2026-03-20', 139900.00, 'pagada'),
(9, 9, 4, '2026-03-22', 149900.00, 'pendiente'),
(10, 10, 5, '2026-03-25', 89900.00, 'pagada');