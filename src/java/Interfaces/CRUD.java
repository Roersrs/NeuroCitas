package Interfaces;

import modelo.Usuario;

public interface CRUD {
    public int agregarUsuario(Usuario u);
    public int actualizarDatos(Usuario u);
    public int eliminarDatos(String id);
    public Usuario listadoDatos_Id(String id);
}
