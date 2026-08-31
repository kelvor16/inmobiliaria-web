-- =====================================================
-- SCRIPT DML - Sistema Web Inmobiliaria
-- Datos de prueba
-- =====================================================

USE inmobiliaria_db;

-- =====================================================
-- BLOQUE 1: USUARIOS Y ROLES
-- =====================================================

INSERT INTO rol (nombre_rol) VALUES
('Administrador'),
('Cliente'),
('Inmobiliaria'),
('Visitante');

INSERT INTO usuario (correo, contrasena_hash, estado) VALUES
('admin@inmobiliaria.com', '$2a$10$examplehash0000000000000000000001', 'activo'),
('juan.perez@mail.com', '$2a$10$examplehash0000000000000000000002', 'activo'),
('maria.gomez@mail.com', '$2a$10$examplehash0000000000000000000003', 'activo'),
('carlos.ruiz@mail.com', '$2a$10$examplehash0000000000000000000004', 'activo'),
('laura.diaz@mail.com', '$2a$10$examplehash0000000000000000000005', 'activo'),
('inmobiliaria.norte@mail.com', '$2a$10$examplehash0000000000000000000006', 'activo'),
('inmobiliaria.sur@mail.com', '$2a$10$examplehash0000000000000000000007', 'activo'),
('pedro.lopez@mail.com', '$2a$10$examplehash0000000000000000000008', 'activo'),
('ana.torres@mail.com', '$2a$10$examplehash0000000000000000000009', 'inactivo'),
('sofia.moreno@mail.com', '$2a$10$examplehash0000000000000000000010', 'activo');

INSERT INTO perfil (id_usuario, nombres, apellidos, documento, telefono, direccion) VALUES
(1, 'Admin', 'Sistema', '1000000001', '3000000001', 'Calle 1 # 1-01, Bucaramanga'),
(2, 'Juan', 'Pérez', '1000000002', '3000000002', 'Cra 5 # 10-20, Bogotá'),
(3, 'María', 'Gómez', '1000000003', '3000000003', 'Cll 20 # 15-30, Medellín'),
(4, 'Carlos', 'Ruiz', '1000000004', '3000000004', 'Cra 10 # 25-15, Cali'),
(5, 'Laura', 'Díaz', '1000000005', '3000000005', 'Cll 8 # 12-40, San Gil'),
(6, 'Inmobiliaria', 'Norte S.A.S', '900000001', '3000000006', 'Cra 15 # 30-10, Bucaramanga'),
(7, 'Inmobiliaria', 'Sur Ltda', '900000002', '3000000007', 'Cll 40 # 5-60, Girón'),
(8, 'Pedro', 'López', '1000000008', '3000000008', 'Cra 20 # 8-25, Floridablanca'),
(9, 'Ana', 'Torres', '1000000009', '3000000009', 'Cll 33 # 18-12, Piedecuesta'),
(10, 'Sofía', 'Moreno', '1000000010', '3000000010', 'Cra 7 # 14-33, San Gil');

INSERT INTO usuario_rol (id_usuario, id_rol) VALUES
(1, 1),
(2, 2),
(3, 2),
(4, 2),
(5, 2),
(6, 3),
(7, 3),
(8, 2),
(8, 3),
(9, 2),
(10, 2);

-- =====================================================
-- BLOQUE 2: PROPIEDADES
-- =====================================================

INSERT INTO ciudad (nombre_ciudad, departamento) VALUES
('Bucaramanga', 'Santander'),
('San Gil', 'Santander'),
('Girón', 'Santander'),
('Floridablanca', 'Santander'),
('Piedecuesta', 'Santander'),
('Bogotá', 'Cundinamarca'),
('Medellín', 'Antioquia'),
('Cali', 'Valle del Cauca');

INSERT INTO tipo_propiedad (nombre_tipo) VALUES
('Casa'),
('Apartamento'),
('Local Comercial'),
('Oficina'),
('Terreno');

INSERT INTO caracteristica (nombre_caracteristica) VALUES
('Piscina'),
('Parqueadero'),
('Ascensor'),
('Gimnasio'),
('Balcón'),
('Terraza'),
('Zona BBQ'),
('Vigilancia 24h');

