package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Usuario;
import modelo.UsuarioDAO;

public class GestionSolicitudDoctor extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Usuario actual = session != null ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (actual == null || actual.getIdperfil() != 1) {
            response.sendRedirect("index.jsp");
            return;
        }

        String identificacion = request.getParameter("identificacion");
        String accion = request.getParameter("accion");
        int ok = 0;

        if ("aprobar".equalsIgnoreCase(accion)) {
            ok = new UsuarioDAO().aprobarSolicitudDoctor(identificacion);
        } else if ("rechazar".equalsIgnoreCase(accion)) {
            ok = new UsuarioDAO().rechazarSolicitudDoctor(identificacion);
        }

        response.sendRedirect("solicitudesDoctor.jsp?" + (ok > 0 ? "ok=1" : "error=1"));
    }

    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { response.sendRedirect("solicitudesDoctor.jsp"); }
}
