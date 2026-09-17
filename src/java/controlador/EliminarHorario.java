package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.HorarioDAO;

public class EliminarHorario extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idHorarioTexto = request.getParameter("idHorario");
        String idDoctor = request.getParameter("idDoctor");

        if (idHorarioTexto == null || idHorarioTexto.trim().isEmpty()) {
            response.sendRedirect("listaHorarios.jsp?error=eliminar");
            return;
        }

        try {
            int idHorario = Integer.parseInt(idHorarioTexto);

            HorarioDAO dao = new HorarioDAO();

            int resultado;

            if (idDoctor != null && !idDoctor.trim().isEmpty()) {
                resultado = dao.eliminarHorario(idHorario, idDoctor);
            } else {
                resultado = dao.eliminarHorarioAdmin(idHorario);
            }

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