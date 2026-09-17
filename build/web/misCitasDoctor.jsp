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

    if (actual.getIdperfil() != 2) {
        response.sendRedirect("front.jsp");
        return;
    }

    CitaDAO citaDAO = new CitaDAO();
    List<Cita> lista = citaDAO.listarPorDoctor(actual.getIdentificacion());

    String ok = request.getParameter("ok");
    String error = request.getParameter("error");
    String estado = request.getParameter("estado");
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
                Consulta las citas asignadas a tu perfil como neurólogo.
            </p>
        </div>
    </div>

    <% if ("estado".equals(ok)) { %>
        <div class="msg ok">
            El estado de la cita fue actualizado correctamente
            <% if (estado != null) { %>
                a <strong><%= estado %></strong>.
            <% } else { %>
                .
            <% } %>
        </div>
    <% } %>

    <% if ("estado".equals(error)) { %>
        <div class="msg error">
            No se pudo actualizar el estado de la cita.
        </div>
    <% } %>

    <div class="card mt-20">

        <div class="table-header">
            <div>
                <h2>Citas asignadas</h2>
                <p class="muted">
                    Aquí puedes revisar los pacientes agendados, el servicio solicitado,
                    la fecha, la hora y el estado de cada cita.
                </p>
            </div>
        </div>

        <div class="table-responsive">

            <table class="table">

                <thead>
                    <tr>
                        <th>Paciente</th>
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
                                Todavía no tienes citas asignadas.
                            </td>
                        </tr>

                    <% } else { %>

                        <% for (Cita c : lista) { %>

                            <tr>
                                <td><%= c.getNombreCliente() %></td>

                                <td><%= c.getNombreServicio() %></td>

                                <td><%= c.getFecha() %></td>

                                <td><%= c.getHora() %></td>

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
                                    <div class="table-actions">

                                        <% if (!"Atendida".equalsIgnoreCase(c.getEstado())) { %>

                                            <a class="btn"
                                               href="CambiarEstadoCita?id=<%= c.getIdCita() %>&estado=Atendida&volver=misCitasDoctor.jsp">
                                                Marcar atendida
                                            </a>

                                        <% } %>

                                        <% if (!"Pendiente".equalsIgnoreCase(c.getEstado())) { %>

                                            <a class="btn secondary"
                                               href="CambiarEstadoCita?id=<%= c.getIdCita() %>&estado=Pendiente&volver=misCitasDoctor.jsp">
                                                Pendiente
                                            </a>

                                        <% } %>

                                        <% if (!"Cancelada".equalsIgnoreCase(c.getEstado())) { %>

                                            <a class="btn danger"
                                               href="CambiarEstadoCita?id=<%= c.getIdCita() %>&estado=Cancelada&volver=misCitasDoctor.jsp"
                                               onclick="return confirm('¿Seguro que deseas cancelar esta cita?')">
                                                Cancelar
                                            </a>

                                        <% } %>

                                    </div>
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