INSERT INTO inmobiliaria (nombre_agencia, id_usuario) VALUES
('Inmobiliaria Norte S.A.S', 6),
('Inmobiliaria Sur Ltda', 7),
('Pedro López Bienes Raíces', 8);

INSERT INTO propiedad (id_inmobiliaria, id_ciudad, id_tipo, matricula_inmobiliaria, titulo, descripcion, direccion, precio, area_m2, estado) VALUES
(1, 1, 2, 'MAT-0001', 'Apartamento moderno centro', 'Apartamento de 3 habitaciones, remodelado', 'Cra 15 # 20-10', 280000000, 85.5, 'disponible'),
(1, 1, 1, 'MAT-0002', 'Casa campestre con jardín', 'Casa amplia con jardín y garaje doble', 'Vía Floridablanca km 3', 450000000, 220.0, 'disponible'),
(1, 3, 2, 'MAT-0003', 'Apartaestudio Girón', 'Ideal para estudiantes, cerca a universidad', 'Cll 30 # 12-15', 150000000, 45.0, 'disponible'),
(2, 4, 3, 'MAT-0004', 'Local comercial esquinero', 'Excelente ubicación, alto flujo peatonal', 'Cra 9 # 5-20', 320000000, 60.0, 'disponible'),
(2, 5, 4, 'MAT-0005', 'Oficina ejecutiva', 'Oficina en edificio corporativo, con ascensor', 'Cll 14 # 22-08', 210000000, 40.0, 'disponible'),
(2, 1, 2, 'MAT-0006', 'Apartamento con vista panorámica', 'Piso 12, vista a la ciudad', 'Cra 33 # 45-12', 380000000, 95.0, 'reservada'),
(3, 2, 1, 'MAT-0007', 'Casa en San Gil', 'Casa de dos pisos cerca al parque principal', 'Cll 10 # 8-45', 260000000, 140.0, 'disponible'),
(3, 2, 5, 'MAT-0008', 'Lote para construcción', 'Terreno plano, servicios públicos disponibles', 'Vereda La Laja', 90000000, 500.0, 'disponible'),
(1, 6, 2, 'MAT-0009', 'Apartamento en Bogotá', 'Cerca a zona rosa, edificio con amenidades', 'Cra 11 # 82-15', 520000000, 78.0, 'vendida'),
(2, 7, 1, 'MAT-0010', 'Casa familiar Medellín', 'Barrio residencial tranquilo', 'Cll 45 # 60-20', 410000000, 180.0, 'disponible'),
(3, 4, 4, 'MAT-0011', 'Oficina pequeña Floridablanca', 'Ideal para consultorio o startup', 'Cra 6 # 10-30', 130000000, 25.0, 'arrendada'),
(1, 1, 3, 'MAT-0012', 'Local para restaurante', 'Amplio, con cocina adecuada previamente', 'Cll 36 # 20-05', 290000000, 110.0, 'disponible');

INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal, orden) VALUES
(1, 'https://ejemplo.com/img/prop1_1.jpg', TRUE, 1),
(1, 'https://ejemplo.com/img/prop1_2.jpg', FALSE, 2),
(1, 'https://ejemplo.com/img/prop1_3.jpg', FALSE, 3),
(2, 'https://ejemplo.com/img/prop2_1.jpg', TRUE, 1),
(2, 'https://ejemplo.com/img/prop2_2.jpg', FALSE, 2),
(3, 'https://ejemplo.com/img/prop3_1.jpg', TRUE, 1),
(4, 'https://ejemplo.com/img/prop4_1.jpg', TRUE, 1),
(4, 'https://ejemplo.com/img/prop4_2.jpg', FALSE, 2),
(5, 'https://ejemplo.com/img/prop5_1.jpg', TRUE, 1),
(6, 'https://ejemplo.com/img/prop6_1.jpg', TRUE, 1),
(6, 'https://ejemplo.com/img/prop6_2.jpg', FALSE, 2),
(7, 'https://ejemplo.com/img/prop7_1.jpg', TRUE, 1);

INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica, cantidad) VALUES
(1, 3, 1),
(1, 2, 1),
(1, 5, 1),
(2, 2, 2),
(2, 1, 1),
(2, 6, 1),
(3, 3, 1),
(4, 2, 1),
(5, 3, 1),
(5, 8, 1),
(6, 3, 1),
(6, 4, 1),
(6, 1, 1),
(7, 2, 1),
(9, 3, 1),
(9, 4, 1),
(9, 8, 1);

