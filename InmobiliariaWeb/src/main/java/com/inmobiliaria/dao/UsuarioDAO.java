package com.inmobiliaria.dao;

import com.inmobiliaria.modelo.Usuario;
import com.inmobiliaria.util.ConexionBD;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    private static final int ROL_CLIENTE = 2;

    public void registrarUsuario(String correo, String passwordPlano, String nombres,
                                   String apellidos, String documento, String telefono,
                                   String direccion) throws SQLException, CorreoDuplicadoException, DocumentoDuplicadoException {

        String passwordHash = BCrypt.hashpw(passwordPlano, BCrypt.gensalt());

        Connection con = null;

        try {
            con = ConexionBD.obtenerConexion();
            con.setAutoCommit(false);

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

            String sqlRol = "INSERT INTO usuario_rol (id_usuario, id_rol) VALUES (?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlRol)) {
                ps.setInt(1, idUsuarioGenerado);
                ps.setInt(2, ROL_CLIENTE);
                ps.executeUpdate();
            }

            con.commit();

        } catch (SQLException e) {
            if (con != null) con.rollback();

            String mensaje = e.getMessage();
            if (mensaje.contains("correo")) {
                throw new CorreoDuplicadoException("El correo ya se encuentra registrado");
            } else if (mensaje.contains("documento")) {
                throw new DocumentoDuplicadoException("El documento ya se encuentra registrado");
            }
            throw e;

        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

    public Usuario autenticar(String correo, String passwordPlano) throws SQLException {
        String sql = "SELECT u.id_usuario, u.contrasena_hash, u.estado, p.nombres, p.apellidos "
                   + "FROM usuario u "
                   + "INNER JOIN perfil p ON u.id_usuario = p.id_usuario "
                   + "WHERE u.correo = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correo);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                String hashGuardado = rs.getString("contrasena_hash");

                if (!BCrypt.checkpw(passwordPlano, hashGuardado)) {
                    return null;
                }

                if ("inactivo".equals(rs.getString("estado"))) {
                    throw new SQLException("CUENTA_INACTIVA");
                }

                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setCorreo(correo);
                usuario.setNombres(rs.getString("nombres"));
                usuario.setApellidos(rs.getString("apellidos"));
                usuario.setRoles(obtenerRoles(rs.getInt("id_usuario"), con));

                return usuario;
            }
        }
    }

    private List<String> obtenerRoles(int idUsuario, Connection con) throws SQLException {
        List<String> roles = new ArrayList<>();
        String sql = "SELECT r.nombre_rol FROM rol r "
                   + "INNER JOIN usuario_rol ur ON r.id_rol = ur.id_rol "
                   + "WHERE ur.id_usuario = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roles.add(rs.getString("nombre_rol"));
                }
            }
        }
        return roles;
    }
}