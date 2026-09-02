package com.inmobiliaria.servlet;

import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.modelo.Propiedad;
import com.inmobiliaria.modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/PropiedadServlet")
public class PropiedadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuarioSesion = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        // Doble verificación de seguridad (además del Filter): solo Inmobiliaria puede publicar
        if (usuarioSesion == null || !usuarioSesion.tieneRol("Inmobiliaria")) {
            response.sendRedirect("acceso-denegado.jsp");
            return;
        }

        PropiedadDAO dao = new PropiedadDAO();

        try {
            Integer idInmobiliaria = dao.obtenerIdInmobiliariaPorUsuario(usuarioSesion.getIdUsuario());
            if (idInmobiliaria == null) {
                request.setAttribute("error", "No se encontró una inmobiliaria asociada a tu cuenta.");
                request.getRequestDispatcher("dashboard-inmobiliaria.jsp").forward(request, response);
                return;
            }

            // Leer campos comunes
            String idPropiedadParam = request.getParameter("idPropiedad"); // presente solo si es edición
            int idCiudad = Integer.parseInt(request.getParameter("idCiudad"));
            int idTipo = Integer.parseInt(request.getParameter("idTipo"));
            String titulo = request.getParameter("titulo");
            String descripcion = request.getParameter("descripcion");
            String direccion = request.getParameter("direccion");
            BigDecimal precio = new BigDecimal(request.getParameter("precio"));

            String areaParam = request.getParameter("areaM2");
            BigDecimal areaM2 = (areaParam != null && !areaParam.isBlank()) ? new BigDecimal(areaParam) : null;

            // Validación básica en el servidor
            if (titulo == null || titulo.isBlank() || direccion == null || direccion.isBlank()) {
                request.setAttribute("error", "Por favor completa todos los campos obligatorios.");
                request.getRequestDispatcher("propiedad-form.jsp").forward(request, response);
                return;
            }

            Propiedad p = new Propiedad();
            p.setIdInmobiliaria(idInmobiliaria);
            p.setIdCiudad(idCiudad);
            p.setIdTipo(idTipo);
            p.setTitulo(titulo);
            p.setDescripcion(descripcion);
            p.setDireccion(direccion);
            p.setPrecio(precio);
            p.setAreaM2(areaM2);

            // El estado solo se envía en modo edición; en creación, forzamos 'disponible'
            String estadoParam = request.getParameter("estado");
            p.setEstado(estadoParam != null ? estadoParam : "disponible");

            // Leer las características seleccionadas (pueden ser varias, o ninguna)
            String[] caracteristicasSeleccionadas = request.getParameterValues("caracteristicas");
            List<Integer> idsCaracteristicas = new ArrayList<>();
            if (caracteristicasSeleccionadas != null) {
                for (String idStr : caracteristicasSeleccionadas) {
                    idsCaracteristicas.add(Integer.parseInt(idStr));
                }
            }

            int idPropiedadFinal;

            if (idPropiedadParam == null || idPropiedadParam.isBlank()) {
                // MODO CREACIÓN
                String matricula = request.getParameter("matriculaInmobiliaria");
                p.setMatriculaInmobiliaria(matricula);
                idPropiedadFinal = dao.crear(p);
            } else {
                // MODO EDICIÓN
                idPropiedadFinal = Integer.parseInt(idPropiedadParam);
                p.setIdPropiedad(idPropiedadFinal);
                dao.actualizar(p);
            }

            dao.guardarCaracteristicas(idPropiedadFinal, idsCaracteristicas);

            response.sendRedirect("dashboard-inmobiliaria.jsp");

        } catch (SQLException e) {
            String mensaje = e.getMessage();
            if (mensaje != null && mensaje.contains("matricula_inmobiliaria")) {
                request.setAttribute("error", "Esa matrícula inmobiliaria ya está registrada.");
            } else {
                request.setAttribute("error", "Ocurrió un error al guardar la propiedad. Intenta de nuevo.");
            }
            try {
                request.getRequestDispatcher("propiedad-form.jsp").forward(request, response);
            } catch (ServletException ex) {
                throw ex;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Verifica que el precio y el área tengan valores numéricos válidos.");
            request.getRequestDispatcher("propiedad-form.jsp").forward(request, response);
        }
    }

    // Manejar la baja lógica (por GET, desde un enlace/botón "Dar de baja")
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuarioSesion = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuarioSesion == null || !usuarioSesion.tieneRol("Inmobiliaria")) {
            response.sendRedirect("acceso-denegado.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        String idParam = request.getParameter("id");

        if ("baja".equals(accion) && idParam != null) {
            try {
                PropiedadDAO dao = new PropiedadDAO();
                Integer idInmobiliaria = dao.obtenerIdInmobiliariaPorUsuario(usuarioSesion.getIdUsuario());
                dao.darDeBaja(Integer.parseInt(idParam), idInmobiliaria);
            } catch (SQLException e) {
                // Si falla, simplemente no se da de baja; podría loguearse
            }
        }

        response.sendRedirect("dashboard-inmobiliaria.jsp");
    }
}