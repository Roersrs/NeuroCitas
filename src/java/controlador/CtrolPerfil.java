package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Perfil;
import modelo.PerfilDAO;
import java.io.IOException;

public class CtrolPerfil extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");
        PerfilDAO dao = new PerfilDAO();

        if (accion.equals("agregar")) {
            Perfil p = new Perfil();
            p.setPerfil(request.getParameter("cperfil"));
            int status = dao.agregarPerfil(p);
            if (status > 0) response.sendRedirect("listaPerfiles.jsp");

        } else if (accion.equals("editar")) {
            Perfil p = new Perfil();
            p.setId_perfil(Integer.parseInt(request.getParameter("cid_perfil")));
            p.setPerfil(request.getParameter("cperfil"));
            int status = dao.actualizarPerfil(p);
            if (status > 0) response.sendRedirect("listaPerfiles.jsp");

        } else if (accion.equals("eliminar")) {
            int status = dao.eliminarPerfil(Integer.parseInt(request.getParameter("id")));
            if (status > 0) response.sendRedirect("listaPerfiles.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }
}
