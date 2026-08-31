 package com.inmobiliaria.util; 
 
 import java.sql.Connection; 
 
 public class PruebaConexion { public static void main(String[] args) 
	 
 { try (Connection con = ConexionBD.obtenerConexion())
	 
	 { if (con != null) { System.out.println("✅ Conexión exitosa a la base de datos inmobiliaria_db"); } }
 
 catch (Exception e) { System.out.println("❌ Error al conectar: " + e.getMessage()); } } }
 
 
 