package com.inmobiliaria.filter;

import com.inmobiliaria.modelo.Usuario;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AutenticacionFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String ruta = uri.substring(contextPath.length()); // ej: "/dashboard-admin.jsp"

        // 1. Rutas públicas: dejamos pasar sin revisar nada
        if (esRutaPublica(ruta)) {
            chain.doFilter(req, res);
            return;
            
        }

        // 2. Revisamos si hay sesión activa
        HttpSession session = request.getSession(false); // false = no crear una nueva
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            // No hay sesión: bloqueado
            response.sendRedirect(contextPath + "/acceso-denegado.jsp");
            return;
        }

        // 3. Revisamos el rol requerido según la ruta
        if (ruta.equals("/dashboard-admin.jsp") && !usuario.tieneRol("Administrador")) {
            response.sendRedirect(contextPath + "/acceso-denegado.jsp");
            return;
        }

        if (ruta.equals("/dashboard-inmobiliaria.jsp") && !usuario.tieneRol("Inmobiliaria")) {
            response.sendRedirect(contextPath + "/acceso-denegado.jsp");
            return;
        }

        // Todo bien: dejamos continuar la petición
        chain.doFilter(req, res);
    }

    private boolean esRutaPublica(String ruta) {
        return ruta.equals("/index.jsp")
            || ruta.equals("/")
            || ruta.equals("/login.jsp")
            || ruta.equals("/registro.jsp")
            || ruta.equals("/LoginServlet")
            || ruta.equals("/RegistroServlet")
            || ruta.equals("/acceso-denegado.jsp")
            || ruta.equals("/detalle-propiedad.jsp")
            || ruta.startsWith("/META-INF")
            || ruta.startsWith("/WEB-INF");
    }
}
