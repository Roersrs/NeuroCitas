package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Horario;
import modelo.HorarioDAO;

public class CtrlHorario extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        if (accion == null) {
            response.sendRedirect("listaHorarios.jsp");
            return;
        }

        if (accion.equals("agregar")) {
            agregarHorario(request, response);
        } else if (accion.equals("eliminar")) {
            eliminarHorario(request, response);
        } else {
            response.sendRedirect("listaHorarios.jsp");
        }
    }

    private void agregarHorario(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idDoctor = request.getParameter("idDoctor");
        String diaSemana = request.getParameter("diaSemana");
        String horaInicio = request.getParameter("horaInicio");
        String horaFin = request.getParameter("horaFin");

        if (idDoctor == null || idDoctor.trim().isEmpty()
                || diaSemana == null || diaSemana.trim().isEmpty()
                || horaInicio == null || horaInicio.trim().isEmpty()
                || horaFin == null || horaFin.trim().isEmpty()) {

            response.sendRedirect("listaHorarios.jsp?error=campos");
            return;
        }

        if (horaInicio.compareTo(horaFin) >= 0) {
            response.sendRedirect("listaHorarios.jsp?error=hora");
            return;
        }

        HorarioDAO dao = new HorarioDAO();

        boolean cruce = dao.existeCruceHorario(
                idDoctor,
                diaSemana,
                horaInicio,
                horaFin
        );

        if (cruce) {
            response.sendRedirect("listaHorarios.jsp?error=cruce");
            return;
        }

        Horario h = new Horario();

        h.setIdDoctor(idDoctor);
        h.setDiaSemana(diaSemana);
        h.setHoraInicio(horaInicio);
        h.setHoraFin(horaFin);
        h.setIdEstado(1);

        int resultado = dao.agregarHorario(h);

        if (resultado > 0) {
            response.sendRedirect("listaHorarios.jsp?ok=agregado");
        } else {
            response.sendRedirect("listaHorarios.jsp?error=guardar");
        }
    }

    private void eliminarHorario(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idHorarioTexto = request.getParameter("idHorario");
        String idDoctor = request.getParameter("idDoctor");

        if (idHorarioTexto == null || idHorarioTexto.trim().isEmpty()
                || idDoctor == null || idDoctor.trim().isEmpty()) {

            response.sendRedirect("listaHorarios.jsp?error=eliminar");
            return;
        }

        try {
            int idHorario = Integer.parseInt(idHorarioTexto);

            HorarioDAO dao = new HorarioDAO();
            int resultado = dao.eliminarHorarioAdmin(idHorario);

            if (resultado > 0) {
                response.sendRedirect("listaHorarios.jsp?ok=eliminado");
            } else {
                response.sendRedirect("listaHorarios.jsp?error=eliminar");
            }

        } catch (NumberFormatException ex) {
            response.sendRedirect("listaHorarios.jsp?error=eliminar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}