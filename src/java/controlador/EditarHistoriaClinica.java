package controlador;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.HistoriaClinica;
import modelo.HistoriaClinicaDAO;
import modelo.Usuario;

public class EditarHistoriaClinica extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        Usuario actual = null;

        if (session != null) {
            actual = (Usuario) session.getAttribute("usuarioLogueado");
        }

        if (actual == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        if (actual.getIdperfil() != 2) {
            response.sendRedirect("front.jsp");
            return;
        }

        String idHistoriaTexto = limpiar(request.getParameter("idHistoria"));
        String idPaciente = limpiar(request.getParameter("idPaciente"));
        String motivoConsulta = limpiar(request.getParameter("motivoConsulta"));
        String enfermedadActual = limpiar(request.getParameter("enfermedadActual"));
        String antecedentes = limpiar(request.getParameter("antecedentes"));
        String examenFisico = limpiar(request.getParameter("examenFisico"));
        String diagnostico = limpiar(request.getParameter("diagnostico"));
        String tratamiento = limpiar(request.getParameter("tratamiento"));
        String observaciones = limpiar(request.getParameter("observaciones"));

        if (idPaciente.isEmpty()) {
            response.sendRedirect("buscarHistoria.jsp");
            return;
        }

        String idPacienteUrl = URLEncoder.encode(idPaciente, StandardCharsets.UTF_8.toString());

        if (idHistoriaTexto.isEmpty()
                || motivoConsulta.isEmpty()
                || enfermedadActual.isEmpty()
                || diagnostico.isEmpty()) {

            response.sendRedirect("historiaPaciente.jsp?idPaciente=" + idPacienteUrl + "&error=editarcampos");
            return;
        }

        try {
            int idHistoria = Integer.parseInt(idHistoriaTexto);

            HistoriaClinica h = new HistoriaClinica();

            h.setIdHistoria(idHistoria);
            h.setIdentificacionPaciente(idPaciente);
            h.setMotivoConsulta(motivoConsulta);
            h.setEnfermedadActual(enfermedadActual);
            h.setAntecedentes(antecedentes);
            h.setExamenFisico(examenFisico);
            h.setDiagnostico(diagnostico);
            h.setTratamiento(tratamiento);
            h.setObservaciones(observaciones);

            HistoriaClinicaDAO dao = new HistoriaClinicaDAO();

            int resultado = dao.actualizar(h);

            if (resultado > 0) {
                response.sendRedirect("historiaPaciente.jsp?idPaciente=" + idPacienteUrl + "&ok=editado");
            } else {
                response.sendRedirect("historiaPaciente.jsp?idPaciente=" + idPacienteUrl + "&error=editar");
            }

        } catch (NumberFormatException ex) {
            response.sendRedirect("historiaPaciente.jsp?idPaciente=" + idPacienteUrl + "&error=editar");
        }
    }

    private String limpiar(String valor) {
        if (valor == null) {
            return "";
        }

        return valor.trim();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("buscarHistoria.jsp");
    }
}