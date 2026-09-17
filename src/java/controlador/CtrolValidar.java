package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.LoginDAO;
import modelo.Usuario;
import java.io.IOException;

public class CtrolValidar extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        if (accion != null && accion.equalsIgnoreCase("Ingresar")) {
            String usu = request.getParameter("cusuario");
            String cla = request.getParameter("cclave");
            LoginDAO dao = new LoginDAO();
            Usuario datos = dao.Login_datos(usu, cla);
            if (datos != null) {
                request.changeSessionId();
                HttpSession sesion = request.getSession(true);
                sesion.setAttribute("usuarioLogueado", datos);
                sesion.setAttribute("nUsuario", datos.getUsuario());
                sesion.setAttribute("idUsuario", datos.getIdentificacion());
                sesion.setAttribute("idPerfil", datos.getIdperfil());
                response.sendRedirect("cpanel.jsp");
            } else {
                int estado = dao.estadoUsuarioConClave(usu, cla);
                if (estado == 2) {
                    request.setAttribute("error", "Tu solicitud está siendo investigada. En unos momentos se te dará acceso al sistema si es aprobada.");
                } else if (estado == 3) {
                    request.setAttribute("error", "Su solicitud ha sido rechazada.");
                } else {
                    request.setAttribute("error", "Usuario o contraseña incorrectos.");
                }
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("index.jsp");
        }
    }
    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { response.sendRedirect("index.jsp"); }
}
