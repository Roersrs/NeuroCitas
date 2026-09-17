package controlador;
import java.io.IOException; import jakarta.servlet.*; import jakarta.servlet.http.*; import modelo.UsuarioDAO;
public class EliminarUsuario extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException{String id=request.getParameter("id"); int ok=new UsuarioDAO().eliminarDatos(id); response.sendRedirect("listaUsuarios.jsp");}
    @Override protected void doGet(HttpServletRequest request,HttpServletResponse response)throws ServletException,IOException{processRequest(request,response);} @Override protected void doPost(HttpServletRequest request,HttpServletResponse response)throws ServletException,IOException{processRequest(request,response);}
}
