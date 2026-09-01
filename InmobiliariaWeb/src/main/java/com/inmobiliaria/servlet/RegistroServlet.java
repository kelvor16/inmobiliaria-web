package com.inmobiliaria.servlet;

import com.inmobiliaria.dao.CorreoDuplicadoException;
import com.inmobiliaria.dao.DocumentoDuplicadoException;
import com.inmobiliaria.dao.UsuarioDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Leer los datos que llegaron del formulario
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String documento = request.getParameter("documento");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");

        // 2. Validación básica en el SERVIDOR (no confiamos solo en el navegador)
        if (correo == null || correo.isBlank() ||
            password == null || password.length() < 6 ||
            nombres == null || nombres.isBlank() ||
            apellidos == null || apellidos.isBlank() ||
            documento == null || documento.isBlank()) {

            request.setAttribute("error", "Por favor completa todos los campos obligatorios (contraseña mínimo 6 caracteres).");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }

        // 3. Intentar registrar usando el DAO
        UsuarioDAO dao = new UsuarioDAO();
        try {
            dao.registrarUsuario(correo, password, nombres, apellidos, documento, telefono, direccion);

            // Éxito: redirige a login con un mensaje
            response.sendRedirect("login.jsp?registrado=true");

        } catch (CorreoDuplicadoException | DocumentoDuplicadoException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("registro.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("error", "Ocurrió un error al registrar. Intenta de nuevo.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
}