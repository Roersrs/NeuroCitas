<%@page import="modelo.Actividades"%>
<%@page import="modelo.ActividadesDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Editar Actividad</title>
</head>
<body>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    ActividadesDAO adao = new ActividadesDAO();
    Actividades a = adao.listadoDatos_Id(id);
%>
    <h2>Editar Actividad</h2>
    <form method="post" action="CtrolActividades">
        <input type="hidden" name="accion" value="editar"/>
        <input type="hidden" name="cid_actividad" value="<%=a.getId_actividad()%>"/>
        <table border="1">
            <tr>
                <td>Nombre Actividad:</td>
                <td><input type="text" name="cnom_actividad" value="<%=a.getNom_actividad()%>" required/></td>
            </tr>
            <tr>
                <td>Enlace:</td>
                <td><input type="text" name="cenlace" value="<%=a.getEnlace()%>" required/></td>
            </tr>
            <tr>
                <td colspan="2"><input type="submit" value="Actualizar"/></td>
            </tr>
        </table>
    </form>
</body>
</html>
