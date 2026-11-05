CREATE DATABASE IF NOT EXISTS academia_cursos;

USE academia_cursos;


-- 1. TABLA ESTUDIANTES
CREATE TABLE estudiantes (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    ciudad VARCHAR(100) NOT NULL,
    fecha_registro DATE NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- 2. TABLA ESPECIALIDADES
CREATE TABLE especialidades (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- 3. TABLA PROFESORES
CREATE TABLE profesores (
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- 4. TABLA PROFESOR_ESPECIALIDAD
CREATE TABLE profesor_especialidad (
    id_profesor INT NOT NULL,
    id_especialidad INT NOT NULL,
    fecha_asignacion DATE,

    PRIMARY KEY (id_profesor, id_especialidad),

    CONSTRAINT fk_pe_profesor
        FOREIGN KEY (id_profesor)
        REFERENCES profesores(id_profesor),

    CONSTRAINT fk_pe_especialidad
        FOREIGN KEY (id_especialidad)
        REFERENCES especialidades(id_especialidad)
);


-- TABLA CATEGORIAS
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- 4. TABLA CURSOS
CREATE TABLE cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    id_profesor INT NOT NULL,
    id_categoria INT NOT NULL,
    id_especialidad INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio_base DECIMAL(10,2) NOT NULL,

    fecha_inicio DATE NOT NULL,
    fecha_termino DATE NOT NULL,
    duracion_horas INT NOT NULL,
    cupo_maximo INT NOT NULL,

    modalidad ENUM(
        'presencial',
        'online',
        'hibrida'
    ) NOT NULL,

    nivel ENUM(
        'basico',
        'intermedio',
        'avanzado'
    ) NOT NULL,

    estado ENUM(
        'programado',
        'en_curso',
        'finalizado',
        'cancelado'
    ) NOT NULL DEFAULT 'programado',

    CONSTRAINT chk_precio
        CHECK (precio_base >= 0),

    CONSTRAINT chk_fechas_curso
        CHECK (fecha_termino >= fecha_inicio),

    CONSTRAINT chk_duracion_curso
        CHECK (duracion_horas > 0),

    CONSTRAINT chk_cupo_curso
        CHECK (cupo_maximo > 0),

    CONSTRAINT fk_curso_profesor
        FOREIGN KEY (id_profesor)
        REFERENCES profesores(id_profesor),
    
    
    CONSTRAINT fk_curso_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria),

    CONSTRAINT fk_curso_profesor_especialidad
        FOREIGN KEY (id_profesor, id_especialidad)
        REFERENCES profesor_especialidad(id_profesor, id_especialidad)
);

-- TABLA DESCUENTOS
CREATE TABLE descuentos (
    id_descuento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),

    tipo_descuento ENUM(
        'porcentaje',
        'monto_fijo'
    ) NOT NULL,

    valor DECIMAL(10,2) NOT NULL,

    fecha_inicio DATE NOT NULL,
    fecha_termino DATE NOT NULL,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_valor_descuento
        CHECK (
            valor >= 0
            AND (
                tipo_descuento <> 'porcentaje'
                OR valor <= 100
            )
        ),

    CONSTRAINT chk_fechas_descuento
        CHECK (fecha_termino >= fecha_inicio)
);

-- TABLA INSCRIPCIONES
CREATE TABLE inscripciones (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_curso INT NOT NULL,
    id_descuento INT NULL,

    fecha DATE NOT NULL,
    importe_final DECIMAL(10,2) NOT NULL,


    estado ENUM(
        'activa',
        'cancelada',
        'finalizada'
    ) NOT NULL DEFAULT 'activa',


    estado_academico ENUM(
        'no_iniciado',
        'en_curso',
        'aprobado',
        'reprobado',
        'retirado'
    ) NOT NULL DEFAULT 'no_iniciado',

    fecha_cancelacion DATE NULL,
    observaciones TEXT,

    -- Validar importe
    CONSTRAINT chk_importe
        CHECK (importe_final >= 0),

    -- Validar fecha de cancelacion
    CONSTRAINT chk_cancelacion
        CHECK (
            (estado = 'cancelada'
                AND fecha_cancelacion IS NOT NULL
                AND fecha_cancelacion >= fecha)
            OR
            (estado <> 'cancelada'
                AND fecha_cancelacion IS NULL)
     ),


    -- Relacion con estudiantes
    CONSTRAINT fk_inscripcion_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiantes(id_estudiante),

    -- Relacion con cursos
    CONSTRAINT fk_inscripcion_curso
        FOREIGN KEY (id_curso)
        REFERENCES cursos(id_curso),

        
    -- Relacion opcional con descuentos
    CONSTRAINT fk_inscripcion_descuento
        FOREIGN KEY (id_descuento)
        REFERENCES descuentos(id_descuento),

    -- Evitar inscripciones duplicadas
    CONSTRAINT uq_estudiante_curso
        UNIQUE (id_estudiante, id_curso)
);

-- TABLA MEDIOS DE PAGO
CREATE TABLE medios_pago (
    id_medio_pago INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- TABLA PLANES DE PAGO
CREATE TABLE planes_pago (
    id_plan_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_inscripcion INT NOT NULL UNIQUE,

    modalidad_pago ENUM(
        'contado',
        'cuotas'
    ) NOT NULL,

    numero_cuotas INT NOT NULL DEFAULT 1,
    monto_total DECIMAL(10,2) NOT NULL,
    fecha_acuerdo DATE NOT NULL,

    CONSTRAINT chk_numero_cuotas
        CHECK (
            (modalidad_pago = 'contado' AND numero_cuotas = 1)
            OR
            (modalidad_pago = 'cuotas' AND numero_cuotas >= 2)
        ),

    CONSTRAINT chk_monto_plan
        CHECK (monto_total >= 0),

    CONSTRAINT fk_plan_inscripcion
        FOREIGN KEY (id_inscripcion)
        REFERENCES inscripciones(id_inscripcion)
);


-- TABLA CUOTAS
CREATE TABLE cuotas (
    id_cuota INT AUTO_INCREMENT PRIMARY KEY,
    id_plan_pago INT NOT NULL,

    numero_cuota INT NOT NULL,
    monto_programado DECIMAL(10,2) NOT NULL,
    fecha_vencimiento DATE NOT NULL,

    CONSTRAINT chk_numero_cuota
        CHECK (numero_cuota > 0),

    CONSTRAINT chk_monto_cuota
        CHECK (monto_programado >= 0),

    CONSTRAINT uq_cuota_plan
        UNIQUE (id_plan_pago, numero_cuota),

    CONSTRAINT fk_cuota_plan
        FOREIGN KEY (id_plan_pago)
        REFERENCES planes_pago(id_plan_pago)
);


-- TABLA PAGOS
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_cuota INT NOT NULL,
    id_medio_pago INT NOT NULL,

    fecha_pago DATE NOT NULL,
    monto_pagado DECIMAL(10,2) NOT NULL,
    referencia_pago VARCHAR(100),

    estado_pago ENUM(
        'pendiente',
        'confirmado',
        'rechazado'
    ) NOT NULL DEFAULT 'pendiente',

    CONSTRAINT chk_monto_pagado
        CHECK (monto_pagado > 0),

    CONSTRAINT fk_pago_cuota
        FOREIGN KEY (id_cuota)
        REFERENCES cuotas(id_cuota),

    CONSTRAINT fk_pago_medio
        FOREIGN KEY (id_medio_pago)
        REFERENCES medios_pago(id_medio_pago)
);