# Diccionario de Datos — Sistema Web Inmobiliaria

**Proyecto:** InmobiliariaWeb
**Base de datos:** `inmobiliaria_db`
**Motor:** MySQL / MariaDB
**Fecha:** Agosto 2026

---

## Índice de tablas

| # | Tabla | Tipo de relación que involucra |
|---|---|---|
| 1 | usuario | Base del sistema |
| 2 | perfil | 1:1 con usuario |
| 3 | rol | Catálogo |
| 4 | usuario_rol | N:M (usuario ↔ rol) |
| 5 | inmobiliaria | 1:1 con usuario |
| 6 | ciudad | Catálogo |
| 7 | tipo_propiedad | Catálogo |
| 8 | propiedad | 1:N (con inmobiliaria, ciudad, tipo) |
| 9 | imagen_propiedad | 1:N con propiedad |
| 10 | caracteristica | Catálogo |
| 11 | propiedad_caracteristica | N:M (propiedad ↔ característica) |
| 12 | cita | 1:N (con usuario y propiedad) |
| 13 | solicitud | 1:N (con usuario y propiedad) |
| 14 | documento_solicitud | 1:N con solicitud |
| 15 | favorito | N:M (usuario ↔ propiedad) |
| 16 | auditoria | 1:N con usuario |

---

## 1. Tabla `usuario`

**Descripción:** Almacena únicamente las credenciales de acceso y el estado de la cuenta. Los datos personales se guardan por separado en `perfil` (relación 1:1).

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_usuario | INT | PK, AUTO_INCREMENT | Identificador único del usuario |
| correo | VARCHAR(150) | NOT NULL, UNIQUE | Correo electrónico, usado como credencial de ingreso |
| contrasena_hash | VARCHAR(255) | NOT NULL | Contraseña cifrada (BCrypt/PBKDF2/SHA-256+salt). Nunca se guarda en texto plano |
| estado | ENUM('activo','inactivo') | NOT NULL, DEFAULT 'activo' | Permite al administrador activar/inactivar cuentas |
| fecha_registro | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha y hora de creación de la cuenta |

---

## 2. Tabla `perfil`

**Descripción:** Guarda los datos personales del usuario. Se separa de `usuario` por seguridad (aísla credenciales de datos personales) y para permitir registro incompleto sin columnas nulas en la tabla principal.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_perfil | INT | PK, AUTO_INCREMENT | Identificador único del perfil |
| id_usuario | INT | FK → usuario(id_usuario), NOT NULL, UNIQUE | Garantiza la relación 1:1 — un usuario solo puede tener un perfil |
| nombres | VARCHAR(100) | NOT NULL | Nombres de la persona |
| apellidos | VARCHAR(100) | NOT NULL | Apellidos de la persona |
| documento | VARCHAR(20) | NOT NULL, UNIQUE | Número de documento de identidad |
| telefono | VARCHAR(20) | — | Número de contacto |
| direccion | VARCHAR(255) | — | Dirección de residencia |
| foto_url | VARCHAR(255) | — | Ruta/URL de la foto de perfil |

**Acción referencial:** `ON DELETE CASCADE` — si se elimina el usuario, su perfil se elimina también (no puede existir un perfil huérfano).

---

## 3. Tabla `rol`

**Descripción:** Catálogo de los roles disponibles en el sistema.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_rol | INT | PK, AUTO_INCREMENT | Identificador único del rol |
| nombre_rol | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del rol: Administrador, Cliente, Inmobiliaria, Visitante |

---

## 4. Tabla `usuario_rol`

**Descripción:** Tabla intermedia que resuelve la relación muchos a muchos entre `usuario` y `rol`. Un usuario puede tener varios roles; un rol puede pertenecer a varios usuarios.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_usuario | INT | PK (compuesta), FK → usuario(id_usuario) | Parte de la llave primaria compuesta |
| id_rol | INT | PK (compuesta), FK → rol(id_rol) | Parte de la llave primaria compuesta |
| fecha_asignacion | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Atributo propio de la relación: cuándo se asignó ese rol a ese usuario |

**Llave primaria compuesta:** `(id_usuario, id_rol)` — evita que un mismo usuario tenga el mismo rol asignado dos veces.

---

## 5. Tabla `inmobiliaria`

**Descripción:** Datos de la agencia/agente que publica propiedades. Vinculada 1:1 con un usuario de rol "Inmobiliaria".

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_inmobiliaria | INT | PK, AUTO_INCREMENT | Identificador único de la inmobiliaria |
| nombre_agencia | VARCHAR(150) | NOT NULL | Nombre comercial de la agencia |
| id_usuario | INT | FK → usuario(id_usuario), NOT NULL, UNIQUE | Cuenta de usuario asociada a esta inmobiliaria |

---

## 6. Tabla `ciudad`

