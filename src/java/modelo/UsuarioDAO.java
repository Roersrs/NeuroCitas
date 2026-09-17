package modelo;

import Interfaces.CRUD;
import config.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO implements CRUD {

    @Override
    public int agregarUsuario(Usuario u) {
        String q = "INSERT INTO Usuario "
                + "(identificacion, nombre, apellido, email, telefono, especialidad, usuario, clave, id_perfil, id_estado) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, u.getIdentificacion());
            ps.setString(2, u.getNombre());
            ps.setString(3, u.getApellido());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getTelefono());
            ps.setString(6, u.getEspecialidad());
            ps.setString(7, u.getUsuario());
            ps.setString(8, u.getClave());
            ps.setInt(9, u.getIdperfil());

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL REGISTRAR USUARIO: " + ex.getMessage());
            return 0;
        }
    }

    public int agregarSolicitudDoctor(Usuario u) {
        String q = "INSERT INTO Usuario "
                + "(identificacion, nombre, apellido, email, telefono, especialidad, usuario, clave, id_perfil, id_estado) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 2, 2)";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, u.getIdentificacion());
            ps.setString(2, u.getNombre());
            ps.setString(3, u.getApellido());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getTelefono());
            ps.setString(6, u.getEspecialidad());
            ps.setString(7, u.getUsuario());
            ps.setString(8, u.getClave());

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL REGISTRAR SOLICITUD DE DOCTOR: " + ex.getMessage());
            return 0;
        }
    }

    public List<Usuario> listarSolicitudesDoctor() {
        List<Usuario> lista = new ArrayList<>();

        String q = "SELECT * FROM Usuario "
                + "WHERE id_perfil = 2 "
                + "AND id_estado IN (2, 3) "
                + "ORDER BY id_estado, nombre";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(map(rs));
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR SOLICITUDES DE DOCTOR: " + ex.getMessage());
        }

        return lista;
    }

    public int aprobarSolicitudDoctor(String identificacion) {
        String q = "UPDATE Usuario "
                + "SET id_estado = 1, id_perfil = 2 "
                + "WHERE identificacion = ? "
                + "AND id_perfil = 2";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, identificacion);

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL APROBAR SOLICITUD: " + ex.getMessage());
            return 0;
        }
    }

    public int rechazarSolicitudDoctor(String identificacion) {
        String q = "UPDATE Usuario "
                + "SET id_estado = 3 "
                + "WHERE identificacion = ? "
                + "AND id_perfil = 2";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, identificacion);

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL RECHAZAR SOLICITUD: " + ex.getMessage());
            return 0;
        }
    }

    @Override
    public int actualizarDatos(Usuario u) {
        String q = "UPDATE Usuario SET "
                + "nombre = ?, "
                + "apellido = ?, "
                + "email = ?, "
                + "telefono = ?, "
                + "especialidad = ?, "
                + "usuario = ?, "
                + "clave = ?, "
                + "id_perfil = ?, "
                + "id_estado = ? "
                + "WHERE identificacion = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, u.getNombre());
            ps.setString(2, u.getApellido());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getTelefono());
            ps.setString(5, u.getEspecialidad());
            ps.setString(6, u.getUsuario());
            ps.setString(7, u.getClave());
            ps.setInt(8, u.getIdperfil());
            ps.setInt(9, u.getIdestado());
            ps.setString(10, u.getIdentificacion());

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL ACTUALIZAR USUARIO: " + ex.getMessage());
            return 0;
        }
    }

    public int actualizarDatosSinClave(Usuario u) {
        String q = "UPDATE Usuario SET "
                + "nombre = ?, "
                + "apellido = ?, "
                + "email = ?, "
                + "telefono = ?, "
                + "especialidad = ?, "
                + "usuario = ?, "
                + "id_perfil = ?, "
                + "id_estado = ? "
                + "WHERE identificacion = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, u.getNombre());
            ps.setString(2, u.getApellido());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getTelefono());
            ps.setString(5, u.getEspecialidad());
            ps.setString(6, u.getUsuario());
            ps.setInt(7, u.getIdperfil());
            ps.setInt(8, u.getIdestado());
            ps.setString(9, u.getIdentificacion());

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL ACTUALIZAR USUARIO SIN CLAVE: " + ex.getMessage());
            return 0;
        }
    }

    @Override
    public int eliminarDatos(String id) {
        String q = "UPDATE Usuario SET id_estado = 0 WHERE identificacion = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, id);

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL DESHABILITAR USUARIO: " + ex.getMessage());
            return 0;
        }
    }

    public List<Usuario> listadoDatos() {
        List<Usuario> lista = new ArrayList<>();

        String q = "SELECT * FROM Usuario "
                + "WHERE id_estado = 1 "
                + "ORDER BY id_perfil, nombre";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(map(rs));
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR USUARIOS: " + ex.getMessage());
        }

        return lista;
    }

    public List<Usuario> listadoTodosLosUsuarios() {
        List<Usuario> lista = new ArrayList<>();

        String q = "SELECT * FROM Usuario "
                + "ORDER BY id_estado DESC, id_perfil, nombre";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(map(rs));
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR TODOS LOS USUARIOS: " + ex.getMessage());
        }

        return lista;
    }

    public List<Usuario> listarDoctores() {
        List<Usuario> lista = new ArrayList<>();

        String q = "SELECT * FROM Usuario "
                + "WHERE id_estado = 1 "
                + "AND id_perfil = 2 "
                + "ORDER BY nombre, apellido";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(map(rs));
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR DOCTORES: " + ex.getMessage());
        }

        return lista;
    }

    public List<Usuario> listarAdministradores() {
        List<Usuario> lista = new ArrayList<>();

        String q = "SELECT * FROM Usuario "
                + "WHERE id_estado = 1 "
                + "AND id_perfil = 1 "
                + "ORDER BY nombre, apellido";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(map(rs));
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR ADMINISTRADORES: " + ex.getMessage());
        }

        return lista;
    }

    public List<Usuario> listarPacientes() {
        List<Usuario> lista = new ArrayList<>();

        String q = "SELECT * FROM Usuario "
                + "WHERE id_estado = 1 "
                + "AND id_perfil = 3 "
                + "ORDER BY nombre, apellido";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(map(rs));
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR PACIENTES: " + ex.getMessage());
        }

        return lista;
    }

    public List<Usuario> listarPacientesDeDoctor(String identificacionDoctor) {
        List<Usuario> lista = new ArrayList<>();

        String q = "SELECT DISTINCT u.* "
                + "FROM Usuario u "
                + "INNER JOIN Cita c ON u.identificacion = c.identificacion_cliente "
                + "WHERE c.identificacion_doctor = ? "
                + "AND u.id_perfil = 3 "
                + "AND u.id_estado = 1 "
                + "AND c.id_estado = 1 "
                + "ORDER BY u.nombre, u.apellido";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, identificacionDoctor);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(map(rs));
                }
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR PACIENTES DEL DOCTOR: " + ex.getMessage());
        }

        return lista;
    }

    public int cambiarRol(String identificacion, int idPerfil) {
        String q = "UPDATE Usuario "
                + "SET id_perfil = ? "
                + "WHERE identificacion = ? "
                + "AND id_estado = 1";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setInt(1, idPerfil);
            ps.setString(2, identificacion);

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL CAMBIAR ROL: " + ex.getMessage());
            return 0;
        }
    }

    public int cambiarEstado(String identificacion, int idEstado) {
        String q = "UPDATE Usuario "
                + "SET id_estado = ? "
                + "WHERE identificacion = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setInt(1, idEstado);
            ps.setString(2, identificacion);

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL CAMBIAR ESTADO DEL USUARIO: " + ex.getMessage());
            return 0;
        }
    }

    public boolean existeUsuario(String usuario) {
        String q = "SELECT identificacion FROM Usuario WHERE usuario = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, usuario);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL VALIDAR USUARIO EXISTENTE: " + ex.getMessage());
            return false;
        }
    }

    public boolean existeIdentificacion(String identificacion) {
        String q = "SELECT identificacion FROM Usuario WHERE identificacion = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, identificacion);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL VALIDAR IDENTIFICACION EXISTENTE: " + ex.getMessage());
            return false;
        }
    }

    public boolean existeCorreo(String email) {
        String q = "SELECT identificacion FROM Usuario WHERE email = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL VALIDAR CORREO EXISTENTE: " + ex.getMessage());
            return false;
        }
    }

    public Usuario buscarPorUsuario(String usuario) {
        String q = "SELECT * FROM Usuario WHERE usuario = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, usuario);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL BUSCAR POR NOMBRE DE USUARIO: " + ex.getMessage());
        }

        return null;
    }

    @Override
    public Usuario listadoDatos_Id(String identificacion) {
        String q = "SELECT * FROM Usuario WHERE identificacion = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, identificacion);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL BUSCAR USUARIO POR ID: " + ex.getMessage());
        }

        return null;
    }

    private Usuario map(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();

        u.setIdentificacion(rs.getString("identificacion"));
        u.setNombre(rs.getString("nombre"));
        u.setApellido(rs.getString("apellido"));
        u.setEmail(rs.getString("email"));
        u.setTelefono(rs.getString("telefono"));

        try {
            u.setEspecialidad(rs.getString("especialidad"));
        } catch (SQLException ex) {
            u.setEspecialidad(null);
        }

        u.setUsuario(rs.getString("usuario"));
        u.setClave(rs.getString("clave"));
        u.setIdperfil(rs.getInt("id_perfil"));
        u.setIdestado(rs.getInt("id_estado"));

        return u;
    }
}