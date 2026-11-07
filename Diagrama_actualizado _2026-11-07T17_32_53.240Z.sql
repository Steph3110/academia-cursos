CREATE TABLE IF NOT EXISTS `Cursos` (
	`ID_curso` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`Nombre` VARCHAR(150),
	`Descripcion` TEXT(65535) NOT NULL,
	`Precio_base` DECIMAL(10,2),
	`Fecha_inicio` DATE,
	`Fecha_termino` DATE,
	`Duracion_horas` INTEGER,
	`Cupo_maximo` INTEGER CHECK(> 0),
	`Modalidad` ENUM('''Presencial''', '''Online''', '''Hibrado'' '),
	`Nivel` ENUM('''Basico''', '''Intermedio''', '''Avanzado'''),
	`Estado` ENUM('''Programado''', '''En curso''', '''Finalizado'' ', '''Cancelado'''),
	`ID_profesor` INTEGER,
	`ID_categorio` INTEGER,
	`ID_especialidad` INTEGER,
	PRIMARY KEY(`ID_curso`)
);


CREATE TABLE IF NOT EXISTS `Inscripciones` (
	`ID_inscripcion` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`Fecha` DATE,
	`Importe _final` DECIMAL(10,2),
	`Estado` ENUM('''Activa''', '''Cancelada''', '''Finalizada'''),
	`Estado_academico` ENUM('''No iniciado''', '''En curso'' ', '''Aprobado'' ', '''Reprobado'' ', '''Retirado''') DEFAULT '''No iniciado''',
	`Fecha_cancelacion` DATE NOT NULL,
	`Observaciones` TEXT(65535) NOT NULL,
	`ID_estudiante` INTEGER,
	`ID_curso` INTEGER,
	`ID_descuento` INTEGER NOT NULL,
	PRIMARY KEY(`ID_inscripcion`)
);


CREATE TABLE IF NOT EXISTS `Planes_pago` (
	`ID_plan_pago` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`Modalidad_pago` ENUM('''Contado''', '''Cuotas'''),
	`Numero_cuotas` INTEGER UNSIGNED,
	`Monto_total` DECIMAL(10,2),
	`Fecha_acuerdo` DATE,
	`ID_inscripcion` INTEGER UNIQUE,
	PRIMARY KEY(`ID_plan_pago`)
);


CREATE TABLE IF NOT EXISTS `Cuotas` (
	`ID_cuota` INTEGER UNSIGNED NOT NULL,
	`Numero_cuota` INTEGER UNSIGNED,
	`Monto_programado` DECIMAL(10,2),
	`Fecha_vencimiento` DATE,
	`ID_plan_pago` INTEGER,
	PRIMARY KEY(`ID_cuota`)
);


CREATE TABLE IF NOT EXISTS `Pagos` (
	`ID_pago` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`Fecha_pago` DATE,
	`Monto_pagado` DECIMAL(10,2),
	`Estado_pago` ENUM('''Pendiente''', '''Confirmado''', '''Rechazado'''),
	`ID_cuota` INTEGER,
	`ID_medio_pago` INTEGER,
	PRIMARY KEY(`ID_pago`)
);


CREATE TABLE IF NOT EXISTS `Estudiantes` (
	`ID_estudiante` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`Nombre` VARCHAR(100),
	`Apellido` VARCHAR(100),
	`Correo` VARCHAR(150),
	`Telefono` VARCHAR(20),
	`Ciudad` VARCHAR(100),
	`Fecha_registro` DATE,
	`Activo` BOOLEAN DEFAULT 1 COMMENT '1 : Activo
0: Inactivo',
	PRIMARY KEY(`ID_estudiante`)
);


CREATE TABLE IF NOT EXISTS `Especialidades` (
	`ID_especialidad` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`Nombre` VARCHAR(100) UNIQUE,
	`Descripcion` VARCHAR(255) NOT NULL,
	`Activo` BOOLEAN DEFAULT 1 COMMENT '1 : Activo 
0 : Inactivo ',
	PRIMARY KEY(`ID_especialidad`)
);


CREATE TABLE IF NOT EXISTS `Profesores` (
	`ID_profesor` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`Nombre` VARCHAR(100),
	`Apellido` VARCHAR(100),
	`Correo` VARCHAR(150),
	`Telefono` VARCHAR(20),
	`Activo` BOOLEAN DEFAULT 1 COMMENT '1 : Activo
0 : Inactivo',
	PRIMARY KEY(`ID_profesor`)
);


CREATE TABLE IF NOT EXISTS `Categorias` (
	`ID_categoria` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`Nombre` VARCHAR(100) UNIQUE,
	`Descripcion` VARCHAR(255) NOT NULL,
	`Activo` BOOLEAN DEFAULT 1 COMMENT '1 : Activo 
0 : Inactivo',
	PRIMARY KEY(`ID_categoria`)
);


CREATE TABLE IF NOT EXISTS `Medios_pago` (
	`ID_medio_pago` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`Nombre` VARCHAR(100) UNIQUE,
	`Descripcion` VARCHAR(255) NOT NULL,
	`Activo` BOOLEAN DEFAULT 1 COMMENT '1 : Activo
0 : Inactivo',
	PRIMARY KEY(`ID_medio_pago`)
);


CREATE TABLE IF NOT EXISTS `Descuentos` (
	`ID_descuento` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`Nombre` VARCHAR(100) UNIQUE,
	`Descripcion` VARCHAR(255) NOT NULL,
	`Tipo_descuento` ENUM('''Monto fijo''', '''Porcentaje'''),
	`Valor` DECIMAL(10,2),
	`Fecha_inicio` DATE,
	`Fecha_termino` DATE,
	`Activo` BOOLEAN DEFAULT 1 COMMENT '1 : Activo
0 : Inactivo',
	PRIMARY KEY(`ID_descuento`)
);


CREATE TABLE IF NOT EXISTS `Profesores_especialidades` (
	`ID_profesor` INTEGER,
	`ID_especialidad` INTEGER,
	`Fecha_asignacion` DATE NOT NULL,
	PRIMARY KEY(`ID_profesor`, `ID_especialidad`)
);


ALTER TABLE `Cursos`
ADD FOREIGN KEY(`ID_profesor`) REFERENCES `Profesores`(`ID_profesor`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `Categorias`
ADD FOREIGN KEY(`ID_categoria`) REFERENCES `Cursos`(`ID_categorio`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `Especialidades`
ADD FOREIGN KEY(`ID_especialidad`) REFERENCES `Cursos`(`ID_especialidad`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `Estudiantes`
ADD FOREIGN KEY(`ID_estudiante`) REFERENCES `Inscripciones`(`ID_estudiante`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `Cursos`
ADD FOREIGN KEY(`ID_curso`) REFERENCES `Inscripciones`(`ID_curso`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `Descuentos`
ADD FOREIGN KEY(`ID_descuento`) REFERENCES `Inscripciones`(`ID_descuento`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `Inscripciones`
ADD FOREIGN KEY(`ID_inscripcion`) REFERENCES `Planes_pago`(`ID_inscripcion`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `Planes_pago`
ADD FOREIGN KEY(`ID_plan_pago`) REFERENCES `Cuotas`(`ID_plan_pago`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `Cuotas`
ADD FOREIGN KEY(`ID_cuota`) REFERENCES `Pagos`(`ID_cuota`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `Medios_pago`
ADD FOREIGN KEY(`ID_medio_pago`) REFERENCES `Pagos`(`ID_medio_pago`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `Profesores`
ADD FOREIGN KEY(`ID_profesor`) REFERENCES `Profesores_especialidades`(`ID_profesor`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `Especialidades`
ADD FOREIGN KEY(`ID_especialidad`) REFERENCES `Profesores_especialidades`(`ID_especialidad`)
ON UPDATE NO ACTION ON DELETE NO ACTION;