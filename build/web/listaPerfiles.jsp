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

    if (actual.getIdperfil() != 1) {
        response.sendRedirect("front.jsp");
        return;
    }

    UsuarioDAO usuarioDAO = new UsuarioDAO();

    List<Usuario> todos = usuarioDAO.listadoTodosLosUsuarios();

    List<Usuario> administradores = new ArrayList<Usuario>();
    List<Usuario> neurologos = new ArrayList<Usuario>();
    List<Usuario> pacientes = new ArrayList<Usuario>();

    if (todos != null) {
        for (Usuario u : todos) {

            if (u.getIdestado() == 1) {

                if (u.getIdperfil() == 1) {
                    administradores.add(u);

                } else if (u.getIdperfil() == 2) {
                    neurologos.add(u);

                } else if (u.getIdperfil() == 3) {
                    pacientes.add(u);
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <title>Roles del Sistema</title>

    <link rel="stylesheet" href="css/estilos.css">

</head>

<body>

<div class="page">

    <!-- ENCABEZADO -->

    <div class="page-header">

        <div>

            <h1>Roles del Sistema</h1>

            <p class="muted">
                Usuarios activos registrados en NeuroCitas.
            </p>

        </div>

    </div>


    <div class="roles-grid mt-20">


        <!-- ================================================= -->
        <!-- ADMINISTRADORES -->
        <!-- ================================================= -->

        <div class="role-card">

            <div class="role-icon admin-icon">
                A
            </div>

            <div class="role-content">

                <h3>Administrador</h3>


                <div class="active-section">

                    <h4>Administradores activos</h4>


                    <% if (administradores.isEmpty()) { %>

                        <p class="empty-text">

                            No hay administradores activos registrados.

                        </p>


                    <% } else { %>


                        <div class="mini-table">

                            <table>

                                <thead>

                                    <tr>

                                        <th>
                                            Identificación
                                        </th>

                                        <th>
                                            Nombre
                                        </th>

                                        <th>
                                            Usuario
                                        </th>

                                        <th>
                                            Correo
                                        </th>

                                        <th>
                                            Teléfono
                                        </th>

                                    </tr>

                                </thead>


                                <tbody>


                                <% for (Usuario u : administradores) { %>


                                    <tr>

                                        <td>
                                            <%= u.getIdentificacion() %>
                                        </td>


                                        <td>

                                            <%= u.getNombre() %>
                                            <%= u.getApellido() %>

                                        </td>


                                        <td>
                                            <%= u.getUsuario() %>
                                        </td>


                                        <td>
                                            <%= u.getEmail() %>
                                        </td>


                                        <td>
                                            <%= u.getTelefono() %>
                                        </td>

                                    </tr>


                                <% } %>


                                </tbody>

                            </table>

                        </div>


                    <% } %>


                </div>

            </div>

        </div>



        <!-- ================================================= -->
        <!-- NEURÓLOGOS -->
        <!-- ================================================= -->

        <div class="role-card">

            <div class="role-icon doctor-icon">
                N
            </div>


            <div class="role-content">

                <h3>Neurólogo</h3>


                <div class="active-section">

                    <h4>Neurólogos activos</h4>


                    <% if (neurologos.isEmpty()) { %>


                        <p class="empty-text">

                            No hay neurólogos activos registrados.

                        </p>


                    <% } else { %>


                        <div class="mini-table">


                            <table>


                                <thead>


                                    <tr>

                                        <th>
                                            Identificación
                                        </th>

                                        <th>
                                            Nombre
                                        </th>

                                        <th>
                                            Especialidad
                                        </th>

                                        <th>
                                            Correo
                                        </th>

                                        <th>
                                            Teléfono
                                        </th>

                                    </tr>


                                </thead>


                                <tbody>


                                <% for (Usuario u : neurologos) { %>


                                    <tr>


                                        <td>

                                            <%= u.getIdentificacion() %>

                                        </td>


                                        <td>

                                            Dr(a).
                                            <%= u.getNombre() %>
                                            <%= u.getApellido() %>

                                        </td>


                                        <td>

                                            <%= (u.getEspecialidad() != null
                                                    && !u.getEspecialidad().trim().isEmpty())
                                                    ? u.getEspecialidad()
                                                    : "Sin especialidad registrada" %>

                                        </td>


                                        <td>

                                            <%= u.getEmail() %>

                                        </td>


                                        <td>

                                            <%= u.getTelefono() %>

                                        </td>


                                    </tr>


                                <% } %>


                                </tbody>


                            </table>


                        </div>


                    <% } %>


                </div>


            </div>


        </div>



        <!-- ================================================= -->
        <!-- PACIENTES -->
        <!-- ================================================= -->

        <div class="role-card">


            <div class="role-icon patient-icon">
                P
            </div>


            <div class="role-content">


                <h3>Paciente</h3>


                <div class="active-section">


                    <h4>Pacientes activos</h4>


                    <% if (pacientes.isEmpty()) { %>


                        <p class="empty-text">

                            No hay pacientes activos registrados.

                        </p>


                    <% } else { %>


                        <div class="mini-table">


                            <table>


                                <thead>


                                    <tr>

                                        <th>
                                            Identificación
                                        </th>

                                        <th>
                                            Nombre
                                        </th>

                                        <th>
                                            Usuario
                                        </th>

                                        <th>
                                            Correo
                                        </th>

                                        <th>
                                            Teléfono
                                        </th>


                                    </tr>


                                </thead>


                                <tbody>


                                <% for (Usuario u : pacientes) { %>


                                    <tr>


                                        <td>

                                            <%= u.getIdentificacion() %>

                                        </td>


                                        <td>

                                            <%= u.getNombre() %>
                                            <%= u.getApellido() %>

                                        </td>


                                        <td>

                                            <%= u.getUsuario() %>

                                        </td>


                                        <td>

                                            <%= u.getEmail() %>

                                        </td>


                                        <td>

                                            <%= u.getTelefono() %>

                                        </td>


                                    </tr>


                                <% } %>


                                </tbody>


                            </table>


                        </div>


                    <% } %>


                </div>


            </div>


        </div>


    </div>


</div>


</body>

</html>