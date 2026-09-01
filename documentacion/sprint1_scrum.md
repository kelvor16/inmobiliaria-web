# Sprint 1 — Cimientos y Acceso

**Proyecto:** Sistema Web Inmobiliaria
**Duración:** 7 días
**Roles simulados:** Product Owner (Docente) · Scrum Master / Development Team (Estudiante)

---

## 🟦 Sprint Planning

### Objetivo del Sprint
Establecer las bases técnicas y de seguridad del proyecto: modelo de datos completo, conexión a base de datos, landing page pública, y sistema de autenticación con control de acceso por rol.

### Historias de usuario seleccionadas para este sprint

| # | Historia | Prioridad | Estimación |
|---|---|---|---|
| — | Como desarrollador, necesito un modelo de datos normalizado (MER, DDL, DML) para soportar toda la aplicación | Alta | 2 días |
| 1 | Como visitante, quiero una página de aterrizaje atractiva para conocer la inmobiliaria y buscar propiedades rápidamente | Alta | 1 día |
| 2 | Como usuario, quiero registrarme con un correo único y validado para crear mi cuenta sin duplicados en el sistema | Alta | 2 días |
| 3 | Como usuario registrado, quiero iniciar y cerrar sesión de forma segura para que el sistema me lleve al panel que corresponde a mi rol | Alta | 1.5 días |
| — | Como sistema, necesito un Filter que proteja las rutas privadas según el rol del usuario | Alta | 0.5 días |

### Criterios de aceptación (Definition of Done) generales del sprint
- Las contraseñas se almacenan cifradas con BCrypt, nunca en texto plano.
- La base de datos cuenta con MER, modelo relacional en 3FN, script DDL y DML con datos de prueba.
- El registro valida correo único en el servidor y muestra mensajes claros ante duplicados.
- El login crea una sesión (`HttpSession`) con el usuario y sus roles.
- Un `Filter` bloquea el acceso a rutas privadas si no hay sesión o si el rol no corresponde, redirigiendo a una página de acceso denegado.
- El repositorio Git está inicializado y sincronizado con GitHub (público).

---

## 🟩 Sprint Review

### Funcionalidad entregada y demostrada

- ✅ Modelo de datos completo: MER, modelo relacional en 3FN, 16 tablas con relaciones 1:1, 1:N y N:M, restricciones UNIQUE, script DDL y DML con datos de prueba, diccionario de datos, y 5 consultas SQL obligatorias (INNER JOIN, LEFT JOIN, GROUP BY/HAVING).
- ✅ Conexión JDBC centralizada y configurable (`ConexionBD.java` + `db.properties`), sin repetir credenciales en cada clase.
- ✅ Landing page responsiva con Bootstrap: navbar, buscador de propiedades, sección de propiedades destacadas y footer.
- ✅ Módulo de registro (`registro.jsp` + `RegistroServlet` + `UsuarioDAO`) con contraseñas cifradas mediante BCrypt, inserción transaccional en 3 tablas (`usuario`, `perfil`, `usuario_rol`), y manejo de errores de correo/documento duplicado con mensajes claros (sin exponer excepciones de Java).
- ✅ Módulo de login (`login.jsp` + `LoginServlet`) con verificación de contraseña vía `BCrypt.checkpw()`, creación de `HttpSession`, y redirección automática al dashboard correspondiente según el rol del usuario.
- ✅ `AutenticacionFilter` que protege todas las rutas privadas: bloquea usuarios sin sesión y usuarios con sesión pero sin el rol requerido, redirigiendo a `acceso-denegado.jsp`.
- ✅ Repositorio Git público en GitHub, con historial de commits descriptivos.

