package controlador;
import java.io.IOException; import jakarta.servlet.*; import jakarta.servlet.http.*;
public class CerrarSesion extends HttpServlet { @Override protected void doGet(HttpServletRequest request,HttpServletResponse response)throws ServletException,IOException{HttpSession s=request.getSession(false); if(s!=null)s.invalidate(); response.sendRedirect("index.jsp");} @Override protected void doPost(HttpServletRequest request,HttpServletResponse response)throws ServletException,IOException{doGet(request,response);} }
