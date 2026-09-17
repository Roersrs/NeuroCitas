package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Usuario;
import modelo.UsuarioDAO;
import org.mindrot.jbcrypt.BCrypt;

public class ControladorUsuario extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String identificacion = request.getParameter("cidentificacion");
        String nombre = request.getParameter("cnombre");
        String apellido = request.getParameter("capellido");
        String email = request.getParameter("cmail");
        String telefono = request.getParameter("ctelefono");
        String usuario = request.getParameter("cusuario");
        String clave = request.getParameter("cclave");
        int idPerfil = Integer.parseInt(request.getParameter("cidperfil"));

        if (!validarNumero10(identificacion) || !validarTelefono(telefono) || !validarClave(clave)) {
            response.getWriter().println("Error: identificación y teléfono deben tener máximo 10 números. La contraseña debe tener mínimo 8 caracteres, una mayúscula, un número y un símbolo.");
            return;
        }

        Usuario u = new Usuario();
        u.setIdentificacion(identificacion);
        u.setNombre(nombre);
        u.setApellido(apellido);
        u.setEmail(email);
        u.setTelefono(telefono);
        u.setUsuario(usuario);
        u.setClave(BCrypt.hashpw(clave, BCrypt.gensalt()));
        u.setIdperfil(idPerfil);

        int ok = new UsuarioDAO().agregarUsuario(u);

        if (ok > 0) {
            response.sendRedirect("listaUsuarios.jsp");
        } else {
            response.getWriter().println("Error al registrar usuario. Revise consola/MySQL.");
        }
    }

    private boolean validarNumero10(String valor) {
        return valor != null && valor.matches("\\d{1,10}");
    }

    private boolean validarTelefono(String valor) {
        return valor == null || valor.trim().isEmpty() || valor.matches("\\d{1,10}");
    }

    private boolean validarClave(String clave) {
        return clave != null
                && clave.length() >= 8
                && clave.matches(".*[A-Z].*")
                && clave.matches(".*[0-9].*")
                && clave.matches(".*[^A-Za-z0-9].*");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("regUsuario.jsp");
    }
}