### Demostración funcional realizada
1. Registro de un usuario nuevo desde `registro.jsp`, verificando en la base de datos que la contraseña se guardó como hash BCrypt (no en texto plano) y que se asignó automáticamente el rol "Cliente".
2. Inicio de sesión con ese usuario, confirmando la redirección automática a `dashboard-cliente.jsp`.
3. Intento de acceso directo (escribiendo la URL) a `dashboard-cliente.jsp` sin sesión activa (ventana de incógnito) → redirigido correctamente a `acceso-denegado.jsp`.
4. Intento de acceso a `dashboard-admin.jsp` con una sesión de rol "Cliente" → también bloqueado correctamente por el Filter.

### Elementos pendientes para próximos sprints
- Contenido real de los dashboards (por ahora son páginas mínimas de bienvenida).
- CRUD de propiedades, galería de imágenes y características (Sprint 2).
- Buscador con filtros funcional (por ahora el formulario existe visualmente, sin lógica de búsqueda).
- Gestión de citas, solicitudes, favoritos y reportes (Sprint 3).

---

## 🟨 Sprint Retrospective

### ✅ Qué salió bien
- La separación en capas (DAO, modelo, servlet, filter) ayudó a mantener el código organizado desde el inicio, facilitando agregar el módulo de login reutilizando gran parte de lo construido para el registro.
- El uso de transacciones (`commit`/`rollback`) en el registro evitó dejar datos inconsistentes entre las tablas `usuario`, `perfil` y `usuario_rol`.
- Documentar el diccionario de datos justo después del DDL/DML, mientras el diseño estaba fresco, resultó más fácil que dejarlo para el final.

### ⚠️ Dificultades encontradas y cómo se resolvieron
- **Configuración inicial del entorno:** hubo varios inconvenientes instalando Eclipse (descarga corrupta) y configurando la versión correcta de Tomcat (el proyecto usa Tomcat 10.1, que requiere el namespace `jakarta.*` en vez de `javax.*`, a diferencia de la mayoría de tutoriales disponibles en internet). Se resolvió verificando la versión del runtime en `Window > Preferences > Server > Runtime Environments` y ajustando los imports en consecuencia.
- **Fallo al iniciar Tomcat (`ClassNotFoundException: org.apache.catalina.startup.Bootstrap`):** la configuración de ejecución (`Run Configurations`) había perdido las referencias a los `.jar` de arranque de Tomcat. Se resolvió usando el botón "Restore Default Entries" en la pestaña Classpath de la configuración del servidor.
- **Librerías externas no publicadas al servidor:** agregar `.jar` (MySQL Connector, jBCrypt, JSTL) al Build Path no era suficiente para que Tomcat los reconociera en tiempo de ejecución; fue necesario añadirlos también en `Deployment Assembly` para que se copiaran automáticamente a `WEB-INF/lib` en cada publicación.
- **Exposición accidental de credenciales:** en un primer commit, el archivo `db.properties` (con la contraseña real de la base de datos) se subió al repositorio público por una ruta de `.gitignore` mal configurada. Se corrigió eliminando el archivo del historial reciente, ajustando la regla del `.gitignore` a `**/db.properties`, y cambiando la contraseña de la base de datos como medida de precaución adicional.
- **Olvido de reiniciar el servidor tras agregar clases nuevas:** varias veces se agregaron Servlets o Filters nuevos sin detener y volver a publicar el servidor, causando errores 404 que en realidad no eran del código sino de una publicación desactualizada. Se adoptó como práctica estándar: *Stop → Project Clean → Run on Server* cada vez que se agrega una clase Java nueva.

### 🔧 Mejoras para el próximo sprint
- Reiniciar el servidor de forma sistemática después de cada clase Java nueva, antes de asumir que hay un error en el código.
- Verificar el `.gitignore` **antes** de crear archivos con información sensible, no después.
- Escribir las consultas SQL de reportes (Sprint 3) apoyándose en las que ya se probaron en este sprint, para mantener consistencia de estilo.
- Empezar a modularizar el CSS/JS propio (fuera de Bootstrap) en un archivo separado, para no sobrecargar cada JSP con estilos en línea a medida que crezcan los dashboards.
