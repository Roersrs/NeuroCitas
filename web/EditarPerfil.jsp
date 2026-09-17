<%@page import="modelo.Perfil"%>
<%@page import="modelo.PerfilDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    PerfilDAO pdao = new PerfilDAO();
    Perfil p = pdao.listadoPerfil_Id(id);
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Perfil</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <div class="page">
        <div class="card form-card">
            <div class="page-header">
                <div>
                    <h1>Editar Perfil</h1>
                    <p class="muted">Modifica la información del perfil seleccionado.</p>
                </div>
            </div>

            <form method="post" action="CtrolPerfil">
                <input type="hidden" name="accion" value="editar"/>
                <input type="hidden" name="cid_perfil" value="<%=p.getId_perfil()%>"/>

                <div class="campo">
                    <label for="cperfil">Nombre del perfil</label>
                    <input type="text" id="cperfil" name="cperfil" value="<%=p.getPerfil()%>" required/>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn ok">Actualizar perfil</button>
                    <a href="listaPerfiles.jsp" target="contenido" class="btn secondary">Volver</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
