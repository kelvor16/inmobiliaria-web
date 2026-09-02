<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.inmobiliaria.dao.PropiedadDAO" %>
<%@ page import="com.inmobiliaria.modelo.Propiedad" %>
<%@ page import="com.inmobiliaria.modelo.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    PropiedadDAO dao = new PropiedadDAO();
    Integer idInmobiliaria = dao.obtenerIdInmobiliariaPorUsuario(usuarioSesion.getIdUsuario());
    List<Propiedad> misPropiedades = (idInmobiliaria != null)
        ? dao.listarPorInmobiliaria(idInmobiliaria)
        : new java.util.ArrayList<>();
    request.setAttribute("propiedades", misPropiedades);
%>
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
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Mis Propiedades</h2>
    <a href="propiedad-form.jsp" class="btn btn-primary">+ Publicar propiedad</a>
  </div>

  <c:choose>
    <c:when test="${empty propiedades}">
      <p class="text-muted">Aún no has publicado ninguna propiedad.</p>
    </c:when>
    <c:otherwise>
      <table class="table table-hover bg-white shadow-sm">
        <thead>
          <tr>
            <th>Título</th>
            <th>Ciudad</th>
            <th>Tipo</th>
            <th>Precio</th>
            <th>Estado</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="prop" items="${propiedades}">
            <tr>
              <td>${prop.titulo}</td>
              <td>${prop.nombreCiudad}</td>
              <td>${prop.nombreTipo}</td>
              <td><fmt:formatNumber value="${prop.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/></td>
              <td>
                <span class="badge ${prop.estado == 'disponible' ? 'bg-success' : prop.estado == 'inactiva' ? 'bg-secondary' : 'bg-warning'}">
                  ${prop.estado}
                </span>
              </td>
              <td>
                <a href="propiedad-form.jsp?id=${prop.idPropiedad}" class="btn btn-sm btn-outline-primary">Editar</a>
                <c:if test="${prop.estado != 'inactiva'}">
                  <a href="PropiedadServlet?accion=baja&id=${prop.idPropiedad}"
                     class="btn btn-sm btn-outline-danger"
                     onclick="return confirm('¿Seguro que deseas dar de baja esta propiedad?');">Dar de baja</a>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</div>
</body>
</html>