**Descripción:** Catálogo de ciudades disponibles para clasificar propiedades.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_ciudad | INT | PK, AUTO_INCREMENT | Identificador único de la ciudad |
| nombre_ciudad | VARCHAR(100) | NOT NULL, UNIQUE | Nombre de la ciudad |
| departamento | VARCHAR(100) | — | Departamento al que pertenece |

---

## 7. Tabla `tipo_propiedad`

**Descripción:** Catálogo de tipos de inmueble.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_tipo | INT | PK, AUTO_INCREMENT | Identificador único del tipo |
| nombre_tipo | VARCHAR(50) | NOT NULL, UNIQUE | Casa, Apartamento, Local Comercial, Oficina, Terreno |

---

## 8. Tabla `propiedad`

**Descripción:** Tabla central del sistema. Almacena la información de cada inmueble publicado.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_propiedad | INT | PK, AUTO_INCREMENT | Identificador único de la propiedad |
| id_inmobiliaria | INT | FK → inmobiliaria(id_inmobiliaria), NOT NULL | Agencia que publica el inmueble |
| id_ciudad | INT | FK → ciudad(id_ciudad), NOT NULL | Ciudad donde se ubica |
| id_tipo | INT | FK → tipo_propiedad(id_tipo), NOT NULL | Tipo de inmueble |
| matricula_inmobiliaria | VARCHAR(50) | NOT NULL, UNIQUE | Identifica de forma irrepetible cada inmueble |
| titulo | VARCHAR(150) | NOT NULL | Título de la publicación |
| descripcion | TEXT | — | Descripción detallada |
| direccion | VARCHAR(255) | NOT NULL | Dirección física del inmueble |
| precio | DECIMAL(15,2) | NOT NULL | Precio de venta o arriendo (sin errores de redondeo) |
| area_m2 | DECIMAL(10,2) | — | Área en metros cuadrados |
| estado | ENUM('disponible','reservada','vendida','arrendada','inactiva') | NOT NULL, DEFAULT 'disponible' | Controla la baja lógica del inmueble |
| fecha_publicacion | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de publicación |

**Acciones referenciales:**
- `id_inmobiliaria`: `ON DELETE CASCADE` — al borrar la agencia, sus propiedades se borran con ella
- `id_ciudad` y `id_tipo`: `ON DELETE RESTRICT` — no se permite borrar una ciudad o tipo si tiene propiedades asociadas, para no perder información del inmueble

---

## 9. Tabla `imagen_propiedad`

**Descripción:** Galería de imágenes de cada propiedad. Relación 1:N — una propiedad tiene muchas imágenes.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_imagen | INT | PK, AUTO_INCREMENT | Identificador único de la imagen |
| id_propiedad | INT | FK → propiedad(id_propiedad), NOT NULL | Propiedad a la que pertenece |
| url_imagen | VARCHAR(255) | NOT NULL | Ruta/URL del archivo de imagen |
| es_principal | BOOLEAN | NOT NULL, DEFAULT FALSE | Marca la foto de portada |
| orden | INT | DEFAULT 0 | Orden de visualización en la galería |

**Acción referencial:** `ON DELETE CASCADE` — al borrar la propiedad, sus imágenes se borran con ella.

---

## 10. Tabla `caracteristica`

**Descripción:** Catálogo de características disponibles para los inmuebles.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_caracteristica | INT | PK, AUTO_INCREMENT | Identificador único de la característica |
| nombre_caracteristica | VARCHAR(100) | NOT NULL, UNIQUE | Piscina, Parqueadero, Ascensor, Gimnasio, etc. |

---

## 11. Tabla `propiedad_caracteristica`

**Descripción:** Tabla intermedia que resuelve la relación muchos a muchos entre `propiedad` y `caracteristica`.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_propiedad | INT | PK (compuesta), FK → propiedad(id_propiedad) | Parte de la llave primaria compuesta |
| id_caracteristica | INT | PK (compuesta), FK → caracteristica(id_caracteristica) | Parte de la llave primaria compuesta |
| cantidad | INT | DEFAULT 1 | Atributo propio de la relación (ej: número de parqueaderos) |

**Llave primaria compuesta:** `(id_propiedad, id_caracteristica)`.

---

## 12. Tabla `cita`

**Descripción:** Agendamiento de visitas a propiedades.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_cita | INT | PK, AUTO_INCREMENT | Identificador único de la cita |
| id_propiedad | INT | FK → propiedad(id_propiedad), NOT NULL | Propiedad a visitar |
| id_usuario | INT | FK → usuario(id_usuario), NOT NULL | Cliente que agenda |
| fecha_hora | DATETIME | NOT NULL | Fecha y hora de la visita |
| estado | ENUM('pendiente','confirmada','rechazada','realizada','cancelada') | NOT NULL, DEFAULT 'pendiente' | Estado del agendamiento |
| observaciones | VARCHAR(255) | — | Notas adicionales |
| fecha_solicitud | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Cuándo se creó la solicitud de cita |

