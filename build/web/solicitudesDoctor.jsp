<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.UsuarioDAO"%>
<%@page import="java.util.List"%>

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

    UsuarioDAO usuarioDAO = new UsuarioDAO();
    List<Usuario> lista = usuarioDAO.listarSolicitudesDoctor();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>NeuroCitas - Solicitudes de Neurólogos</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body>

<div class="page">

    <div class="topbar">
        <div>
            <h2>Solicitudes de Neurólogos</h2>
            <p class="muted">
                Revisa las cuentas que pidieron acceso como neurólogo.
                Puedes aprobarlas o rechazarlas.
            </p>
        </div>

        <a class="btn secondary" href="front.jsp">Inicio</a>
    </div>

    <% if (request.getParameter("ok") != null) { %>
        <div class="msg ok">Solicitud actualizada correctamente.</div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
        <div class="msg error">No se pudo actualizar la solicitud.</div>
    <% } %>

    <div class="card">

        <h3>Solicitudes pendientes y rechazadas</h3>

        <p class="muted">
            Si apruebas una solicitud, la cuenta quedará activa como neurólogo
            y podrá iniciar sesión.
        </p>

        <table class="table roles-table">
            <thead>
                <tr>
                    <th>Identificación</th>
                    <th>Nombre</th>
                    <th>Usuario</th>
                    <th>Correo</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
            </thead>

            <tbody>

            <% if (lista == null || lista.isEmpty()) { %>

                <tr>
                    <td colspan="6">
                        No hay solicitudes de neurólogo por revisar.
                    </td>
                </tr>

            <% } else { %>

                <% for (Usuario u : lista) { 
                    String estadoTexto = "";
                    String claseEstado = "";

                    if (u.getIdestado() == 2) {
                        estadoTexto = "Pendiente";
                        claseEstado = "pendiente";
                    } else if (u.getIdestado() == 3) {
                        estadoTexto = "Rechazada";
                        claseEstado = "rechazada";
                    } else {
                        estadoTexto = "Otro";
                        claseEstado = "otro";
                    }
                %>

                <tr>
                    <td><%= u.getIdentificacion() %></td>

                    <td>
                        <%= u.getNombre() %> <%= u.getApellido() %>
                    </td>

                    <td><%= u.getUsuario() %></td>

                    <td><%= u.getEmail() %></td>

                    <td>
                        <span class="badge <%= claseEstado %>">
                            <%= estadoTexto %>
                        </span>
                    </td>

                    <td>
                        <form action="GestionSolicitudDoctor" method="post" class="inline-form">

                            <input type="hidden" name="identificacion" value="<%= u.getIdentificacion() %>">

                            <button class="ok" type="submit" name="accion" value="aprobar">
                                Aprobar
                            </button>

                            <button class="danger" type="submit" name="accion" value="rechazar">
                                Rechazar
                            </button>

                        </form>
                    </td>
                </tr>

                <% } %>

            <% } %>

            </tbody>
        </table>

    </div>

</div>

</body>
</html>