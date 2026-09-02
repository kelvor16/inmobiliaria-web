<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.inmobiliaria.dao.PropiedadDAO" %>
<%@ page import="com.inmobiliaria.modelo.Propiedad" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    int idPropiedad = 0;
    Propiedad propiedad = null;
    List<String> imagenes = null;
    List<String> caracteristicas = null;

    try {
        idPropiedad = Integer.parseInt(request.getParameter("id"));
        PropiedadDAO dao = new PropiedadDAO();
        propiedad = dao.obtenerPorId(idPropiedad);
        if (propiedad != null) {
            imagenes = dao.listarImagenes(idPropiedad);
            caracteristicas = dao.listarCaracteristicas(idPropiedad);
        }
    } catch (Exception e) {
        propiedad = null;
    }

    request.setAttribute("propiedad", propiedad);
    request.setAttribute("imagenes", imagenes);
    request.setAttribute("caracteristicas", caracteristicas);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${propiedad.titulo} - Inmobiliaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<nav class="navbar navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">🏠 Inmobiliaria</a>
  </div>
</nav>

<div class="container py-5">

  <c:choose>
    <c:when test="${empty propiedad}">
      <div class="text-center">
        <h3>Propiedad no encontrada</h3>
        <a href="index.jsp" class="btn btn-primary mt-3">Volver al inicio</a>
      </div>
    </c:when>

    <c:otherwise>
      <div class="row">
        <div class="col-md-7">
          <c:choose>
            <c:when test="${not empty imagenes}">
              <div id="carruselPropiedad" class="carousel slide mb-3" data-bs-ride="carousel">
                <div class="carousel-inner rounded shadow-sm">
                  <c:forEach var="img" items="${imagenes}" varStatus="loop">
                    <div class="carousel-item ${loop.first ? 'active' : ''}">
                      <img src="${img}" class="d-block w-100" style="height: 400px; object-fit: cover;">
                    </div>
                  </c:forEach>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#carruselPropiedad" data-bs-slide="prev">
                  <span class="carousel-control-prev-icon"></span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#carruselPropiedad" data-bs-slide="next">
                  <span class="carousel-control-next-icon"></span>
                </button>
              </div>
            </c:when>
            <c:otherwise>
              <div class="bg-secondary rounded mb-3" style="height: 400px;"></div>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="col-md-5">
          <span class="badge bg-primary mb-2">${propiedad.nombreTipo}</span>
          <h2>${propiedad.titulo}</h2>
          <p class="text-muted">${propiedad.nombreCiudad} — ${propiedad.direccion}</p>
          <h3 class="text-success fw-bold">
            <fmt:formatNumber value="${propiedad.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
          </h3>
          <p><strong>Área:</strong> ${propiedad.areaM2} m²</p>
          <p><strong>Matrícula:</strong> ${propiedad.matriculaInmobiliaria}</p>
          <p><strong>Publicado por:</strong> ${propiedad.nombreAgencia}</p>

          <button class="btn btn-primary w-100 mt-3">Agendar visita</button>
          <button class="btn btn-outline-secondary w-100 mt-2">Marcar como favorito</button>
        </div>
      </div>

      <div class="mt-4">
        <h4>Descripción</h4>
        <p>${propiedad.descripcion}</p>
      </div>

      <c:if test="${not empty caracteristicas}">
        <div class="mt-4">
          <h4>Características</h4>
          <div class="d-flex flex-wrap gap-2">
            <c:forEach var="carac" items="${caracteristicas}">
              <span class="badge bg-light text-dark border">✔ ${carac}</span>
            </c:forEach>
          </div>
        </div>
      </c:if>

    </c:otherwise>
  </c:choose>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>