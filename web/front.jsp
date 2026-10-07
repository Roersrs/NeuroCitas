<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    int rol = u.getIdperfil();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/estilos.css">
    <title>NeuroCitas - Inicio</title>
</head>
<body>
<div class="page">
    <% if (rol == 1) { %>
        <div class="hero-panel admin-panel">
            <div>
                <span class="eyebrow">Panel Administrativo</span>
                <h1>Bienvenido, <%= u.getNombre() %></h1>
                <p>Administra usuarios, servicios neurologicos, horarios, citas y roles desde el menu lateral. Consulta historias clinicas de cualquier paciente buscando por cedula.</p>
            </div>
            <a class="btn" href="asignarRoles.jsp">Asignar roles</a>
        </div>
        <div class="grid dashboard-grid">
            <div class="info-card">
                <div class="icon-circle">&#128100;</div>
                <h3>Usuarios</h3>
                <p>Gestiona los pacientes, neurologos y administradores registrados en el sistema.</p>
                <a href="listaUsuarios.jsp">Gestionar usuarios</a>
            </div>
            <div class="info-card">
                <div class="icon-circle">&#128737;</div>
                <h3>Asignar roles</h3>
                <p>Cambia el perfil de un usuario entre Paciente, Neurologo o Administrador.</p>
                <a href="asignarRoles.jsp">Ir a roles</a>
            </div>
            <div class="info-card">
                <div class="icon-circle">&#128197;</div>
                <h3>Todas las citas</h3>
                <p>Visualiza y gestiona todas las citas neurologicas registradas en el sistema.</p>
                <a href="listaCitas.jsp">Ver citas</a>
            </div>
            <div class="info-card">
                <div class="icon-circle">&#128203;</div>
                <h3>Historias clinicas</h3>
                <p>Consulta el historial clinico completo de cualquier paciente escribiendo su numero de cedula.</p>
                <a href="buscarHistoria.jsp">Buscar historia clinica</a>
            </div>
            <div class="info-card">
                <div class="icon-circle">&#128105;</div>
                <h3>Solicitudes de neurologos</h3>
                <p>Aprueba o rechaza las solicitudes de registro de nuevos neurologos.</p>
                <a href="solicitudesDoctor.jsp">Revisar solicitudes</a>
            </div>
            <div class="info-card">
                <div class="icon-circle">&#128138;</div>
                <h3>Servicios neurologicos</h3>
                <p>Administra los servicios disponibles: consultas, resonancias, EEG y mas.</p>
                <a href="listaServicios.jsp">Gestionar servicios</a>
            </div>
        </div>

    <% } else if (rol == 2) { %>
        <div class="hero-panel doctor-panel">
            <div>
                <span class="eyebrow">Panel del Neurologo</span>
                <h1>Hola, Dr(a). <%= u.getNombre() %></h1>
                <p>Gestiona tus citas, registra y actualiza las historias clinicas de tus pacientes y mantente al dia con tus horarios de atencion.</p>
            </div>
            <a class="btn" href="citasDoctor.jsp">Ver mis citas</a>
        </div>
        <div class="grid dashboard-grid">
            <div class="info-card">
                <div class="icon-circle">&#10003;</div>
                <h3>Citas pendientes</h3>
                <p>Acepta o rechaza las reservas de citas neurologicas solicitadas por tus pacientes.</p>
                <a href="citasDoctor.jsp">Gestionar citas</a>
            </div>
            <div class="info-card">
                <div class="icon-circle">&#128203;</div>
                <h3>Historias clinicas</h3>
                <p>Registra nuevas historias clinicas, actualiza diagnosticos, tratamientos y estudios de tus pacientes.</p>
                <a href="historiaNeurologo.jsp">Ir a historias clinicas</a>
            </div>
            <div class="info-card">
                <div class="icon-circle">&#128336;</div>
                <h3>Mis horarios</h3>
                <p>Consulta tus horarios de atencion disponibles para los pacientes registrados.</p>
                <a href="listaHorarios.jsp">Ver horarios</a>
            </div>
        </div>

    <% } else { %>
        <div class="hero-panel cliente-panel">
            <div>
                <span class="eyebrow">Bienvenido a NeuroCitas</span>
                <h1>Hola, <%= u.getNombre() %></h1>
                <p>Agenda tus citas con neurologos especializados y consulta tu historial clinico de manera segura desde este portal.</p>
            </div>
            <a class="btn" href="solicitarCita.jsp">Agendar cita</a>
        </div>
        <div class="grid dashboard-grid">
            <div class="info-card">
                <div class="icon-circle">&#128203;</div>
                <h3>Mi historia clinica</h3>
                <p>Consulta todos los registros clinicos que tus neurologos tratantes han registrado en tu historial.</p>
                <a href="miHistoriaClinica.jsp">Ver mi historia clinica</a>
            </div>
            <div class="info-card">
                <div class="icon-circle">&#128197;</div>
                <h3>Mis citas</h3>
                <p>Revisa el estado de tus citas: pendientes, aceptadas o rechazadas por el neurologo.</p>
                <a href="misCitasCliente.jsp">Ver mis citas</a>
            </div>
            <div class="info-card">
                <div class="icon-circle">&#43;</div>
                <h3>Nueva cita</h3>
                <p>Elige un neurologo, selecciona el servicio especializado y escoge fecha y hora disponible.</p>
                <a href="solicitarCita.jsp">Agendar cita</a>
            </div>
        </div>

        <div class="card mt-20">
            <h2>Como funciona NeuroCitas</h2>
            <div class="steps">
                <div><b>1</b><span>Consulta la disponibilidad de neurologos y sus horarios de atencion.</span></div>
                <div><b>2</b><span>Selecciona el servicio: consulta inicial, EEG, resonancia u otro.</span></div>
                <div><b>3</b><span>Espera confirmacion del neurologo y accede a tu historia clinica actualizada.</span></div>
            </div>
        </div>
    <% } %>
</div>
</body>
</html>
