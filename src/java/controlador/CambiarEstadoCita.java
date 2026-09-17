package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.CitaDAO;

public class CambiarEstadoCita extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idTexto = request.getParameter("id");
        String estado = request.getParameter("estado");
        String volver = request.getParameter("volver");

        if (volver == null || volver.trim().isEmpty()) {
            volver = "listaCitas.jsp";
        }

        if (idTexto == null || idTexto.trim().isEmpty()
                || estado == null || estado.trim().isEmpty()) {

            response.sendRedirect(volver + "?error=estado");
            return;
        }

        try {
            int idCita = Integer.parseInt(idTexto);

            CitaDAO dao = new CitaDAO();
            int resultado = dao.cambiarEstado(idCita, estado);

            if (resultado > 0) {
                response.sendRedirect(volver + "?ok=estado&estado=" + estado);
            } else {
                response.sendRedirect(volver + "?error=estado");
            }

        } catch (NumberFormatException ex) {
            response.sendRedirect(volver + "?error=estado");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}