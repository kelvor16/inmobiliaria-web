package com.inmobiliaria.dao;

import com.inmobiliaria.modelo.Propiedad;
import com.inmobiliaria.util.ConexionBD;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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

    // Trae propiedades destacadas para la landing page (las más recientes, disponibles)
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

    // Trae TODAS las propiedades de una inmobiliaria específica (para su panel)
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

    // Trae UNA propiedad específica por su ID (para la ficha de detalle)
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

 // Trae TODAS las imágenes de una propiedad (para la galería completa)
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

    // Trae las características de una propiedad (resuelve la relación N:M)
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
    
    
    // Convierte una fila del ResultSet en un objeto Propiedad (evita repetir código)
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