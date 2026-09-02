<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.inmobiliaria.dao.CatalogoDAO" %>
<%@ page import="com.inmobiliaria.dao.PropiedadDAO" %>
<%@ page import="com.inmobiliaria.modelo.CatalogoItem" %>
<%@ page import="com.inmobiliaria.modelo.Propiedad" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    PropiedadDAO propDao = new PropiedadDAO();
    CatalogoDAO catDao = new CatalogoDAO();

    List<CatalogoItem> ciudades = catDao.listarCiudades();
    List<CatalogoItem> tipos = catDao.listarTipos();
    List<CatalogoItem> caracteristicas = catDao.listarCaracteristicas();

    Propiedad propiedad = null;
    List<Integer> idsCaracteristicasActuales = new java.util.ArrayList<>();
    String idParam = request.getParameter("id");
    if (idParam != null) {
        propiedad = propDao.obtenerPorId(Integer.parseInt(idParam));
        idsCaracteristicasActuales = propDao.listarIdsCaracteristicas(Integer.parseInt(idParam));
    }

    request.setAttribute("ciudades", ciudades);
    request.setAttribute("tipos", tipos);
    request.setAttribute("caracteristicas", caracteristicas);
    request.setAttribute("idsCaracteristicasActuales", idsCaracteristicasActuales);
    request.setAttribute("propiedad", propiedad);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty propiedad ? 'Publicar propiedad' : 'Editar propiedad'} - Inmobiliaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="dashboard-inmobiliaria.jsp">🏠 Inmobiliaria</a>
  </div>
</nav>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card shadow-sm">
        <div class="card-body p-4">
          <h3 class="mb-4">${empty propiedad ? 'Publicar nueva propiedad' : 'Editar propiedad'}</h3>

          <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
          </c:if>

          <form action="PropiedadServlet" method="post">

            <c:if test="${not empty propiedad}">
              <input type="hidden" name="idPropiedad" value="${propiedad.idPropiedad}">
            </c:if>

            <div class="mb-3">
              <label class="form-label">Título</label>
              <input type="text" class="form-control" name="titulo" value="${propiedad.titulo}" required>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label">Ciudad</label>
                <select class="form-select" name="idCiudad" required>
                  <option value="">Selecciona...</option>
                  <c:forEach var="ciudad" items="${ciudades}">
                    <option value="${ciudad.id}" ${propiedad.idCiudad == ciudad.id ? 'selected' : ''}>${ciudad.nombre}</option>
                  </c:forEach>
                </select>
              </div>
              <div class="col-md-6 mb-3">
                <label class="form-label">Tipo de propiedad</label>
                <select class="form-select" name="idTipo" required>
                  <option value="">Selecciona...</option>
                  <c:forEach var="tipo" items="${tipos}">
                    <option value="${tipo.id}" ${propiedad.idTipo == tipo.id ? 'selected' : ''}>${tipo.nombre}</option>
                  </c:forEach>
                </select>
              </div>
            </div>

            <c:if test="${not empty propiedad}">
              <div class="mb-3">
                <label class="form-label">Estado</label>
                <select class="form-select" name="estado">
                  <option value="disponible" ${propiedad.estado == 'disponible' ? 'selected' : ''}>Disponible</option>
                  <option value="reservada" ${propiedad.estado == 'reservada' ? 'selected' : ''}>Reservada</option>
                  <option value="vendida" ${propiedad.estado == 'vendida' ? 'selected' : ''}>Vendida</option>
                  <option value="arrendada" ${propiedad.estado == 'arrendada' ? 'selected' : ''}>Arrendada</option>
                  <option value="inactiva" ${propiedad.estado == 'inactiva' ? 'selected' : ''}>Inactiva (dada de baja)</option>
                </select>
              </div>
            </c:if>

            <c:if test="${empty propiedad}">
              <div class="mb-3">
                <label class="form-label">Matrícula inmobiliaria</label>
                <input type="text" class="form-control" name="matriculaInmobiliaria" required>
              </div>
            </c:if>

            <div class="mb-3">
              <label class="form-label">Dirección</label>
              <input type="text" class="form-control" name="direccion" value="${propiedad.direccion}" required>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label">Precio</label>
                <input type="number" class="form-control" name="precio" value="${propiedad.precio}" required min="0">
              </div>
              <div class="col-md-6 mb-3">
                <label class="form-label">Área (m²)</label>
                <input type="number" step="0.01" class="form-control" name="areaM2" value="${propiedad.areaM2}">
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label">Descripción</label>
              <textarea class="form-control" name="descripcion" rows="4">${propiedad.descripcion}</textarea>
            </div>

            <div class="mb-3">
              <label class="form-label">Características</label>
              <div class="row">
                <c:forEach var="carac" items="${caracteristicas}">
                  <div class="col-md-6">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" name="caracteristicas"
                             value="${carac.id}" id="carac${carac.id}"
                             ${idsCaracteristicasActuales.contains(carac.id) ? 'checked' : ''}>
                      <label class="form-check-label" for="carac${carac.id}">${carac.nombre}</label>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </div>

            <button type="submit" class="btn btn-primary w-100">
              ${empty propiedad ? 'Publicar propiedad' : 'Guardar cambios'}
            </button>
          </form>

        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>