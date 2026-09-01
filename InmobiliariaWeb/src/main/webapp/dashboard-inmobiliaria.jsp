<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Inmobiliaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">🏠 Inmobiliaria</a>
    <span class="text-white">Bienvenido, ${sessionScope.usuario.nombres}</span>
  </div>
</nav>
<div class="container py-5">
  <h2>Panel de Inmobiliaria</h2>
  <p>Aquí irá: gestión de propiedades, citas recibidas, solicitudes por aprobar.</p>
</div>
</body>
</html>

