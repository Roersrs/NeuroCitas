package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Usuario;
import modelo.UsuarioDAO;
import org.mindrot.jbcrypt.BCrypt;

public class EditarUsuario extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Usuario u = new Usuario();

        u.setIdentificacion(request.getParameter("cidentificacion"));
        u.setNombre(request.getParameter("cnombre"));
        u.setApellido(request.getParameter("capellido"));
        u.setEmail(request.getParameter("cmail"));
        u.setTelefono(request.getParameter("ctelefono"));
        u.setUsuario(request.getParameter("cusuario"));

        int idPerfil = Integer.parseInt(request.getParameter("cidperfil"));
        int idEstado = Integer.parseInt(request.getParameter("cidestado"));

        u.setIdperfil(idPerfil);
        u.setIdestado(idEstado);

        String clave = request.getParameter("cclave");

        UsuarioDAO dao = new UsuarioDAO();
        int resultado;

        if (clave != null && !clave.trim().isEmpty()) {
            String claveEncriptada = BCrypt.hashpw(clave, BCrypt.gensalt());
            u.setClave(claveEncriptada);
            resultado = dao.actualizarDatos(u);
        } else {
            resultado = dao.actualizarDatosSinClave(u);
        }

        if (resultado > 0) {
            response.sendRedirect("listaUsuarios.jsp");
        } else {
            response.getWriter().println("Error al editar usuario.");
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
        response.sendRedirect("listaUsuarios.jsp");
    }
}