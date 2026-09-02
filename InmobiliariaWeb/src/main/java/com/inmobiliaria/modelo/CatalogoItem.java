package com.inmobiliaria.modelo;

public class CatalogoItem {

    private int id;
    private String nombre;

    public CatalogoItem(int id, String nombre) {
        this.id = id;
        this.nombre = nombre;
    }

    public int getId() { return id; }
    public String getNombre() { return nombre; }
}