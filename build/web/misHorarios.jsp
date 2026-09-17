<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Horario"%>
<%@page import="modelo.HorarioDAO"%>
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

    HorarioDAO horarioDAO = new HorarioDAO();
    List<Horario> lista = horarioDAO.listarPorDoctor(actual.getIdentificacion());

    String ok = request.getParameter("ok");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis horarios</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body>

<div class="page">

    <div class="page-header">
        <div>
            <h1>Mis horarios</h1>
            <p class="muted">
                Crea y consulta tus horarios de atención disponibles para los pacientes.
            </p>
        </div>
    </div>

    <% if ("agregado".equals(ok)) { %>
        <div class="msg ok">Horario agregado correctamente.</div>
    <% } else if ("eliminado".equals(ok)) { %>
        <div class="msg ok">Horario eliminado correctamente.</div>
    <% } %>

    <% if ("campos".equals(error)) { %>
        <div class="msg error">Completa todos los campos del horario.</div>
    <% } else if ("hora".equals(error)) { %>
        <div class="msg error">La hora de inicio debe ser menor que la hora de fin.</div>
    <% } else if ("cruce".equals(error)) { %>
        <div class="msg error">Ya tienes un horario registrado que se cruza con esa hora.</div>
    <% } else if ("guardar".equals(error)) { %>
        <div class="msg error">No se pudo guardar el horario.</div>
    <% } else if ("eliminar".equals(error)) { %>
        <div class="msg error">No se pudo eliminar el horario.</div>
    <% } %>

    <div class="card mt-20">

        <div class="table-header">
            <div>
                <h2>Crear nuevo horario</h2>
                <p class="muted">
                    Define el día y el rango de horas en el que puedes atender pacientes.
                </p>
            </div>
        </div>

        <form action="ControladorMisHorarios" method="post">

            <input type="hidden" name="accion" value="agregar">

            <div class="form-grid">

                <div>
                    <label>Día de atención</label>
                    <select name="diaSemana" required>
                        <option value="">Seleccione un día</option>
                        <option value="Lunes">Lunes</option>
                        <option value="Martes">Martes</option>
                        <option value="Miércoles">Miércoles</option>
                        <option value="Jueves">Jueves</option>
                        <option value="Viernes">Viernes</option>
                        <option value="Sábado">Sábado</option>
                        <option value="Domingo">Domingo</option>
                    </select>
                </div>

                <div>
                    <label>Hora de inicio</label>
                    <input type="time" name="horaInicio" required>
                </div>

                <div>
                    <label>Hora de fin</label>
                    <input type="time" name="horaFin" required>
                </div>

            </div>

            <div style="margin-top: 20px;">
                <button type="submit" class="btn">
                    Guardar horario
                </button>
            </div>

        </form>

    </div>

    <div class="card mt-20">

        <div class="table-header">
            <div>
                <h2>Horarios registrados</h2>
                <p class="muted">
                    Estos son los horarios que has creado para tu atención médica.
                </p>
            </div>
        </div>

        <div class="table-responsive">

            <table class="table">

                <thead>
                    <tr>
                        <th>Día</th>
                        <th>Hora de inicio</th>
                        <th>Hora de fin</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>

                <tbody>

                    <% if (lista == null || lista.isEmpty()) { %>

                        <tr>
                            <td colspan="5" class="empty-state">
                                Todavía no tienes horarios registrados.
                            </td>
                        </tr>

                    <% } else { %>

                        <% for (Horario h : lista) { %>

                            <tr>
                                <td><%= h.getDiaSemana() %></td>

                                <td><%= h.getHoraInicio() %></td>

                                <td><%= h.getHoraFin() %></td>

                                <td>
                                    <span class="badge activo">
                                        Activo
                                    </span>
                                </td>

                                <td>
                                    <form action="ControladorMisHorarios"
                                          method="post"
                                          style="display:inline;">

                                        <input type="hidden" name="accion" value="eliminar">

                                        <input type="hidden"
                                               name="idHorario"
                                               value="<%= h.getIdHorario() %>">

                                        <button type="submit"
                                                class="btn danger"
                                                onclick="return confirm('¿Seguro que deseas eliminar este horario?')">
                                            Eliminar
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

</div>

</body>
</html>