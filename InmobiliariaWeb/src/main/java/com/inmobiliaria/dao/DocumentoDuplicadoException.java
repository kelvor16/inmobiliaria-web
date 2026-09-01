package com.inmobiliaria.dao;

public class DocumentoDuplicadoException extends Exception {
	private static final long serialVersionUID = 1L;
	public DocumentoDuplicadoException(String mensaje) {
        super(mensaje);
    }
}