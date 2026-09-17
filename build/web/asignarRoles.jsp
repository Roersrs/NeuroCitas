<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.*"%>
<%@page import="java.util.*"%>
<%
    Usuario actual = (Usuario) session.getAttribute("usuarioLogueado");
    if (actual == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    if (actual.getIdperfil() != 1) {
        response.sendRedirect("front.jsp");
        return;
    }
    List<Usuario> lista = new UsuarioDAO().listadoDatos();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/estilos.css">
    <title>Asignar roles</title>
</head>
<body>
<div class="page">
    <div class="topbar">
        <div>
            <h2>Asignar roles</h2>
            <p class="muted">Aquí puedes cambiar el rol de las cuentas registradas: Cliente, Doctor o Administrador.</p>
        </div>
        <a class="btn secondary" href="front.jsp">Inicio</a>
    </div>

    <% if (request.getParameter("ok") != null) { %>
        <div class="msg ok">Rol actualizado correctamente.</div>
    <% } %>
    <% if (request.getParameter("error") != null) { %>
        <div class="msg error">No se pudo actualizar el rol. Revisa la consola o intenta nuevamente.</div>
    <% } %>

    <div class="card">
        <h3>Cuentas registradas</h3>
        <p class="muted">Los clientes nuevos se registran como Cliente. Desde este apartado el administrador puede convertirlos en Doctor o Administrador.</p>
        <table class="table roles-table">
            <tr>
                <th>Identificación</th>
                <th>Nombre</th>
                <th>Usuario</th>
                <th>Rol actual</th>
                <th>Nuevo rol</th>
                <th>Acción</th>
            </tr>
            <% for (Usuario u : lista) {
                String perfil = u.getIdperfil()==1 ? "Administrador" : u.getIdperfil()==2 ? "Doctor" : "Cliente";
            %>
            <tr>
                <td><%=u.getIdentificacion()%></td>
                <td><%=u.getNombre()%> <%=u.getApellido()%></td>
                <td><%=u.getUsuario()%></td>
                <td><span class="role-badge role-<%=u.getIdperfil()%>"><%=perfil%></span></td>
                <td>
                    <form action="CambiarRolUsuario" method="post" class="inline-form">
                        <input type="hidden" name="identificacion" value="<%=u.getIdentificacion()%>">
                        <select name="idperfil" required>
                            <option value="3" <%=u.getIdperfil()==3?"selected":""%>>Cliente</option>
                            <option value="2" <%=u.getIdperfil()==2?"selected":""%>>Doctor</option>
                            <option value="1" <%=u.getIdperfil()==1?"selected":""%>>Administrador</option>
                        </select>
                </td>
                <td>
                        <button type="submit">Actualizar rol</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
    </div>
</div>
</body>
</html>
