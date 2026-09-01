<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso denegado</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5 text-center">
    <h1 class="display-1 text-danger">🚫</h1>
    <h2>Acceso denegado</h2>
    <p class="lead">No tienes permiso para ver esta página, o tu sesión ha expirado.</p>
    <a href="login.jsp" class="btn btn-primary">Iniciar sesión</a>
    <a href="index.jsp" class="btn btn-outline-secondary">Volver al inicio</a>
</div>
</body>
</html>