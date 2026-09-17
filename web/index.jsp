<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String solMsg = request.getParameter("solicitud");
    String logoutMsg = request.getParameter("logout");

    String errorParam = request.getParameter("error");
    String errorAttr = (String) request.getAttribute("error");

    String mensajeError = null;

    if (errorAttr != null) {
        mensajeError = errorAttr;
    } else if (errorParam != null) {
        mensajeError = "Usuario o contraseña incorrectos.";
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NeuroCitas - Sistema de Gestión Neurológica</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body class="login-body">

<div class="login-container">

    <div class="hero">
        <div class="hero-badge">
            NeuroCitas Colombia
        </div>

        <h1>Sistema de Gestión Neurológica</h1>

        <p class="hero-sub">
            Plataforma especializada en neurología para el agendamiento seguro de citas médicas,
            gestión de historias clínicas y acceso a servicios diagnósticos del sistema nervioso.
        </p>

        <br>

        <p class="hero-sub" style="font-size:14px;">
            Consultas neurológicas &nbsp; | &nbsp; Resonancias y tomografías<br>
            Evaluación de epilepsia &nbsp; | &nbsp; Electroencefalograma EEG<br>
            Neurología pediátrica &nbsp; | &nbsp; Manejo de cefalea crónica
        </p>
    </div>

    <div class="login-card">

        <h2>Iniciar sesión</h2>
        <p class="muted">Accede con tu usuario y contraseña</p>

        <% if ("doctor".equals(solMsg)) { %>
            <div class="msg ok">
                Tu solicitud como neurólogo fue enviada. El administrador la revisará pronto.
            </div>
        <% } %>

        <% if ("logout".equals(logoutMsg)) { %>
            <div class="msg ok">
                Sesión cerrada correctamente.
            </div>
        <% } %>

        <% if (mensajeError != null) { %>
            <div class="msg error">
                <%= mensajeError %>
            </div>
        <% } %>

        <form method="post" action="CtrolValidar">

            <input type="hidden" name="accion" value="Ingresar">

            <div class="campo">
                <label>Usuario</label>
                <input 
                    type="text" 
                    name="cusuario" 
                    placeholder="Tu usuario" 
                    required 
                    autocomplete="username">
            </div>

            <div class="campo">
                <label>Contraseña</label>
                <input 
                    type="password" 
                    name="cclave" 
                    placeholder="Tu contraseña" 
                    required 
                    autocomplete="current-password">
            </div>

            <button type="submit" style="width:100%;margin-top:10px;">
                Ingresar
            </button>

        </form>

        <div class="login-actions">
            <a href="registro.jsp">Registrarme como paciente</a>
            <span style="color:var(--line)">|</span>
            <a href="solicitudDoctor.jsp">Soy neurólogo</a>
        </div>

    </div>

</div>

</body>
</html>
