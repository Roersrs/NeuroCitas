<%@page import="modelo.GesActividad"%>
<%@page import="modelo.GesActividadDAO"%>
<%@page import="modelo.Perfil"%>
<%@page import="modelo.PerfilDAO"%>
<%@page import="modelo.Actividades"%>
<%@page import="modelo.ActividadesDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int id = Integer.parseInt(request.getParameter("id"));

    GesActividadDAO gdao = new GesActividadDAO();
    GesActividad g = gdao.listadoGesActividad_Id(id);

    PerfilDAO pdao = new PerfilDAO();
    List<Perfil> listaPerfiles = pdao.listadoPerfiles();

    ActividadesDAO adao = new ActividadesDAO();
    List<Actividades> listaActs = adao.listadoActividades();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Asignación</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <div class="page">
        <div class="card form-card">
            <div class="page-header">
                <div>
                    <h1>Editar Asignación</h1>
                    <p class="muted">Actualiza el perfil y la actividad de esta relación.</p>
                </div>
            </div>

            <form method="post" action="CtrolGesActividad">
                <input type="hidden" name="accion" value="editar"/>
                <input type="hidden" name="cidgesActividad" value="<%=g.getIdgesActividad()%>"/>

                <div class="campo">
                    <label for="cid_perfil">Perfil</label>
                    <select name="cid_perfil" id="cid_perfil" required>
                        <% for (Perfil p : listaPerfiles) { %>
                            <option value="<%=p.getId_perfil()%>"
                                <%= p.getId_perfil() == g.getId_perfil() ? "selected" : "" %>>
                                <%=p.getPerfil()%>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="campo">
                    <label for="cid_actividad">Actividad</label>
                    <select name="cid_actividad" id="cid_actividad" required>
                        <% for (Actividades a : listaActs) { %>
                            <option value="<%=a.getId_actividad()%>"
                                <%= a.getId_actividad() == g.getId_actividad() ? "selected" : "" %>>
                                <%=a.getNom_actividad()%>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn ok">Actualizar asignación</button>
                    <a href="listaGesActividad.jsp" target="contenido" class="btn secondary">Volver</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
