package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.HistoriaClinica;
import modelo.HistoriaClinicaDAO;
import modelo.Usuario;

public class CtrlHistoriaClinica extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Usuario actual = (Usuario) session.getAttribute("usuarioLogueado");

        if (actual == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if (accion == null) {
            response.sendRedirect("buscarHistoria.jsp");
            return;
        }

        if (accion.equals("guardar")) {
            guardarHistoria(request, response, actual);
        } else {
            response.sendRedirect("buscarHistoria.jsp");
        }
    }

    private void guardarHistoria(HttpServletRequest request, HttpServletResponse response, Usuario actual)
            throws IOException {

        if (actual.getIdperfil() != 2) {
            response.sendRedirect("front.jsp");
            return;
        }

        String idPaciente = request.getParameter("idPaciente");
        String motivoConsulta = request.getParameter("motivoConsulta");
        String enfermedadActual = request.getParameter("enfermedadActual");
        String antecedentes = request.getParameter("antecedentes");
        String examenFisico = request.getParameter("examenFisico");
        String diagnostico = request.getParameter("diagnostico");
        String tratamiento = request.getParameter("tratamiento");
        String observaciones = request.getParameter("observaciones");

        if (idPaciente == null || idPaciente.trim().isEmpty()
                || motivoConsulta == null || motivoConsulta.trim().isEmpty()
                || enfermedadActual == null || enfermedadActual.trim().isEmpty()
                || diagnostico == null || diagnostico.trim().isEmpty()) {

            response.sendRedirect("historiaPaciente.jsp?idPaciente=" + idPaciente + "&error=campos");
            return;
        }

        HistoriaClinica h = new HistoriaClinica();

        h.setIdentificacionPaciente(idPaciente);
        h.setIdentificacionDoctor(actual.getIdentificacion());
        h.setMotivoConsulta(motivoConsulta);
        h.setEnfermedadActual(enfermedadActual);
        h.setAntecedentes(antecedentes);
        h.setExamenFisico(examenFisico);
        h.setDiagnostico(diagnostico);
        h.setTratamiento(tratamiento);
        h.setObservaciones(observaciones);
        h.setIdEstado(1);

        HistoriaClinicaDAO dao = new HistoriaClinicaDAO();
        int resultado = dao.agregar(h);

        if (resultado > 0) {
            response.sendRedirect("historiaPaciente.jsp?idPaciente=" + idPaciente + "&ok=guardado");
        } else {
            response.sendRedirect("historiaPaciente.jsp?idPaciente=" + idPaciente + "&error=guardar");
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