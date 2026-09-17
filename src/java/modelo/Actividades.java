/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

/**
 *
 * @author sebas
 */
public class Actividades {
    
    int id_actividad;
    String nom_actividad;
    String enlace;
    int id_estado;

    public Actividades() {
    }

    public Actividades(int id_actividad, String nom_actividad, int id_estado) {
        this.id_actividad = id_actividad;
        this.nom_actividad = nom_actividad;
        this.id_estado = id_estado;
    }

    public int getId_actividad() {
        return id_actividad;
    }

    public void setId_actividad(int id_actividad) {
        this.id_actividad = id_actividad;
    }

    public String getNom_actividad() {
        return nom_actividad;
    }

    public void setNom_actividad(String nom_actividad) {
        this.nom_actividad = nom_actividad;
    }

    public String getEnlace() {
        return enlace;
    }

    public void setEnlace(String enlace) {
        this.enlace = enlace;
    }

    public int getId_estado() {
        return id_estado;
    }

    public void setId_estado(int id_estado) {
        this.id_estado = id_estado;
    }
}
