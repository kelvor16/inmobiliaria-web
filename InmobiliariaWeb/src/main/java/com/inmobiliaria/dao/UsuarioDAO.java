package com.inmobiliaria.dao;

import com.inmobiliaria.util.ConexionBD;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class UsuarioDAO {

    // ID del rol "Cliente" según tu tabla rol (revisa que coincida con tu INSERT INTO rol)
    private static final int ROL_CLIENTE = 2;

    public void registrarUsuario(String correo, String passwordPlano, String nombres,
                                   String apellidos, String documento, String telefono,
                                   String direccion) throws SQLException, CorreoDuplicadoException, DocumentoDuplicadoException {

        String passwordHash = BCrypt.hashpw(passwordPlano, BCrypt.gensalt());

        Connection con = null;

        try {
            con = ConexionBD.obtenerConexion();
            con.setAutoCommit(false); // Iniciamos la transacción manual

            // 1. Insertar en 'usuario'
            int idUsuarioGenerado;
            String sqlUsuario = "INSERT INTO usuario (correo, contrasena_hash) VALUES (?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlUsuario, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, correo);
                ps.setString(2, passwordHash);
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    rs.next();
                    idUsuarioGenerado = rs.getInt(1);
                }
            }

            // 2. Insertar en 'perfil'
            String sqlPerfil = "INSERT INTO perfil (id_usuario, nombres, apellidos, documento, telefono, direccion) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlPerfil)) {
                ps.setInt(1, idUsuarioGenerado);
                ps.setString(2, nombres);
                ps.setString(3, apellidos);
                ps.setString(4, documento);
                ps.setString(5, telefono);
                ps.setString(6, direccion);
                ps.executeUpdate();
            }

            // 3. Insertar en 'usuario_rol' (rol Cliente por defecto)
            String sqlRol = "INSERT INTO usuario_rol (id_usuario, id_rol) VALUES (?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlRol)) {
                ps.setInt(1, idUsuarioGenerado);
                ps.setInt(2, ROL_CLIENTE);
                ps.executeUpdate();
            }

            con.commit(); // Todo salió bien, confirmamos los 3 INSERT juntos

        } catch (SQLException e) {
            if (con != null) con.rollback(); // Algo falló, deshacemos todo

            // Detectamos si el error es por un UNIQUE duplicado
            String mensaje = e.getMessage();
            if (mensaje.contains("correo")) {
                throw new CorreoDuplicadoException("El correo ya se encuentra registrado");
            } else if (mensaje.contains("documento")) {
                throw new DocumentoDuplicadoException("El documento ya se encuentra registrado");
            }
            throw e; // Si es otro tipo de error, lo dejamos pasar

        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }
}