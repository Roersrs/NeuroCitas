<%@page import="modelo.GesActividad"%>
<%@page import="modelo.GesActividadDAO"%>
<%@page import="modelo.Perfil"%>
<%@page import="modelo.PerfilDAO"%>
<%@page import="modelo.Actividades"%>
<%@page import="modelo.ActividadesDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    PerfilDAO pdao = new PerfilDAO();
    List<Perfil> listaPerfiles = pdao.listadoPerfiles();

    ActividadesDAO adao = new ActividadesDAO();
    List<Actividades> listaActs = adao.listadoActividades();

    GesActividadDAO gdao = new GesActividadDAO();
    List<GesActividad> lista = gdao.listadoGesActividades();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Actividades por Perfil</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <div class="page">

        <div class="page-header">
            <div>
                <h1>Gestión de Actividades por Perfil</h1>
                <p class="muted">Asigna permisos y módulos a cada perfil del sistema.</p>
            </div>
        </div>

        <div class="grid-2">
            <div class="card">
                <h2>Asignar actividad</h2>
                <p class="muted">Selecciona un perfil y asígnale una actividad o módulo.</p>

                <form method="post" action="CtrolGesActividad">
                    <input type="hidden" name="accion" value="agregar"/>

                    <div class="campo">
                        <label for="cid_perfil">Perfil</label>
                        <select name="cid_perfil" id="cid_perfil" required>
                            <option value="">Seleccione un perfil</option>
                            <% for (Perfil p : listaPerfiles) { %>
                                <option value="<%=p.getId_perfil()%>"><%=p.getPerfil()%></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="campo">
                        <label for="cid_actividad">Actividad</label>
                        <select name="cid_actividad" id="cid_actividad" required>
                            <option value="">Seleccione una actividad</option>
                            <% for (Actividades a : listaActs) { %>
                                <option value="<%=a.getId_actividad()%>"><%=a.getNom_actividad()%></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn ok">Asignar actividad</button>
                    </div>
                </form>
            </div>

            <div class="card">
                <h2>Resumen</h2>
                <div class="mini-stats">
                    <div class="mini-stat">
                        <span class="mini-stat-label">Perfiles</span>
                        <strong><%= listaPerfiles != null ? listaPerfiles.size() : 0 %></strong>
                    </div>
                    <div class="mini-stat">
                        <span class="mini-stat-label">Actividades</span>
                        <strong><%= listaActs != null ? listaActs.size() : 0 %></strong>
                    </div>
                    <div class="mini-stat">
                        <span class="mini-stat-label">Asignaciones</span>
                        <strong><%= lista != null ? lista.size() : 0 %></strong>
                    </div>
                </div>
                <p class="muted" style="margin-top:16px;">
                    Este módulo define qué opciones aparecen en el menú según el perfil del usuario.
                </p>
            </div>
        </div>

        <div class="card mt-20">
            <div class="table-header">
                <div>
                    <h2>Asignaciones registradas</h2>
                    <p class="muted">Consulta, edita o elimina las actividades asignadas a cada perfil.</p>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th style="width: 90px;">ID</th>
                            <th style="width: 120px;">ID Perfil</th>
                            <th style="width: 140px;">ID Actividad</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (lista != null && !lista.isEmpty()) { %>
                            <% for (GesActividad g : lista) { %>
                                <tr>
                                    <td><%= g.getIdgesActividad() %></td>
                                    <td><%= g.getId_perfil() %></td>
                                    <td><%= g.getId_actividad() %></td>
                                    <td>
                                        <div class="table-actions">
                                            <a class="btn" href="EditarGesActividad.jsp?id=<%=g.getIdgesActividad()%>" target="contenido">Editar</a>
                                            <a class="btn danger"
                                               href="CtrolGesActividad?accion=eliminar&id=<%=g.getIdgesActividad()%>"
                                               onclick="return confirm('¿Seguro que deseas eliminar esta asignación?')">Eliminar</a>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        <% } else { %>
                            <tr>
                                <td colspan="4" class="empty-state">No hay asignaciones registradas.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</body>
</html>
