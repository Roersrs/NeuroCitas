package modelo;
public class Cita {
    private int idCita; private String identificacionCliente; private String identificacionDoctor; private int idServicio; private String fecha; private String hora; private String estado; private String observacion; private int idEstado;
    private String nombreCliente; private String nombreDoctor; private String nombreServicio;
    public int getIdCita(){return idCita;} public void setIdCita(int idCita){this.idCita=idCita;}
    public String getIdentificacionCliente(){return identificacionCliente;} public void setIdentificacionCliente(String identificacionCliente){this.identificacionCliente=identificacionCliente;}
    public String getIdentificacionDoctor(){return identificacionDoctor;} public void setIdentificacionDoctor(String identificacionDoctor){this.identificacionDoctor=identificacionDoctor;}
    public int getIdServicio(){return idServicio;} public void setIdServicio(int idServicio){this.idServicio=idServicio;}
    public String getFecha(){return fecha;} public void setFecha(String fecha){this.fecha=fecha;}
    public String getHora(){return hora;} public void setHora(String hora){this.hora=hora;}
    public String getEstado(){return estado;} public void setEstado(String estado){this.estado=estado;}
    public String getObservacion(){return observacion;} public void setObservacion(String observacion){this.observacion=observacion;}
    public int getIdEstado(){return idEstado;} public void setIdEstado(int idEstado){this.idEstado=idEstado;}
    public String getNombreCliente(){return nombreCliente;} public void setNombreCliente(String nombreCliente){this.nombreCliente=nombreCliente;}
    public String getNombreDoctor(){return nombreDoctor;} public void setNombreDoctor(String nombreDoctor){this.nombreDoctor=nombreDoctor;}
    public String getNombreServicio(){return nombreServicio;} public void setNombreServicio(String nombreServicio){this.nombreServicio=nombreServicio;}
}
