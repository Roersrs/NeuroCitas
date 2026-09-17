package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Usuario;
import modelo.UsuarioDAO;
import org.mindrot.jbcrypt.BCrypt;

public class ControladorSolicitudDoctor extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String identificacion = request.getParameter("cidentificacion");
        String nombre = request.getParameter("cnombre");
        String apellido = request.getParameter("capellido");
        String email = request.getParameter("cmail");
        String telefono = request.getParameter("ctelefono");
        String especialidad = request.getParameter("cespecialidad");
        String usuario = request.getParameter("cusuario");
        String clave = request.getParameter("cclave");

        if (!validarNumero10(identificacion)
                || !validarNumero10(telefono)
                || !validarClave(clave)
                || !validarEspecialidad(especialidad)) {

            response.sendRedirect("solicitudDoctor.jsp?error=validacion");
            return;
        }

        Usuario u = new Usuario();

        u.setIdentificacion(identificacion);
        u.setNombre(nombre);
        u.setApellido(apellido);
        u.setEmail(email);
        u.setTelefono(telefono);
        u.setEspecialidad(especialidad);
        u.setUsuario(usuario);
        u.setClave(BCrypt.hashpw(clave, BCrypt.gensalt()));
        u.setIdperfil(2);
        u.setIdestado(2);

        int ok = new UsuarioDAO().agregarSolicitudDoctor(u);

        if (ok > 0) {
            response.sendRedirect("index.jsp?solicitud=doctor");
        } else {
            response.sendRedirect("solicitudDoctor.jsp?error=1");
        }
    }

    private boolean validarNumero10(String valor) {
        return valor != null && valor.matches("\\d{1,10}");
    }

    private boolean validarClave(String clave) {
        return clave != null
                && clave.length() >= 8
                && clave.matches(".*[A-Z].*")
                && clave.matches(".*[0-9].*")
                && clave.matches(".*[^A-Za-z0-9].*");
    }

    private boolean validarEspecialidad(String especialidad) {
        if (especialidad == null || especialidad.trim().isEmpty()) {
            return false;
        }

        return especialidad.equals("Neurología clínica")
                || especialidad.equals("Neurología pediátrica")
                || especialidad.equals("Epileptología")
                || especialidad.equals("Neurofisiología clínica")
                || especialidad.equals("Neuropsicología")
                || especialidad.equals("Trastornos del movimiento")
                || especialidad.equals("Cefaleas y migraña")
                || especialidad.equals("Enfermedad cerebrovascular")
                || especialidad.equals("Neuroinmunología")
                || especialidad.equals("Demencias y deterioro cognitivo");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("solicitudDoctor.jsp");
    }
}