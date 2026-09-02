package com.inmobiliaria.dao;

import com.inmobiliaria.modelo.Propiedad;
import com.inmobiliaria.util.ConexionBD;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PropiedadDAO {

    // Consulta base reutilizada por varios métodos (trae info legible con JOIN)
    private static final String SELECT_BASE =
        "SELECT p.id_propiedad, p.id_inmobiliaria, p.id_ciudad, p.id_tipo, "
      + "p.matricula_inmobiliaria, p.titulo, p.descripcion, p.direccion, "
      + "p.precio, p.area_m2, p.estado, "
      + "c.nombre_ciudad, t.nombre_tipo, i.nombre_agencia, "
      + "(SELECT ip.url_imagen FROM imagen_propiedad ip "
      + "   WHERE ip.id_propiedad = p.id_propiedad "
      + "   ORDER BY ip.es_principal DESC, ip.orden ASC LIMIT 1) AS imagen_principal "
      + "FROM propiedad p "
      + "INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad "
      + "INNER JOIN tipo_propiedad t ON p.id_tipo = t.id_tipo "
      + "INNER JOIN inmobiliaria i ON p.id_inmobiliaria = i.id_inmobiliaria ";

    public List<Propiedad> listarDestacadas(int limite) throws SQLException {
        String sql = SELECT_BASE + "WHERE p.estado = 'disponible' "
                   + "ORDER BY p.fecha_publicacion DESC LIMIT ?";

        List<Propiedad> lista = new ArrayList<>();
        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearPropiedad(rs));
                }
            }
        }
        return lista;
    }

    public List<Propiedad> listarPorInmobiliaria(int idInmobiliaria) throws SQLException {
        String sql = SELECT_BASE + "WHERE p.id_inmobiliaria = ? ORDER BY p.fecha_publicacion DESC";

        List<Propiedad> lista = new ArrayList<>();
        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idInmobiliaria);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearPropiedad(rs));
                }
            }
        }
        return lista;
    }

    public Propiedad obtenerPorId(int idPropiedad) throws SQLException {
        String sql = SELECT_BASE + "WHERE p.id_propiedad = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idPropiedad);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearPropiedad(rs);
                }
            }
        }
        return null;
    }

    public List<String> listarImagenes(int idPropiedad) throws SQLException {
        String sql = "SELECT url_imagen FROM imagen_propiedad "
                   + "WHERE id_propiedad = ? ORDER BY es_principal DESC, orden ASC";

        List<String> imagenes = new ArrayList<>();
        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idPropiedad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    imagenes.add(rs.getString("url_imagen"));
                }
            }
        }
        return imagenes;
    }

    public List<String> listarCaracteristicas(int idPropiedad) throws SQLException {
        String sql = "SELECT c.nombre_caracteristica, pc.cantidad "
                   + "FROM caracteristica c "
                   + "INNER JOIN propiedad_caracteristica pc ON c.id_caracteristica = pc.id_caracteristica "
                   + "WHERE pc.id_propiedad = ?";

        List<String> caracteristicas = new ArrayList<>();
        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idPropiedad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int cantidad = rs.getInt("cantidad");
                    String nombre = rs.getString("nombre_caracteristica");
                    caracteristicas.add(cantidad > 1 ? nombre + " (x" + cantidad + ")" : nombre);
                }
            }
        }
        return caracteristicas;
    }

    // NUEVO: Devuelve solo los IDs de las características asignadas a una propiedad (para marcar checkboxes)
    public List<Integer> listarIdsCaracteristicas(int idPropiedad) throws SQLException {
        String sql = "SELECT id_caracteristica FROM propiedad_caracteristica WHERE id_propiedad = ?";

        List<Integer> ids = new ArrayList<>();
        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idPropiedad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("id_caracteristica"));
                }
            }
        }
        return ids;
    }

    // NUEVO: Reemplaza TODAS las características de una propiedad por las nuevas seleccionadas
    public void guardarCaracteristicas(int idPropiedad, List<Integer> idsCaracteristicas) throws SQLException {
        Connection con = null;
        try {
            con = ConexionBD.obtenerConexion();
            con.setAutoCommit(false);

            String sqlBorrar = "DELETE FROM propiedad_caracteristica WHERE id_propiedad = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlBorrar)) {
                ps.setInt(1, idPropiedad);
                ps.executeUpdate();
            }

            String sqlInsertar = "INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES (?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlInsertar)) {
                for (Integer idCaracteristica : idsCaracteristicas) {
                    ps.setInt(1, idPropiedad);
                    ps.setInt(2, idCaracteristica);
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            con.commit();
        } catch (SQLException e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

    public int crear(Propiedad p) throws SQLException {
        String sql = "INSERT INTO propiedad (id_inmobiliaria, id_ciudad, id_tipo, matricula_inmobiliaria, "
                   + "titulo, descripcion, direccion, precio, area_m2, estado) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'disponible')";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, p.getIdInmobiliaria());
            ps.setInt(2, p.getIdCiudad());
            ps.setInt(3, p.getIdTipo());
            ps.setString(4, p.getMatriculaInmobiliaria());
            ps.setString(5, p.getTitulo());
            ps.setString(6, p.getDescripcion());
            ps.setString(7, p.getDireccion());
            ps.setBigDecimal(8, p.getPrecio());
            ps.setBigDecimal(9, p.getAreaM2());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    public void actualizar(Propiedad p) throws SQLException {
        String sql = "UPDATE propiedad SET id_ciudad = ?, id_tipo = ?, titulo = ?, descripcion = ?, "
                   + "direccion = ?, precio = ?, area_m2 = ?, estado = ? WHERE id_propiedad = ? AND id_inmobiliaria = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, p.getIdCiudad());
            ps.setInt(2, p.getIdTipo());
            ps.setString(3, p.getTitulo());
            ps.setString(4, p.getDescripcion());
            ps.setString(5, p.getDireccion());
            ps.setBigDecimal(6, p.getPrecio());
            ps.setBigDecimal(7, p.getAreaM2());
            ps.setString(8, p.getEstado());
            ps.setInt(9, p.getIdPropiedad());
            ps.setInt(10, p.getIdInmobiliaria());
            ps.executeUpdate();
        }
    }

    public void darDeBaja(int idPropiedad, int idInmobiliaria) throws SQLException {
        String sql = "UPDATE propiedad SET estado = 'inactiva' WHERE id_propiedad = ? AND id_inmobiliaria = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idPropiedad);
            ps.setInt(2, idInmobiliaria);
            ps.executeUpdate();
        }
    }

    public Integer obtenerIdInmobiliariaPorUsuario(int idUsuario) throws SQLException {
        String sql = "SELECT id_inmobiliaria FROM inmobiliaria WHERE id_usuario = ?";

        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_inmobiliaria");
                }
            }
        }
        return null;
    }

    private Propiedad mapearPropiedad(ResultSet rs) throws SQLException {
        Propiedad p = new Propiedad();
        p.setIdPropiedad(rs.getInt("id_propiedad"));
        p.setIdInmobiliaria(rs.getInt("id_inmobiliaria"));
        p.setIdCiudad(rs.getInt("id_ciudad"));
        p.setIdTipo(rs.getInt("id_tipo"));
        p.setMatriculaInmobiliaria(rs.getString("matricula_inmobiliaria"));
        p.setTitulo(rs.getString("titulo"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setDireccion(rs.getString("direccion"));
        p.setPrecio(rs.getBigDecimal("precio"));
        p.setAreaM2(rs.getBigDecimal("area_m2"));
        p.setEstado(rs.getString("estado"));
        p.setNombreCiudad(rs.getString("nombre_ciudad"));
        p.setNombreTipo(rs.getString("nombre_tipo"));
        p.setNombreAgencia(rs.getString("nombre_agencia"));
        p.setImagenPrincipal(rs.getString("imagen_principal"));
        return p;
    }
}