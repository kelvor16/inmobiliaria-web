package com.inmobiliaria.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConexionBD {

    private static Properties propiedades = new Properties();

    // Este bloque "static" se ejecuta UNA SOLA VEZ, cuando la clase se carga por primera vez
    static {
        try (InputStream input = ConexionBD.class.getClassLoader()
                .getResourceAsStream("db.properties")) {

            if (input == null) {
                throw new RuntimeException("No se encontró el archivo db.properties");
            }
            propiedades.load(input);

            // Registra el driver de MySQL una sola vez
            Class.forName(propiedades.getProperty("db.driver"));

        } catch (IOException | ClassNotFoundException e) {
            throw new RuntimeException("Error al cargar la configuración de la base de datos", e);
        }
    }

    // Este método es el que va a usar el resto de tu aplicación
    public static Connection obtenerConexion() throws SQLException {
        String url = propiedades.getProperty("db.url");
        String usuario = propiedades.getProperty("db.usuario");
        String password = propiedades.getProperty("db.password");

        return DriverManager.getConnection(url, usuario, password);
    }
}