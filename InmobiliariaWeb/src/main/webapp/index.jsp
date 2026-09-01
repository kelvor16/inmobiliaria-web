<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inmobiliaria - Encuentra tu próximo hogar</title>

    <!-- Bootstrap CSS (desde CDN, no hay que instalar nada) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="#">🏠 Inmobiliaria</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="#">Propiedades</a></li>
        <li class="nav-item"><a class="nav-link" href="registro.jsp">Registrarse</a></li>
        <li class="nav-item"><a class="nav-link btn btn-outline-light ms-2" href="login.jsp">Iniciar sesión</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- Sección Hero con buscador -->
<div class="bg-primary text-white text-center py-5">
  <div class="container">
    <h1 class="display-4 fw-bold">Encuentra el hogar de tus sueños</h1>
    <p class="lead">Miles de propiedades en venta y arriendo esperándote</p>

    <form class="row g-2 justify-content-center mt-4" action="#" method="get">
      <div class="col-md-3">
        <select class="form-select" name="ciudad">
          <option value="">Todas las ciudades</option>
          <option value="1">Bucaramanga</option>
          <option value="2">San Gil</option>
          <option value="6">Bogotá</option>
        </select>
      </div>
      <div class="col-md-3">
        <select class="form-select" name="tipo">
          <option value="">Todos los tipos</option>
          <option value="1">Casa</option>
          <option value="2">Apartamento</option>
          <option value="3">Local Comercial</option>
        </select>
      </div>
      <div class="col-md-3">
        <input type="number" class="form-control" name="precioMax" placeholder="Precio máximo">
      </div>
      <div class="col-md-2">
        <button type="submit" class="btn btn-warning w-100 fw-bold">Buscar</button>
      </div>
    </form>
  </div>
</div>

<!-- Sección Propiedades Destacadas -->
<div class="container py-5">
  <h2 class="text-center mb-4">Propiedades Destacadas</h2>
  <div class="row g-4">

    <div class="col-md-4">
      <div class="card h-100 shadow-sm">
        <div class="card-img-top bg-secondary" style="height: 200px;"></div>
        <div class="card-body">
          <h5 class="card-title">Apartamento moderno centro</h5>
          <p class="card-text text-muted">Bucaramanga · Apartamento</p>
          <p class="card-text fw-bold fs-5">$280.000.000</p>
          <a href="#" class="btn btn-outline-primary w-100">Ver detalle</a>
        </div>
      </div>
    </div>

    <div class="col-md-4">
      <div class="card h-100 shadow-sm">
        <div class="card-img-top bg-secondary" style="height: 200px;"></div>
        <div class="card-body">
          <h5 class="card-title">Casa campestre con jardín</h5>
          <p class="card-text text-muted">Bucaramanga · Casa</p>
          <p class="card-text fw-bold fs-5">$450.000.000</p>
          <a href="#" class="btn btn-outline-primary w-100">Ver detalle</a>
        </div>
      </div>
    </div>

    <div class="col-md-4">
      <div class="card h-100 shadow-sm">
        <div class="card-img-top bg-secondary" style="height: 200px;"></div>
        <div class="card-body">
          <h5 class="card-title">Local comercial esquinero</h5>
          <p class="card-text text-muted">Floridablanca · Local Comercial</p>
          <p class="card-text fw-bold fs-5">$320.000.000</p>
          <a href="#" class="btn btn-outline-primary w-100">Ver detalle</a>
        </div>
      </div>
    </div>

  </div>
</div>


<!-- Footer -->
<footer class="bg-dark text-white text-center py-4 mt-5">
  <div class="container">
    <p class="mb-1">🏠 Inmobiliaria — Encuentra tu próximo hogar</p>
    <p class="mb-0 text-muted small">© 2026 Proyecto académico UTS — Tecnología en Desarrollo de Sistemas Informáticos</p>
  </div>
</footer>

    <!-- Bootstrap JS (necesario para menús desplegables, etc.) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
