package modelo;

import config.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CitaDAO {

    public int agregar(Cita cita) {
        String q = "INSERT INTO Cita "
                + "(identificacion_cliente, identificacion_doctor, id_servicio, fecha, hora, estado, observacion, id_estado) "
                + "VALUES (?, ?, ?, ?, ?, 'Pendiente', ?, 1)";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, cita.getIdentificacionCliente());
            ps.setString(2, cita.getIdentificacionDoctor());
            ps.setInt(3, cita.getIdServicio());
            ps.setString(4, cita.getFecha());
            ps.setString(5, cita.getHora());
            ps.setString(6, cita.getObservacion());

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL AGREGAR CITA: " + ex.getMessage());
            return 0;
        }
    }

    public int cambiarEstado(int idCita, String estado) {
        String q = "UPDATE Cita SET estado = ? WHERE id_cita = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, estado);
            ps.setInt(2, idCita);

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL CAMBIAR ESTADO DE CITA: " + ex.getMessage());
            return 0;
        }
    }

    public int eliminar(int idCita) {
        String q = "UPDATE Cita SET id_estado = 0 WHERE id_cita = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setInt(1, idCita);

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL ELIMINAR CITA: " + ex.getMessage());
            return 0;
        }
    }

    public List<Cita> listarTodas() {
        return listar("WHERE c.id_estado = 1", null);
    }

    public List<Cita> listarPorDoctor(String identificacionDoctor) {
        return listar("WHERE c.id_estado = 1 AND c.identificacion_doctor = ?", identificacionDoctor);
    }

    public List<Cita> listarPorCliente(String identificacionCliente) {
        return listar("WHERE c.id_estado = 1 AND c.identificacion_cliente = ?", identificacionCliente);
    }

    public Cita buscarPorId(int idCita) {
        String q = "SELECT c.*, "
                + "CONCAT(cli.nombre, ' ', cli.apellido) AS cliente, "
                + "CONCAT(doc.nombre, ' ', doc.apellido) AS doctor, "
                + "s.nombre_servicio AS servicio "
                + "FROM Cita c "
                + "INNER JOIN Usuario cli ON c.identificacion_cliente = cli.identificacion "
                + "INNER JOIN Usuario doc ON c.identificacion_doctor = doc.identificacion "
                + "INNER JOIN Servicio s ON c.id_servicio = s.id_servicio "
                + "WHERE c.id_cita = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setInt(1, idCita);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL BUSCAR CITA POR ID: " + ex.getMessage());
        }

        return null;
    }

    public boolean existeCitaEnHorario(String identificacionDoctor, String fecha, String hora) {
        String q = "SELECT id_cita FROM Cita "
                + "WHERE identificacion_doctor = ? "
                + "AND fecha = ? "
                + "AND hora = ? "
                + "AND id_estado = 1 "
                + "AND estado <> 'Cancelada'";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, identificacionDoctor);
            ps.setString(2, fecha);
            ps.setString(3, hora);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL VALIDAR CITA EXISTENTE: " + ex.getMessage());
            return false;
        }
    }

    private List<Cita> listar(String where, String parametro) {
        List<Cita> lista = new ArrayList<>();

        String q = "SELECT c.*, "
                + "CONCAT(cli.nombre, ' ', cli.apellido) AS cliente, "
                + "CONCAT(doc.nombre, ' ', doc.apellido) AS doctor, "
                + "s.nombre_servicio AS servicio "
                + "FROM Cita c "
                + "INNER JOIN Usuario cli ON c.identificacion_cliente = cli.identificacion "
                + "INNER JOIN Usuario doc ON c.identificacion_doctor = doc.identificacion "
                + "INNER JOIN Servicio s ON c.id_servicio = s.id_servicio "
                + where + " "
                + "ORDER BY c.fecha DESC, c.hora DESC";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            if (parametro != null) {
                ps.setString(1, parametro);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(map(rs));
                }
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR CITAS: " + ex.getMessage());
        }

        return lista;
    }

    private Cita map(ResultSet rs) throws SQLException {
        Cita c = new Cita();

        c.setIdCita(rs.getInt("id_cita"));
        c.setIdentificacionCliente(rs.getString("identificacion_cliente"));
        c.setIdentificacionDoctor(rs.getString("identificacion_doctor"));
        c.setIdServicio(rs.getInt("id_servicio"));
        c.setFecha(rs.getString("fecha"));
        c.setHora(rs.getString("hora"));
        c.setEstado(rs.getString("estado"));
        c.setObservacion(rs.getString("observacion"));
        c.setIdEstado(rs.getInt("id_estado"));

        c.setNombreCliente(rs.getString("cliente"));
        c.setNombreDoctor(rs.getString("doctor"));
        c.setNombreServicio(rs.getString("servicio"));

        return c;
    }
}