-- =====================================================
-- BLOQUE 3: OPERACIONES
-- =====================================================

INSERT INTO cita (id_propiedad, id_usuario, fecha_hora, estado, observaciones) VALUES
(1, 2, '2026-09-05 10:00:00', 'confirmada', 'Cliente interesado en compra rápida'),
(1, 3, '2026-09-06 14:30:00', 'pendiente', NULL),
(2, 4, '2026-09-05 09:00:00', 'confirmada', 'Visita con toda la familia'),
(3, 5, '2026-09-07 11:00:00', 'realizada', 'Cliente ya firmó arriendo'),
(4, 2, '2026-09-08 16:00:00', 'pendiente', NULL),
(5, 3, '2026-09-09 10:30:00', 'rechazada', 'Cliente canceló por horario'),
(6, 9, '2026-09-10 15:00:00', 'confirmada', NULL),
(7, 4, '2026-09-05 08:30:00', 'pendiente', 'Primera visita a la zona'),
(9, 5, '2026-09-11 13:00:00', 'realizada', 'Visita técnica completa'),
(10, 2, '2026-09-12 09:30:00', 'confirmada', NULL);

INSERT INTO solicitud (id_usuario, id_propiedad, tipo_solicitud, estado, observaciones) VALUES
(2, 1, 'compra', 'aprobada', 'Documentación completa y verificada'),
(3, 3, 'arriendo', 'en_revision', 'Falta certificado laboral'),
(4, 2, 'compra', 'pendiente', NULL),
(5, 3, 'arriendo', 'aprobada', 'Contrato firmado'),
(9, 6, 'compra', 'pendiente', 'A la espera de aprobación de crédito'),
(2, 4, 'arriendo', 'rechazada', 'No cumple requisitos de ingresos'),
(10, 10, 'compra', 'en_revision', NULL),
(4, 7, 'arriendo', 'pendiente', NULL);

INSERT INTO documento_solicitud (id_solicitud, nombre_documento, url_archivo) VALUES
(1, 'Cédula de ciudadanía', 'https://ejemplo.com/docs/cedula_2.pdf'),
(1, 'Certificado laboral', 'https://ejemplo.com/docs/cert_laboral_2.pdf'),
(2, 'Cédula de ciudadanía', 'https://ejemplo.com/docs/cedula_3.pdf'),
(4, 'Cédula de ciudadanía', 'https://ejemplo.com/docs/cedula_5.pdf'),
(4, 'Contrato de arriendo', 'https://ejemplo.com/docs/contrato_5.pdf'),
(6, 'Cédula de ciudadanía', 'https://ejemplo.com/docs/cedula_2b.pdf'),
(6, 'Certificado de ingresos', 'https://ejemplo.com/docs/ingresos_2.pdf');

INSERT INTO favorito (id_usuario, id_propiedad) VALUES
(2, 1),
(2, 6),
(2, 9),
(3, 3),
(3, 7),
(4, 2),
(4, 10),
(5, 3),
(5, 5),
(9, 6),
(10, 1),
(10, 10);

INSERT INTO auditoria (id_usuario, accion, detalle) VALUES
(1, 'LOGIN', 'Administrador inició sesión'),
(1, 'ACTUALIZAR_ROL', 'Se asignó rol Inmobiliaria a usuario id 8'),
(2, 'LOGIN', 'Cliente inició sesión'),
(2, 'CREAR_SOLICITUD', 'Solicitud de compra sobre propiedad id 1'),
(6, 'PUBLICAR_PROPIEDAD', 'Nueva propiedad matrícula MAT-0001'),
(6, 'PUBLICAR_PROPIEDAD', 'Nueva propiedad matrícula MAT-0002'),
(1, 'INACTIVAR_CUENTA', 'Se inactivó la cuenta del usuario id 9'),
(7, 'LOGIN', 'Inmobiliaria Sur inició sesión'),
(3, 'AGENDAR_CITA', 'Cita para propiedad id 1'),
(1, 'LOGIN', 'Administrador inició sesión nuevamente');