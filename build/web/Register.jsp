<%-- 
    Document   : index.jsp
    Created on : 17/03/2026, 5:19:29 p. m.
    Author     : sebas
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Administración de Usuarios</title>
    </head>

    <body>

        <h2>Registro de Usuario</h2>

        <form id="form1"
              name="form1"
              method="post"
              action="ControladorUsuario">

            <table>

                <!-- IDENTIFICACIÓN -->
                <tr>
                    <td>Identificación:</td>
                    <td>
                        <input
                            type="text"
                            name="cidentificacion"
                            required
                            minlength="10"
                            maxlength="10"
                            pattern="[0-9]{10}"
                            inputmode="numeric"
                        />
                    </td>
                </tr>

                <!-- NOMBRE -->
                <tr>
                    <td>Nombre:</td>
                    <td>
                        <input
                            type="text"
                            name="cnombre"
                            required
                        />
                    </td>
                </tr>

                <!-- APELLIDO -->
                <tr>
                    <td>Apellido:</td>
                    <td>
                        <input
                            type="text"
                            name="capellido"
                            required
                        />
                    </td>
                </tr>

                <!-- EMAIL -->
                <tr>
                    <td>Email:</td>
                    <td>
                        <input
                            type="email"
                            name="cmail"
                            required
                        />
                    </td>
                </tr>

                <!-- TELÉFONO -->
                <tr>
                    <td>Teléfono:</td>
                    <td>
                        <input
                            type="text"
                            name="ctelefono"
                            required
                            minlength="10"
                            maxlength="10"
                            pattern="[0-9]{10}"
                            inputmode="numeric"
                        />
                    </td>
                </tr>

                <!-- USUARIO -->
                <tr>
                    <td>Usuario:</td>
                    <td>
                        <input
                            type="text"
                            name="cusuario"
                            required
                            minlength="4"
                        />
                    </td>
                </tr>

                <!-- CONTRASEÑA -->
                <tr>
                    <td>Clave:</td>
                    <td>
                        <input
                            type="password"
                            name="cclave"
                            required
                            minlength="8"
                            pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$"
                        />
                    </td>
                </tr>

                <!-- PERFIL -->
                <tr>
                    <td>Perfil:</td>
                    <td>
                        <select name="cidperfil" required>
                            <option value="">Seleccione un perfil</option>
                            <option value="1">Administrador</option>
                            <option value="2">Usuario</option>
                        </select>
                    </td>
                </tr>

                <!-- BOTONES -->
                <tr>
                    <td colspan="2">
                        <input type="submit" value="Guardar"/>
                        <input type="reset" value="Limpiar"/>
                    </td>
                </tr>

            </table>

            <a href="index.jsp">Log In</a>

        </form>

    </body>
</html>