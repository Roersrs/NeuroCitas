package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Horario;
import modelo.HorarioDAO;
import modelo.Usuario;

public class ControladorMisHorarios extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Usuario actual = (Usuario) session.getAttribute("usuarioLogueado");

        if (actual == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        if (actual.getIdperfil() != 2) {
            response.sendRedirect("front.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if (accion == null) {
            response.sendRedirect("misHorarios.jsp");
            return;
        }

        if (accion.equals("agregar")) {
            agregarHorario(request, response, actual);
        } else if (accion.equals("eliminar")) {
            eliminarHorario(request, response, actual);
        } else {
            response.sendRedirect("misHorarios.jsp");
        }
    }

    private void agregarHorario(HttpServletRequest request, HttpServletResponse response, Usuario actual)
            throws IOException {

        String diaSemana = request.getParameter("diaSemana");
        String horaInicio = request.getParameter("horaInicio");
        String horaFin = request.getParameter("horaFin");

        if (diaSemana == null || diaSemana.trim().isEmpty()
                || horaInicio == null || horaInicio.trim().isEmpty()
                || horaFin == null || horaFin.trim().isEmpty()) {

            response.sendRedirect("misHorarios.jsp?error=campos");
            return;
        }

        if (horaInicio.compareTo(horaFin) >= 0) {
            response.sendRedirect("misHorarios.jsp?error=hora");
            return;
        }

        HorarioDAO dao = new HorarioDAO();

        boolean cruce = dao.existeCruceHorario(
                actual.getIdentificacion(),
                diaSemana,
                horaInicio,
                horaFin
        );

        if (cruce) {
            response.sendRedirect("misHorarios.jsp?error=cruce");
            return;
        }

        Horario h = new Horario();

        h.setIdDoctor(actual.getIdentificacion());
        h.setDiaSemana(diaSemana);
        h.setHoraInicio(horaInicio);
        h.setHoraFin(horaFin);
        h.setIdEstado(1);

        int resultado = dao.agregarHorario(h);

        if (resultado > 0) {
            response.sendRedirect("misHorarios.jsp?ok=agregado");
        } else {
            response.sendRedirect("misHorarios.jsp?error=guardar");
        }
    }

    private void eliminarHorario(HttpServletRequest request, HttpServletResponse response, Usuario actual)
            throws IOException {

        String idHorarioTexto = request.getParameter("idHorario");

        if (idHorarioTexto == null || idHorarioTexto.trim().isEmpty()) {
            response.sendRedirect("misHorarios.jsp?error=eliminar");
            return;
        }

        try {
            int idHorario = Integer.parseInt(idHorarioTexto);

            HorarioDAO dao = new HorarioDAO();
            int resultado = dao.eliminarHorario(idHorario, actual.getIdentificacion());

            if (resultado > 0) {
                response.sendRedirect("misHorarios.jsp?ok=eliminado");
            } else {
                response.sendRedirect("misHorarios.jsp?error=eliminar");
            }

        } catch (NumberFormatException ex) {
            response.sendRedirect("misHorarios.jsp?error=eliminar");
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