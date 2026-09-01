<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Inmobiliaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">🏠 Inmobiliaria</a>
  </div>
</nav>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="card shadow-sm">
        <div class="card-body p-4">
          <h3 class="text-center mb-4">Crear cuenta</h3>

          <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
          </c:if>

          <form action="RegistroServlet" method="post">

            <div class="mb-3">
              <label class="form-label">Correo electrónico</label>
              <input type="email" class="form-control" name="correo" required>
            </div>

            <div class="mb-3">
              <label class="form-label">Contraseña</label>
              <input type="password" class="form-control" name="password" required minlength="6">
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label">Nombres</label>
                <input type="text" class="form-control" name="nombres" required>
              </div>
              <div class="col-md-6 mb-3">
                <label class="form-label">Apellidos</label>
                <input type="text" class="form-control" name="apellidos" required>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label">Documento</label>
              <input type="text" class="form-control" name="documento" required>
            </div>

            <div class="mb-3">
              <label class="form-label">Teléfono</label>
              <input type="text" class="form-control" name="telefono">
            </div>

            <div class="mb-3">
              <label class="form-label">Dirección</label>
              <input type="text" class="form-control" name="direccion">
            </div>

            <button type="submit" class="btn btn-primary w-100">Registrarme</button>
          </form>

          <p class="text-center mt-3 mb-0">
            ¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión</a>
          </p>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>