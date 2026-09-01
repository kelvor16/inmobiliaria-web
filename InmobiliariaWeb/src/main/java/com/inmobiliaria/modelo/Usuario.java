package com.inmobiliaria.modelo;

import java.util.List;

public class Usuario {

    private int idUsuario;
    private String correo;
    private String nombres;
    private String apellidos;
    private List<String> roles;

    // Getters y setters (así se leen y escriben los datos desde afuera)

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public List<String> getRoles() {
        return roles;
    }

    public void setRoles(List<String> roles) {
        this.roles = roles;
    }

    // Método de ayuda: revisa si el usuario tiene un rol específico
    public boolean tieneRol(String nombreRol) {
        return roles != null && roles.contains(nombreRol);
    }
}