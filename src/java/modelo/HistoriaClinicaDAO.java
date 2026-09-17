package modelo;

import config.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HistoriaClinicaDAO {

    public int agregar(HistoriaClinica h) {
        String q = "INSERT INTO HistoriaClinica "
                + "(identificacion_paciente, identificacion_doctor, motivo_consulta, enfermedad_actual, "
                + "antecedentes, examen_fisico, diagnostico, tratamiento, observaciones, id_estado) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, h.getIdentificacionPaciente());
            ps.setString(2, h.getIdentificacionDoctor());
            ps.setString(3, h.getMotivoConsulta());
            ps.setString(4, h.getEnfermedadActual());
            ps.setString(5, h.getAntecedentes());
            ps.setString(6, h.getExamenFisico());
            ps.setString(7, h.getDiagnostico());
            ps.setString(8, h.getTratamiento());
            ps.setString(9, h.getObservaciones());

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("=======================================");
            System.out.println("ERROR AL GUARDAR HISTORIA CLINICA");
            System.out.println("SQL ERROR: " + ex.getMessage());
            System.out.println("PACIENTE: " + h.getIdentificacionPaciente());
            System.out.println("DOCTOR: " + h.getIdentificacionDoctor());
            System.out.println("MOTIVO: " + h.getMotivoConsulta());
            System.out.println("ENFERMEDAD: " + h.getEnfermedadActual());
            System.out.println("DIAGNOSTICO: " + h.getDiagnostico());
            System.out.println("=======================================");
            return 0;
        }
    }

    public int actualizar(HistoriaClinica h) {
        String q = "UPDATE HistoriaClinica SET "
                + "motivo_consulta = ?, "
                + "enfermedad_actual = ?, "
                + "antecedentes = ?, "
                + "examen_fisico = ?, "
                + "diagnostico = ?, "
                + "tratamiento = ?, "
                + "observaciones = ? "
                + "WHERE id_historia = ? "
                + "AND id_estado = 1";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, h.getMotivoConsulta());
            ps.setString(2, h.getEnfermedadActual());
            ps.setString(3, h.getAntecedentes());
            ps.setString(4, h.getExamenFisico());
            ps.setString(5, h.getDiagnostico());
            ps.setString(6, h.getTratamiento());
            ps.setString(7, h.getObservaciones());
            ps.setInt(8, h.getIdHistoria());

            return ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println("=======================================");
            System.out.println("ERROR AL ACTUALIZAR HISTORIA CLINICA");
            System.out.println("SQL ERROR: " + ex.getMessage());
            System.out.println("ID HISTORIA: " + h.getIdHistoria());
            System.out.println("=======================================");
            return 0;
        }
    }

    public HistoriaClinica buscarPorId(int idHistoria) {
        String q = "SELECT h.*, "
                + "CONCAT(p.nombre, ' ', p.apellido) AS nombre_paciente, "
                + "CONCAT(d.nombre, ' ', d.apellido) AS nombre_doctor "
                + "FROM HistoriaClinica h "
                + "LEFT JOIN Usuario p ON h.identificacion_paciente = p.identificacion "
                + "LEFT JOIN Usuario d ON h.identificacion_doctor = d.identificacion "
                + "WHERE h.id_historia = ? "
                + "AND h.id_estado = 1";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setInt(1, idHistoria);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL BUSCAR HISTORIA POR ID: " + ex.getMessage());
        }

        return null;
    }

    public List<HistoriaClinica> listarPorPaciente(String identificacionPaciente) {
        List<HistoriaClinica> lista = new ArrayList<>();

        String q = "SELECT h.*, "
                + "CONCAT(p.nombre, ' ', p.apellido) AS nombre_paciente, "
                + "CONCAT(d.nombre, ' ', d.apellido) AS nombre_doctor "
                + "FROM HistoriaClinica h "
                + "LEFT JOIN Usuario p ON h.identificacion_paciente = p.identificacion "
                + "LEFT JOIN Usuario d ON h.identificacion_doctor = d.identificacion "
                + "WHERE h.identificacion_paciente = ? "
                + "AND h.id_estado = 1 "
                + "ORDER BY h.fecha_registro DESC";

        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, identificacionPaciente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(map(rs));
                }
            }

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR HISTORIAS DEL PACIENTE: " + ex.getMessage());
        }

        return lista;
    }

    private HistoriaClinica map(ResultSet rs) throws SQLException {
        HistoriaClinica h = new HistoriaClinica();

        h.setIdHistoria(rs.getInt("id_historia"));
        h.setIdentificacionPaciente(rs.getString("identificacion_paciente"));
        h.setIdentificacionDoctor(rs.getString("identificacion_doctor"));
        h.setMotivoConsulta(rs.getString("motivo_consulta"));
        h.setEnfermedadActual(rs.getString("enfermedad_actual"));
        h.setAntecedentes(rs.getString("antecedentes"));
        h.setExamenFisico(rs.getString("examen_fisico"));
        h.setDiagnostico(rs.getString("diagnostico"));
        h.setTratamiento(rs.getString("tratamiento"));
        h.setObservaciones(rs.getString("observaciones"));
        h.setFechaRegistro(rs.getString("fecha_registro"));
        h.setIdEstado(rs.getInt("id_estado"));

        try {
            h.setNombrePaciente(rs.getString("nombre_paciente"));
        } catch (SQLException ex) {
            h.setNombrePaciente(null);
        }

        try {
            h.setNombreDoctor(rs.getString("nombre_doctor"));
        } catch (SQLException ex) {
            h.setNombreDoctor(null);
        }

        return h;
    }
}