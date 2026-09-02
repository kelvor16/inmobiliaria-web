package com.inmobiliaria.dao;

import com.inmobiliaria.modelo.CatalogoItem;
import com.inmobiliaria.util.ConexionBD;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CatalogoDAO {

    public List<CatalogoItem> listarCiudades() throws SQLException {
        return listarGenerico("SELECT id_ciudad AS id, nombre_ciudad AS nombre FROM ciudad ORDER BY nombre_ciudad");
    }

    public List<CatalogoItem> listarTipos() throws SQLException {
        return listarGenerico("SELECT id_tipo AS id, nombre_tipo AS nombre FROM tipo_propiedad ORDER BY nombre_tipo");
    }

    public List<CatalogoItem> listarCaracteristicas() throws SQLException {
        return listarGenerico("SELECT id_caracteristica AS id, nombre_caracteristica AS nombre FROM caracteristica ORDER BY nombre_caracteristica");
    }

    // Método reutilizable: cualquier consulta que devuelva (id, nombre) puede usar este método
    private List<CatalogoItem> listarGenerico(String sql) throws SQLException {
        List<CatalogoItem> lista = new ArrayList<>();
        try (Connection con = ConexionBD.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(new CatalogoItem(rs.getInt("id"), rs.getString("nombre")));
            }
        }
        return lista;
    }
}