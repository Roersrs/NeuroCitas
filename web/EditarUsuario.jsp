<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.UsuarioDAO"%>

<%
    String id = request.getParameter("id");

    if (id == null || id.trim().isEmpty()) {
        out.println("Usuario no encontrado.");
        return;
    }

    UsuarioDAO dao = new UsuarioDAO();
    Usuario u = dao.listadoDatos_Id(id);

    if (u == null) {
        out.println("Usuario no encontrado.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar usuario</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body>

<div class="page">

    <div class="card">

        <h2>Editar usuario</h2>
        <p class="muted">
            Desde este apartado puedes modificar toda la información del usuario seleccionado.
        </p>

        <form action="EditarUsuario" method="post">

            <div class="form-grid">

                <div>
                    <label>Identificación</label>
                    <input type="text"
                           name="cidentificacion"
                           value="<%= u.getIdentificacion() %>"
                           readonly>
                </div>

                <div>
                    <label>Nombre</label>
                    <input type="text"
                           name="cnombre"
                           value="<%= u.getNombre() %>"
                           required>
                </div>

                <div>
                    <label>Apellido</label>
                    <input type="text"
                           name="capellido"
                           value="<%= u.getApellido() %>"
                           required>
                </div>

                <div>
                    <label>Correo electrónico</label>
                    <input type="email"
                           name="cmail"
                           value="<%= u.getEmail() %>"
                           required>
                </div>

                <div>
                    <label>Teléfono</label>
                    <input type="text"
                           name="ctelefono"
                           value="<%= u.getTelefono() %>"
                           maxlength="10">
                </div>

                <div>
                    <label>Nombre de usuario</label>
                    <input type="text"
                           name="cusuario"
                           value="<%= u.getUsuario() %>"
                           required>
                </div>

                <div>
                    <label>Nueva contraseña</label>
                    <input type="password"
                           name="cclave"
                           placeholder="Déjala vacía si no deseas cambiarla">
                </div>

                <div>
                    <label>Perfil</label>
                    <select name="cidperfil" required>
                        <option value="1" <%= u.getIdperfil() == 1 ? "selected" : "" %>>
                            Administrador
                        </option>

                        <option value="2" <%= u.getIdperfil() == 2 ? "selected" : "" %>>
                            Neurólogo
                        </option>

                        <option value="3" <%= u.getIdperfil() == 3 ? "selected" : "" %>>
                            Paciente
                        </option>
                    </select>
                </div>

                <div>
                    <label>Estado</label>
                    <select name="cidestado" required>
                        <option value="1" <%= u.getIdestado() == 1 ? "selected" : "" %>>
                            Activo
                        </option>

                        <option value="2" <%= u.getIdestado() == 2 ? "selected" : "" %>>
                            Pendiente
                        </option>

                        <option value="3" <%= u.getIdestado() == 3 ? "selected" : "" %>>
                            Rechazado
                        </option>

                        <option value="0" <%= u.getIdestado() == 0 ? "selected" : "" %>>
                            Inactivo
                        </option>
                    </select>
                </div>

            </div>

            <div style="margin-top: 22px;">
                <button type="submit" class="btn">
                    Actualizar usuario
                </button>

                <a href="listaUsuarios.jsp" class="btn secondary">
                    Volver
                </a>
            </div>

        </form>

    </div>

</div>

</body>
</html>