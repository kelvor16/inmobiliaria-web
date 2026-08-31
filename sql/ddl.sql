-- =====================================================
-- SCRIPT DDL - Sistema Web Inmobiliaria
-- Base de datos: inmobiliaria_db
-- =====================================================

CREATE DATABASE IF NOT EXISTS inmobiliaria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE inmobiliaria_db;

-- =====================================================
-- BLOQUE 1: USUARIOS Y ROLES
-- =====================================================

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(150) NOT NULL UNIQUE,
    contrasena_hash VARCHAR(255) NOT NULL,
    estado ENUM('activo','inactivo') NOT NULL DEFAULT 'activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE perfil (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    documento VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    foto_url VARCHAR(255),
    CONSTRAINT fk_perfil_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE usuario_rol (
    id_usuario INT NOT NULL,
    id_rol INT NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_rol),
    CONSTRAINT fk_usuariorol_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_usuariorol_rol
        FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =====================================================
-- BLOQUE 2: PROPIEDADES
-- =====================================================

CREATE TABLE ciudad (
    id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
    nombre_ciudad VARCHAR(100) NOT NULL UNIQUE,
    departamento VARCHAR(100)
);

CREATE TABLE tipo_propiedad (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE inmobiliaria (
    id_inmobiliaria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_agencia VARCHAR(150) NOT NULL,
    id_usuario INT NOT NULL UNIQUE,
    CONSTRAINT fk_inmobiliaria_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE propiedad (
    id_propiedad INT AUTO_INCREMENT PRIMARY KEY,
    id_inmobiliaria INT NOT NULL,
    id_ciudad INT NOT NULL,
    id_tipo INT NOT NULL,
    matricula_inmobiliaria VARCHAR(50) NOT NULL UNIQUE,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    direccion VARCHAR(255) NOT NULL,
    precio DECIMAL(15,2) NOT NULL,
    area_m2 DECIMAL(10,2),
    estado ENUM('disponible','reservada','vendida','arrendada','inactiva') NOT NULL DEFAULT 'disponible',
    fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_propiedad_inmobiliaria
        FOREIGN KEY (id_inmobiliaria) REFERENCES inmobiliaria(id_inmobiliaria)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_propiedad_ciudad
        FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_propiedad_tipo
        FOREIGN KEY (id_tipo) REFERENCES tipo_propiedad(id_tipo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE imagen_propiedad (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    es_principal BOOLEAN NOT NULL DEFAULT FALSE,
    orden INT DEFAULT 0,
    CONSTRAINT fk_imagen_propiedad
        FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE caracteristica (
    id_caracteristica INT AUTO_INCREMENT PRIMARY KEY,
    nombre_caracteristica VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE propiedad_caracteristica (
    id_propiedad INT NOT NULL,
    id_caracteristica INT NOT NULL,
    cantidad INT DEFAULT 1,
    PRIMARY KEY (id_propiedad, id_caracteristica),
    CONSTRAINT fk_propcarac_propiedad
        FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_propcarac_caracteristica
        FOREIGN KEY (id_caracteristica) REFERENCES caracteristica(id_caracteristica)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =====================================================
-- BLOQUE 3: OPERACIONES
-- =====================================================

CREATE TABLE cita (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_usuario INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    estado ENUM('pendiente','confirmada','rechazada','realizada','cancelada') NOT NULL DEFAULT 'pendiente',
    observaciones VARCHAR(255),
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cita_propiedad
        FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_cita_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT uq_cita_propiedad_fecha UNIQUE (id_propiedad, fecha_hora)
);

CREATE TABLE solicitud (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_propiedad INT NOT NULL,
    tipo_solicitud ENUM('compra','arriendo') NOT NULL,
    estado ENUM('pendiente','en_revision','aprobada','rechazada') NOT NULL DEFAULT 'pendiente',
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observaciones VARCHAR(255),
    CONSTRAINT fk_solicitud_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_solicitud_propiedad
        FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE documento_solicitud (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    nombre_documento VARCHAR(150) NOT NULL,
    url_archivo VARCHAR(255) NOT NULL,
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_documento_solicitud
        FOREIGN KEY (id_solicitud) REFERENCES solicitud(id_solicitud)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE favorito (
    id_usuario INT NOT NULL,
    id_propiedad INT NOT NULL,
    fecha_marcado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_propiedad),
    CONSTRAINT fk_favorito_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_favorito_propiedad
        FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    accion VARCHAR(150) NOT NULL,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    detalle TEXT,
    CONSTRAINT fk_auditoria_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);