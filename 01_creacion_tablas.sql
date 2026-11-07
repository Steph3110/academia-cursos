CREATE DATABASE IF NOT EXISTS academia_cursos
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE academia_cursos;

CREATE TABLE IF NOT EXISTS estudiantes (
    id_estudiante INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    ciudad VARCHAR(100),
    fecha_registro DATE NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS especialidades (
    id_especialidad INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS profesores (
    id_profesor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    activo BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS categorias (
    id_categoria INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS medios_pago (
    id_medio_pago INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS descuentos (
    id_descuento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    tipo_descuento ENUM('porcentaje', 'monto_fijo') NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_termino DATE NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_descuento_valor CHECK (
        valor >= 0
        AND (
            tipo_descuento = 'monto_fijo'
            OR valor <= 100
        )
    ),
    CONSTRAINT chk_descuento_fechas CHECK (fecha_termino >= fecha_inicio)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS profesores_especialidades (
    id_profesor INT UNSIGNED NOT NULL,
    id_especialidad INT UNSIGNED NOT NULL,
    fecha_asignacion DATE NOT NULL,
    PRIMARY KEY (id_profesor, id_especialidad),
    CONSTRAINT fk_pe_profesor
        FOREIGN KEY (id_profesor)
        REFERENCES profesores(id_profesor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_pe_especialidad
        FOREIGN KEY (id_especialidad)
        REFERENCES especialidades(id_especialidad)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS cursos (
    id_curso INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio_base DECIMAL(10, 2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_termino DATE NOT NULL,
    duracion_horas INT UNSIGNED NOT NULL,
    cupo_maximo INT UNSIGNED NOT NULL,
    modalidad ENUM('presencial', 'online', 'hibrida') NOT NULL,
    nivel ENUM('basico', 'intermedio', 'avanzado') NOT NULL,
    estado ENUM('programado', 'en_curso', 'finalizado', 'cancelado')
        NOT NULL DEFAULT 'programado',
    id_profesor INT UNSIGNED NOT NULL,
    id_categoria INT UNSIGNED NOT NULL,
    id_especialidad INT UNSIGNED NOT NULL,
    CONSTRAINT chk_curso_precio CHECK (precio_base >= 0),
    CONSTRAINT chk_curso_fechas CHECK (fecha_termino >= fecha_inicio),
    CONSTRAINT chk_curso_duracion CHECK (duracion_horas > 0),
    CONSTRAINT chk_curso_cupo CHECK (cupo_maximo > 0),
    CONSTRAINT fk_curso_profesor
        FOREIGN KEY (id_profesor)
        REFERENCES profesores(id_profesor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_curso_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_curso_especialidad
        FOREIGN KEY (id_especialidad)
        REFERENCES especialidades(id_especialidad)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS inscripciones (
    id_inscripcion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    importe_final DECIMAL(10, 2) NOT NULL,
    estado ENUM('activa', 'cancelada', 'finalizada')
        NOT NULL DEFAULT 'activa',
    estado_academico ENUM(
        'no_iniciado',
        'en_curso',
        'aprobado',
        'reprobado',
        'retirado'
    ) NOT NULL DEFAULT 'no_iniciado',
    fecha_cancelacion DATE,
    observaciones TEXT,
    id_estudiante INT UNSIGNED NOT NULL,
    id_curso INT UNSIGNED NOT NULL,
    id_descuento INT UNSIGNED,
    CONSTRAINT chk_inscripcion_importe CHECK (importe_final >= 0),
    CONSTRAINT chk_inscripcion_cancelacion CHECK (
        (estado = 'cancelada' AND fecha_cancelacion IS NOT NULL)
        OR (estado <> 'cancelada' AND fecha_cancelacion IS NULL)
    ),
    CONSTRAINT fk_inscripcion_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiantes(id_estudiante)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_inscripcion_curso
        FOREIGN KEY (id_curso)
        REFERENCES cursos(id_curso)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_inscripcion_descuento
        FOREIGN KEY (id_descuento)
        REFERENCES descuentos(id_descuento)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT uq_inscripcion_estudiante_curso
        UNIQUE (id_estudiante, id_curso)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS planes_pago (
    id_plan_pago INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    modalidad_pago ENUM('contado', 'cuotas') NOT NULL,
    numero_cuotas INT UNSIGNED NOT NULL DEFAULT 1,
    monto_total DECIMAL(10, 2) NOT NULL,
    fecha_acuerdo DATE NOT NULL,
    id_inscripcion INT UNSIGNED NOT NULL UNIQUE,
    CONSTRAINT chk_plan_numero_cuotas CHECK (
        (modalidad_pago = 'contado' AND numero_cuotas = 1)
        OR (modalidad_pago = 'cuotas' AND numero_cuotas >= 2)
    ),
    CONSTRAINT chk_plan_monto CHECK (monto_total >= 0),
    CONSTRAINT fk_plan_inscripcion
        FOREIGN KEY (id_inscripcion)
        REFERENCES inscripciones(id_inscripcion)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS cuotas (
    id_cuota INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    numero_cuota INT UNSIGNED NOT NULL,
    monto_programado DECIMAL(10, 2) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    id_plan_pago INT UNSIGNED NOT NULL,
    CONSTRAINT chk_cuota_numero CHECK (numero_cuota > 0),
    CONSTRAINT chk_cuota_monto CHECK (monto_programado >= 0),
    CONSTRAINT uq_cuota_plan_numero UNIQUE (id_plan_pago, numero_cuota),
    CONSTRAINT fk_cuota_plan
        FOREIGN KEY (id_plan_pago)
        REFERENCES planes_pago(id_plan_pago)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS pagos (
    id_pago INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    fecha_pago DATE NOT NULL,
    monto_pagado DECIMAL(10, 2) NOT NULL,
    estado_pago ENUM('pendiente', 'confirmado', 'rechazado')
        NOT NULL DEFAULT 'pendiente',
    id_cuota INT UNSIGNED NOT NULL,
    id_medio_pago INT UNSIGNED NOT NULL,
    CONSTRAINT chk_pago_monto CHECK (monto_pagado > 0),
    CONSTRAINT fk_pago_cuota
        FOREIGN KEY (id_cuota)
        REFERENCES cuotas(id_cuota)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_pago_medio
        FOREIGN KEY (id_medio_pago)
        REFERENCES medios_pago(id_medio_pago)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;
