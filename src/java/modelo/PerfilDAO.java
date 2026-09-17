package modelo;

import Interfaces.perfilCRUD;
import config.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PerfilDAO implements perfilCRUD {

    @Override
    public int agregarPerfil(Perfil p) {
        Conexion cn = new Conexion();
        Connection con;
        PreparedStatement ps;
        int estatus = 0;
        try {
            con = cn.crearConexion();
            String q = "INSERT INTO Perfil (perfil) VALUES (?)";
            ps = con.prepareStatement(q);
            ps.setString(1, p.getPerfil());
            estatus = ps.executeUpdate();
            System.out.println("PERFIL GUARDADO");
            con.close();
        } catch (SQLException ex) {
            System.out.println("ERROR AL AGREGAR PERFIL: " + ex.getMessage());
        }
        return estatus;
    }

    @Override
    public int actualizarPerfil(Perfil p) {
        Conexion cn = new Conexion();
        Connection con;
        PreparedStatement ps;
        int estatus = 0;
        try {
            con = cn.crearConexion();
            String q = "UPDATE Perfil SET perfil=? WHERE id_perfil=?";
            ps = con.prepareStatement(q);
            ps.setString(1, p.getPerfil());
            ps.setInt(2, p.getId_perfil());
            estatus = ps.executeUpdate();
            System.out.println("PERFIL ACTUALIZADO");
            con.close();
        } catch (SQLException ex) {
            System.out.println("ERROR AL ACTUALIZAR PERFIL: " + ex.getMessage());
        }
        return estatus;
    }

    @Override
    public int eliminarPerfil(int id) {
        Conexion cn = new Conexion();
        Connection con;
        PreparedStatement ps;
        int estatus = 0;
        try {
            con = cn.crearConexion();
            String q = "DELETE FROM Perfil WHERE id_perfil=?";
            ps = con.prepareStatement(q);
            ps.setInt(1, id);
            estatus = ps.executeUpdate();
            System.out.println("PERFIL ELIMINADO");
            con.close();
        } catch (SQLException ex) {
            System.out.println("ERROR AL ELIMINAR PERFIL: " + ex.getMessage());
        }
        return estatus;
    }

    @Override
    public Perfil listadoPerfil_Id(int id) {
        Conexion cn = new Conexion();
        Perfil p = null;
        Connection con;
        PreparedStatement ps;
        ResultSet rs;
        try {
            con = cn.crearConexion();
            String q = "SELECT * FROM Perfil WHERE id_perfil=?";
            ps = con.prepareStatement(q);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                p = new Perfil();
                p.setId_perfil(rs.getInt("id_perfil"));
                p.setPerfil(rs.getString("perfil"));
            }
            con.close();
        } catch (SQLException ex) {
            System.out.println("ERROR AL BUSCAR PERFIL: " + ex.getMessage());
        }
        return p;
    }

    public List<Perfil> listadoPerfiles() {
        List<Perfil> lista = new ArrayList<>();
        Conexion cn = new Conexion();
        Connection con;
        PreparedStatement ps;
        ResultSet rs;
        try {
            con = cn.crearConexion();
            ps = con.prepareStatement("SELECT * FROM Perfil ORDER BY id_perfil");
            rs = ps.executeQuery();
            while (rs.next()) {
                Perfil p = new Perfil();
                p.setId_perfil(rs.getInt("id_perfil"));
                p.setPerfil(rs.getString("perfil"));
                lista.add(p);
            }
            con.close();
        } catch (SQLException ex) {
            System.out.println("ERROR AL LISTAR PERFILES: " + ex.getMessage());
        }
        return lista;
    }
}
