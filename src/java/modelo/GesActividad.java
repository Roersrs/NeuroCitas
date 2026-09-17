/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

/**
 *
 * @author sebas
 */
public class GesActividad {
    
    int idgesActividad;
    int id_perfil;
    int id_actividad;
    int id_estado;

    public GesActividad() {
    }

    public GesActividad(int idgesActividad, int id_perfil, int id_actividad, int id_estado) {
        this.idgesActividad = idgesActividad;
        this.id_perfil = id_perfil;
        this.id_actividad = id_actividad;
        this.id_estado = id_estado;
    }

    public int getIdgesActividad() {
        return idgesActividad;
    }

    public void setIdgesActividad(int idgesActividad) {
        this.idgesActividad = idgesActividad;
    }

    public int getId_perfil() {
        return id_perfil;
    }

    public void setId_perfil(int id_perfil) {
        this.id_perfil = id_perfil;
    }

    public int getId_actividad() {
        return id_actividad;
    }

    public void setId_actividad(int id_actividad) {
        this.id_actividad = id_actividad;
    } 

    public int getId_estado() {
        return id_estado;
    }

    public void setId_estado(int id_estado) {
        this.id_estado = id_estado;
    }
}
