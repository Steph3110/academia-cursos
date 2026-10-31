## Proyecto: Grupo 3 - academia de cursos

## Contexto

Una academia ofrece cursos impartidos por profesores y organizados por categorías. Los estudiantes pueden inscribirse en varios cursos.

Cada curso tiene un profesor y una categoría. Cada inscripción vincula a un estudiante con un curso y registra el importe final que debe pagar después de aplicar descuentos.

## Tablas y campos mínimos

Estudiante: id_estudiante, nombre, correo, ciudad.
Profesor: id_profesor, nombre, especialidad.
Categoría: id_categoria, nombre.
Curso: id_curso, id_profesor, id_categoria, nombre, precio_base.
Inscripción: id_inscripcion, id_estudiante, id_curso, fecha, importe_final, estado.

## Reglas del negocio

Un profesor puede impartir varios cursos.
Cada curso pertenece a una sola categoría.
Un estudiante puede inscribirse en varios cursos.
Un estudiante no puede inscribirse dos veces en el mismo curso.
Los estados permitidos son “pendiente”, “pagada” y “cancelada”.
El estado “pagada” indica que se pagó todo el importe final.

## Reportes solicitados

Una tabla: listar los cursos con un precio base inferior a $100.000.
Dos tablas: contar las inscripciones por curso mediante COUNT.
Tres tablas: mostrar el nombre del estudiante, el nombre del curso y la fecha de las inscripciones pagadas. Utilizar Estudiante, Inscripción y Curso.
Cuatro tablas: calcular el total recaudado por profesor y categoría, considerando únicamente inscripciones pagadas. Utilizar Profesor, Curso, Categoría e Inscripción, con SUM.
Dos tablas: calcular el importe final promedio de las inscripciones pagadas de cada curso mediante AVG.



## Entregables

Cada grupo deberá entregar una carpeta comprimida con los siguientes archivos:

Modelo entidad-relación: diagrama en PDF o imagen legible, con entidades, atributos, relaciones y cardinalidades.
Esquema relacional: diagrama de las cinco tablas, con tipos de datos, PK y FK.
Script de creación y carga: archivo .sql con la creación de tablas y la inserción de los datos.
Script de reportes: archivo .sql con las cinco consultas numeradas y su enunciado como comentario.
Evidencias y conclusiones: documento breve con los resultados de cada consulta y la explicación de la utilidad de dos reportes para la organización.
Incluyan el número de grupo y los nombres de sus integrantes.

## Criterios de revisión

Se considerará:

Coherencia del modelo con el caso asignado.
Identificación correcta de entidades, relaciones y cardinalidades.
Definición adecuada de PK, FK y tipos de datos.
Cumplimiento de la cantidad mínima y calidad de los registros.
Ejecución correcta de los scripts.
Consultas que respondan a los reportes solicitados.
Uso correcto de JOIN, WHERE, SUM, COUNT, AVG, GROUP BY y ORDER BY.
Claridad de los diagramas, resultados y conclusiones.

##Recomendaciones finales

Utilicen nombres consistentes para tablas y campos; en SQL se recomienda evitar espacios y tildes.
Agrupen por identificadores y nombres cuando sea necesario para no mezclar entidades que se llamen igual.
Verifiquen que los filtros correspondan al estado y período solicitados.
Comprueben manualmente al menos un total, un conteo y un promedio.
Revisen que los JOIN no multipliquen registros de forma incorrecta antes de aplicar funciones.
Documenten las reglas que requieran controles adicionales, como evitar préstamos simultáneos o impedir que se supere la capacidad de un recinto. No se exige implementar esos controles mediante programación avanzada, pero los datos ingresados deben respetarlos.
El trabajo debe demostrar que el modelo, los datos y las consultas funcionan en conjunto y entregan información útil para el caso asignado.