**Restricción UNIQUE adicional:** `(id_propiedad, fecha_hora)` — impide agendar dos visitas a la misma propiedad en el mismo horario.

---

## 13. Tabla `solicitud`

**Descripción:** Trámite de compra o arriendo iniciado por un cliente.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_solicitud | INT | PK, AUTO_INCREMENT | Identificador único de la solicitud |
| id_usuario | INT | FK → usuario(id_usuario), NOT NULL | Cliente que radica |
| id_propiedad | INT | FK → propiedad(id_propiedad), NOT NULL | Propiedad involucrada |
| tipo_solicitud | ENUM('compra','arriendo') | NOT NULL | Tipo de trámite |
| estado | ENUM('pendiente','en_revision','aprobada','rechazada') | NOT NULL, DEFAULT 'pendiente' | Estado del trámite |
| fecha_solicitud | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de radicación |
| observaciones | VARCHAR(255) | — | Notas del proceso |

---

## 14. Tabla `documento_solicitud`

**Descripción:** Documentos adjuntos a una solicitud (cédula, certificado laboral, etc.). Relación 1:N con `solicitud`.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_documento | INT | PK, AUTO_INCREMENT | Identificador único del documento |
| id_solicitud | INT | FK → solicitud(id_solicitud), NOT NULL | Solicitud a la que pertenece |
| nombre_documento | VARCHAR(150) | NOT NULL | Nombre/tipo de documento |
| url_archivo | VARCHAR(255) | NOT NULL | Ruta/URL del archivo cargado |
| fecha_carga | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha en que se subió el documento |

---

## 15. Tabla `favorito`

**Descripción:** Tabla intermedia que resuelve la relación muchos a muchos entre `usuario` (clientes) y `propiedad`.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_usuario | INT | PK (compuesta), FK → usuario(id_usuario) | Parte de la llave primaria compuesta |
| id_propiedad | INT | PK (compuesta), FK → propiedad(id_propiedad) | Parte de la llave primaria compuesta |
| fecha_marcado | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Cuándo se marcó como favorita |

**Llave primaria compuesta:** `(id_usuario, id_propiedad)` — evita duplicados.

---

## 16. Tabla `auditoria`

**Descripción:** Registro de actividad del sistema (accesos y cambios), para trazabilidad.

| Columna | Tipo de dato | Restricciones | Descripción |
|---|---|---|---|
| id_auditoria | INT | PK, AUTO_INCREMENT | Identificador único del registro |
| id_usuario | INT | FK → usuario(id_usuario), NULL permitido | Usuario que ejecutó la acción |
| accion | VARCHAR(150) | NOT NULL | Tipo de acción (LOGIN, CREAR_SOLICITUD, etc.) |
| fecha_hora | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Momento del evento |
| detalle | TEXT | — | Descripción ampliada de la acción |

**Acción referencial:** `ON DELETE SET NULL` — el registro de auditoría se conserva aunque el usuario sea eliminado (por trazabilidad), solo queda el campo `id_usuario` en blanco.

---

## Resumen de restricciones UNIQUE (mínimo 3 exigidas)

| Tabla | Campo(s) UNIQUE | Justificación |
|---|---|---|
| usuario | correo | Es la credencial de ingreso, no pueden existir dos cuentas con el mismo correo |
| perfil | documento | Dos personas no deberían compartir el mismo número de documento |
| perfil | id_usuario | Garantiza la relación 1:1 con usuario |
| inmobiliaria | id_usuario | Garantiza la relación 1:1 con usuario |
| propiedad | matricula_inmobiliaria | Identifica de forma irrepetible cada inmueble |
| usuario_rol | (id_usuario, id_rol) | Evita roles repetidos para un mismo usuario |
| propiedad_caracteristica | (id_propiedad, id_caracteristica) | Evita características repetidas para una misma propiedad |
| favorito | (id_usuario, id_propiedad) | Evita marcar la misma propiedad como favorita dos veces |
| cita | (id_propiedad, fecha_hora) | Evita agendar dos visitas a la misma propiedad en el mismo horario |

## Resumen de relaciones del modelo

| Tipo | Tablas involucradas |
|---|---|
| **1:1** | usuario ↔ perfil · usuario ↔ inmobiliaria |
| **1:N** | inmobiliaria → propiedad · ciudad → propiedad · tipo_propiedad → propiedad · propiedad → imagen_propiedad · usuario → cita · propiedad → cita · usuario → solicitud · propiedad → solicitud · solicitud → documento_solicitud · usuario → auditoria |
| **N:M** | usuario ↔ rol (vía usuario_rol) · propiedad ↔ caracteristica (vía propiedad_caracteristica) · usuario ↔ propiedad (vía favorito) |
