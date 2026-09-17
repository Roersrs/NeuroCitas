package modelo;

import config.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.mindrot.jbcrypt.BCrypt;

public class LoginDAO {

    public Usuario Login_datos(String usuario, String clave) {
        Usuario datos = null;
        String sql = "SELECT * FROM Usuario WHERE usuario = ? AND id_estado = 1";

        try (Connection conn = new Conexion().crearConexion()) {
            if (conn == null) {
                System.out.println("No hay conexión a la base de datos.");
                return null;
            }
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, usuario);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next() && claveCorrecta(clave, rs.getString("clave"))) {
                        datos = map(rs);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("ERROR LOGIN: " + e.getMessage());
        }
        return datos;
    }

    public int estadoUsuarioConClave(String usuario, String clave) {
        String sql = "SELECT clave, id_estado FROM Usuario WHERE usuario = ?";
        try (Connection conn = new Conexion().crearConexion()) {
            if (conn == null) return -1;
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, usuario);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next() && claveCorrecta(clave, rs.getString("clave"))) {
                        return rs.getInt("id_estado");
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("ERROR ESTADO LOGIN: " + e.getMessage());
        }
        return -1;
    }

    private boolean claveCorrecta(String claveIngresada, String claveBD) {
        if (claveIngresada == null || claveBD == null) return false;
        if (claveBD.startsWith("$2a$") || claveBD.startsWith("$2b$") || claveBD.startsWith("$2y$")) {
            return BCrypt.checkpw(claveIngresada, claveBD);
        }
        return claveIngresada.equals(claveBD);
    }

    private Usuario map(ResultSet rs) throws Exception {
        Usuario datos = new Usuario();
        datos.setIdentificacion(rs.getString("identificacion"));
        datos.setNombre(rs.getString("nombre"));
        datos.setApellido(rs.getString("apellido"));
        datos.setEmail(rs.getString("email"));
        datos.setTelefono(rs.getString("telefono"));
        datos.setUsuario(rs.getString("usuario"));
        datos.setClave(rs.getString("clave"));
        datos.setIdperfil(rs.getInt("id_perfil"));
        datos.setIdestado(rs.getInt("id_estado"));
        return datos;
    }
}
