<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Cita"%>
<%@page import="modelo.CitaDAO"%>
<%@page import="java.util.List"%>

<%
    Usuario actual = (Usuario) session.getAttribute("usuarioLogueado");

    if (actual == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    if (actual.getIdperfil() != 3) {
        response.sendRedirect("front.jsp");
        return;
    }

    CitaDAO citaDAO = new CitaDAO();
    List<Cita> lista = citaDAO.listarPorCliente(actual.getIdentificacion());
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis citas</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body>

<div class="page">

    <div class="page-header">
        <div>
            <h1>Mis citas</h1>
            <p class="muted">
                Consulta las citas que has solicitado dentro del sistema NeuroCitas.
            </p>
        </div>
    </div>

    <div class="card mt-20">

        <div class="table-header">
            <div>
                <h2>Citas registradas</h2>
                <p class="muted">
                    Aquí puedes revisar el neurólogo, servicio, fecha, hora y estado de tus citas.
                </p>
            </div>
        </div>

        <div class="table-responsive">

            <table class="table">

                <thead>
                    <tr>
                        <th>Neurólogo</th>
                        <th>Servicio</th>
                        <th>Fecha</th>
                        <th>Hora</th>
                        <th>Estado</th>
                        <th>Observación</th>
                        <th>Acciones</th>
                    </tr>
                </thead>

                <tbody>

                    <% if (lista == null || lista.isEmpty()) { %>

                        <tr>
                            <td colspan="7" class="empty-state">
                                Todavía no tienes citas registradas.
                            </td>
                        </tr>

                    <% } else { %>

                        <% for (Cita c : lista) { %>

                            <tr>
                                <td>
                                    Dr(a). <%= c.getNombreDoctor() %>
                                </td>

                                <td>
                                    <%= c.getNombreServicio() %>
                                </td>

                                <td>
                                    <%= c.getFecha() %>
                                </td>

                                <td>
                                    <%= c.getHora() %>
                                </td>

                                <td>
                                    <span class="badge">
                                        <%= c.getEstado() %>
                                    </span>
                                </td>

                                <td>
                                    <%= c.getObservacion() != null && !c.getObservacion().trim().isEmpty()
                                        ? c.getObservacion()
                                        : "Sin observación" %>
                                </td>

                                <td>
                                    <% if (!"Cancelada".equalsIgnoreCase(c.getEstado()) 
                                            && !"Atendida".equalsIgnoreCase(c.getEstado())) { %>

                                        <a class="btn danger"
                                           href="CancelarCita?id=<%= c.getIdCita() %>&volver=misCitasPaciente.jsp"
                                           onclick="return confirm('¿Seguro que deseas cancelar esta cita?')">
                                            Cancelar
                                        </a>

                                    <% } else { %>

                                        <span class="muted">
                                            Sin acciones
                                        </span>

                                    <% } %>
                                </td>
                            </tr>

                        <% } %>

                    <% } %>

                </tbody>

            </table>

        </div>

    </div>

</div>

</body>
</html>