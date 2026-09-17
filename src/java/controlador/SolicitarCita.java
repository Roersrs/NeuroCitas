package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Cita;
import modelo.CitaDAO;
import modelo.Usuario;

public class SolicitarCita extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Usuario actual = (Usuario) session.getAttribute("usuarioLogueado");

        if (actual == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        if (actual.getIdperfil() != 3) {
            response.sendRedirect("front.jsp");
            return;
        }

        String idDoctor = request.getParameter("idDoctor");
        String idServicioTexto = request.getParameter("idServicio");
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");
        String observacion = request.getParameter("observacion");

        if (idDoctor == null || idDoctor.trim().isEmpty()
                || idServicioTexto == null || idServicioTexto.trim().isEmpty()
                || fecha == null || fecha.trim().isEmpty()
                || hora == null || hora.trim().isEmpty()) {

            response.sendRedirect("solicitarCita.jsp?error=campos");
            return;
        }

        try {
            int idServicio = Integer.parseInt(idServicioTexto);

            CitaDAO dao = new CitaDAO();

            boolean ocupada = dao.existeCitaEnHorario(idDoctor, fecha, hora);

            if (ocupada) {
                response.sendRedirect("solicitarCita.jsp?error=ocupada");
                return;
            }

            Cita cita = new Cita();

            cita.setIdentificacionCliente(actual.getIdentificacion());
            cita.setIdentificacionDoctor(idDoctor);
            cita.setIdServicio(idServicio);
            cita.setFecha(fecha);
            cita.setHora(hora);
            cita.setObservacion(observacion);

            int resultado = dao.agregar(cita);

            if (resultado > 0) {
                response.sendRedirect("solicitarCita.jsp?ok=creada");
            } else {
                response.sendRedirect("solicitarCita.jsp?error=guardar");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("solicitarCita.jsp?error=campos");
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
        response.sendRedirect("solicitarCita.jsp");
    }
}