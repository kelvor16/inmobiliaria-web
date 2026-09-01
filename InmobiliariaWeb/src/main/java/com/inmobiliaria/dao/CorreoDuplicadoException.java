package com.inmobiliaria.dao;

public class CorreoDuplicadoException extends Exception {
	private static final long serialVersionUID = 1L;
	public CorreoDuplicadoException(String mensaje) {
        super(mensaje);
    }
}