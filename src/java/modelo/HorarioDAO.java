package modelo;

import config.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HorarioDAO {

    public int agregarHorario(Horario h) {
        String q = "INSERT INTO horarios "
                + "(id_doctor, dia_semana, hora_inicio, hora_fin, id_estado) "
                + "VALUES (?, ?, ?, ?, 1)";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, h.getIdDoctor());
            ps.setString(2, h.getDiaSemana());
            ps.setString(3, h.getHoraInicio());
            ps.setString(4, h.getHoraFin());

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL AGREGAR HORARIO: " + ex.getMessage());
            return 0;
        }
    }

    public List<Horario> listarPorDoctor(String idDoctor) {
        List<Horario> lista = new ArrayList<>();

        String q = "SELECT * FROM horarios "
                + "WHERE id_doctor = ? "
                + "AND id_estado = 1 "
                + "ORDER BY "
                + "CASE dia_semana "
                + "WHEN 'Lunes' THEN 1 "
                + "WHEN 'Martes' THEN 2 "
                + "WHEN 'Miércoles' THEN 3 "
                + "WHEN 'Jueves' THEN 4 "
                + "WHEN 'Viernes' THEN 5 "
                + "WHEN 'Sábado' THEN 6 "
                + "WHEN 'Domingo' THEN 7 "
                + "ELSE 8 END, hora_inicio";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, idDoctor);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(map(rs));
                }
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR HORARIOS DEL DOCTOR: " + ex.getMessage());
        }

        return lista;
    }

    public List<Horario> listarTodos() {
        List<Horario> lista = new ArrayList<>();

        String q = "SELECT * FROM horarios "
                + "WHERE id_estado = 1 "
                + "ORDER BY id_doctor, "
                + "CASE dia_semana "
                + "WHEN 'Lunes' THEN 1 "
                + "WHEN 'Martes' THEN 2 "
                + "WHEN 'Miércoles' THEN 3 "
                + "WHEN 'Jueves' THEN 4 "
                + "WHEN 'Viernes' THEN 5 "
                + "WHEN 'Sábado' THEN 6 "
                + "WHEN 'Domingo' THEN 7 "
                + "ELSE 8 END, hora_inicio";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(map(rs));
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR TODOS LOS HORARIOS: " + ex.getMessage());
        }

        return lista;
    }

    public int eliminarHorario(int idHorario, String idDoctor) {
        String q = "UPDATE horarios "
                + "SET id_estado = 0 "
                + "WHERE id_horario = ? "
                + "AND id_doctor = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setInt(1, idHorario);
            ps.setString(2, idDoctor);

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL ELIMINAR HORARIO: " + ex.getMessage());
            return 0;
        }
    }

    public int eliminarHorarioAdmin(int idHorario) {
        String q = "UPDATE horarios "
                + "SET id_estado = 0 "
                + "WHERE id_horario = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setInt(1, idHorario);

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("ERROR AL ELIMINAR HORARIO COMO ADMIN: " + ex.getMessage());
            return 0;
        }
    }

    public boolean existeCruceHorario(String idDoctor, String diaSemana, String horaInicio, String horaFin) {
        String q = "SELECT id_horario FROM horarios "
                + "WHERE id_doctor = ? "
                + "AND dia_semana = ? "
                + "AND id_estado = 1 "
                + "AND (hora_inicio < ? AND hora_fin > ?)";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, idDoctor);
            ps.setString(2, diaSemana);
            ps.setString(3, horaFin);
            ps.setString(4, horaInicio);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL VALIDAR CRUCE DE HORARIO: " + ex.getMessage());
            return false;
        }
    }

    public Horario buscarPorId(int idHorario) {
        String q = "SELECT * FROM horarios WHERE id_horario = ?";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setInt(1, idHorario);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL BUSCAR HORARIO POR ID: " + ex.getMessage());
        }

        return null;
    }

    private Horario map(ResultSet rs) throws SQLException {
        Horario h = new Horario();

        h.setIdHorario(rs.getInt("id_horario"));
        h.setIdDoctor(rs.getString("id_doctor"));
        h.setDiaSemana(rs.getString("dia_semana"));
        h.setHoraInicio(rs.getString("hora_inicio"));
        h.setHoraFin(rs.getString("hora_fin"));
        h.setIdEstado(rs.getInt("id_estado"));

        return h;
    }
}