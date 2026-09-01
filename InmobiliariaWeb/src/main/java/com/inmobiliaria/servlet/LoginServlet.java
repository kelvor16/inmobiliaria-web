package com.inmobiliaria.servlet;

import com.inmobiliaria.dao.UsuarioDAO;
import com.inmobiliaria.modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        UsuarioDAO dao = new UsuarioDAO();

        try {
            Usuario usuario = dao.autenticar(correo, password);

            if (usuario == null) {
                request.setAttribute("error", "Correo o contraseña incorrectos.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Login exitoso: creamos la sesión
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            session.setAttribute("idUsuario", usuario.getIdUsuario());
            session.setAttribute("roles", usuario.getRoles());

            // Redirigimos según el rol principal
            if (usuario.tieneRol("Administrador")) {
                response.sendRedirect("dashboard-admin.jsp");
            } else if (usuario.tieneRol("Inmobiliaria")) {
                response.sendRedirect("dashboard-inmobiliaria.jsp");
            } else {
                response.sendRedirect("dashboard-cliente.jsp");
            }

        } catch (SQLException e) {
            if ("CUENTA_INACTIVA".equals(e.getMessage())) {
                request.setAttribute("error", "Tu cuenta está inactiva. Contacta al administrador.");
            } else {
                request.setAttribute("error", "Ocurrió un error al iniciar sesión. Intenta de nuevo.");
            }
            try {
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } catch (ServletException ex) {
                throw ex;
            }
        }
    }
}