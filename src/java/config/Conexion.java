package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    public static String usuario = "root";
    public static String clave = "root";
    public static String servidor = "localhost:3306";
    public static String BD = "NeuroCitas";

    public Connection crearConexion() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String URL = "jdbc:mysql://" + servidor + "/" + BD
                    + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            con = DriverManager.getConnection(URL, usuario, clave);
            System.out.println("Conectado correctamente a MySQL: " + BD);
        } catch (ClassNotFoundException ex) {
            System.out.println("ERROR: No se encontró el driver de MySQL");
            System.out.println(ex.getMessage());
        } catch (SQLException e) {
            System.out.println("ERROR DE CONEXIÓN A MYSQL");
            System.out.println("Base de datos: " + BD);
            System.out.println("Usuario: " + usuario);
            System.out.println("Servidor: " + servidor);
            System.out.println("Detalle: " + e.getMessage());
        }
        return con;
    }
}
