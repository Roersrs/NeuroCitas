package modelo;

import Interfaces.actividadesCRUD;
import config.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ActividadesDAO implements actividadesCRUD {

    @Override
    public int agregarActividad(Actividades a) {
        int estatus = 0;
        String q = "INSERT INTO actividades (nom_actividad, enlace, id_estado) VALUES (?, ?, 1)";

        try {
            Conexion cn = new Conexion();
            Connection con = cn.crearConexion();
            PreparedStatement ps = con.prepareStatement(q);

            ps.setString(1, a.getNom_actividad());
            ps.setString(2, a.getEnlace());

            estatus = ps.executeUpdate();

            ps.close();
            con.close();

        } catch (SQLException ex) {
            System.out.println("ERROR AL AGREGAR ACTIVIDAD: " + ex.getMessage());
        }

        return estatus;
    }

    @Override
    public int actualizarActividad(Actividades a) {
        int estatus = 0;
        String q = "UPDATE actividades SET nom_actividad = ?, enlace = ? WHERE id_actividad = ?";

        try {
            Conexion cn = new Conexion();
            Connection con = cn.crearConexion();
            PreparedStatement ps = con.prepareStatement(q);

            ps.setString(1, a.getNom_actividad());
            ps.setString(2, a.getEnlace());
            ps.setInt(3, a.getId_actividad());

            estatus = ps.executeUpdate();

            ps.close();
            con.close();

        } catch (SQLException ex) {
            System.out.println("ERROR AL ACTUALIZAR ACTIVIDAD: " + ex.getMessage());
        }

        return estatus;
    }

    @Override
    public int eliminarActividad(int id) {
        int estatus = 0;
        String q = "UPDATE actividades SET id_estado = 0 WHERE id_actividad = ?";

        try {
            Conexion cn = new Conexion();
            Connection con = cn.crearConexion();
            PreparedStatement ps = con.prepareStatement(q);

            ps.setInt(1, id);

            estatus = ps.executeUpdate();

            ps.close();
            con.close();

        } catch (SQLException ex) {
            System.out.println("ERROR AL DESHABILITAR ACTIVIDAD: " + ex.getMessage());
        }

        return estatus;
    }

    public List<Actividades> listadoActividades() {
        List<Actividades> lista = new ArrayList<>();

        String q = "SELECT id_actividad, nom_actividad, enlace, id_estado "
                + "FROM actividades "
                + "WHERE id_estado = 1 "
                + "ORDER BY id_actividad";

        try {
            Conexion cn = new Conexion();
            Connection con = cn.crearConexion();
            PreparedStatement ps = con.prepareStatement(q);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Actividades a = new Actividades();
                a.setId_actividad(rs.getInt("id_actividad"));
                a.setNom_actividad(rs.getString("nom_actividad"));
                a.setEnlace(rs.getString("enlace"));
                a.setId_estado(rs.getInt("id_estado"));
                lista.add(a);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR ACTIVIDADES: " + ex.getMessage());
        }

        return lista;
    }

    public List<Actividades> listadoDatos_Perfil(int idPerfil) {
        List<Actividades> lista = new ArrayList<>();

        String q = "SELECT a.id_actividad, a.nom_actividad, a.enlace, a.id_estado "
                + "FROM actividades a "
                + "INNER JOIN gesActividad g ON a.id_actividad = g.id_actividad "
                + "WHERE g.id_perfil = ? "
                + "AND g.id_estado = 1 "
                + "AND a.id_estado = 1 "
                + "ORDER BY a.id_actividad";

        try {
            Conexion cn = new Conexion();
            Connection con = cn.crearConexion();
            PreparedStatement ps = con.prepareStatement(q);

            ps.setInt(1, idPerfil);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Actividades a = new Actividades();
                a.setId_actividad(rs.getInt("id_actividad"));
                a.setNom_actividad(rs.getString("nom_actividad"));
                a.setEnlace(rs.getString("enlace"));
                a.setId_estado(rs.getInt("id_estado"));
                lista.add(a);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR ACTIVIDADES POR PERFIL: " + ex.getMessage());
        }

        return lista;
    }

    @Override
    public Actividades listadoDatos_Id(int id) {
        Actividades a = null;

        String q = "SELECT id_actividad, nom_actividad, enlace, id_estado "
                + "FROM actividades "
                + "WHERE id_actividad = ?";

        try {
            Conexion cn = new Conexion();
            Connection con = cn.crearConexion();
            PreparedStatement ps = con.prepareStatement(q);

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a = new Actividades();
                a.setId_actividad(rs.getInt("id_actividad"));
                a.setNom_actividad(rs.getString("nom_actividad"));
                a.setEnlace(rs.getString("enlace"));
                a.setId_estado(rs.getInt("id_estado"));
            }

            rs.close();
            ps.close();
            con.close();

        } catch (SQLException ex) {
            System.out.println("ERROR AL BUSCAR ACTIVIDAD: " + ex.getMessage());
        }

        return a;
    }
}