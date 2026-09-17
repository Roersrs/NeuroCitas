<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.UsuarioDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%
    Usuario actual = (Usuario) session.getAttribute("usuarioLogueado");

    if (actual == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    if (actual.getIdperfil() != 1 && actual.getIdperfil() != 2) {
        response.sendRedirect("front.jsp");
        return;
    }

    UsuarioDAO usuarioDAO = new UsuarioDAO();

    String cedulaBuscar = request.getParameter("cedula");
    List<Usuario> pacientes = new ArrayList<Usuario>();

    if (cedulaBuscar != null && !cedulaBuscar.trim().isEmpty()) {

        Usuario pacienteEncontrado = usuarioDAO.listadoDatos_Id(cedulaBuscar.trim());

        if (pacienteEncontrado != null 
                && pacienteEncontrado.getIdperfil() == 3 
                && pacienteEncontrado.getIdestado() == 1) {

            pacientes.add(pacienteEncontrado);
        }

    } else {

        if (actual.getIdperfil() == 2) {
            pacientes = usuarioDAO.listarPacientesDeDoctor(actual.getIdentificacion());
        } else {
            pacientes = usuarioDAO.listarPacientes();
        }
    }

    String limpiar = request.getParameter("limpiar");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historia clínica</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body>

<div class="page">

    <div class="page-header">
        <div>
            <h1>Historia clínica</h1>
            <p class="muted">
                Busca un paciente por cédula para crear, consultar o actualizar su historia clínica.
            </p>
        </div>
    </div>

    <div class="card mt-20">

        <h2>Buscar paciente</h2>

        <p class="muted">
            Ingresa la cédula del paciente para consultar directamente su historial clínico.
        </p>

        <form action="buscarHistoria.jsp" method="get">

            <div class="form-grid">

                <div>
                    <label>Cédula del paciente</label>
                    <input type="text"
                           name="cedula"
                           maxlength="20"
                           placeholder="Ej: 1105782166"
                           value="<%= cedulaBuscar != null ? cedulaBuscar : "" %>">
                </div>

                <div style="display:flex; align-items:end; gap:10px;">
                    <button type="submit" class="btn">
                        Buscar
                    </button>

                    <a href="buscarHistoria.jsp" class="btn secondary">
                        Ver todos
                    </a>
                </div>

            </div>

        </form>

    </div>

    <div class="card mt-20">

        <div class="table-header">
            <div>
                <h2>Pacientes disponibles</h2>

                <p class="muted">
                    <% if (cedulaBuscar != null && !cedulaBuscar.trim().isEmpty()) { %>
                        Resultado de búsqueda para la cédula:
                        <strong><%= cedulaBuscar %></strong>
                    <% } else if (actual.getIdperfil() == 2) { %>
                        Aquí aparecen los pacientes que tienen o han tenido citas contigo.
                    <% } else { %>
                        Aquí aparecen todos los pacientes activos del sistema.
                    <% } %>
                </p>
            </div>
        </div>

        <div class="table-responsive">

            <table class="table">

                <thead>
                    <tr>
                        <th>Identificación</th>
                        <th>Paciente</th>
                        <th>Usuario</th>
                        <th>Correo</th>
                        <th>Teléfono</th>
                        <th>Acciones</th>
                    </tr>
                </thead>

                <tbody>

                    <% if (pacientes == null || pacientes.isEmpty()) { %>

                        <tr>
                            <td colspan="6" class="empty-state">
                                <% if (cedulaBuscar != null && !cedulaBuscar.trim().isEmpty()) { %>
                                    No se encontró ningún paciente activo con esa cédula.
                                <% } else { %>
                                    No hay pacientes disponibles para historia clínica.
                                <% } %>
                            </td>
                        </tr>

                    <% } else { %>

                        <% for (Usuario p : pacientes) { %>

                            <tr>
                                <td><%= p.getIdentificacion() %></td>

                                <td>
                                    <strong><%= p.getNombre() %> <%= p.getApellido() %></strong>
                                </td>

                                <td><%= p.getUsuario() %></td>

                                <td><%= p.getEmail() %></td>

                                <td><%= p.getTelefono() %></td>

                                <td>
                                    <a class="btn"
                                       href="historiaPaciente.jsp?idPaciente=<%= p.getIdentificacion() %>">
                                        Ver historial
                                    </a>
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