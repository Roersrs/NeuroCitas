package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Usuario;
import modelo.UsuarioDAO;

public class CambiarRolUsuario extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Usuario actual = session != null ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (actual == null || actual.getIdperfil() != 1) {
            response.sendRedirect("index.jsp");
            return;
        }

        String identificacion = request.getParameter("identificacion");
        String rolTexto = request.getParameter("idperfil");

        try {
            int idPerfil = Integer.parseInt(rolTexto);
            if (idPerfil < 1 || idPerfil > 3) {
                response.sendRedirect("asignarRoles.jsp?error=1");
                return;
            }

            int ok = new UsuarioDAO().cambiarRol(identificacion, idPerfil);
            if (ok > 0) {
                response.sendRedirect("asignarRoles.jsp?ok=1");
            } else {
                response.sendRedirect("asignarRoles.jsp?error=1");
            }
        } catch (Exception e) {
            System.out.println("ERROR AL CAMBIAR ROL: " + e.getMessage());
            response.sendRedirect("asignarRoles.jsp?error=1");
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
        response.sendRedirect("asignarRoles.jsp");
    }
}
