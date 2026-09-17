package controlador;
import jakarta.servlet.*; import jakarta.servlet.http.*; import java.io.IOException;
public class SecurityFilter implements Filter {
    @Override public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req=(HttpServletRequest)request; HttpServletResponse res=(HttpServletResponse)response;
        String uri=req.getRequestURI();
        boolean publico = uri.endsWith("index.jsp") || uri.endsWith("registro.jsp") || uri.endsWith("solicitudDoctor.jsp") || uri.endsWith("CtrolValidar") || uri.endsWith("ControladorRegistro") || uri.endsWith("ControladorSolicitudDoctor") || uri.contains("/css/") || uri.contains("/img/");
        HttpSession s=req.getSession(false);
        boolean logueado = s!=null && s.getAttribute("usuarioLogueado")!=null;
        if(!publico && !logueado){res.sendRedirect(req.getContextPath()+"/index.jsp"); return;}
        chain.doFilter(request,response);
    }
}
